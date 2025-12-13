{ config, pkgs, lib, ... }:

let
  # composeYaml = ''
  #   version: "3.8"
  #   services:
  #     anythingllm:
  #       image: docker.io/mintplexlabs/anythingllm:latest
  #       container_name: anythingllm
  #       restart: unless-stopped
  #       ports:
  #         - "3001:3001"
  #       volumes:
  #         - /var/lib/anythingllm:/app/server/storage
  # '';

  composeYaml = ''
    version: '3.8'
    services:
      anythingllm:
        image: mintplexlabs/anythingllm
        container_name: anythingllm
        ports:
        - "3001:3001"
        cap_add:
          - SYS_ADMIN
        environment:
        # Adjust for your environment
          - STORAGE_DIR=/app/server/storage
          # - JWT_SECRET="make this a large list of random numbers and letters 20+"
          # - LLM_PROVIDER=ollama
          # - OLLAMA_BASE_PATH=http://127.0.0.1:11434
          # - OLLAMA_MODEL_PREF=llama2
          # - OLLAMA_MODEL_TOKEN_LIMIT=4096
          # - EMBEDDING_ENGINE=ollama
          # - EMBEDDING_BASE_PATH=http://127.0.0.1:11434
          # - EMBEDDING_MODEL_PREF=nomic-embed-text:latest
          # - EMBEDDING_MODEL_MAX_CHUNK_LENGTH=8192
          # - VECTOR_DB=lancedb
          # - WHISPER_PROVIDER=local
          # - TTS_PROVIDER=native
          # - PASSWORDMINCHAR=8
          # Add any other keys here for services or settings
          # you can find in the docker/.env.example file
        volumes:
          - anythingllm_storage:/app/server/storage
        restart: always

    volumes:
      anythingllm_storage:
        driver: local
        driver_opts:
          type: none
          o: bind
          device: /var/lib/anythingllm
  '';
in {
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
    # Create storage dir
    systemd.tmpfiles.rules = [
      "${config.anythingllm.storagePath} - - - - -"
    ];

    # Drop compose file
    environment.etc."anythingllm/docker-compose.yml".text = composeYaml;

    # systemd service
    systemd.services.anythingllm = {
      description = "AnythingLLM (docker-compose)";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        # ExecStart = "/run/current-system/sw/bin/docker compose -f ${config.anythingllm.composeFile} up -d";
        # ExecStop  = "/run/current-system/sw/bin/docker compose -f ${config.anythingllm.composeFile} down";

        ExecStartPre = "/run/current-system/sw/bin/docker compose -f ${config.anythingllm.composeFile} pull";
        ExecStart = "/run/current-system/sw/bin/docker compose -f ${config.anythingllm.composeFile} up -d";
        ExecStop  = "/run/current-system/sw/bin/docker compose -f ${config.anythingllm.composeFile} down";
      };
    };
  };
}
