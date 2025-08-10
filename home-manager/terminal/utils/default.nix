{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (import ./update.nix {inherit pkgs;})

#  (writeShellApplication {
#    name = "extractMojangJar";
#    text = (builtins.readFile ../../scripts/extractMojangJar.sh);
#  })
	
	# Media somethingorother
	playerctl
	
	# Command-line benchmarking tool
	hyperfine
	
	# System information tool
	fastfetch
	
	# Copying things to clipboard
	# Used by screenshot command
	wl-clipboard
	
	# Yet another nix cli helper
	# Replaces nixos-rebuild
	nh
  ];
  programs.btop.enable = true;
}