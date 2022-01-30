{ lib, pkgs, ... }:

with (import ./private.nix); let
  # Individual apps.
  apps = with pkgs; [
    # Detecting system info.
    profetch
    cpufetch
    # Check if X11 works.
    xorg.xclock
  ];
  defaultApps = {
    # Default editor.
    editor = pkgs.vimHugeX;
    # For interactive use, i.e default shell.
    loginShell = pkgs.zsh;
    # For scripts. Linked to /bin/sh.
    shellScript = pkgs.dash;
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
    default = "${hostName}.local:${httpProxyPort}";
    noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # basic packages.
  environment.systemPackages = with pkgs; [
    # Linux manual
    man
    # Version control
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

    # Alternative to `find`
    fd
  ] ++ builtins.attrValues defaultApps ++ apps;

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
    enable = defaultApps.loginShell == pkgs.zsh;
    syntaxHighlighting.enable = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    interactiveShellInit = ''
      PS1="%F{32}%~ %F{34}%# %f"
    '';
  };

  # Set default shell fro all users.
  users.defaultUserShell = defaultApps.loginShell;

  # Link `/bin/sh` with `shells.script` package.
  environment.binsh = let pkg = defaultApps.shellScript; in
      "${pkg}${pkg.shellPath}";

  # Set hostname.
  networking.hostName = hostName;

  networking.useHostResolvConf = true;

  # Configuring /etc/wsl.conf
  environment.etc."wsl.conf" = {
    text = ''
      # Generated by /etc/nixos/configuration.nix
      [network]
      hostname = ${hostName}
      generateHosts = false
      generateResolvConf = true
    '';
  };

  programs.vim = {
    package = pkgs.vimHugeX;
    defaultEditor = defaultApps.editor == pkgs.vimHugeX;
  };
}
