{ pkgs, nixos-branding, ... }: {
  programs.firefox.profiles.matthew = {
    id = 0;
    name = "Matthew";
    bookmarks = {
      force = true;
      settings = [
        {
          name = "Bookmarks Bar";
          toolbar = true;
          bookmarks = [
            { name = "YouTube"; url = "https://www.youtube.com/feed/subscriptions"; }
            { name = "YouTube Music"; url = "https://music.youtube.com/"; }
            {
              name = "Video";
              bookmarks = [
                { name = "Netflix"; url = "https://www.netflix.com/browse"; }
                { name = "Disney+"; url = "https://www.disneyplus.com/en-gb/home"; }
                { name = "BBC iPlayer"; url = "https://www.bbc.co.uk/iplayer"; }
              ];
            }
            {
              name = "AI";
              bookmarks = [
                { name = "Gemini"; url = "https://ai.dev"; }
              ];
            }
            {
              name = "Proton";
              bookmarks = [
                { name = "Mail"; url = "https://mail.proton.me/u/0/inbox"; }
                { name = "Calendar"; url = "https://calendar.proton.me/u/0/month"; }
                { name = "Drive"; url = "https://drive.proton.me"; }
              ];
            }
            {
              name = "NixOS";
              bookmarks = [
                { name = "NixOS Packages"; url = "https://search.nixos.org/packages?channel=25.11&"; }
                { name = "Home Manager Options"; url = "https://home-manager-options.extranix.com/?query=&release=release-25.11"; }
                { name = "NixOS Options"; url = "https://search.nixos.org/options?channel=25.11&"; }
              ];
            }
            { name = "DHM Weather"; url = "https://www.metoffice.gov.uk/weather/forecast/gcwzefp2c"; }
            { name = "WhatsApp"; url = "https://web.whatsapp.com/"; }
            { name = "Immich"; url = "http://100.70.23.49:2283/"; }
            { name = "Jellyfin"; url = "http://100.70.23.49:8096/"; }
            { name = "Developer Roadmaps"; url = "https://roadmap.sh/"; }
            {
              name = "Pebble";
              bookmarks = [
                { name = "Learning C with Pebble"; url = "https://pebble.gitbooks.io/learning-c-with-pebble/content/chapter04.html"; }
                { name = "Tutorials // Pebble Developers"; url = "https://developer.repebble.com/tutorials/"; }
                { name = "CloudPebble"; url = "https://cloudpebble.repebble.com/ide/"; }
              ];
            }
            {
              name = "MCM";
              bookmarks = [
                { name = "G Drive"; url = "https://drive.google.com/drive/u/0/folders/1iY98aDj5Ql6BoKUvEt4TPV0sUwnCdlF7"; }
                { name = "Pebblehost"; url = "https://panel.pebblehost.com/server/3e437777"; }
              ];
            }
            { name = "Stop Misusing Rate Limiting in Go - 5 Real-World Fixes"; url = "https://www.linkedin.com/pulse/stop-writing-dumb-rate-limiters-go-do-thisinstead-archit-argarwal-xjuac"; }
          ];
        }
      ];
    };

    settings =
      let
        homepage-url = "https://start.duckduckgo.com";
      in
      {
        "browser.startup.homepage" = homepage-url;
        "browser.startup.page" = 1;
        "browser.newtabpage.enabled" = false;
        "browser.newtab.url" = homepage-url;
        "browser.tabs.warnOnClose" = false;
      };

    search = {
      force = true;
      default = "ddg";
      privateDefault = "ddg";

      engines = {
        ddg = {
          urls = [{ template = "https://duckduckgo.com/?q={searchTerms}"; }];
          definedAliases = [ "@ddg" ];
        };

        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                { name = "channel"; value = "25.11"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" "@nixpkgs" ];
        };

        "Nix Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                { name = "channel"; value = "25.11"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@no" "@nixoptions" ];
        };

        "Home Manager Options" = {
          urls = [
            {
              template = "https://home-manager-options.extranix.com";
              params = [
                { name = "release"; value = "release-25.11"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@hm" "@homemanager" ];
        };

        "NixOS Wiki" = {
          urls = [
            {
              template = "https://wiki.nixos.org/w/index.php";
              params = [
                { name = "search"; value = "{searchTerms}"; }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@nixwix" "@nixoswiki" ];
        };

        bing.metaData.hidden = true;
        google.metaData.hidden = true;
        eBay.metaData.hidden = true;
        perplexity.metaData.hidden = true;
        wikipedia.metaData.hidden = true;
      };
    };
  };
}
