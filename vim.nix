with import <nixpkgs> {};
vim_configurable.customize {
  name = "vim";
  vimrcConfig.customRC = ''
    set tabstop=4
    set shiftwidth=4
    set expandtab
    set smarttab
    set noundofile
    set nobackup
    set backspace=indent,eol,start
    set nocompatible

    filetype plugin indent on
    syntax on
 
    set number
    set cursorline
    highlight CursorLine cterm=NONE
    highlight CursorLineNr ctermfg=blue
    
    set clipboard=unnamedplus   
  '';

  vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
    start = [
      vim-nix
      vim-gitgutter
      vim-surround
    ];
  };
}
