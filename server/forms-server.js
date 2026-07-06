/* OnDemand Staffing — form submission server
   Zero-framework Node server. Receives contact/newsletter submissions and
   emails them via Gmail SMTP (Google Workspace app password).

   PIPEDA: submission contents (names, emails, messages) are NEVER logged or
   stored on disk — they exist in memory only for the duration of the send.
   Logs contain timestamps, form source, and status codes only.

   Config: /etc/ods-forms.env  (systemd EnvironmentFile)
     SMTP_USER=info@ondemandstaffing.ca
     SMTP_PASS=<16-char Google app password>
*/

const http = require("http");
const nodemailer = require("nodemailer");

const PORT = 3001;
const SITE = "ondemandstaffing.ca";

// Server-side recipient map. The browser sends a "source" tag, never an address.
const ROUTES = {
  "contact-employer": { to: "info@ondemandstaffing.ca", label: "Employer contact form (/contact)" },
  "contact-learn-more": { to: "info@ondemandstaffing.ca", label: "Learn More lead form (/learn-more)" },
  "contact-job-seeker": { to: "work@ondemandstaffing.ca", label: "Job seeker contact form (/contact-job-seeker)" },
  "newsletter": { to: "info@ondemandstaffing.ca", label: "Newsletter signup" },
};

const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 465,
  secure: true,
  auth: { user: process.env.SMTP_USER, pass: process.env.SMTP_PASS },
});

// --- naive per-IP rate limit: 5 submissions / 10 minutes ---
const hits = new Map();
function rateLimited(ip) {
  const now = Date.now();
  const windowStart = now - 10 * 60 * 1000;
  const list = (hits.get(ip) || []).filter((t) => t > windowStart);
  list.push(now);
  hits.set(ip, list);
  if (hits.size > 5000) hits.clear(); // memory guard
  return list.length > 5;
}

const clean = (v, max) => String(v ?? "").trim().slice(0, max);
const validEmail = (e) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(e);

function json(res, code, obj) {
  res.writeHead(code, { "Content-Type": "application/json" });
  res.end(JSON.stringify(obj));
}

async function handle(req, res) {
  if (req.method !== "POST") return json(res, 405, { ok: false });

  const ip = (req.headers["x-forwarded-for"] || req.socket.remoteAddress || "").split(",")[0].trim();
  if (rateLimited(ip)) return json(res, 429, { ok: false, error: "Too many requests" });

  let body = "";
  for await (const chunk of req) {
    body += chunk;
    if (body.length > 20000) return json(res, 413, { ok: false });
  }

  let data;
  try { data = JSON.parse(body); } catch { return json(res, 400, { ok: false }); }

  // Honeypot: hidden "website" field — humans leave it empty, bots fill it.
  // Return success so bots don't learn; nothing is sent.
  if (clean(data.website, 50)) return json(res, 200, { ok: true });

  const route = ROUTES[clean(data.source, 40)];
  if (!route) return json(res, 400, { ok: false, error: "Unknown form" });

  const email = clean(data.email, 200);
  if (!validEmail(email)) return json(res, 400, { ok: false, error: "Valid email required" });

  let subject, text;
  if (req.url === "/api/newsletter") {
    subject = `New newsletter signup — ${SITE}`;
    text = `New newsletter subscriber:\n\n${email}\n\nSource: ${route.label}\nTime: ${new Date().toISOString()}`;
  } else if (req.url === "/api/contact") {
    const name = clean(data.name, 200);
    const message = clean(data.message, 5000);
    if (!name || !message) return json(res, 400, { ok: false, error: "Name and message required" });
    subject = `Website lead: ${clean(data.subject, 200) || "New enquiry"} — ${name}`;
    text = [
      `New submission from ${route.label}`,
      ``,
      `Name:    ${name}`,
      `Email:   ${email}`,
      `Phone:   ${clean(data.phone, 50) || "(not provided)"}`,
      `Subject: ${clean(data.subject, 200) || "(not provided)"}`,
      ``,
      `Message:`,
      message,
      ``,
      `— Sent by the ${SITE} website at ${new Date().toISOString()}`,
    ].join("\n");
  } else {
    return json(res, 404, { ok: false });
  }

  try {
    await transporter.sendMail({
      from: `"ODS Website" <${process.env.SMTP_USER}>`,
      to: route.to,
      replyTo: email,
      subject,
      text,
    });
    console.log(`${new Date().toISOString()} sent source=${data.source} -> ${route.to}`);
    return json(res, 200, { ok: true });
  } catch (err) {
    console.error(`${new Date().toISOString()} send FAILED source=${data.source}: ${err.code || err.message}`);
    return json(res, 502, { ok: false, error: "Email delivery failed" });
  }
}

http.createServer((req, res) => {
  handle(req, res).catch(() => json(res, 500, { ok: false }));
}).listen(PORT, "127.0.0.1", () => console.log(`ods-forms listening on 127.0.0.1:${PORT}`));
