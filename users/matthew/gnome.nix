{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.desktop;
in
{
  config = lib.mkIf (cfg.environment == "gnome") {

  };
}
