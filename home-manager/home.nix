{
  inputs,
  lib,
  config,
  pkgs,
  userName,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
    ./kde.nix
    ./essentials/helix.nix
    ./essentials/alacritty.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
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
        github-cli
        ranger
        fish
        virt-manager
        bottom
        solaar
        mpv
      ]; 
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1"; # enable wayland for firefox
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
