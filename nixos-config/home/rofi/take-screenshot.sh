#!/usr/bin/env bash

MODE=$1
OUT_DIR=$2
SHARE=none

if [[ $# -eq 3 ]]; then
  SHARE=$3
fi

hyprshot --mode $MODE --output-folder $OUT_DIR

if [[ $SHARE = "share" ]]; then
  sleep 0.5 # wait for hyprshot to save the image to clipboard (might need to increase delay on other systems)
  xdg-open $(wl-paste --type image/png | curl -F "files[]=@-;filename=screenshot.png" https://uguu.se/upload?output=text)
fi
