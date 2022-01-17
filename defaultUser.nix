## `home-manager` config for `/home/$defaultUser`
{ config, lib, pkgs, ... }:

let
  defaultUser = (import ./private.nix).defaultUser;
  defaultShell = pkgs.zsh;
  userApps = with pkgs; [
    python39Packages.ipython
  ];
in {
  # Set default shell
  users.users.${defaultUser}.shell = defaultShell;

  # Get system packages' completion for `zsh`.
  environment.pathsToLink = [ "/share/zsh" ];

  home-manager.users.${defaultUser} = { config, pkgs, ... }: {
    home.packages = with pkgs; [
      defaultShell
    ] ++ userApps;
    programs = {
      zsh = {
        enable = defaultShell == pkgs.zsh;
        defaultKeymap = "emacs";

        enableSyntaxHighlighting = true;
        enableCompletion = true;
        enableAutosuggestions = true;

        history = {
          path = "../../${config.xdg.dataHome}/zsh/zsh_history";
          ignorePatterns = [
            "cd *"
            "cp *"
            "mv *"
            "rm *"
            "man *"
            "vim *"
            "emacs *"
            "cat *"
            "echo *"
          ];
          extended = true;
        };

        autocd = true;
        
        sessionVariables = {
          ## Tweak the Zsh command line prompt.
          ## https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
          prompt = with lib.lists; let
            ## Some helper functions to compose content.
            # At the end always reset color and leaves a space.
            concat = foldr (a: b: a + b) "%f ";
            # Process the `[color text]` format
            colored = l: let
              n = head l;
              s = head (tail l);
            in "%F{${toString n}}${s}";
            # Add underline scheme surround that text.
            underlined = s: "%U${s}%u";
            ## Dedicate values
            # Separate string for time format
            # https://man7.org/linux/man-pages/man3/strftime.3.html
            # "timezone:hour:minute"
            time = "%Z:%H:%M";
          ## Refer to the color of these numbers in
          ## https://www.ditig.com/256-colors-cheat-sheet
          in concat (map colored [# [34 "<"]
                                  ## current time
                                  [32 (underlined "%D{${time}}")]
                                  # [34 ">"]
                                  ## current path, relevant
                                  [39 " %~"]
                                  ## prompt symbol
                                  [34 " %#"]]);
        };

        shellAliases = {
          # Aliases for reload NixOS and Zsh
          nextsetup = "sudo nixos-rebuild switch";
          reloadzsh = "exec zsh";
          # Add aliases for stonelike git commands
          gstat = "git status";
          gcommit = "git commit --edit";
        };
      };
      git = {
        enable = true;
        aliases = {
        };
      } // (import ./private.nix).git;
    };

    home.file."nixos".source = config.lib.file.mkOutOfStoreSymlink /etc/nixos;
  };
}
