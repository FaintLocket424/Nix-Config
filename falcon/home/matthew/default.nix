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
    };
  };
}
