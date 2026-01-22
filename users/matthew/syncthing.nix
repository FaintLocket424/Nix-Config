{ hostname, ... }:
let
  # Define all your devices here once
  devices = {
    falcon = {
      id = "5P3PM4N-LPNZ6UR-AS2NZHK-LPOBUKB-42TYS4O-HPZCTUF-XFXQHCW-M6K7GAR";
      name = "Falcon";
    };
    hyperion = {
      id = "T66QOX3-NADLDBH-UBAUUVR-U53YNCA-2GVR4JI-MS3RF4U-WWHHBGZ-YJYWWAU";
      name = "Hyperion";
    };
    s25 = {
      id = "RJYXKAI-CMTCOMD-XPLK5PG-4DGG3FB-SWFD6TL-B7WQDZJ-EKC4B2P-LRXNVA2";
      name = "S25";
    };
  };

  # Helper: Remove the current machine from a list of device names
  # This prevents a machine from trying to connect to itself
  others = deviceNames: builtins.filter (d: d != hostname) deviceNames;
in
{
  services.syncthing = {
    enable = true;
    settings = {
      # Include all devices EXCEPT the current host
      devices = builtins.removeAttrs devices [ hostname ];

      folders = {
        "programming" = {
          id = "programming";
          label = "Programming";
          path = "~/programming";
          devices = others [
            "falcon"
            "hyperion"
          ];
        };

        "sharedDocuments" = {
          id = "sharedDocuments";
          label = "Shared Documents";
          path = "~/sharedDocuments";
          # On hyperion, this includes s25. On falcon, it just includes hyperion.
          devices = others [
            "falcon"
            "hyperion"
            "s25"
          ];
        };

        "lecture-tracker" = {
          id = "lecture-tracker";
          label = "Lecture Tracker";
          path = "~/.local/share/lecture_tracker";
          devices = others [
            "falcon"
            "hyperion"
          ];
        };

        #        "modrinth-instances" = {
        #          id = "modrinth-instances";
        #          label = "Modrinth Instances";
        #          path = "~/Games/Standalone Games/Minecraft/ModrinthApp/profiles";
        #          devices = others [
        #            "falcon"
        #            "hyperion"
        #          ];
        #        };
      };
    };
  };
}
