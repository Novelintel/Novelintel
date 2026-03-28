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

function formatJSONOutput(data) {
  return JSON.stringify(data, null, 2);
}

function formatHeaderString(cookies, response) {
  const cookieBlock = cookies.map(c => {
    let str = `${c.name}=${c.value}`;
    if (c.domain) str += `; Domain=${c.domain}`;
    if (c.path) str += `; Path=${c.path}`;
    if (c.secure) str += `; Secure`;
    if (c.httpOnly) str += `; HttpOnly`;
    if (c.sameSite) str += `; SameSite=${c.sameSite}`;
    return str;
  }).join("\n");

  const extra = "\n\n# Extra Browser Data (JSON)\n" +
                JSON.stringify(response, null, 2);

  return cookieBlock + extra;
}

function formatNetscape(cookies, response) {
  const header = "# Netscape HTTP Cookie File\n# Extended with browser data\n\n";

  const lines = cookies.map(c => {
    const domain = c.domain.startsWith(".") ? c.domain : "." + c.domain;
    const flag = c.domain.startsWith(".") ? "TRUE" : "FALSE";
    const path = c.path || "/";
    const secure = c.secure ? "TRUE" : "FALSE";
    const expiry = c.expirationDate ? Math.floor(c.expirationDate) : 0;

    return [
      domain,
      flag,
      path,
      secure,
      expiry,
      c.name,
      c.value
    ].join("\t");
  });

  const extra = "\n\n# Extra Browser Data (JSON)\n" +
                JSON.stringify(response, null, 2);

  return header + lines.join("\n") + extra;
}

function applyCookies(cookies) {
  return Promise.all(
    cookies.map(c => {
      return new Promise(resolve => {
        try {
          const url = "https://" + (c.domain || "").replace(/^\./, "");

          chrome.cookies.set({
            url: url,
            name: c.name,
            value: c.value,
            domain: c.domain,
            path: c.path || "/",
            secure: c.secure || false,
            httpOnly: c.httpOnly || false,
            expirationDate: c.expirationDate || undefined,
            sameSite: c.sameSite || "no_restriction"
          }, resolve);
        } catch {
          resolve();
        }
      });
    })
  );
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

  let output;

  if (format === "json") {
    output = formatJSONOutput(response);
    
  } else if (format === "pretty") {
    output = formatHeaderString(response.cookies, response);
    
  } else if (format === "compact") {
    output = formatNetscape(response.cookies, response);
    
  } else {
    output = JSON.stringify(response, null, 2);
  }

  const base64 = toBase64(output);
  const encoded = rot13(base64);

  await navigator.clipboard.writeText(encoded);

  const countCookies = response.cookies.length;

  setStatus(
    `<div class="sparkle" style="font-size:22px;">✔️</div>
     Copied ${countCookies} cookies`
  );

  document.getElementById("statusDomains").innerHTML = "";
}

document.getElementById("copyBtn").addEventListener("click", () => handleCopyRequest("json"));
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

document.getElementById("applyImport").addEventListener("click", async () => {
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

  const decoded = decodeURIComponent(escape(atob(rot)));

  let cookies = [];

  try {
    const data = JSON.parse(decoded);
    if (data.cookies && Array.isArray(data.cookies)) {
      cookies = data.cookies;
    }
  } catch {}

  if (!cookies.length && decoded.includes("\t")) {
    const lines = decoded.split("\n").filter(l => l.trim() && !l.startsWith("#"));

    cookies = lines.map(line => {
      const parts = line.split("\t");
      if (parts.length < 7) return null;

      return {
        domain: parts[0],
        path: parts[2],
        secure: parts[3] === "TRUE",
        expirationDate: parseInt(parts[4]) || 0,
        name: parts[5],
        value: parts[6]
      };
    }).filter(Boolean);
  }

  if (!cookies.length && decoded.includes("=")) {
    const lines = decoded.split("\n");

    lines.forEach(line => {
      const parts = line.split(";");
      let cookie = {};

      parts.forEach((p, i) => {
        const [k, ...v] = p.split("=");
        const key = k.trim();
        const val = v.join("=").trim();

        if (i === 0) {
          cookie.name = key;
          cookie.value = val;
        } else if (key.toLowerCase() === "domain") {
          cookie.domain = val;
        } else if (key.toLowerCase() === "path") {
          cookie.path = val;
        } else if (key.toLowerCase() === "secure") {
          cookie.secure = true;
        } else if (key.toLowerCase() === "httponly") {
          cookie.httpOnly = true;
        } else if (key.toLowerCase() === "samesite") {
          cookie.sameSite = val;
        }
      });

      if (cookie.name) cookies.push(cookie);
    });
  }

  if (!cookies.length) {
    setStatus(`<div class="shake">Unknown format</div>`);
    document.getElementById("statusDomains").innerHTML = "";
    return;
  }

  await applyCookies(cookies);
  
    const domains = [...new Set(cookies.map(c => (c.domain || "").replace(/^\./, "")))]
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
