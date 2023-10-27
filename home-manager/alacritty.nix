{ ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "/home/utkn/.nix-profile/bin/fish";
      window = {
        padding = {
          x = 8;
          y = 8;
        };
        opacity = 0.8;
      };
    };
  };
}
