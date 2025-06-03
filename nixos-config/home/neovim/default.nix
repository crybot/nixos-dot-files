
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
        nvim-osc52
        vim-surround
        vim-repeat
        vim-dispatch
        vim-closetag

        # QoL and aesthetics
        snacks-nvim
        alpha-nvim
        smear-cursor-nvim
        catppuccin-nvim
        nvim-web-devicons
        nvim-tree-lua
        lualine-nvim
        bufferline-nvim

        # " Autocompletion plugins
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        luasnip

        # " LSP and language servers
        nvim-lspconfig

        # " Typst
        typst-preview-nvim

        # " Code parsing (treesitter)
        nvim-treesitter.withAllGrammars
        # indent-blankline-nvim
        refactoring-nvim
        vim-matchup
        plenary-nvim
        rainbow-delimiters-nvim

        # " Others
        # dockerfile # TODO: use nvim-treesitter-parsers.dockerfile (it was commented out originally probably because of
        # this)
        vim-fugitive
        virt-column-nvim
        todo-comments-nvim
        toggleterm-nvim
        # auto-pairs # was commented out
      ];
    };
  };
}

