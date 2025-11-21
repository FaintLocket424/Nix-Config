{
  pkgs,
  ...
}: {
  stylix = {
    enable = true;
    image = ./wallpapers/system-default.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
  };
}