{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [(
    self: super: {
      vim_configurable = super.vim_configurable.customize {
        name = "vim";
        vimrcConfig.packages.myVimPackage = with super.vimPlugins; {
          start = [
            vim-gitgutter # just for some git diff
            vim-surround

            # Syntax supports
            vim-nix
            julia-vim
            vim-toml
            haskell-vim
          ];
        };
        vimrcConfig.customRC = builtins.readFile ./vimrc;
      };
    }
  )];
}
