#!/usr/bin/env fish

# Get the NixOS path for vpnc-script
set vpnc_path (readlink -f (which vpnc-script))

echo "Step 1: Connecting to Durham VPN..."
echo "Keep this terminal open to stay connected."
echo "----------------------------------------"

sudo openconnect --protocol=f5 access.durham.ac.uk --script $vpnc_path --no-dtls