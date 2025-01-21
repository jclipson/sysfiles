{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "joe";
  home.homeDirectory = "/home/joe";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    obsidian
    i3lock-color
    fastfetch
    playerctl
    floorp
    ungoogled-chromium
    xorg.xkill
    git
    gnupg
    pamixer
    pinentry
    spotify-player
    flameshot
    i3blocks
    obs-studio
    vesktop
    rofi
    vlc
    pix
    btop
    python3
    libreoffice-fresh
    sqlitebrowser
  ];

  programs.alacritty.enable = true;    

  programs.gpg = {
    enable = true;
  };  
  
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };  
  
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      # Extensions go here 
    ];
  };

  programs.zsh = {  
    enable = true;
    #enableCompletion = true;
    #autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      cconf = "git -C /home/joe/.sysfiles commit -am "; # Commits all files in .sysfiles, requires a commit message
      pconf = "git -C /home/joe/.sysfiles push origin main"; # Pushes all changes in .sysfiles
      sconf = "nano /home/joe/.sysfiles/system/configuration.nix"; # Edit system config
      uconf = "nano /home/joe/.sysfiles/users/joe/home.nix"; # Edit user config
      neofetch = "fastfetch";
      py = "python3 ";
      spotify = "i3-msg 'move container to workspace 8' --quiet && i3-msg 'workspace 8' --quiet && spotify_player";
      xclass = "xprop | grep 'WM_CLASS'";
      htop = "btop";
      update = "cd ~/.sysfiles && nix flake update && cconf 'Updated nixpkgs' && nh os switch && flatpak update";
    };
    
    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = ["rm *" "pkill *" "cp *"];
  };  

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/joe/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
