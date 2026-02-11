#!/usr/bin/env fish

# 1. Prepare the DNS Watcher function
# This runs in the background and waits for the VPN to connect
function vpn_dns_watcher
    echo "Watcher: Waiting for tun0 interface..."
    while not ip addr show tun0 >/dev/null 2>&1
        sleep 1
        # If the main openconnect process dies, stop the watcher
        if not pgrep -x openconnect >/dev/null
            return
        end
    end

    echo "Watcher: Detected tun0. Configuring Split DNS..."
    sudo resolvectl dns tun0 10.255.0.1 10.255.0.2
    sudo resolvectl domain tun0 ~dur.ac.uk ~mds.ad.dur.ac.uk

    echo "------------------------------------------------"
    echo " SUCCESS: Tunnel active and DNS configured."
    echo " Routes: Durham traffic via VPN, all else home."
    echo " DNS: .dur.ac.uk via Durham, all else home."
    echo "------------------------------------------------"
end

# 2. Get the vpnc-script path
set vpnc_path (readlink -f (which vpnc-script))

# 3. Start the DNS watcher in the background
vpn_dns_watcher &

# 4. Start OpenConnect in the FOREGROUND
# This ensures you see the password/MFA prompts and can Ctrl+C to stop.
echo "Starting OpenConnect..."
sudo openconnect --protocol=f5 access.durham.ac.uk --script $vpnc_path

# 5. Cleanup when VPN stops
echo "VPN Disconnected."