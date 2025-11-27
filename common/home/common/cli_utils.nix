{ pkgs, lib, config, ...}:
let
  scriptsDir = ./scripts;

  dependencyMap = import ./scripts/dependencies.nix { inherit pkgs; };

  shellScripts = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".sh" name)
    (builtins.readDir scriptsDir);

  scriptPackages = lib.mapAttrsToList (name: type:
    let
      scriptPath = "${scriptsDir}/${name}";
      packageName = lib.removeSuffix ".sh" name;

      deps = lib.attrByPath [packageName]
        (lib.attrByPath ["default"] [pkgs.bash] dependencyMap)
        dependencyMap;
    in
    pkgs.writeShellApplication {
      name = packageName;
      runtimeInputs = deps;
      text = builtins.readFile scriptPath;
    }
  ) shellScripts;
in
{
  # This file is for specifically programs that are designed to be
  # used within, and to aid in the use of the terminal.

  home.packages = with pkgs; [
    playerctl
    fastfetch
    wl-clipboard
    nh
    bat
    eza
    pfetch-rs
    pciutils
  ]
  ++ scriptPackages;
}