#!/usr/bin/env bash
# Display a simple rofi menu with three options:
SELECTION=" Selection"
WINDOW=" Window"
SCREEN=" Screen"
choice=$(printf "$SELECTION\n$WINDOW\n$SCREEN" | rofi -dmenu -i -p "  Hyprshot")
out_dir=$HOME/Pictures/Screenshots

case "$choice" in
  $SELECTION)
    # Capture a region
    hyprshot --mode region --output-folder $out_dir
    ;;
  $WINDOW)
    # Capture the selected window
    hyprshot --mode window --output-folder $out_dir
    ;;
  $SCREEN)
    # Capture the full screen
    hyprshot --mode output --output-folder $out_dir
    ;;
  *)
    # Do nothing if no valid option is selected.
    exit 0
    ;;
esac
