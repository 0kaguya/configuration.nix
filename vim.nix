## Used in `system.systemPackages` in 'configuration.nix'
with import <nixpkgs> {};
vim_configurable.customize {
  name = "vim";

  vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
    start = [
      vim-gitgutter # some git diff
      vim-surround
      # syntax supports
      vim-nix
    ];
  };

  vimrcConfig.customRC = ''
    set nocompatible

    set tabstop=4
    set shiftwidth=4
    set expandtab
    set smarttab
    set noundofile
    set nobackup
    set backspace=indent,eol,start

    filetype plugin indent on
    syntax on
 
    set number
    set cursorline
    highlight CursorLine cterm=NONE
    highlight CursorLineNr ctermfg=blue
    " set GitGutter sign column color
    " fixed the problem that the column has grey background.
    highlight SignColumn ctermbg=NONE
    
    set clipboard=unnamedplus   
  '';
}
