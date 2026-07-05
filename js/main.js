/* OnDemand Staffing — main.js
   Replaces jQuery + Webflow runtime (~350KB) with <3KB of vanilla JS. */

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

// Forms — UI only. TODO: wire to backend endpoint (+ Turnstile) before launch.
// Submissions are intentionally NOT sent anywhere yet; the live Webflow site
// remains the real lead pipeline until cutover.
document.querySelectorAll("form[data-form]").forEach((form) => {
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    if (!form.reportValidity()) return;
    const ok = form.querySelector(".form__status--ok");
    const err = form.querySelector(".form__status--err");
    if (err) err.style.display = "none";
    if (ok) {
      ok.style.display = "block";
      ok.textContent =
        form.dataset.form === "newsletter"
          ? "Thank you for subscribing to our newsletter!"
          : "Thank you! Your submission has been received!";
    }
    form.reset();
    // When the backend exists:
    // fetch("/api/contact", { method: "POST", body: new FormData(form) })
  });
});
