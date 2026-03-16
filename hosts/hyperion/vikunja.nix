{
  lib,
  config,
  pkgs,
  hostname,
  ...
}:
{
  services.vikunja = {
    enable = true;
    port = 3456;

    # Tell Vikunja how it will be accessed so CORS and routing work properly.
    # Because you have Avahi and Tailscale, 'hyperion' or 'hyperion.local' will work!
    frontendScheme = "http";
    frontendHostname = hostname;

    settings = {
      service = {
        # Leave this true initially so you can create your admin account.
        # You can change it to false later to prevent others from making accounts.
        enableregistration = false;
        timezone = "Europe/London";
      };
      # Default to SQLite for a lightweight, zero-maintenance laptop database
      database = {
        type = "sqlite";
        path = "/var/lib/vikunja/vikunja.db";
      };
    };
  };

  # Open the port so other devices on Tailscale/LAN can reach the to-do list
  networking.firewall.allowedTCPPorts = [ 3456 ];
}
