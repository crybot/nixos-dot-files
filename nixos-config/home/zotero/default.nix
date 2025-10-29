{ config, pkgs, lib, ... }: # Ensure lib is available for pkgs.lib.fakeSha256

# TODO: better-bibtex

let
  # Define the path to your Zotero config files relative to home.nix
  # zoteroConfigDir = .;

  # Plugin details
  zotmoovVersion = "1.2.19";
  zotmoovUrl = "https://github.com/wileyyugioh/zotmoov/releases/download/${zotmoovVersion}/zotmoov-${zotmoovVersion}-fx.xpi";
  # --- IMPORTANT ---
  # Replace this with the actual hash obtained from nix-prefetch-url
  # Or use pkgs.lib.fakeSha256 or "" initially and let Nix tell you the hash.
  zotmoovSha256 = "sha256-s0OevYL3V+wfpQpXglRNbH7vrc9mMk9pq0yL97n4+H4=";
  # The internal ID of the plugin used for the filename
  zotmoovId = "zotmoov@wileyy.com";
in
{
  # 1. Ensure Zotero is installed
  home.packages = [ pkgs.zotero ];

  # 2. Manage the Zotero configuration files and directories
  home.file = {
    # Manage profiles.ini (essential for predictable paths)
    ".zotero/zotero/profiles.ini" = {
      source = ./profiles.ini;
      recursive = true;
    };

    # user.js overwrites prefs.js but it's not written back by zotero.
    ".zotero/zotero/Profiles/default/user.js" = {
      source = pkgs.replaceVars ./user.js.template {
        # Define the substitutions. Key is the placeholder name (without @ symbols).
        # Value is the replacement string.
        homeDir = config.home.homeDirectory;
      };
      recursive = true;
    };

    # # Manage prefs.js (optional, but shown previously)
    # ".zotero/zotero/Profiles/default/prefs.js" = {
    #   source = "${zoteroConfigDir}/Profiles/default/prefs.js";
    #   recursive = true;
    # };

    # --- Add Zotmoov Plugin ---
    ".zotero/zotero/Profiles/default/extensions/${zotmoovId}.xpi" = {
      source = pkgs.fetchurl {
        url = zotmoovUrl;
        sha256 = zotmoovSha256;
      };
      # Ensure the parent directories (.zotero/zotero/Profiles/default/extensions) exist
      recursive = true;
    };
  };
}
