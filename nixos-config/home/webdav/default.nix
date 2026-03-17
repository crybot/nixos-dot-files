{ config, pkgs, ... }:

let
  # Declarative State Definitions
  webdavUrl = "http://192.168.4.1:8080/dav/zotero";
  webDavUsername = "crybot";
  syncDir = "/home/crybot/Dropbox/Applicazioni/onyx-knote/Zotero/";
  configDir = "${config.home.homeDirectory}/.config/zotero-sync";
  credFile = "${configDir}/credentials.env";
  markerFile = "${configDir}/.resync_initialized";

  # Dependency Injection for the Setup Script
  zotero-auth-setup = pkgs.writeScriptBin "zotero-auth-setup" ''
    #!/usr/bin/env bash
    # Inject runtime dependencies and execute the pure bash script from the Nix store
    export PATH="${pkgs.rclone}/bin:$PATH"
    export CONFIG_DIR="${configDir}"
    export CRED_FILE="${credFile}"
    exec ${pkgs.bash}/bin/bash ${./zotero-auth-setup.sh}
  '';

  # Dependency Injection for the Logic Wrapper
  zotero-bisync-wrapper = pkgs.writeScriptBin "zotero-bisync-wrapper" ''
    #!/usr/bin/env bash
    export PATH="${pkgs.rclone}/bin:$PATH"
    export SYNC_DIR="${syncDir}"
    export CRED_FILE="${credFile}"
    export MARKER_FILE="${markerFile}"
    exec ${pkgs.bash}/bin/bash ${./zotero-bisync-wrapper.sh}
  '';

  shellWarning = ''
    if [ ! -f "${credFile}" ]; then
        echo -e "\033[1;33m[Action Required]\033[0m Zotero WebDAV sync is installed but missing credentials."
        echo -e "Run \033[1;32mzotero-auth-setup\033[0m to authenticate and activate the background daemon."
        echo ""
    fi
  '';

in
{
  programs.rclone.enable = true;

  home.packages = [
    zotero-auth-setup
    zotero-bisync-wrapper
  ];

  programs.fish.interactiveShellInit = ''
    if not test -f "${credFile}"
        set_color yellow -o
        echo -n "[Action Required]"
        set_color normal
        echo " Zotero WebDAV sync is installed but missing credentials."
        echo "Run "(set_color green -o)"zotero-auth-setup"(set_color normal)" to authenticate and activate the background daemon."
        echo ""
    end
  '';
  programs.bash.initExtra = shellWarning;
  programs.zsh.initExtra = shellWarning;

  systemd.user.services.zotero-webdav-sync = {
    Unit = {
      Description = "Bidirectional synchronization for Zotero WebDAV";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      EnvironmentFile = "-${credFile}";

      # The target remote configuration
      Environment = [
        "RCLONE_CONFIG_OPENWRT_TYPE=webdav"
        "RCLONE_CONFIG_OPENWRT_URL=${webdavUrl}"
        "RCLONE_CONFIG_OPENWRT_VENDOR=other"
        "RCLONE_CONFIG_OPENWRT_USER=${webDavUsername}"
      ];

      ExecStart = "${zotero-bisync-wrapper}/bin/zotero-bisync-wrapper";
    };
  };

  systemd.user.timers.zotero-webdav-sync = {
    Unit = {
      Description = "Timer for Zotero WebDAV bidirectional sync";
    };
    Timer = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
