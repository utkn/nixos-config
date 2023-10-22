{
  programs.plasma = {
    enable = true;
    shortcuts = {
      "org.kde.krunner.desktop"."_launch" = ["Meta+Space" "Search"];
    };
    configFile = {
      "plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";
      "plasma-localerc"."Formats"."LC_MEASUREMENT" = "en_CH.UTF-8";
      "plasma-localerc"."Formats"."LC_TIME" = "en_CH.UTF-8";
    };
  };
}
