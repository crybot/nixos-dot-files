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

if [[ ! $ROFI_RETV -eq 1 ]]; then
  exit 0
fi

case "$choice" in
  $SELECTION)
    # Capture a region
    area="region"
    ;;
  $WINDOW)
    # Capture the selected window
    area="window"
    ;;
  $SCREEN)
    # Capture the full screen
    area="output"
    ;;
  *)
    # Do nothing if no valid option is selected.
    exit 0
    ;;
esac

coproc ( $HOME/scripts/take-screenshot.sh $area $out_dir $mode > /dev/null 2>&1 )
