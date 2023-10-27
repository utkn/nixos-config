{
  inputs,
  # lib,
  # config,
  pkgs,
  userName,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./helix.nix
    ./alacritty.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      (final: prev: {
        fish = prev.fish.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or []) ++ [ ./fish-zfs.patch ];
        });
      })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "${userName}";
    homeDirectory = "/home/${userName}";
    packages = with pkgs; [
        firefox-wayland
        ranger
        gh
        bottom
        solaar
        mpv
        fish
      ]; 
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1"; # enable wayland for firefox
      RANGER_LOAD_DEFAULT_RC = "false";
    };
  };

  # Cursor
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.simp1e-cursors;
    name = "Simp1e-Dark";
    size = 36;
  };
  
  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
