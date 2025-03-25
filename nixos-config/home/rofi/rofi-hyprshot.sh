#!/usr/bin/env bash
# Display a simple rofi menu with three options:
choice=$(printf "Selection\nWindow\nScreen" | rofi -dmenu -p "Hyprshot:")
out_dir=$HOME/Pictures/Screenshots

case "$choice" in
  "Selection")
    # Capture a region (if hyprshot supports a selection mode, e.g., with -s)
    hyprshot --mode region --output-folder $out_dir
    ;;
  "Window")
    # Capture the active window (assuming hyprshot uses -w for window capture)
    hyprshot --mode window --output-folder $out_dir
    ;;
  "Screen")
    # Capture the full screen (default behavior, no extra flag)
    hyprshot --mode output --output-folder $out_dir
    ;;
  *)
    # Do nothing if no valid option is selected.
    exit 0
    ;;
esac
