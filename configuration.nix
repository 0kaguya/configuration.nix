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

  # configure network proxy
  networking.proxy = {
    default = httpProxy;
    noProxy = "127.0.0.1,localhost,internal.domain";
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
