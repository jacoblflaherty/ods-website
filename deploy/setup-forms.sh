#!/usr/bin/env bash
# One-time forms-backend setup on the ODS droplet. Run as root:
#   bash setup-forms.sh
# Expects forms-server.js alongside this script (scp'd to /root/).
set -euo pipefail

echo "==> Installing Node.js 20"
if ! command -v node &>/dev/null; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash - >/dev/null
  apt-get install -y -qq nodejs
fi
node --version

echo "==> Installing form server to /opt/ods-forms"
mkdir -p /opt/ods-forms
cp "$(dirname "$0")/forms-server.js" /opt/ods-forms/
cd /opt/ods-forms
npm init -y >/dev/null 2>&1 || true
npm install --no-fund --no-audit nodemailer >/dev/null

echo "==> Creating config file /etc/ods-forms.env (edit it after this script!)"
if [ ! -f /etc/ods-forms.env ]; then
  cat > /etc/ods-forms.env << 'ENV'
SMTP_USER=info@ondemandstaffing.ca
SMTP_PASS=PASTE_APP_PASSWORD_HERE
ENV
  chmod 600 /etc/ods-forms.env
fi

echo "==> Creating systemd service"
cat > /etc/systemd/system/ods-forms.service << 'UNIT'
[Unit]
Description=ODS website form server
After=network.target

[Service]
ExecStart=/usr/bin/node /opt/ods-forms/forms-server.js
EnvironmentFile=/etc/ods-forms.env
Restart=always
RestartSec=5
User=www-data
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable ods-forms >/dev/null 2>&1

echo "==> Adding /api/ proxy to nginx"
if ! grep -q "location /api/" /etc/nginx/sites-available/ondemandstaffing; then
  sed -i 's|    error_page 404 /404.html;|    location /api/ {\n        proxy_pass http://127.0.0.1:3001;\n        proxy_set_header X-Forwarded-For $remote_addr;\n        client_max_body_size 32k;\n    }\n\n    error_page 404 /404.html;|' /etc/nginx/sites-available/ondemandstaffing
fi
nginx -t && systemctl reload nginx

echo ""
echo "==> Done. FINAL STEPS:"
echo "  1. Edit the config:      nano /etc/ods-forms.env   (replace PASTE_APP_PASSWORD_HERE)"
echo "  2. Start the service:    systemctl restart ods-forms"
echo "  3. Check it's running:   systemctl status ods-forms --no-pager"
