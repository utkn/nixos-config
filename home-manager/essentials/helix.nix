{ ... }: {
  programs.helix = {
    enable = true;
    themes = {
      custom = {
        inherits = "catppuccin_frappe";
        "ui.background" = "{}";
      };
    };
    settings = {
      theme = "custom";
      editor = {
        bufferline = "always";
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
        indent-guides.render = true;
      };
    };
  };
}
