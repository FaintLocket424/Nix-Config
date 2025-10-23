{ pkgs, ...}: {
  home.packages = with pkgs; [
    (import ./update.nix {inherit pkgs;})

    playerctl
    hyperfine
    fastfetch
    wl-clipboard
    nh
    bat
    eza
    pfetch-rs
  ];
}