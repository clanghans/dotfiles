#!/bin/bash

set -e

echo "=== DNS Monitor Setup ==="
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo"
   exit 1
fi

echo "[1/4] Creating systemd service file..."
cat > /etc/systemd/system/dns-monitor.service << 'EOF'
[Unit]
Description=Monitor DNS and reconnect network if failed
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/dns-monitor.sh
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
echo "✓ Service file created"

echo "[2/4] Creating monitoring script..."
cat > /usr/local/bin/dns-monitor.sh << 'SCRIPT'
#!/bin/bash

LOGFILE="/var/log/dns-monitor.log"
CHECK_INTERVAL=30
FAIL_THRESHOLD=3
FAIL_COUNT=0

echo "$(date): DNS monitoring service started" >> "$LOGFILE"

while true; do
    # Try DNS resolution against multiple servers with timeout
    if timeout 5 nslookup bosch.com 10.53.53.53 &>/dev/null || \
       timeout 5 nslookup bosch.com 10.58.195.11 &>/dev/null || \
       timeout 5 nslookup google.com 8.8.8.8 &>/dev/null; then
        FAIL_COUNT=0
    else
        FAIL_COUNT=$((FAIL_COUNT + 1))

        if [ $FAIL_COUNT -ge $FAIL_THRESHOLD ]; then
            echo "$(date): DNS failed $FAIL_COUNT times, reconnecting network..." >> "$LOGFILE"

            # Reconnect by cycling the connection
            nmcli connection down "netplan-eno1" 2>&1 >> "$LOGFILE"
            sleep 2
            nmcli connection up "netplan-eno1" 2>&1 >> "$LOGFILE"

            echo "$(date): Network reconnected" >> "$LOGFILE"
            FAIL_COUNT=0
            sleep 10
        fi
    fi

    sleep $CHECK_INTERVAL
done
SCRIPT
chmod +x /usr/local/bin/dns-monitor.sh
echo "✓ Monitoring script created and made executable"

echo "[3/4] Enabling systemd service..."
systemctl daemon-reload
systemctl enable dns-monitor.service
echo "✓ Service enabled"

echo "[4/4] Starting service..."
systemctl start dns-monitor.service
echo "✓ Service started"

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Service status:"
systemctl status dns-monitor.service
echo ""
echo "To view logs:"
echo "  sudo journalctl -u dns-monitor -f"
echo ""
echo "To view monitoring log:"
echo "  tail -f /var/log/dns-monitor.log"
