{
  description = "Minimal Nix flake to run AnythingLLM via docker-compose on NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; # adjust to your preferred channel
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs { inherit system; config = {}; };
        composeYaml = ''
          version: "3.8"

          services:
            anythingllm:
              image: docker.io/mintplexlabs/anythingllm:latest
              container_name: anythingllm
              restart: unless-stopped
              ports:
                - "3001:3001"
              volumes:
                - /var/lib/anythingllm:/app/server/storage
              # optionally add environment: [ ... ]
        '';
      in {
        packages.default = pkgs.writeShellScriptBin "anythingllm-run" ''
          echo "This flake provides a NixOS module. Use it with: sudo nixos-rebuild switch --flake /path/to/this#your-host"
        '';

        nixosModules.anythingllm = { config, lib, pkgs, ... }: {
          options.anythingllm = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable AnythingLLM (docker-compose) service.";
            };
            storagePath = lib.mkOption {
              type = lib.types.str;
              default = "/var/lib/anythingllm";
              description = "Host path for AnythingLLM persistent storage.";
            };
            composeFile = lib.mkOption {
              type = lib.types.str;
              default = "/etc/anythingllm/docker-compose.yml";
              description = "Path to the docker-compose.yml installed by this module.";
            };
          };

          config = lib.mkIf config.anythingllm.enable {
            # install docker + docker-compose CLI
            environment.systemPackages = [ pkgs.docker pkgs.docker_compose ];

            # ensure the storage directory exists
            systemd.tmpfiles.rules = [
              "${config.anythingllm.storagePath} - - - - -"
            ];

            # Install the compose file into /etc/anythingllm/docker-compose.yml
            environment.etc."anythingllm/docker-compose.yml".text = composeYaml;

            # systemd service to run docker-compose
            systemd.services.anythingllm = {
              description = "AnythingLLM (docker-compose)";
              wants = [ "network-online.target" ];
              after = [ "network-online.target" ];
              serviceConfig = {
                Type = "simple";
                Restart = "on-failure";
                RestartSec = "5s";
                # Use the docker-compose binary provided by the system packages
                ExecStart = ''
                  /run/current-system/sw/bin/docker-compose -f ${config.anythingllm.composeFile} up -d
                '';
                ExecStop = ''
                  /run/current-system/sw/bin/docker-compose -f ${config.anythingllm.composeFile} down
                '';
                TimeoutStartSec = "120s";
                KillMode = "process";
              };
              install = {
                WantedBy = [ "multi-user.target" ];
              };
            };

            # grant docker socket access if you need additional user-level tooling:
            # (this does NOT modify users by default; add your admin user to 'docker' group in your configuration.nix if desired)
          };
        };
      });
}
