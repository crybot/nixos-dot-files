
{ config, lib, pkgs, ... }:

{
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      extraLuaConfig = builtins.readFile ./init.lua;
      extraPackages = with pkgs; [
        tinymist
        texlab
        pyright
        biome
        nil
        dockerfile-language-server-nodejs
      ];
      extraWrapperArgs = [
        # "--prefix"
        # "PATH"
        # ":"
        # "${lib.makeBinPath [ pkgs.gcc ]}"
        # "--suffix"
        # "LIBRARY_PATH"
        # ":"
        # "${lib.makeLibraryPath [ pkgs.stdenv.cc.cc pkgs.zlib ]}"
        # "--suffix"
        # "PKG_CONFIG_PATH"
        # ":"
        # "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [ pkgs.stdenv.cc.cc pkgs.zlib ]}"
      ];
      plugins = with pkgs.vimPlugins; [
        ############################
        # Core editing / text objects
        # Surroundings, repeats, tags, basics
        ############################
        vim-surround          # edit surrounding pairs
        vim-repeat            # repeat plugin-defined mappings
        vim-closetag          # auto close HTML tags

        ############################
        # Clipboard / jobs / terminal
        # System clipboard, async jobs, terminal
        ############################
        nvim-osc52            # terminal clipboard over ssh
        vim-dispatch          # async build and tests
        toggleterm-nvim       # integrated terminal management

        ############################
        # UI / layout / aesthetics
        # Look, feel, cursor, layout
        ############################
        snacks-nvim           # miscellaneous UX enhancements
        alpha-nvim            # startup screen dashboard
        smear-cursor-nvim     # smooth motion cursor trail
        catppuccin-nvim       # Catppuccin colorscheme integration
        nvim-web-devicons     # filetype icons for UI
        lualine-nvim          # flexible statusline component
        bufferline-nvim       # tab-like buffer line
        virt-column-nvim      # virtual column guideline
        fidget-nvim
        nvim-navic

        ############################
        # File / buffer navigation
        # File tree, pickers, navigation
        ############################
        nvim-tree-lua         # file explorer side panel
        telescope-nvim        # fuzzy finder and pickers

        ############################
        # Completion and snippets
        # cmp core and sources
        ############################
        nvim-cmp              # completion engine core
        cmp-nvim-lsp          # LSP source for completion
        cmp-buffer            # buffer words completion source
        cmp-path              # file path completion
        cmp-cmdline           # commandline completion source
        luasnip               # snippet engine for completion

        ############################
        # LSP / IDE features
        # Language servers, semantics, helpers
        ############################
        nvim-lspconfig        # common LSP server configs
        vim-illuminate        # highlight LSP word references
        refactoring-nvim      # interactive code refactoring helpers
        trouble-nvim
        aerial-nvim


        ############################
        # Treesitter / syntax / structure
        # Parsing, matching, visual structure
        ############################
        # indent-blankline-nvim # indent guides between lines
        nvim-treesitter.withAllGrammars # Treesitter parsing all languages
        vim-matchup           # enhanced % matching pairs
        rainbow-delimiters-nvim # rainbow colored delimiters
        nvim-ufo # folds

        ############################
        # Git / version control
        # Git porcelain inside Neovim
        ############################
        vim-fugitive          # powerful git integration

        ############################
        # Workflow / sessions / TODOs
        # Sessions, keymaps, annotations
        ############################
        which-key-nvim        # popup keybinding hints
        persistence-nvim      # restore last session automatically
        todo-comments-nvim    # highlight TODO style comments

        ############################
        # Typst / docs tooling
        # Typst live preview
        ############################
        typst-preview-nvim    # live Typst preview pane

        ############################
        # Plugin dependencies / libs
        # Lua helper libraries
        ############################
        plenary-nvim          # lua helper library dependency

        ############################
        # Optional old plugins
        # Commented but kept for reference
        ############################
        # auto-pairs           # basic automatic bracket pairing
      ];
    };
  };
}

