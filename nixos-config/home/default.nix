{ config, pkgs, lib, ... }:

{
  imports = [
    ./neovim/default.nix
    ./hyprland/default.nix
    ./firefox/default.nix
    ./waybar/default.nix
    ./fish/default.nix
    ./rofi/default.nix
    ./zotero/default.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "crybot";
  home.homeDirectory = "/home/crybot";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    playerctl
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  gtk.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs = {
    bash.enable = true;
    kitty.enable = true;
    foot.enable = true;
    git = {
      enable = true;
      userName  = "crybot";
      userEmail = "crybot@hotmail.it";
    };
    btop = {
      enable = true;
      package = pkgs.btop-cuda;
      settings = {
        vim_keys = true;
        update_ms = 100;
        mem_graphs = false;
        proc_per_core = true;
        io_mode = true;
        disks_filter = "exclude=/boot";
      };
    };
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
    cursors.enable = true;
    alacritty = {
      enable = true;
      flavor = "mocha"; #TODO: also test "macchiato"
    };
    bat = {
      enable = true;
      flavor = "mocha";
    };
    hyprland = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
    };
    fish = {
      enable = true;
      flavor = "mocha";
    };
    waybar = {
      enable = true;
      flavor = "mocha";
      mode = "prependImport";
    };
    gtk = {
      flavor = "macchiato";
      enable = true;
    };

    zathura.enable = false;
    rofi.enable = false;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          # family = "FiraCode Nerd Font";
          family = "Jetbrains Mono Nerd Font";
          style = "Regular";
        };
        size = 13.0;
      };

      colors = {
        draw_bold_text_with_bright_colors = true;
      };

      terminal = {
        shell = "fish";
      };

      window = {
        dynamic_padding = true;
      };
    };
  };

  programs.bat = {
    enable = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    colors = "always";
  };

  programs.zathura = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zellij = {
    enable = true;
  };

  services.swaync = {
    enable = true;
  };

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = "41.902782";
    longitude = "12.496365";
    tray = true;
    temperature = {
      day = 5500;
      night = 2200;
    };
  };

  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.nautilus}/bin/nautilus";
      };
    };
  };

  home.shell.enableFishIntegration = true;
  home.shell.enableBashIntegration = true;

  # Aliases
  home.shellAliases = {
    cz = "chezmoi";
    cat = "bat";
    ls = "eza -l --no-user --no-permissions --no-time --grid --icons=always";
    lss = "ls --total-size";
  };

  # Default applications
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = ["zathura"];
    };
    defaultApplications = {
      "application/pdf" = ["zathura"];
    };
  };

  # scripts 
  home.file."scripts/rofi-hyprshot.sh" = {
    source = ./rofi/rofi-hyprshot.sh;
    executable = true;
  };
  home.file."scripts/rofi-menu.sh" = {
    source = ./rofi/rofi-menu.sh;
    executable = true;
  };
  home.file."scripts/take-screenshot.sh" = {
    source = ./rofi/take-screenshot.sh;
    executable = true;
  };

  home.file.".clang-format" = {
    source = ./clangd/.clang-format;
  };
  home.file.".clang-tidy" = {
    source = ./clangd/.clang-tidy;
  };

  dconf.enable = true;
}
