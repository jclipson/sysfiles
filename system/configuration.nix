# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  # Use zen kernel 
  boot.kernelPackages = pkgs.linuxPackages_zen; # Optimized for desktop usage 

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Automatic updates
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  
  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 

  # Networking
  networking.hostName = "nyx"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  
  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Disable mouse acceleration and change sensitivity  
  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
      accelSpeed = "0";
      accelStepMotion = 0.1;
    };
  };
  
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  }; 

  # Enable the i3 window manager.
  services.xserver.windowManager.i3.enable = true;
  
  # Enable and configure the lightdm display manager (login manager)
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk = {
      theme.name = "Adwaita";
      iconTheme.name = "Adwaita";
      cursorTheme.name = "Numix-cursor";
      extraConfig = ''
        user-background = false
      '';
    };
  };
  #services.xserver.displayManager.lightdm.background = lib.mkDefault "/home/joe/.sysfiles/wallpapers/gruvbox_stripes.png";      

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };

  # Configure console keymap
  console.keyMap = "us";
  
  # Disable CUPS as I don't need to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joe = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Joe Clipson";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install other programs not defined in system packages, which cannot be enabled in home-manager
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 14d --keep 10";
    flake = "/home/joe/.sysfiles";
  };

  programs.zsh = {
    enable = true;
    
    ohMyZsh = {
      enable = true;
      #plugins = [];
      theme = "xiong-chiamiov-plus";
      #other cool themes include: arrow, jonathan, lambda, xiong-chiamiov-plus
    };
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.tumbler.enable = true; # Thumbnails for images in thunar
  services.gvfs.enable = true;  # Other functionality for thunar

  services.flatpak.enable = true;  
  xdg.portal.enable = true; 
  xdg.portal.extraPortals = [ pkgs.flatpak ];
  xdg.portal.config.common.default = "*";

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  
  # Install fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
    nerd-fonts.terminess-ttf
  ]; 

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    #xorg
    numix-cursor-theme
    unzip
  ];  
  
  # Session variables
  environment.sessionVariables = {
    FLAKE = "/home/joe/.sysfiles";
  };
  
  # Enable and configure stylix (for automatic ricing)
  stylix = {
    enable = true;

    base16Scheme = { # gruvbox light soft theme
      base00 = "f2e5bc"; # ----
      base01 = "ebdbb2"; # ---
      base02 = "d5c4a1"; # --
      base03 = "bdae93"; # -
      base04 = "665c54"; # +
      base05 = "504945"; # ++
      base06 = "3c3836"; # +++
      base07 = "282828"; # ++++
      base08 = "9d0006"; # red
      base09 = "af3a03"; # orange
      base0A = "b57614"; # yellow
      base0B = "79740e"; # green
      base0C = "427b58"; # aqua/cyan
      base0D = "076678"; # blue
      base0E = "8f3f71"; # purple
      base0F = "d65d0e"; # brown
    };

    image = ./gruvbox_stripes.png;  
    cursor = {
      size = 24;
      package = pkgs.numix-cursor-theme;
      name = "Numix-Cursor";
    };  
  };
    
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
