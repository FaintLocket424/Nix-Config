{
  config,
  pkgs,
  lib,
  inputs,
  hostname,
  pkgs-25_05,
  ...
}: {
  services.syncthing.settings = {
    devices = {
      falcon = {
        name = "Falcon";
        id = "5P3PM4N-LPNZ6UR-AS2NZHK-LPOBUKB-42TYS4O-HPZCTUF-XFXQHCW-M6K7GAR";
      };
      s25 = {
        name = "S25";
        id = "RJYXKAI-CMTCOMD-XPLK5PG-4DGG3FB-SWFD6TL-B7WQDZJ-EKC4B2P-LRXNVA2";
      };
    };

    folders = {
      programming = {
        enable = true;
        devices = [ "falcon" ];
        id = "programming";
        label = "Programming";
        path = "~/programming";
      };
      sharedDocuments = {
        enable = true;
        devices = [ "falcon" "s25" ];
        id = "sharedDocuments";
        label = "Shared Documents";
        path = "~/sharedDocuments";
      };
      lecture-tracker = {
        enable = true;
        devices = [ "falcon" ];
        id = "lecture-tracker";
        label = "Lecture Tracker";
        path = "~/.local/share/lecture_tracker";
      };
      modrinth-instances = {
        enable = true;
        devices = [ "falcon" ];
        id = "modrinth-instances";
        label = "Modrinth Instances";
        path = "~/Games/Standalone Games/Minecraft/ModrinthApp/profiles";
      };
    };
  };

  home.packages = with pkgs; [
#    modrinth-app
    prismlauncher
#    (symlinkJoin {
#      name = "modrinth-app-fixed";
#      paths = [ pkgs-25_05.modrinth-app ];
#      nativeBuildInputs = [ makeWrapper ];
#      postBuild = ''
#        # 1. We must remove the symlink to the original binary so we can replace it
#        rm "$out/bin/ModrinthApp"
#
#        # 2. Create a wrapper script in its place that sets the variable
#        makeWrapper "${pkgs-25_05.modrinth-app}/bin/ModrinthApp" "$out/bin/ModrinthApp" \
#          --set WEBKIT_DISABLE_DMABUF_RENDERER 1
#      '';
#    })
  ];
}
