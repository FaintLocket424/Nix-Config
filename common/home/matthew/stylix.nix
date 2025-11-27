{
  pkgs,
  ...
}: {
  stylix = {
    enable = true;
    image = ./backgrounds/toothless_1.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";

    polarity = "dark";
    opacity.popups = 0.4;

    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 20;
    };

    targets = {
      qt.platform = "qtct";

      firefox = {
        profileNames = [ "Home" ];
      };
    };

    iconTheme = {
      enable = true;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
      package = pkgs.papirus-icon-theme;
    };
  };
}
