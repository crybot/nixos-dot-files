# 1. Clean Path Setup
# We point to the PARENT directory now
CONFIG_DIR="$HOME/.config/anythingllm-desktop"
mkdir -p "$CONFIG_DIR/storage"

# 2. Robust Variable Detection
REAL_UID=$(id -u)
WL_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"
XDG_RUNTIME="${XDG_RUNTIME_DIR:-/run/user/$REAL_UID}"

if [ ! -e "$XDG_RUNTIME/$WL_DISPLAY" ]; then
    echo "⚠️  Warning: Wayland socket $XDG_RUNTIME/$WL_DISPLAY not found."
fi

# 3. GPU/Freezing Fixes
# Disabling the AT-SPI bridge often fixes 'freezing on new window' in Electron apps
export NO_AT_BRIDGE=1

echo "🐳 Verifying AnythingLLM Container..."
@docker@/bin/docker build -t anythingllm-gui -f "@dockerfile@" .

echo "🚀 Launching AnythingLLM..."
@docker@/bin/docker run --rm \
  --privileged \
  --ipc=host \
  --net=host \
  --env XDG_RUNTIME_DIR=/tmp \
  --env WAYLAND_DISPLAY="$WL_DISPLAY" \
  --env NO_AT_BRIDGE=1 \
  --env XDG_CURRENT_DESKTOP=gnome \
  --volume "$XDG_RUNTIME/$WL_DISPLAY:/tmp/$WL_DISPLAY" \
  --volume /run/dbus:/run/dbus \
  --volume "$CONFIG_DIR":/home/appuser/.config/anythingllm-desktop \
  --volume "$HOME":"$HOME" \
  --device /dev/dri \
  --name anythingllm-desktop-instance \
  anythingllm-gui \
  --no-sandbox \
  --ozone-platform-hint=auto \
  --enable-features=UseOzonePlatform,WaylandWindowDecorations %U \
  --ozone-platform=wayland
