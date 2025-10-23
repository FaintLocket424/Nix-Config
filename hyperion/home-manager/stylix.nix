{
  stylix = {
    targets = {
      qt.platform = "qtct";
#      waybar.font = "sansSerif";
    };

    iconTheme = {
      enable = true;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
      package = pkgs.papirus-icon-theme;
    };
  };
}