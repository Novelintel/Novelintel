function rot13(str) {
  return str.replace(/[A-Za-z]/g, (c) =>
    String.fromCharCode(
      c <= "Z"
        ? ((c.charCodeAt(0) - 65 + 13) % 26) + 65
        : ((c.charCodeAt(0) - 97 + 13) % 26) + 97
    )
  );
}

function toBase64(str) {
  return btoa(unescape(encodeURIComponent(str)));
}

function setStatus(html) {
  document.getElementById("statusMessage").innerHTML =
    `<div class="fade">${html}</div>`;
}

async function fakeStep(text, delay = 900) {
  setStatus(`<div class="cookie">🍪</div>${text}<span class="dots"></span>`);
  await new Promise((resolve) => setTimeout(resolve, delay));
}

function collectAllData() {
  return new Promise((resolve) => {
    chrome.runtime.sendMessage({ action: "collectAllData" }, (response) => {
      resolve(response);
    });
  });
}

function formatJSON(data, pretty) {
  if (pretty) return JSON.stringify(data, null, 2);
  return JSON.stringify(data);
}

async function handleCopyRequest(format) {
  await fakeStep("Collecting browser data");
  await fakeStep("Encrypting");
  await fakeStep("Packaging");

  const response = await collectAllData();
  if (!response) {
    setStatus(`<div class="shake">Failed to collect data</div>`);
    return;
  }

  const pretty = format !== "compact";
  const json = formatJSON(response, pretty);

  const base64 = toBase64(json);
  const encoded = rot13(base64);

  await navigator.clipboard.writeText(encoded);

  const countCookies = response.cookies.length;

  setStatus(
    `<div class="sparkle" style="font-size:22px;">✔️</div>
     Copied ${countCookies} cookies`
  );

  document.getElementById("statusDomains").innerHTML = "";
}

document.getElementById("copyBtn").addEventListener("click", () => handleCopyRequest("pretty"));
document.getElementById("copyPretty").addEventListener("click", () => handleCopyRequest("pretty"));
document.getElementById("copyCompact").addEventListener("click", () => handleCopyRequest("compact"));

document.getElementById("clearCookies").addEventListener("click", () => {
  const site = document.getElementById("siteInput").value.trim();
  if (!site) {
    setStatus(`<div class="shake">Enter a site first</div>`);
    document.getElementById("statusDomains").innerHTML = "";
    return;
  }
  chrome.browsingData.remove({
    origins: ["https://" + site]
  }, {
    cookies: true
  }, () => {
    setStatus(`<div class="sparkle" style="font-size:22px;">✔️</div>Cookies cleared`);
    document.getElementById("statusDomains").innerHTML = "";
  });
});

document.getElementById("importCookies").addEventListener("click", () => {
  document.getElementById("importBox").style.display = "block";
});

document.getElementById("applyImport").addEventListener("click", () => {
  const encoded = document.getElementById("importText").value.trim();

  if (!encoded) {
    setStatus(`<div class="shake">No data pasted</div>`);
    document.getElementById("statusDomains").innerHTML = "";
    return;
  }

  try {
    const rot = encoded.replace(/[A-Za-z]/g, (c) =>
      String.fromCharCode(
        c <= "Z"
          ? ((c.charCodeAt(0) - 65 + 13) % 26) + 65
          : ((c.charCodeAt(0) - 97 + 13) % 26) + 97
      )
    );

    const jsonStr = decodeURIComponent(escape(atob(rot)));
    const data = JSON.parse(jsonStr);

    if (!data.cookies || !Array.isArray(data.cookies)) {
      setStatus(`<div class="shake">Invalid cookie data</div>`);
      document.getElementById("statusDomains").innerHTML = "";
      return;
    }

    const domains = [...new Set(data.cookies.map(c => c.domain.replace(/^\./, "")))]
  .sort((a, b) => a.localeCompare(b));

    setStatus(`Detected ${domains.length} domains`);

    const domainBox = document.getElementById("statusDomains");
    domainBox.innerHTML = "";

    domains.forEach(domain => {
      const btn = document.createElement("button");
      btn.textContent = domain;
      btn.style.cssText = `
        width: 100%;
        padding: 10px;
        margin-top: 6px;
        border-radius: 10px;
        background: var(--button);
        border: 1px solid var(--border);
        color: var(--text);
        cursor: pointer;
        text-align: left;
      `;
      btn.onclick = () => chrome.tabs.create({ url: "https://" + domain });
      domainBox.appendChild(btn);
    });

  } catch (err) {
    setStatus(`<div class="shake">Failed to decode</div>`);
    document.getElementById("statusDomains").innerHTML = "";
  }
});

document.getElementById("themeToggle").addEventListener("click", () => {
  document.body.classList.toggle("light");
});

