{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.anythingllm-desktop;

  # 1. Read the Dockerfile from disk
  # We put it in the Nix store so it has a definitive path we can reference
  dockerfileObj = pkgs.writeText "Dockerfile" (builtins.readFile ./Dockerfile);

  # 2. Process the Launcher Script
  # We read the file into a string and replace the placeholders manually using builtins.
  # This avoids dependency on deprecated helpers like substituteAll.
  launcherTemplate = builtins.readFile ./launcher.sh;
  
  startScriptContent = builtins.replaceStrings 
    [ "@docker@" "@dockerfile@" ] 
    [ "${pkgs.docker}" "${dockerfileObj}" ] 
    launcherTemplate;

  startScript = pkgs.writeScriptBin "anythingllm-desktop" startScriptContent;

  # 3. Create Desktop Icon
  desktopItem = pkgs.makeDesktopItem {
    name = "anythingllm-desktop";
    desktopName = "AnythingLLM Desktop";
    genericName = "AI Knowledge Base";
    exec = "${startScript}/bin/anythingllm-desktop";
    icon = "utilities-terminal";
    categories = [ "Office" "Utility" ];
    terminal = true;
  };

in {
  options.programs.anythingllm-desktop = {
    enable = mkEnableOption "AnythingLLM Desktop (Dockerized Wayland)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      startScript
      desktopItem
      pkgs.docker
    ];

    virtualisation.docker.enable = true;
  };
}
