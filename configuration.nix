{ lib, pkgs, ... }:

with (import ./private.nix);
{
  imports = [
    ./wsl.nix
  ];

  # do not change user settings by manual command.
  users.mutableUsers = false;
  # set up user password.
  users.users.${defaultUser} = {
    hashedPassword = defaultUserPassword;
  };
  users.users.root = {
    hashedPassword = rootPassword;
  };

  # basic packages.
  environment.systemPackages = [
    pkgs.man
    pkgs.git
    # for generating password
    pkgs.mkpasswd
    # vim customized
    (import ./vim.nix)
  ];
}
