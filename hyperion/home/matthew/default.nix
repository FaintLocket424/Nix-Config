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
      falcon = {
        name = "Falcon";
        id = "XFGFHYX-PW2S6YQ-AUZQRZK-HDW63XF-G5VBUSQ-QZJEDK7-GBBSNW3-5YU4YQE";
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
    (modrinth-app.overrideAttrs (oldAttrs: {
      RUSTFLAGS = "-A warnings";
    }))
  ];
}
