FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libgbm1 libasound2 \
    libpangocairo-1.0-0 libxss1 libgtk-3-0 libxshmfence1 libglu1 \
    ca-certificates libwayland-client0 libwayland-cursor0 libwayland-egl1 \
    libgl1-mesa-dri libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# 2. Setup User
RUN groupadd -g 1000 appuser && \
    useradd -r -u 1000 -g appuser -d /home/appuser -m appuser

# 3. Switch User
WORKDIR /app
RUN chown appuser:appuser /app
USER appuser
ENV HOME=/home/appuser

# 4. Download & Extract
RUN wget https://cdn.anythingllm.com/latest/AnythingLLMDesktop.AppImage -O anythingllm.AppImage
RUN chmod +x anythingllm.AppImage
RUN ./anythingllm.AppImage --appimage-extract

# RUN rm anythingllm.AppImage

USER root
RUN apt-get update && apt-get install -y curl
RUN apt-get install -y dconf-cli dconf-gsettings-backend libglib2.0-bin xdg-utils
USER appuser

# Launch with Wayland flags
# ENTRYPOINT defines the executable. It cannot be overridden by arguments.
ENTRYPOINT ["./squashfs-root/anythingllm-desktop"]

# CMD defines default arguments. These are appended to ENTRYPOINT.
# If you pass arguments in 'docker run', they replace these CMD values.
CMD ["--no-sandbox", "--ozone-platform-hint=auto"]
