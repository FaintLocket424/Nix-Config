#!/usr/bin/env fish

# Get the correct path for the vpnc-script on NixOS
set vpnc_path (readlink -f (which vpnc-script))

echo "Starting Durham VPN..."

# 1. Start OpenConnect in the background
# This will prompt for your sudo password, then the VPN credentials
sudo openconnect --protocol=f5 access.durham.ac.uk --script $vpnc_path &

# Capture the PID of the backgrounded job
set vpn_pid (jobs -p | tail -n 1)

# 2. Wait for the tun0 interface to appear
echo "Waiting for connection to establish..."
while not ip addr show tun0 >/dev/null 2>&1
    sleep 1
    # Safety check: exit if the VPN process crashes/exits early
    if not ps -p $vpn_pid >/dev/null
        echo "Error: VPN process died before connection was established."
        exit 1
    end
end

# 3. Configure Split DNS for NixOS
echo "Configuring Split DNS via systemd-resolved..."
sudo resolvectl dns tun0 10.255.0.1 10.255.0.2
sudo resolvectl domain tun0 ~dur.ac.uk ~mds.ad.dur.ac.uk

echo "------------------------------------------------"
echo " SUCCESS: Tunnel active and DNS configured."
echo " Routes: Durham traffic via VPN, all else home."
echo " DNS: .dur.ac.uk via Durham, all else home."
echo "------------------------------------------------"

# 4. Bring the VPN process back to the foreground
# This allows you to see session logs and use Ctrl+C to disconnect
fg %1