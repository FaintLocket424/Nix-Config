{ pkgs, lib, ... }: {
  imports = [
    ./kde.nix
  ];

  home.packages = with pkgs; [
    bat
    eza
    fd
    ripgrep

    fastfetch
    pfetch
    p7zip
    wget

    geteduroam
    btop
    htop
    vesktop
    qalculate-qt

    haruna

    onlyoffice-desktopeditors
    hunspell
    hunspellDicts.en-gb-ise

    (pkgs.stdenvNoCC.mkDerivation {
      pname = "my-custom-fonts";
      version = "1.0";
      src = ./fonts;

      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp *.ttf $out/share/fonts/truetype/
      '';
    })
  ];



  programs = {
    firefox = {
      enable = true;

      languagePacks = [ "en-GB" ];

      policies = let homepage-url = "https://start.duckduckgo.com"; in {
        AppAutoUpdate = false;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;

        BackgroundAppUpdate = false;
        # BlockAboutConfig = false;
        BlockAboutProfiles = true;
        BlockAboutSupport = true;

        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxScreenshots = true;
        DisableForgetButton = true;
        DisableMasterPasswordCreation = true;
        DisableProfileImport = true;
        DisableProfileRefresh = true;
        DisableSetDesktopBackground = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFormHistory = true;
        DisablePasswordReveal = true;

        DisplayMenuBar = "never";
        DontCheckDefaultBrowser = true;
        HardwareAcceleration = false;
        OfferToSaveLogins = false;
        DefaultDownloadDirectory = "~/Downloads";
        PasswordManagerEnabled = false;

        TrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        ExtensionSettings =
          let
            moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
          in
          {
            "*".installation_mode = "blocked";

            "uBlock0@raymondhill.net" = {
              install_url = moz "ublock-origin";
              installation_mode = "force_installed";
              updates_disabled = true;
            };

            "{f3b4b962-34b4-4935-9eee-45b0bce58279}" = {
              install_url = moz "animated-purple-moon-lake";
              installation_mode = "force_installed";
              updates_disabled = true;
            };

            "{7b1bf0b6-a1b9-42b0-b75d-252036438bdc}" = {
              install_url = moz "youtube-high-definition";
              installation_mode = "force_installed";
              updates_disabled = true;
            };

            "clipper@obsidian.md" = {
              install_url = moz "web-clipper-obsidian";
              installation_mode = "force_installed";
              updates_disabled = true;
            };

            "firefox-extension@steamdb.info" = {
              install_url = moz "steam-database";
              installation_mode = "force_installed";
              updates_disabled = true;
            };

            "{cb31ec5d-c49a-4e5a-b240-16c767444f62}" = {
              install_url = moz "indie-wiki-buddy";
              installation_mode = "force_installed";
              updates_disabled = true;
            };

            "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
              install_url = moz "proton-pass";
              installation_mode = "force_installed";
              updates_disabled = true;
            };

            "{34daeb50-c2d2-4f14-886a-7160b24d66a4}" = {
              install_url = moz "youtube-shorts-block";
              installation_mode = "force_installed";
              updates_disabled = true;
            };
          };

        "3rdparty".Extensions = {
          "uBlock0@raymondhill.net".adminSettings = {
            userSettings = rec {
              uiTheme = "dark";
              uiAccentCustom = true;
              uiAccentCustom0 = "#8300ff";
              cloudStorageEnabled = lib.mkForce false;

              importedLists = [
                "https:#filters.adtidy.org/extension/ublock/filters/3.txt"
                "https:#github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
              ];

              externalLists = lib.concatStringsSep "\n" importedLists;
            };

            selectedFilterLists = [
              "CZE-0"
              "adguard-generic"
              "adguard-annoyance"
              "adguard-social"
              "adguard-spyware-url"
              "easylist"
              "easyprivacy"
              "https:#github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
              "plowe-0"
              "ublock-abuse"
              "ublock-badware"
              "ublock-filters"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"
              "urlhaus-1"
            ];
          };
        };

        Homepage = {
          URL = homepage-url;
          Locked = true;
        };

        Preferences = {
          "browser.newtabpage.enabled" = { Value = false; Status = "locked"; };
          "browser.newtab.url" = { Value = homepage-url; Status = "locked"; };

          "javascript.options.baselinejit" = { Value = false; Status = "locked"; };
          "javascript.options.ion" = { Value = false; Status = "locked"; };
        };
      };
    };

    fish = {
      enable = true;

      shellAliases = {
        ls = "eza --icons --group-directories-first";
        cat = "bat";
        ll = "eza -l --icons --git -a";
        find = "fd";
        grep = "rg";
      };

      interactiveShellInit = ''
        fastfetch
        set -g fish_greeting ""
      '';
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type f";
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

    git.enable = true;
    home-manager.enable = true;
  };

  services = {
    playerctld.enable = true;
  };

  fonts.fontconfig.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
