#!/usr/bin/env fish

# 1. Check if tun0 exists
if not ip link show tun0 >/dev/null 2>&1
    echo "Error: VPN interface (tun0) not found."
    echo "Please run 'vpn-connect.fish' in another terminal first."
    exit 1
end

# 2. Apply DNS settings via systemd-resolved
echo "Step 2: Configuring Split DNS for Durham..."

sudo resolvectl dns tun0 10.255.0.1 10.255.0.2
sudo resolvectl domain tun0 ~dur.ac.uk ~mds.ad.dur.ac.uk

echo "------------------------------------------------"
echo "DNS Configured!"
echo "You can now access Durham internal sites."
echo "Test: ping mira.dur.ac.uk"
echo "------------------------------------------------"