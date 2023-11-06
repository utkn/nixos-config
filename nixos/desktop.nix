{ pkgs, ... }: {

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    font-awesome_5
  ];
  
  services.blueman.enable = true;

  # Greeter
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd bash";
        user = "greeter";
      };
    };
  };

  # Window manager
  programs.hyprland.enable = true;

	# Desktop apps (core)
  environment.systemPackages = with pkgs; [
    waybar
    dunst # Notifications
    wofi
    networkmanagerapplet
    pavucontrol
    hyprpaper
    playerctl
    brightnessctl
    wdisplays
  ];
}
