# Deploy Runbook

## Phase A — Localize assets (your Mac)

```bash
cd ~/Claude/Projects/ODS\ Website/site
bash scripts/download-assets.sh
```

Then tell Claude "assets downloaded" — Claude rewrites all CDN URLs to `/assets/…` and commits.

## Phase B — GitHub

1. github.com → create org `ondemand-staffing` (free plan) → create empty **private** repo `website` (no README).
2. Push:

```bash
cd ~/Claude/Projects/ODS\ Website/site
git remote add origin git@github.com:ondemand-staffing/website.git
git branch -M main
git push -u origin main
```

## Phase C — Droplet (one time)

1. DigitalOcean → Create Droplet: Ubuntu 24.04 LTS, Basic $6/mo, Toronto (TOR1), add your SSH key. Name: `ods-web`.
2. On your Mac, make the deploy keypair:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/ods_deploy -C "ods-deploy" -N ""
```

3. Copy setup files up and run them:

```bash
scp deploy/setup-droplet.sh deploy/nginx-ondemandstaffing.conf root@<DROPLET_IP>:/root/
ssh root@<DROPLET_IP> "bash /root/setup-droplet.sh"
# paste contents of ~/.ssh/ods_deploy.pub when prompted
```

4. GitHub repo → Settings → Secrets and variables → Actions:
   - `DEPLOY_HOST` = droplet IP
   - `DEPLOY_SSH_KEY` = contents of `~/.ssh/ods_deploy` (the private key file — paste into GitHub only, nowhere else)
5. Push to main (or Actions tab → Deploy → Run workflow). Site is live at `http://<DROPLET_IP>/`.

## Phase D — Cutover (LATER — blocked until forms are wired)

Do not do this yet. When R1 (form backend) and R3 (jobs board) are resolved:

1. `deploy/nginx-ondemandstaffing.conf`: set `server_name ondemandstaffing.ca www.ondemandstaffing.ca;`, redeploy config, reload nginx.
2. GoDaddy DNS (you, in the GoDaddy UI): A record `@` → droplet IP, CNAME `www` → `@`. Drop TTL to 600 an hour before switching.
3. On droplet: `apt install certbot python3-certbot-nginx && certbot --nginx -d ondemandstaffing.ca -d www.ondemandstaffing.ca`.
4. Verify forms deliver leads end-to-end, then keep Webflow paid one more billing cycle as rollback insurance before cancelling.

## Rollback

DNS back to Webflow's records (keep a screenshot of the current GoDaddy DNS zone before changing anything).
