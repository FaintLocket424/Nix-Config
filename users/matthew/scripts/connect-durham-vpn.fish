# Find the exact Nix store paths from the script's isolated environment
set oc_path (command -v openconnect)
set vpnc_path (command -v vpnc-script)

echo "🎓 Connecting to Durham University VPN..."
echo "⚠️  Keep this terminal open to stay connected."
echo "----------------------------------------"

# Run the absolute path with sudo, bypassing the sudo PATH reset
sudo $oc_path --protocol=f5 access.durham.ac.uk --script $vpnc_path --no-dtls