{ pkgs, lib, ... }:

let
  scriptsDir = ./scripts;

  # Import your dependencies file and pass pkgs to it
  depMap = import ./scripts/dependencies.nix { inherit pkgs; };

  # Scan the current directory
  allFiles = builtins.readDir scriptsDir;

  # Filter for files ending in .fish
  fishFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".fish" name) allFiles;

  # Function to transform a .fish file into a Nix package
  mkScript =
    fileName: type:
    let
      # Name of the command (filename without .fish)
      name = lib.removeSuffix ".fish" fileName;

      # Determine dependencies: use specific list or fallback to "default"
      scriptDeps = if builtins.hasAttr name depMap then depMap."${name}" else (depMap.default or [ ]);
    in
    pkgs.writers.writeFishBin name {
      # This ensures the dependencies are in the script's PATH at runtime
      makeWrapperArgs = [
        "--prefix"
        "PATH"
        ":"
        (lib.makeBinPath scriptDeps)
      ];
    } (builtins.readFile (scriptsDir + "/${fileName}"));

  scriptPackages = lib.mapAttrsToList mkScript fishFiles;
in
{
  home.packages =
    with pkgs;
    [

    ]
    ++ scriptPackages;
}
