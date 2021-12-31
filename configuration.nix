{ lib, pkgs, ... }:

{
  imports = [
    ./wsl.nix
    ./private.nix
  ];

  # do not change user infomation elsewhere.
  users.mutableUsers = false;

  # basic packages.
  environment.systemPackages = [
    pkgs.man
    pkgs.git
    # for generating password
    pkgs.mkpasswd
    pkgs.vim
  ];
}
