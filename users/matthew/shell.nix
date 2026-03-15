{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat # A better 'cat' with syntax highlighting
    eza # A faster, modern 'ls' replacement
    fd # A faster 'find'
    ripgrep # A faster 'grep'
    pfetch-rs
    fastfetch
    playerctl
    wl-clipboard
    nh
    pciutils
    p7zip
    ncdu
  ];

  programs = {
    kitty = {
      enable = true;

      settings = {
        font_features = "JetBrainsMono Nerd Font Mono +calt";
        input_delay = 0;
        repaint_delay = 10;
        sync_to_monitor = "yes";
        window_padding_width = 4;
        enable_audio_bell = "no";
        confirm_os_window_close = 0;
        "modify_font cell_height" = "120%";
      };

      shellIntegration.enableFishIntegration = true;
    };

    fish = {
      enable = true;

      shellAliases = {
        #        edit = "$EDITOR";
        ls = "eza --icons --group-directories-first";
        cat = "bat";
        ll = "eza -l --icons --git -a";
        find = "fd";
        grep = "rg";
      };

      interactiveShellInit = ''
        pfetch
        set fish_greeting
      '';

      plugins = [
        {
          name = "tide";
          src = pkgs.fishPlugins.tide.src;
        }
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
      ];
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };

    starship = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        add_newline = false;
        command_timeout = 20;

        format = "[](green)$username[](bg:cyan fg:green)$directory[](fg:cyan bg:blue)$git_branch$git_status[](fg:blue bg:bright-black)$time[ ](fg:bright-black)$line_break$character";

        username = {
          show_always = true;
          style_user = "bg:green fg:black";
          style_root = "bg:green fg:black";
          format = "[ $user ]($style)";
        };

        directory = {
          style = "fg:black bg:cyan";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
        };

        git_branch = {
          symbol = "";
          style = "bg:blue fg:black";
          format = "[[ $symbol $branch ](fg:black bg:blue)]($style)";
        };

        git_status = {
          style = "bg:blue";
          format = "[[($all_status$ahead_behind )](fg:black bg:blue)]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:bright-black";
          format = "[[  $time ](fg:white bg:bright-black)]($style)";
        };
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type f";
    };
  };
}
