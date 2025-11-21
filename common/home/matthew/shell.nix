{ pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = "fastfetch; set fish_greeting";
      shellAliases = {
        edit = "$EDITOR";
        ls = "eza --icons --group-directories-first";
        cat = "bat";
      };
    };
	
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };
	
    starship = {
      enable = true;
      settings = {
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
  };
}