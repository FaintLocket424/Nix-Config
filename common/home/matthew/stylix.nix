{
  pkgs,
  ...
}: {
  stylix = {
    enable = true;
    image = ./backgrounds/toothless_1.jpg;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";

    fonts = {
      sizes = {
        desktop = 11;
        popups = 11;
        terminal = 10;
        applications = 11;
      };

      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };

      serif = {
        package = pkgs.roboto-serif;
        name = "Roboto Serif";
      };

      monospace = {
        package = pkgs.nerd-fonts.commit-mono;
        name = "CommitMono Nerd Font";
      };
    };

    polarity = "dark";
    opacity.popups = 0.4;

    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 20;
    };

    targets = {
      qt.platform = "qtct";
      waybar.font = "sansSerif";
    };

    iconTheme = {
      enable = true;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
      package = pkgs.papirus-icon-theme;
    };
  };
}
