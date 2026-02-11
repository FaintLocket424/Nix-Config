#!/usr/bin/env fish

# This script must be run with sudo: 'sudo ./durham-vpn.fish'

# 1. Check if we are actually running as root
if not functions -q fish_is_root_user; or not fish_is_root_user
    echo "Error: This script must be run with sudo."
    echo "Usage: sudo ./durham-vpn.fish"
    exit 1
end

# 2. Find the vpnc-script (NixOS path)
set vpnc_path (readlink -f (which vpnc-script))

# 3. Start the DNS Watcher in the background
# Since we are already root, the watcher can run 'resolvectl' freely
begin
    echo "[Watcher] Waiting for tun0 interface..."
    while not ip link show tun0 >/dev/null 2>&1
        sleep 1
        # If openconnect stops before tun0 appears, kill the watcher
        if not pgrep -x openconnect >/dev/null
            exit
        end
    end

    # Give the interface a second to fully initialize
    sleep 2

    echo "[Watcher] Interface tun0 found. Configuring Split DNS..."
    resolvectl dns tun0 10.255.0.1 10.255.0.2
    resolvectl domain tun0 ~dur.ac.uk ~mds.ad.dur.ac.uk

    echo "------------------------------------------------"
    echo " SUCCESS: Tunnel active and DNS configured."
    echo "------------------------------------------------"
end &

# 4. Start OpenConnect in the foreground
# We don't need 'sudo' here because the whole script is running as root
echo "Starting OpenConnect..."
openconnect --protocol=f5 access.durham.ac.uk --script $vpnc_path