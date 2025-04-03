#!/usr/bin/env bash
# Display a simple rofi menu with three options:
SELECTION=" Selection"
WINDOW=" Window"
SCREEN=" Screen"

MENU=$(cat <<EOF
$SELECTION
$WINDOW
$SCREEN
EOF
)

mode=none
choice=none

if [[ $ROFI_RETV -eq 0 ]]; then
  printf "$MENU"
  exit 0
fi

if [[ $# -eq 1 ]]; then
  choice=$1
fi

if [[ $# -eq 2 ]]; then
  mode=$1
  choice=$2
fi

out_dir=$HOME/Pictures/Screenshots

other=""

# if [[ $mode = "share" ]]; then
#   other="--clipboard-only"
# fi

case "$choice" in
  $SELECTION)
    # Capture a region
    hyprshot --mode region --output-folder $out_dir $other
    ;;
  $WINDOW)
    # Capture the selected window
    hyprshot --mode window --output-folder $out_dir $other
    ;;
  $SCREEN)
    # Capture the full screen
    hyprshot --mode output --output-folder $out_dir $other
    ;;
  *)
    # Do nothing if no valid option is selected.
    exit 0
    ;;
esac

sleep 0.5 # wait for hyprshot to save the image to clipboard (might need to increase delay on other systems)

if [[ $mode = "share" ]]; then
  xdg-open $(wl-paste --type image/png | curl -F "files[]=@-;filename=screenshot.png" https://uguu.se/upload?output=text)
fi

