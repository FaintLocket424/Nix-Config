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
        id = "MYFAGZC-Z6HAPNZ-4Y66OCM-JBIXCWG-IB42EPE-YJOKBC3-QCO6LH5-TOPPGA5";
      };
      s25 = {
        name = "S25";
        id = "RJYXKAI-CMTCOMD-XPLK5PG-4DGG3FB-SWFD6TL-B7WQDZJ-EKC4B2P-LRXNVA2";
      };
    };

    folders = {
      programming = {
        enable = true;
        devices = ["falcon"];
        id = "programming";
        label = "Programming";
        path = "~/programming";
      };
      sharedDocuments = {
        enable = true;
        devices = ["falcon"];
        id = "sharedDocuments";
        label = "Shared Documents";
        path = "~/sharedDocuments";
      };
    };
  };
}
