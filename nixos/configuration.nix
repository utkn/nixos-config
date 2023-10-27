{
  inputs,
  lib,
  config,
  pkgs,
  # hostName,
  adminUser,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./virtualization.nix
    ./desktop.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # (final: prev: {
      #   fish = prev.fish.overrideAttrs (oldAttrs: {
      #     patches = (oldAttrs.patches or []) ++ [ ./fish-zfs.patch ];
      #   });
      # })
    ];
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Core programs.
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    helix
    aria2
    git
    wget
    tree
    pciutils
    usbutils
    htop
    neofetch
    nil # nix lsp server
    killall
  ];

  environment.sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
  };

  # Networking
  networking.hostName = "apollo";
  networking.hostId = "00bab10c";
  # Use NetworkManager
  networking.networkmanager.enable = true;
  # Allow mDNS broadcast + listen
  networking.networkmanager.extraConfig = "
    [connection]
    mdns=2
  ";
  # Disable the firewall.
  networking.firewall.enable = false;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable logitech compatibility
  hardware.logitech.wireless.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
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

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  users.users = {
    ${adminUser} = {
      initialPassword = "supersecretpassword";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "kvm" "input" "video" ];
      openssh.authorizedKeys.keys = [
      ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
