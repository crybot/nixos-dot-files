
TARGET_LANG="en"

input=$(rofi -dmenu -p "Translate to $TARGET_LANG" -lines 0)

if [ -z "$input" ]; then
    exit 0
fi

output=$(trans -brief -no-ansi ":$TARGET_LANG" "$input")
choice=$(echo "$output" | rofi -dmenu -p "Copy" -mesg "Original: $input")

if [ -n "$choice" ]; then
    echo "$choice" | wl-copy
    notify-send "Translation Copied" "$choice"
fi
