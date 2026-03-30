# Capture the absolute Nix store paths so they survive 'sudo'
set ip_cmd (command -v ip)
set resolvectl_cmd (command -v resolvectl)

# 1. Check if tun0 exists
if not $ip_cmd link show tun0 >/dev/null 2>&1
    echo "❌ Error: VPN interface (tun0) not found."
    echo "Please run 'connect-durham-vpn' in another terminal first."
    exit 1
end

# 2. Apply DNS settings via systemd-resolved
echo "⚙️  Configuring Split DNS for Durham University..."

sudo $resolvectl_cmd dns tun0 10.255.0.1 10.255.0.2
sudo $resolvectl_cmd domain tun0 ~dur.ac.uk ~mds.ad.dur.ac.uk

echo "------------------------------------------------"
echo "✅ DNS Configured Successfully!"
echo "You can now access Durham internal sites securely."
echo "Test connection: ping mira.dur.ac.uk"
echo "------------------------------------------------"