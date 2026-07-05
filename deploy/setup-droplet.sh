#!/usr/bin/env bash
# One-time droplet setup for the ODS static site.
# Run as root on a fresh Ubuntu 24.04 droplet:
#   bash setup-droplet.sh
# Prereq: you've generated a deploy keypair on your Mac:
#   ssh-keygen -t ed25519 -f ~/.ssh/ods_deploy -C "ods-deploy" -N ""
# Paste the PUBLIC key (~/.ssh/ods_deploy.pub) when prompted below.
set -euo pipefail

echo "==> Installing nginx + firewall"
apt-get update -qq && apt-get install -y -qq nginx ufw
ufw allow OpenSSH && ufw allow 'Nginx Full' && ufw --force enable

echo "==> Creating docroot"
mkdir -p /var/www/ondemandstaffing
chown -R www-data:www-data /var/www/ondemandstaffing

echo "==> Creating deploy user (used by the GitHub Action)"
if ! id deploy &>/dev/null; then
  adduser --disabled-password --gecos "" deploy
fi
usermod -aG www-data deploy
chown -R deploy:www-data /var/www/ondemandstaffing
chmod -R g+w /var/www/ondemandstaffing

mkdir -p /home/deploy/.ssh && chmod 700 /home/deploy/.ssh
echo ""
echo "Paste the DEPLOY PUBLIC KEY (contents of ~/.ssh/ods_deploy.pub), then Enter:"
read -r PUBKEY
echo "$PUBKEY" >> /home/deploy/.ssh/authorized_keys
chmod 600 /home/deploy/.ssh/authorized_keys
chown -R deploy:deploy /home/deploy/.ssh

echo "==> Installing nginx site config"
# Expects nginx-ondemandstaffing.conf alongside this script
cp "$(dirname "$0")/nginx-ondemandstaffing.conf" /etc/nginx/sites-available/ondemandstaffing
ln -sf /etc/nginx/sites-available/ondemandstaffing /etc/nginx/sites-enabled/ondemandstaffing
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl reload nginx

echo ""
echo "==> Done. Next:"
echo "  1. Add GitHub repo secrets: DEPLOY_HOST=<this droplet's IP>, DEPLOY_SSH_KEY=<contents of ~/.ssh/ods_deploy (PRIVATE key)>"
echo "  2. Push to main — the Action deploys automatically."
echo "  3. Visit http://<droplet-ip>/ to verify."
