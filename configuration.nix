{ lib, pkgs, ... }:

with (import ./private.nix); let
  # Individual apps.
  apps = with pkgs; [
    emacs

    # Detecting system info.
    profetch
    cpufetch
    # Check if X11 works.
    xorg.xclock
  ];
in {
  imports = [
    ./wsl.nix
  ];

  # Looks like `isContainer = true` in ./wsl.nix (just
  # guessing) disabled X11 libs. Enable it again here.
  environment.noXlibs = false;

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
  environment.systemPackages = with pkgs; [
    man
    git

    # for generating password
    mkpasswd
    # for encrypting ./private.nix
    git-crypt
    # `gpg` can't find `pinentry` binary. Here's the
    # stupid way to solve it, just run it manually:
    # ``` bash
    # $ gpg-agent \
    #     --pinentry-program \
    #         /run/current-system/sw/bin/pinentry \
    #     --daemon
    # ```
    gnupg
    pinentry

    # Vim customized.
    (import ./vim.nix)

  ] ++ apps;

  # Commented. manually run it instead.
  # programs.gnupg.agent = {
  #   enable = true;
  #   pinentryFlavor = "curses";
  # };
}
