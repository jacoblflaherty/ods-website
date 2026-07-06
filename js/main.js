/* OnDemand Staffing — main.js
   Vanilla JS replacing jQuery + Webflow runtime. Forms POST to the droplet's
   /api endpoints (see server/forms-server.js). */

// Mobile nav toggle
const toggle = document.querySelector(".nav__toggle");
const menu = document.querySelector(".nav__menu");
if (toggle && menu) {
  toggle.addEventListener("click", () => {
    const open = menu.classList.toggle("is-open");
    document.body.classList.toggle("nav-open", open);
    toggle.setAttribute("aria-expanded", String(open));
  });
}

// Dynamic copyright year
document.querySelectorAll("[data-year]").forEach((el) => {
  el.textContent = new Date().getFullYear();
});

// ---- Forms -----------------------------------------------------------------
// source tag tells the server which inbox to route to (mapping lives server-side)
function formSource(kind) {
  if (kind === "newsletter") return "newsletter";
  const p = location.pathname;
  if (p.startsWith("/contact-job-seeker")) return "contact-job-seeker";
  if (p.startsWith("/learn-more")) return "contact-learn-more";
  return "contact-employer";
}

document.querySelectorAll("form[data-form]").forEach((form) => {
  const kind = form.dataset.form; // "contact" | "newsletter"

  // Honeypot: invisible field bots tend to fill; server drops those silently.
  const hp = document.createElement("input");
  hp.type = "text";
  hp.name = "website";
  hp.tabIndex = -1;
  hp.autocomplete = "off";
  hp.setAttribute("aria-hidden", "true");
  hp.style.cssText = "position:absolute;left:-9999px;height:0;width:0;opacity:0";
  form.appendChild(hp);

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    if (!form.reportValidity()) return;

    const ok = form.querySelector(".form__status--ok");
    const err = form.querySelector(".form__status--err");
    const btn = form.querySelector('[type="submit"]');
    if (ok) ok.style.display = "none";
    if (err) err.style.display = "none";
    const btnLabel = btn ? btn.textContent : "";
    if (btn) { btn.disabled = true; btn.textContent = "Sending…"; }

    const payload = { source: formSource(kind) };
    new FormData(form).forEach((v, k) => (payload[k] = v));

    try {
      const r = await fetch(kind === "newsletter" ? "/api/newsletter" : "/api/contact", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
      if (!r.ok) throw new Error("send failed");

      if (kind === "contact") {
        location.href = "/thank-you/";
        return;
      }
      form.reset();
      if (ok) {
        ok.textContent = "Thank you for subscribing to our newsletter!";
        ok.style.display = "block";
      }
    } catch {
      if (err) err.style.display = "block";
    } finally {
      if (btn) { btn.disabled = false; btn.textContent = btnLabel; }
    }
  });
});
