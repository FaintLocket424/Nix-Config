{
  pkgs,
  ...
}: {
  stylix = {
    enable = true;
    image = ./wallpapers/system-default.jpg;
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
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono";
      };
    };
  };
}