{
  config,
  pkgs,
  lib,
  inputs,
  hostname,
  ...
}: {
  services.syncthing.settings = {
    devices = {
      hyperion = {
        name = "Hyperion";
        id = "T66QOX3-NADLDBH-UBAUUVR-U53YNCA-2GVR4JI-MS3RF4U-WWHHBGZ-YJYWWAU";
      };
      s25 = {
        name = "S25";
        id = "RJYXKAI-CMTCOMD-XPLK5PG-4DGG3FB-SWFD6TL-B7WQDZJ-EKC4B2P-LRXNVA2";
      };
    };

    folders = {
      programming = {
        enable = true;
        devices = [ "hyperion" ];
        id = "programming";
        label = "Programming";
        path = "~/programming";
      };
      sharedDocuments = {
        enable = true;
        devices = [ "hyperion" ];
        id = "sharedDocuments";
        label = "Shared Documents";
        path = "~/sharedDocuments";
      };
      lecture-tracker = {
        enable = true;
        devices = [ "hyperion" ];
        id = "lecture-tracker";
        label = "Lecture Tracker";
        path = "~/.local/share/lecture_tracker";
      };
      modrinth-instances = {
        enable = true;
        devices = [ "hyperion" ];
        id = "modrinth-instances";
        label = "Modrinth Instances";
        path = "~/Games/Standalone Games/Minecraft/ModrinthApp/profiles";
      };
    };
  };

  home.packages = with pkgs; [
#    (symlinkJoin {
#        name = "modrinth-app-fixed";
#        paths = [ modrinth-app ];
#        nativeBuildInputs = [ makeWrapper ];
#        postBuild = ''
#          # 1. We must remove the symlink to the original binary so we can replace it
#          rm "$out/bin/ModrinthApp"
#
#          # 2. Create a wrapper script in its place that sets the variable
#          makeWrapper "${modrinth-app}/bin/ModrinthApp" "$out/bin/ModrinthApp" \
#            --set WEBKIT_DISABLE_DMABUF_RENDERER 1
#        '';
#      })
    modrinth-app
  ];
}
