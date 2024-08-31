#!/bin/bash

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to display system information
display_system_info() {
    echo -e "${GREEN}--- System Information ---${NC}"
    echo "Uptime:"
    uptime
    echo
    echo "Disk Usage:"
    df -h
    echo
    echo "Memory Usage:"
    free -h
    echo
}

# Function to list running processes
list_processes() {
    echo -e "${GREEN}--- Running Processes ---${NC}"
    ps aux --sort=-%mem | head -n 10
    echo
}

# Function to kill a process
kill_process() {
    read -p "Enter the PID of the process to kill: " pid
    if [ -z "$pid" ]; then
        echo -e "${RED}No PID entered!${NC}"
        return
    fi
    if kill -9 "$pid" >/dev/null 2>&1; then
        echo -e "${GREEN}Process $pid killed successfully.${NC}"
    else
        echo -e "${RED}Failed to kill process $pid.${NC}"
    fi
    echo
}

# Function to perform disk cleanup
cleanup_disk() {
    echo -e "${YELLOW}--- Disk Cleanup ---${NC}"
    find / -type f -size +100M 2>/dev/null | tee /tmp/large_files.txt
    read -p "Do you want to delete these files? (y/n): " choice
    if [ "$choice" = "y" ]; then
        while read -r file; do
            rm -i "$file"
        done < /tmp/large_files.txt
    fi
    echo
}

# Function to check network connectivity
check_network() {
    echo -e "${GREEN}--- Network Check ---${NC}"
    read -p "Enter the host to check (e.g., google.com): " host
    if [ -z "$host" ]; then
        echo -e "${RED}No host entered!${NC}"
        return
    fi
    if ping -c 4 "$host" >/dev/null 2>&1; then
        echo -e "${GREEN}Host $host is reachable.${NC}"
    else
        echo -e "${RED}Host $host is not reachable.${NC}"
    fi
    echo
}

# Function to backup specified directories
backup_dirs() {
    echo -e "${YELLOW}--- Backup Utility ---${NC}"
    read -p "Enter the directory to backup: " dir
    read -p "Enter the backup destination (e.g., /backup): " dest
    if [ -z "$dir" ] || [ -z "$dest" ]; then
        echo -e "${RED}Directory or destination not specified!${NC}"
        return
    fi
    tar -czf "$dest/backup_$(date +%F_%T).tar.gz" -C "$(dirname "$dir")" "$(basename "$dir")"
    echo -e "${GREEN}Backup created successfully.${NC}"
    echo
}

# Function to analyze system log files
analyze_logs() {
    echo -e "${YELLOW}--- Log File Analysis ---${NC}"
    read -p "Enter the log file path (e.g., /var/log/syslog): " log_file
    if [ -z "$log_file" ]; then
        echo -e "${RED}Log file not specified!${NC}"
        return
    fi
    grep -i 'error\|fail' "$log_file" | less
    echo
}

# Function to check the status of critical services
check_services() {
    echo -e "${YELLOW}--- Service Status Check ---${NC}"
    for service in nginx apache2 mysql; do
        systemctl is-active --quiet "$service"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}$service is running.${NC}"
        else
            echo -e "${RED}$service is not running.${NC}"
        fi
    done
    echo
}

# Function to display system temperature
display_temperature() {
    echo -e "${YELLOW}--- System Temperature ---${NC}"
    if command -v sensors &>/dev/null; then
        sensors
    else
        echo -e "${RED}sensors command not found. Install lm-sensors package.${NC}"
    fi
    echo
}

# Function to show network bandwidth usage
show_bandwidth_usage() {
    echo -e "${YELLOW}--- Network Bandwidth Usage ---${NC}"
    if command -v ifstat &>/dev/null; then
        ifstat -i eth0 1 10
    else
        echo -e "${RED}ifstat command not found. Install ifstat package.${NC}"
    fi
    echo
}

# Function to list and manage cron jobs
manage_cron_jobs() {
    echo -e "${YELLOW}--- Scheduled Tasks ---${NC}"
    crontab -l
    read -p "Do you want to edit the crontab? (y/n): " choice
    if [ "$choice" = "y" ]; then
        crontab -e
    fi
    echo
}

# Main menu
while true; do
    echo -e "${GREEN}--- System Health Monitor ---${NC}"
    echo "1. Display System Information"
    echo "2. List Running Processes"
    echo "3. Kill a Process"
    echo "4. Disk Cleanup"
    echo "5. Check Network Connectivity"
    echo "6. Backup Utility"
    echo "7. Analyze Logs"
    echo "8. Check Services"
    echo "9. Display Temperature"
    echo "10. Show Bandwidth Usage"
    echo "11. Manage Cron Jobs"
    echo "12. Exit"
    read -p "Choose an option [1-12]: " option

    case $option in
        1) display_system_info ;;
        2) list_processes ;;
        3) kill_process ;;
        4) cleanup_disk ;;
        5) check_network ;;
        6) backup_dirs ;;
        7) analyze_logs ;;
        8) check_services ;;
        9) display_temperature ;;
        10) show_bandwidth_usage ;;
        11) manage_cron_jobs ;;
        12) echo "Exiting..."; exit 0 ;;
        *) echo -e "${RED}Invalid option, please try again.${NC}" ;;
    esac
done
