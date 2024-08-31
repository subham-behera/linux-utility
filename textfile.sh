#!/bin/bash

# Define the file to operate on
FILE="$1"

# Function to display the file content
view_file() {
    echo "Displaying contents of $FILE:"
    cat "$FILE"
}

# Function to search for a pattern in the file
search_pattern() {
    read -p "Enter the pattern to search for: " PATTERN
    grep "$PATTERN" "$FILE"
}

# Function to replace text in the file
replace_text() {
    read -p "Enter the text to replace: " OLD_TEXT
    read -p "Enter the new text: " NEW_TEXT
    sed -i.bak "s/$OLD_TEXT/$NEW_TEXT/g" "$FILE"
    echo "Text replaced. Backup of the original file created as $FILE.bak."
}

# Function to append text to the file
append_text() {
    read -p "Enter the text to append: " APPEND_TEXT
    echo "$APPEND_TEXT" >> "$FILE"
    echo "Text appended to $FILE."
}

# Function to delete specific lines from the file
delete_lines() {
    read -p "Enter the line numbers to delete (e.g., 2,5,7): " LINES
    sed -i.bak "/^$(echo $LINES | sed 's/,/\\|/g')$/d" "$FILE"
    echo "Lines deleted. Backup of the original file created as $FILE.bak."
}

# Function to count lines, words, and characters
count_stats() {
    echo "Counting lines, words, and characters in $FILE:"
    wc "$FILE"
}

# Function to sort the contents of the file
sort_file() {
    sort "$FILE" -o "$FILE"
    echo "File sorted."
}

# Function to create a backup of the file
backup_file() {
    cp "$FILE" "$FILE.bak"
    echo "Backup of $FILE created as $FILE.bak."
}

# Main menu function
main_menu() {
    echo "Text File Operations Menu"
    echo "1. View file"
    echo "2. Search pattern"
    echo "3. Replace text"
    echo "4. Append text"
    echo "5. Delete lines"
    echo "6. Count lines, words, and characters"
    echo "7. Sort file"
    echo "8. Backup file"
    echo "9. Exit"

    read -p "Choose an option [1-9]: " OPTION

    case $OPTION in
        1) view_file ;;
        2) search_pattern ;;
        3) replace_text ;;
        4) append_text ;;
        5) delete_lines ;;
        6) count_stats ;;
        7) sort_file ;;
        8) backup_file ;;
        9) exit 0 ;;
        *) echo "Invalid option. Please choose a number between 1 and 9." ;;
    esac
}

# Check if a file is provided
if [ -z "$FILE" ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Check if the file exists
if [ ! -f "$FILE" ]; then
    echo "File $FILE does not exist."
    exit 1
fi

# Main loop
while true; do
    main_menu
done

