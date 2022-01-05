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
  shells = {
    # For interactive use, i.e default shell.
    login = pkgs.zsh;
    # For scripts. Linked to /bin/sh.
    script = pkgs.dash;
  };
in {
  imports = [
    ./wsl.nix
    ./vim/vim.nix
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
    # Linux manual
    man
    # Version control
    git
    # Command line editor
    vimHugeX

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

    # Alternative to `find`
    fd
  ] ++ builtins.attrValues shells ++ apps;

  # Commented. manually run it instead.
  # programs.gnupg.agent = {
  #   enable = true;
  #   pinentryFlavor = "curses";
  # };

  # Add flakes command to Nix.
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Global shell aliases
  # environment.shellAliases = {
  # };
  
  programs.zsh = {
    enable = shells.login == pkgs.zsh;
    syntaxHighlighting.enable = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    interactiveShellInit = ''
      PS1="%F{32}%~ %F{34}%# %f"
    '';
  };

  # Set default shell fro all users.
  users.defaultUserShell = shells.login;

  # Link `/bin/sh` to the `shells.script` package.
  environment.binsh = "${shells.script}${shells.script.shellPath}";
}
