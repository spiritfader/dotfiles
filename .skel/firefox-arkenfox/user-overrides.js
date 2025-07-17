/*** [SECTION 2800]: SHUTDOWN & SANITIZING ***/
user_pref("_user.js.parrot", "2800 syntax error: the parrot's bleedin' demised!");
/* 2810: enable Firefox to clear items on shutdown
 * [NOTE] In FF129+ clearing "siteSettings" on shutdown (2811+), or manually via site data (2820+) and
 * via history (2830), will no longer remove sanitize on shutdown "cookie and site data" site exceptions (2815)
 * [SETTING] Privacy & Security>History>Custom Settings>Clear history when Firefox closes | Settings ***/
user_pref("privacy.sanitize.sanitizeOnShutdown", false);

/** SANITIZE ON SHUTDOWN: IGNORES "ALLOW" SITE EXCEPTIONS ***/
/* 2811: set/enforce clearOnShutdown items (if 2810 is true) [SETUP-CHROME] [FF128+] ***/
user_pref("privacy.clearOnShutdown_v2.cache", false); // [DEFAULT: true]
user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false); // [DEFAULT: true]
   // user_pref("privacy.clearOnShutdown_v2.siteSettings", false); // [DEFAULT: false]
/* 2812: set/enforce clearOnShutdown items [FF136+] ***/
user_pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", false); // [DEFAULT: true]
user_pref("privacy.clearOnShutdown_v2.downloads", false);
user_pref("privacy.clearOnShutdown_v2.formdata", false);
/* 2813: set Session Restore to clear on shutdown (if 2810 is true) [FF34+]
 * [NOTE] Not needed if Session Restore is not used (0102) or it is already cleared with history (2811+)
 * [NOTE] If true, this prevents resuming from crashes (also see 5008) ***/
   // user_pref("privacy.clearOnShutdown.openWindows", true);

/** SANITIZE ON SHUTDOWN: RESPECTS "ALLOW" SITE EXCEPTIONS ***/
/* 2815: set "Cookies" and "Site Data" to clear on shutdown (if 2810 is true) [SETUP-CHROME] [FF128+]
 * [NOTE] Exceptions: For cross-domain logins, add exceptions for both sites
 * e.g. https://www.youtube.com (site) + https://accounts.google.com (single sign on)
 * [WARNING] Be selective with what sites you "Allow", as they also disable partitioning (1767271)
 * [SETTING] to add site exceptions: Ctrl+I>Permissions>Cookies>Allow (when on the website in question)
 * [SETTING] to manage site exceptions: Options>Privacy & Security>Permissions>Settings ***/
user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", false);

/** SANITIZE SITE DATA: IGNORES "ALLOW" SITE EXCEPTIONS ***/
/* 2820: set manual "Clear Data" items [SETUP-CHROME] [FF128+]
 * Firefox remembers your last choices. This will reset them when you start Firefox
 * [SETTING] Privacy & Security>Browser Privacy>Cookies and Site Data>Clear Data ***/
user_pref("privacy.clearSiteData.cache", false);
user_pref("privacy.clearSiteData.cookiesAndStorage", false); // keep false until it respects "allow" site exceptions
user_pref("privacy.clearSiteData.historyFormDataAndDownloads", false);
   // user_pref("privacy.clearSiteData.siteSettings", false);
/* 2821: set manual "Clear Data" items [FF136+] ***/
user_pref("privacy.clearSiteData.browsingHistoryAndDownloads", false);
user_pref("privacy.clearSiteData.formdata", false);

/** SANITIZE HISTORY: IGNORES "ALLOW" SITE EXCEPTIONS ***/
/* 2830: set manual "Clear History" items, also via Ctrl-Shift-Del [SETUP-CHROME] [FF128+]
 * Firefox remembers your last choices. This will reset them when you start Firefox
 * [SETTING] Privacy & Security>History>Custom Settings>Clear History ***/
user_pref("privacy.clearHistory.cache", false); // [DEFAULT: true]
user_pref("privacy.clearHistory.cookiesAndStorage", false);
user_pref("privacy.clearHistory.historyFormDataAndDownloads", false); // [DEFAULT: true]
   // user_pref("privacy.clearHistory.siteSettings", false); // [DEFAULT: false]
/* 2831: set manual "Clear History" items [FF136+] ***/
user_pref("privacy.clearHistory.browsingHistoryAndDownloads", false); // [DEFAULT: true]
user_pref("privacy.clearHistory.formdata", false);

/* override recipe: enable DRM and let me watch videos ***/
   // user_pref("media.gmp-widevinecdm.enabled", true); // 2021 default-inactive in user.js and removed in user.js 115.1
user_pref("media.eme.enabled", true); // 2022

/* 5003: disable saving passwords
 * [NOTE] This does not clear any passwords already saved
 * [SETTING] Privacy & Security>Logins and Passwords>Ask to save logins and passwords for websites ***/
user_pref("signon.rememberSignons", false);

/* 5017: disable Form Autofill
 * If .supportedCountries includes your region (browser.search.region) and .supported
 * is "detect" (default), then the UI will show. Stored data is not secure, uses JSON
 * [SETTING] Privacy & Security>Forms and Autofill>Autofill addresses
 * [1] https://wiki.mozilla.org/Firefox/Features/Form_Autofill ***/
user_pref("extensions.formautofill.addresses.enabled", false); // [FF55+]
user_pref("extensions.formautofill.creditCards.enabled", false); // [FF56+]

/* 5013: enable browsing and download history
 * [SETTING] Privacy & Security>History>Custom Settings>Remember browsing and download history ***/
user_pref("places.history.enabled", true);

/* 5010: disable location bar suggestion types
 * [SETTING] Search>Address Bar>When using the address bar, suggest ***/
   // user_pref("browser.urlbar.suggest.history", false);
   // user_pref("browser.urlbar.suggest.bookmark", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.topsites", false); // [FF78+]

/* 0815: disable tab-to-search [FF85+]
 * Alternatively, you can exclude on a per-engine basis by unchecking them in Options>Search
 * [SETTING] Search>Address Bar>When using the address bar, suggest>Search engines ***/
user_pref("browser.urlbar.suggest.engines", false);

/* 7021: enable GPC (Global Privacy Control) in non-PB windows
 * [WHY] Passive and active fingerprinting. Mostly redundant with Tracking Protection
 * in ETP Strict (2701) and sanitizing on close (2800s) ***/
user_pref("privacy.globalprivacycontrol.enabled", true);

/* 0710: disable DNS-over-HTTPS (DoH) [FF60+] (use local dns server)
 * 0=default, 2=increased (TRR (Trusted Recursive Resolver) first), 3=max (TRR only), 5=off (no rollout)
 * see "doh-rollout.home-region": USA 2019, Canada 2021, Russia/Ukraine 2022 [3]
 * [SETTING] Privacy & Security>DNS over HTTPS
 * [1] https://hacks.mozilla.org/2018/05/a-cartoon-intro-to-dns-over-https/
 * [2] https://wiki.mozilla.org/Security/DOH-resolver-policy
 * [3] https://support.mozilla.org/kb/firefox-dns-over-https
 * [4] https://www.eff.org/deeplinks/2020/12/dns-doh-and-odoh-oh-my-year-review-2020 ***/
user_pref("network.trr.mode", 5);

// Prevent https http & other protocols from being trimmed out of  url
user_pref("browser.urlbar.trimURLs", false);

// prevent app suggestions
user_pref("browser.urlbar.suggest.yelp", false);
user_pref("browser.urlbar.suggest.weather", false);
user_pref("browser.urlbar.suggest.trending", false);
user_pref("browser.urlbar.suggest.fakespot", false);
user_pref("browser.urlbar.suggest.fakespot", false);

user_pref("browser.ml.chat.sidebar", false);
user_pref("sidebar.revamp", false);


