{ pkgs, adminUser, ... }: {
	users.users."${adminUser}" = {
		packages = with pkgs; [
			thunderbird
	    ranger
	    bottom
	    firefox-wayland
	    solaar
	    alacritty
	    bitwarden
			rustup
		];
	};
	
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1"; # enable wayland for firefox
  };
}
