const CONFIG_URL = "./ens/identity-roots.json";

function esc(v){
  return String(v ?? "")
    .replaceAll("&","&amp;")
    .replaceAll("<","&lt;")
    .replaceAll(">","&gt;");
}

async function loadEnsRoots(){
  const host = document.querySelector("#ensRail");
  if(!host) return;

  try{
    const r = await fetch(CONFIG_URL + "?t=" + Date.now(), {
      cache:"no-store"
    });

    if(!r.ok) throw new Error("HTTP " + r.status);

    const cfg = await r.json();

    host.innerHTML = cfg.names.map(n => `
      <a class="ensCard"
         href="${
           n.network === "ethereum"
             ? "https://app.ens.domains/" + encodeURIComponent(n.name)
             : "https://www.base.org/name/" + encodeURIComponent(n.name.replace(".base.eth",""))
         }"
         target="_blank"
         rel="noopener">
        <div class="ensLabel">${esc(n.network.toUpperCase())}</div>
        <strong>${esc(n.name)}</strong>
        <div class="ensMeta">
          ${esc(n.role)} · LIVE RESOLUTION WITNESS
        </div>
        <div class="ensState">CLICK TO RESOLVE ↗</div>
      </a>
    `).join("");

  }catch(err){
    host.innerHTML =
      '<div class="ensCard">ENS RAIL READ ERROR · ' +
      esc(err.message) +
      '</div>';
  }
}

loadEnsRoots();
setInterval(loadEnsRoots,5000);
