{ pkgs, lib, config, ...}:
let
  scriptsDir = ./scripts;

  dependencyMap = import ./dependencies.nix { inherit pkgs; };

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
  home.packages = with pkgs; [
    playerctl
    hyperfine
    fastfetch
    wl-clipboard
    nh
    bat
    eza
    pfetch-rs
  ]
  ++ scriptPackages;
}