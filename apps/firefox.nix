{ config, pkgs, lib, ... }:

# Based on @sleepy from discourse.nix.org configuration.
let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" ];

    policies = {
      AppAutoUpdate = false;
      DontCheckDefaultBrowser = true;

      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;

      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";

      EnableTrackingProtection = {
        Value = true; Locked = true;
        Cryptomining = true; Fingerprinting = true;
      };

      # Heavily based on pollyuko's relaxed user.js.
			# https://github.com/pyllyukko/user.js
      Preferences = {
        "browser.theme.toolbar-theme".Value = 2;
        "browser.theme.content-theme".Value = 2;
        "extensions.activeThemeID".Value = "firefox-compact-dark@mozilla.org";
        "extensions.screenshots.enabled" = lock-false;

				# =================== #
				# HTML5 / APIs / DOM  #
				# =================== #

				# PREF: Disable web notifications
				# https://support.mozilla.org/en-US/questions/1140439
				"dom.webnotifications.enabled" = lock-false;

				# PREF: Disable DOM timing API
				# https://wiki.mozilla.org/Security/Reviews/Firefox/NavigationTimingAPI
				# https://www.w3.org/TR/navigation-timing/#privacy
				# NOTICE: Breaks item pages in AliExpress
				"dom.enable_performance" = lock-false;

				# PREF: Disable resource timing API
				# https://www.w3.org/TR/resource-timing/#privacy-security
				# NOTICE: Breaks some DDoS protection pages (Cloudflare)
				#"dom.enable_resource_timing" = lock-false;

				# PREF: Make sure the User Timing API does not provide a new high resolution timestamp
				# https://trac.torproject.org/projects/tor/ticket/16336
				# https://www.w3.org/TR/2013/REC-user-timing-20131212/#privacy-security
				"dom.enable_user_timing" = lock-false;

				# PREF: Disable Web Audio API
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1288359
				# NOTICE: Breaks Unity web player/games
				"dom.webaudio.enabled" = lock-false;

				# PREF: Disable Location-Aware Browsing (geolocation)
				# https://www.mozilla.org/en-US/firefox/geolocation/
				"geo.enabled" = lock-false;
				"geo.wifi.uri".Value = "";
				"geo.wifi.logging.enabled" = lock-false;

				# PREF: Disable raw TCP socket support (mozTCPSocket)
				# https://trac.torproject.org/projects/tor/ticket/18863
				# https://www.mozilla.org/en-US/security/advisories/mfsa2015-97/
				# https://developer.mozilla.org/docs/Mozilla/B2G_OS/API/TCPSocket
				"dom.mozTCPSocket.enabled" = lock-false;

				# PREF: Disable leaking network/browser connection information via Javascript
				# https://developer.mozilla.org/en-US/docs/Web/API/Network_Information_API
				# https://wicg.github.io/netinfo/#privacy-considerations
				# https://bugzilla.mozilla.org/show_bug.cgi?id=960426
				"dom.netinfo.enabled" = lock-false;

				# PREF: Disable network API (Firefox < 32)
				# https://developer.mozilla.org/en-US/docs/Web/API/Connection/onchange
				# https://www.torproject.org/projects/torbrowser/design/#fingerprinting-defenses
				"dom.network.enabled" = lock-false;

				# PREF: Disable WebRTC entirely to prevent leaking internal IP addresses (Firefox < 42)
				# NOTICE: Breaks peer-to-peer file sharing tools (reep.io)
				"media.peerconnection.enabled" = lock-false;
				"media.peerconnection.ice.default_address_only" = lock-true;
				"media.peerconnection.ice.no_host" = lock-true;

				# PREF: Disable WebRTC getUserMedia, screen sharing, audio capture, video capture
				# https://wiki.mozilla.org/Media/getUserMedia
				# https://blog.mozilla.org/futurereleases/2013/01/12/capture-local-camera-and-microphone-streams-with-getusermedia-now-enabled-in-firefox/
				# https://developer.mozilla.org/en-US/docs/Web/API/Navigator
				"media.navigator.enabled" = lock-false;
				"media.navigator.video.enabled" = lock-false;
				"media.getusermedia.screensharing.enabled" = lock-false;
				"media.getusermedia.audiocapture.enabled" = lock-false;

				# PREF: Disable battery API (Firefox < 52)
				# https://developer.mozilla.org/en-US/docs/Web/API/BatteryManager
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1313580
				"dom.battery.enabled" = lock-false;

				# PREF: Disable telephony API
				# https://wiki.mozilla.org/WebAPI/Security/WebTelephony
				"dom.telephony.enabled" = lock-false;

				# PREF: Disable "beacon" asynchronous HTTP transfers (used for analytics)
				# https://developer.mozilla.org/en-US/docs/Web/API/navigator.sendBeacon
				"beacon.enabled" = lock-false;

				# PREF: Disable clipboard event detection (onCut/onCopy/onPaste) via Javascript
				# https://web.archive.org/web/20210416195937/https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/Preference_reference/dom.event.clipboardevents.enabled
				# https://github.com/pyllyukko/user.js/issues/287
				# NOTICE: Breaks Ctrl+C/X/V in JS-based web applications
				#"dom.event.clipboardevents.enabled" = lock-false;
				#"dom.allow_cut_copy" = lock-false;

				# PREF: Disable speech recognition and synthesis
				# https://dvcs.w3.org/hg/speech-api/raw-file/tip/speechapi.html
				# https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognition
				# https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesis
				# https://wiki.mozilla.org/HTML5_Speech_API
				"media.webspeech.recognition.enable" = lock-false;
				"media.webspeech.synth.enabled" = lock-false;

				# PREF: Disable sensor API
				# https://wiki.mozilla.org/Sensor_API
				"device.sensors.enabled" = lock-false;

				# PREF: Disable pinging URIs specified in HTML <a> ping= attributes
				# http://kb.mozillazine.org/Browser.send_pings
				"browser.send_pings" = lock-false;
				"browser.send_pings.require_same_host" = lock-true;

				# PREF: Disable IndexedDB (disabled)
				# https://developer.mozilla.org/en-US/docs/IndexedDB
				# https://en.wikipedia.org/wiki/Indexed_Database_API
				# https://wiki.mozilla.org/Security/Reviews/Firefox4/IndexedDB_Security_Review
				# http://forums.mozillazine.org/viewtopic.php?p=13842047
				# https://github.com/pyllyukko/user.js/issues/8
				# NOTICE: Breaks some add-ons (uBlock)
				#"dom.indexedDB.enabled" = lock-false;

				# PREF: Disable gamepad API to prevent USB device enumeration
				# https://www.w3.org/TR/gamepad/
				# https://trac.torproject.org/projects/tor/ticket/13023
				"dom.gamepad.enabled" = lock-false;

				# PREF: Disable virtual reality devices APIs
				# https://developer.mozilla.org/en-US/Firefox/Releases/36#Interfaces.2FAPIs.2FDOM
				# https://developer.mozilla.org/en-US/docs/Web/API/WebVR_API
				"dom.vr.enabled" = lock-false;

				# PREF: Disable vibrator API
				"dom.vibrator.enabled" = lock-false;

				# PREF: Disable Archive API (Firefox < 54)
				# https://wiki.mozilla.org/WebAPI/ArchiveAPI
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1342361
				"dom.archivereader.enabled" = lock-false;

				# PREF: Disable webGL
				# https://www.contextis.com/resources/blog/webgl-new-dimension-browser-exploitation/
				# https://trac.torproject.org/projects/tor/ticket/18603
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1171228
				# NOTICE: Breaks WebGL-based websites/applications (windy, meteoblue)
				"webgl.disabled" = lock-true;
				"webgl.min_capability_mode" = lock-true;
				"webgl.disable-extensions" = lock-true;
				"webgl.disable-fail-if-major-performance-caveat" = lock-true;
				"webgl.enable-debug-renderer-info" = lock-false;

				# PREF: Disable WebAssembly
				# https://trac.torproject.org/projects/tor/ticket/21549
				#"javascript.options.wasm" = lock-false;

				# =================== #
				#         Misc        #
				# =================== #

				# PREF: Disable face detection
				"camera.control.face_detection.enabled" = lock-false;

				# PREF: Disable GeoIP lookup on your address to set default search engine region
				# https://trac.torproject.org/projects/tor/ticket/16254
				# https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections#w_geolocation-for-default-search-engine
				"browser.search.countryCode".Value = "US";
				"browser.search.region".Value = "US";
				"browser.search.geoip.url".Value = "";

				# PREF: Set Accept-Language HTTP header to en-US regardless of Firefox localization
				"intl.accept_languages".Value = "en-US, en";

				# PREF: Don't use OS values to determine locale, force using Firefox locale setting
				# http://kb.mozillazine.org/Intl.locale.matchOS
				"intl.locale.matchOS" = lock-false;

				# PREF: Don't use Mozilla-provided location-specific search engines
				"browser.search.geoSpecificDefaults" = lock-false;

				# PREF: Do not automatically send selection to clipboard on some Linux platforms
				# http://kb.mozillazine.org/Clipboard.autocopy
				#"clipboard.autocopy" = lock-false;

				# PREF: Prevent leaking application locale/date format using JavaScript
				# https://bugzilla.mozilla.org/show_bug.cgi?id=867501
				# https://hg.mozilla.org/mozilla-central/rev/52d635f2b33d
				"javascript.use_us_english_locale" = lock-true;

				# PREF: Do not submit invalid URIs entered in the address bar to the default search engine
				# http://kb.mozillazine.org/Keyword.enabled
				"keyword.enabled" = lock-false;

				# PREF: Don't trim HTTP off of URLs in the address bar.
				# https://bugzilla.mozilla.org/show_bug.cgi?id=665580
				"browser.urlbar.trimURLs" = lock-false;

				# PREF: Disable preloading of autocomplete URLs.
				# https://wiki.mozilla.org/Privacy/Privacy_Task_Force/firefox_about_config_privacy_tweeks
				"browser.urlbar.speculativeConnect.enabled" = lock-false;

				# PREF: Don't try to guess domain names when entering an invalid domain name in URL bar
				# http://www-archive.mozilla.org/docs/end-user/domain-guessing.html
				"browser.fixup.alternate.enabled" = lock-false;
				"browser.fixup.hide_user_pass" = lock-true;

				# PREF: Send DNS request through SOCKS when SOCKS proxying is in use
				# https://trac.torproject.org/projects/tor/wiki/doc/TorifyHOWTO/WebBrowsers
				"network.proxy.socks_remote_dns" = lock-true;

				# PREF: Don't monitor OS online/offline connection state
				# https://trac.torproject.org/projects/tor/ticket/18945
				"network.manage-offline-status" = lock-false;

				# PREF: Enforce Mixed Active Content Blocking
				# https://support.mozilla.org/t5/Protect-your-privacy/Mixed-content-blocking-in-Firefox/ta-p/10990
				# https://developer.mozilla.org/en-US/docs/Site_Compatibility_for_Firefox_23#Non-SSL_contents_on_SSL_pages_are_blocked_by_default
				# https://blog.mozilla.org/tanvi/2013/04/10/mixed-content-blocking-enabled-in-firefox-23/
				"security.mixed_content.block_active_content" = lock-true;
				"security.mixed_content.block_display_content" = lock-true;

				# PREF: Disable JAR from opening Unsafe File Types
				# http://kb.mozillazine.org/Network.jar.open-unsafe-types
				# CIS Mozilla Firefox 24 ESR v1.0.0 - 3.7 
				"network.jar.open-unsafe-types" = lock-false;

				# CIS 2.7.4 Disable Scripting of Plugins by JavaScript
				# http://forums.mozillazine.org/viewtopic.php?f=7&t=153889
				"security.xpconnect.plugin.unrestricted" = lock-false;

				# PREF: Set File URI Origin Policy
				# http://kb.mozillazine.org/Security.fileuri.strict_origin_policy
				# CIS Mozilla Firefox 24 ESR v1.0.0 - 3.8
				"security.fileuri.strict_origin_policy" = lock-true;

				# PREF: Disable Displaying Javascript in History URLs
				# http://kb.mozillazine.org/Browser.urlbar.filter.javascript
				# CIS 2.3.6 
				"browser.urlbar.filter.javascript" = lock-true;

				# PREF: Disable asm.js
				# https://www.mozilla.org/en-US/security/advisories/mfsa2015-29/
				# https://www.mozilla.org/en-US/security/advisories/mfsa2015-50/
				# https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-2712
				"javascript.options.asmjs" = lock-false;

				# PREF: Disable SVG in OpenType fonts
				# https://github.com/iSECPartners/publications/tree/master/reports/Tor%20Browser%20Bundle
				"gfx.font_rendering.opentype_svg.enabled" = lock-false;

				# PREF: Disable video stats to reduce fingerprinting threat
				# https://bugzilla.mozilla.org/show_bug.cgi?id=654550
				# https://github.com/pyllyukko/user.js/issues/9#issuecomment-100468785
				# https://github.com/pyllyukko/user.js/issues/9#issuecomment-148922065
				"media.video_stats.enabled" = lock-false;

				# PREF: Don't use document specified fonts to prevent installed font enumeration (fingerprinting)
				# https://github.com/pyllyukko/user.js/issues/395
				# https://github.com/pyllyukko/user.js/issues/120
				# NOTICE: Breaks Gemini UI interface
				#"browser.display.use_document_fonts".Value = 0;

				# PREF: Always block media autoplay
				# https://support.mozilla.org/en-US/kb/block-autoplay
				"media.autoplay.default".Value = 5;

				# ==================== #
				# Extensions / plugins #
				# ==================== #

				# PREF: Ensure you have a security delay when installing add-ons (milliseconds)
				# http://www.squarefree.com/2004/07/01/race-conditions-in-security-dialogs/
				"security.dialog_enable_delay".Value = 1000;

				# PREF: Opt-out of add-on metadata updates
				# https://blog.mozilla.org/addons/how-to-opt-out-of-add-on-metadata-updates/
				"extensions.getAddons.cache.enabled" = lock-false;

				# PREF: Opt-out of themes (Persona) updates
				# https://support.mozilla.org/t5/Firefox/how-do-I-prevent-autoamtic-updates-in-a-50-user-environment/td-p/144287
				"lightweightThemes.update.enabled" = lock-false;

				# PREF: Disable Flash Player NPAPI plugin
				# http://kb.mozillazine.org/Flash_plugin
				"plugin.state.flash".Value = 0;

				# PREF: Disable Java NPAPI plugin
				"plugin.state.java".Value = 0;

				# PREF: Disable sending Flash Player crash reports
				"dom.ipc.plugins.flash.subprocess.crashreporter.enabled" = lock-false;
				"dom.ipc.plugins.reportCrashURL" = lock-false;

				# PREF: When Flash is enabled, download and use Mozilla SWF URIs blocklist
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1237198
				# https://github.com/mozilla-services/shavar-plugin-blocklist
				"browser.safebrowsing.blockedURIs.enabled" = lock-true;

				# PREF: Disable Gnome Shell Integration NPAPI plugin
				"plugin.state.libgnome-shell-browser-plugin".Value = 0;

				# PREF: Disable the bundled OpenH264 video codec (disabled)
				# http://forums.mozillazine.org/viewtopic.php?p=13845077&sid=28af2622e8bd8497b9113851676846b1#p13845077
				#"media.gmp-provider.enabled" = lock-false;

				# PREF: Updates addons automatically
				"extensions.update.enabled" = true;

				# PREF: Decrease system information leakage to Mozilla blocklist update servers
				# https://trac.torproject.org/projects/tor/ticket/16931
				"extensions.blocklist.url".Value = "https://blocklist.addons.mozilla.org/blocklist/3/%APP_ID%/%APP_VERSION%/";

				# PREF: Disable system add-on updates (hidden & always-enabled add-ons from Mozilla)
				# https://github.com/pyllyukko/user.js/issues/419
				# https://dxr.mozilla.org/mozilla-central/source/toolkit/mozapps/extensions/AddonManager.jsm#1248-1257
				# NOTICE: Disabling system add-on updates prevents Mozilla from "hotfixing" your browser to patch critical problems (one possible use case from the documentation)
				#"extensions.systemAddon.update.enabled" = lock-false;

				# =================== #
				# (anti-)features     #
				# =================== #

				# PREF: Disable Extension recommendations (Firefox >= 65)
				"browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = lock-false;
				"extensions.htmlaboutaddons.recommendations.enabled" = lock-false;

				# PREF: Disable WebIDE
				# https://trac.torproject.org/projects/tor/ticket/16222
				"devtools.webide.enabled" = lock-false;
				"devtools.webide.autoinstallADBHelper" = lock-false;
				"devtools.webide.autoinstallFxdtAdapters" = lock-false;

				# PREF: Disable remote debugging
				"devtools.debugger.remote-enabled" = lock-false;
				"devtools.chrome.enabled" = lock-false;
				"devtools.debugger.force-local" = lock-true;

				# PREF: Disable Mozilla telemetry/experiments
				# https://support.mozilla.org/t5/Firefox-crashes/Mozilla-Crash-Reporter/ta-p/1715
				# https://support.mozilla.org/en-US/questions/1197144
				"toolkit.telemetry.enabled" = lock-false;
				"toolkit.telemetry.unified" = lock-false;
				"toolkit.telemetry.archive.enabled" = lock-false;
				"experiments.supported" = lock-false;
				"experiments.enabled" = lock-false;
				"experiments.manifest.uri".Value = "";

				# PREF: Disable daily usage ping
				"datareporting.usage.uploadEnabled" = lock-false;

				# PREF: Disallow Necko to do A/B testing
				# https://trac.torproject.org/projects/tor/ticket/13170
				"network.allow-experiments" = lock-false;

				# PREF: Disable sending Firefox crash reports to Mozilla servers
				# https://dxr.mozilla.org/mozilla-central/source/toolkit/crashreporter
				# https://bugzilla.mozilla.org/show_bug.cgi?id=411490
				# A list of submitted crash reports can be found at about:crashes
				"breakpad.reportURL".Value = "";

				# PREF: Disable sending reports of tab crashes to Mozilla (about:tabcrashed), don't nag user about unsent crash reports
				"browser.tabs.crashReporting.sendReport" = lock-false;
				"browser.crashReports.unsubmittedCheck.enabled" = lock-false;

				# PREF: Disable FlyWeb (discovery of LAN/proximity IoT devices that expose a Web interface)
				# https://wiki.mozilla.org/FlyWeb/Security_scenarios
				# https://docs.google.com/document/d/1eqLb6cGjDL9XooSYEEo7mE-zKQ-o-AuDTcEyNhfBMBM/edit
				# http://www.ghacks.net/2016/07/26/firefox-flyweb
				"dom.flyweb.enabled" = lock-false;

				# PREF: Disable the UITour backend
				# https://trac.torproject.org/projects/tor/ticket/19047#comment:3
				"browser.uitour.enabled" = lock-false;

				# PREF: Enable Firefox Tracking Protection
				# https://kontaxis.github.io/trackingprotectionfirefox/
				# https://feeding.cloud.geek.nz/posts/how-tracking-protection-works-in-firefox/
				"privacy.trackingprotection.enabled" = lock-true;
				"privacy.trackingprotection.pbmode.enabled" = lock-true;

				# PREF: Enable contextual identity Containers feature (Firefox >= 52)
				# NOTICE: Containers are not available in Private Browsing mode
				"privacy.userContext.enabled" = lock-true;

				# PREF: Enable Firefox's anti-fingerprinting mode ("resist fingerprinting" or RFP) (Tor Uplift project)
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1333933
				# NOTICE: Breaks some keyboard shortcuts used in certain websites (see #443)
				# NOTICE: Changes your time zone
				# NOTICE: Breaks some DDoS protection pages (Clouflare)
				#"privacy.resistFingerprinting" = lock-true;

				# PREF: disable mozAddonManager Web API [FF57+]
				# https://bugzilla.mozilla.org/buglist.cgi?bug_id=1384330
				# https://bugzilla.mozilla.org/buglist.cgi?bug_id=1406795
				# https://bugzilla.mozilla.org/buglist.cgi?bug_id=1415644
				# https://bugzilla.mozilla.org/buglist.cgi?bug_id=1453988
				# https://trac.torproject.org/projects/tor/ticket/26114
				"privacy.resistFingerprinting.block_mozAddonManager" = lock-true;
				"extensions.webextensions.restrictedDomains".Value = "";

				# PREF: Disable the built-in PDF viewer
				# https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2015-2743
				# https://blog.mozilla.org/security/2015/08/06/firefox-exploit-found-in-the-wild/
				# https://www.mozilla.org/en-US/security/advisories/mfsa2015-69/
				#"pdfjs.disabled" = lock-true;

				# PREF: Disable collection/sending of the health report (healthreport.sqlite*)
				"datareporting.healthreport.uploadEnabled" = lock-false;
				"datareporting.healthreport.service.enabled" = lock-false;
				"datareporting.policy.dataSubmissionEnabled" = lock-false;
				"browser.discovery.enabled" = lock-false;

				# PREF: Disable Shield/Heartbeat/Normandy (Mozilla user rating telemetry)
				# https://trac.torproject.org/projects/tor/ticket/19047
				# https://trac.torproject.org/projects/tor/ticket/18738
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1370801
				"app.normandy.enabled" = lock-false;
				"app.normandy.api_url".Value = "";
				"extensions.shield-recipe-client.enabled" = lock-false;
				"app.shield.optoutstudies.enabled" = lock-false;

				# PREF: Disable Firefox Hello metrics collection
				# https://groups.google.com/d/topic/mozilla.dev.platform/nyVkCx-_sFw/discussion
				"loop.logDomains" = lock-false;

				# PREF: Disable querying Google Application Reputation database for downloaded binary files
				"browser.safebrowsing.downloads.remote.enabled" = lock-false;

				# PREF: Disable Pocket
				# https://github.com/pyllyukko/user.js/issues/143
				"browser.pocket.enabled" = lock-false;
				"extensions.pocket.enabled" = lock-false;

				# PREF: Disable "Recommended by Pocket" in Firefox Quantum
				"browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;

				# PREF: Enable Global Privacy Control (GPC) (Firefox >= 120)
				# https://globalprivacycontrol.org/
				"privacy.globalprivacycontrol.enabled" = lock-true;

				# PREF: Hide weather on New Tab
				"browser.newtabpage.activity-stream.showWeather" = lock-false;

				# ===================== #
				# Automatic connections #
				# ===================== #

				# PREF: Disable prefetching of <link rel="next"> URLs
				"network.prefetch-next" = lock-false;

				# PREF: Disable DNS prefetching
				"network.dns.disablePrefetch" = lock-true;
				"network.dns.disablePrefetchFromHTTPS" = lock-true;

				# PREF: Disable the predictive service (Necko)
				"network.predictor.enabled" = lock-false;

				# PREF: Reject .onion hostnames before passing the to DNS
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1228457
				# RFC 7686
				"network.dns.blockDotOnion" = lock-true;

				# PREF: Disable SSDP
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1111967
				"browser.casting.enabled" = lock-false;

				# PREF: Disable automatic downloading of OpenH264 codec
				"media.gmp-gmpopenh264.enabled" = lock-false;
				"media.gmp-manager.url".Value = "";

				# PREF: Disable speculative pre-connections
				# https://bugzilla.mozilla.org/show_bug.cgi?id=814169
				"network.http.speculative-parallel-limit".Value = 0;

				# PREF: Disable automatic captive portal detection (Firefox >= 52.0)
				# https://support.mozilla.org/en-US/questions/1157121
				"network.captive-portal-service.enabled" = lock-false;
				"network.connectivity-service.enabled" = lock-false;

				# Disable (parts of?) "TopSites"
				"browser.topsites.contile.enabled" = lock-false;
				"browser.newtabpage.activity-stream.feeds.topsites" = lock-false;
				"browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;

				# =================== #
				#         HTTP        #
				# =================== #

				# PREF: Disallow NTLMv1
				# https://bugzilla.mozilla.org/show_bug.cgi?id=828183
				"network.negotiate-auth.allow-insecure-ntlm-v1" = lock-false;
				"network.negotiate-auth.allow-insecure-ntlm-v1-https" = lock-false;

				# PREF: Enable CSP 1.1 script-nonce directive support
				# https://bugzilla.mozilla.org/show_bug.cgi?id=855326
				"security.csp.experimentalEnabled" = lock-true;

				# PREF: Enable Content Security Policy (CSP)
				"security.csp.enable" = lock-true;

				# PREF: Enable Subresource Integrity
				"security.sri.enable" = lock-true;

				# PREF: Trim HTTP referer headers to only send the scheme, host, and port
				"network.http.referer.trimmingPolicy".Value = 2;

				# PREF: When sending Referer across domains, only send scheme, host, and port in the Referer header
				"network.http.referer.XOriginTrimmingPolicy".Value = 2;

				# =================== #
				#       Caching       #
				# =================== #

				# PREF: Do not download URLs for the offline cache
				"browser.cache.offline.enable" = lock-false;

				# PREF: Disable disk cache
				"browser.cache.disk.enable" = lock-false;

				# PREF: Disable Caching of SSL Pages
				"browser.cache.disk_cache_ssl" = lock-false;

				# PREF: Cookies expires at the end of the session (when the browser closes)
				"network.cookie.lifetimePolicy".Value = 2;

				# PREF: Disable formless login capture
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1166947
				"signon.formlessCapture.enabled" = lock-false;

				# PREF: Show in-content login form warning UI for insecure login fields
				# https://hg.mozilla.org/integration/mozilla-inbound/rev/f0d146fe7317
				"security.insecure_field_warning.contextual.enabled" = lock-true;

				# PREF: Clear SSL Form Session Data
				"browser.sessionstore.privacy_level".Value = 2;

				# PREF: Delete temporary files on exit
				# https://bugzilla.mozilla.org/show_bug.cgi?id=238789
				"browser.helperApps.deleteTempFileOnExit" = lock-true;

				# PREF: Do not create screenshots of visited pages (relates to the "new tab page" feature)
				# https://support.mozilla.org/en-US/questions/973320
				"browser.pagethumbnails.capturing_disabled" = lock-true;

				# 

				# =================== #
				#      UI related     #
				# =================== #

				# PREF: Enable insecure password warnings (login forms in non-HTTPS pages)
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1319119
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1217156
				"security.insecure_password.ui.enabled" = lock-true;
				
				# PREF: Disable "Are you sure you want to leave this page?" popups on page close
				# https://support.mozilla.org/en-US/questions/1043508
				# NOTICE: Does not prevent JS leaks of the page close event.
				#"dom.disable_beforeunload" = lock-true;

				# PREF: Disable the "new tab page" feature and show a blank tab instead
				"browser.newtabpage.enabled" = lock-false;
				"browser.newtab.url".Value = "about:blank";

				# PREF: Disable Snippets
				"browser.newtabpage.activity-stream.feeds.snippets" = lock-false;

				# PREF: Disable Activity Stream
				"browser.newtabpage.activity-stream.enabled" = lock-false;

				# PREF: Force Punycode for Internationalized Domain Names
				# https://www.mozilla.org/en-US/security/advisories/mfsa2017-02/
				# https://en.wikipedia.org/wiki/IDN_homograph_attack
				"network.IDN_show_punycode" = lock-true;

				# PREF: Do not check if Firefox is the default browser
				"browser.shell.checkDefaultBrowser" = lock-false;

				# PREF: Display a notification bar when websites offer data for offline use
				"browser.offline-apps.notify" = lock-true;

				# =================== #
				#    Cryptography     #
				# =================== #

				# PREF: Disable TLS Session Tickets
				# https://bugzilla.mozilla.org/show_bug.cgi?id=917049
				# https://bugzilla.mozilla.org/show_bug.cgi?id=967977
				# https://media.blackhat.com/us-13/US-13-Daigniere-TLS-Secrets-Slides.pdf
				# https://media.blackhat.com/us-13/US-13-Daigniere-TLS-Secrets-WP.pdf
				"security.ssl.disable_session_identifiers" = lock-true;

				# PREF: Only allow TLS 1.[2-3]
				"security.tls.version.min".Value = 3;
				"security.tls.version.enable-deprecated" = false;

				# PREF: Disable insecure TLS version fallback
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1084025
				# https://github.com/pyllyukko/user.js/pull/206#issuecomment-280229645
				"security.tls.version.fallback-limit".Value = 4;

				# PREF: Disallow SHA-1
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1302140
				"security.pki.sha1_enforcement_level".Value = 1;

				# PREF: Warn the user when server doesn't support RFC 5746 ("safe" renegotiation)
				# https://wiki.mozilla.org/Security:Renegotiation#security.ssl.treat_unsafe_negotiation_as_broken
				# https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3555
				"security.ssl.treat_unsafe_negotiation_as_broken" = lock-true;

				# PREF: Disallow connection to servers not supporting safe renegotiation
				# https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3555
				# https://github.com/pyllyukko/user.js/issues/237
				"security.ssl.require_safe_negotiation" = lock-true;

				# PREF: Disable automatic reporting of TLS connection errors
				"security.ssl.errorReporting.enabled" = lock-false;
				"security.ssl.errorReporting.automatic" = lock-false;

				# PREF: Encrypted SNI (when TRR is enabled)
				"network.security.esni.enabled" = lock-true;

				# PREF: Disable the Enterprise Roots preference
				# https://github.com/pyllyukko/user.js/issues/560
				"security.certerrors.mitm.auto_enable_enterprise_roots" = lock-false;
				"security.enterprise_roots.enabled" = lock-false;

				# =================== #
				#    Cipher suites    #
				# =================== #

				# PREF: Disable null ciphers
				"security.ssl3.rsa_null_sha" = lock-false;
				"security.ssl3.rsa_null_md5" = lock-false;
				"security.ssl3.ecdhe_rsa_null_sha" = lock-false;
				"security.ssl3.ecdhe_ecdsa_null_sha" = lock-false;
				"security.ssl3.ecdh_rsa_null_sha" = lock-false;
				"security.ssl3.ecdh_ecdsa_null_sha" = lock-false;

				# PREF: Disable SEED cipher
				"security.ssl3.rsa_seed_sha" = lock-false;

				# PREF: Disable 40/56/128-bit ciphers
				"security.ssl3.rsa_rc4_40_md5" = lock-false;
				"security.ssl3.rsa_rc2_40_md5" = lock-false;
				"security.ssl3.rsa_1024_rc4_56_sha" = lock-false;
				"security.ssl3.rsa_camellia_128_sha" = lock-false;
				"security.ssl3.ecdhe_rsa_aes_128_sha" = lock-false;
				"security.ssl3.ecdhe_ecdsa_aes_128_sha" = lock-false;
				"security.ssl3.ecdh_rsa_aes_128_sha" = lock-false;
				"security.ssl3.ecdh_ecdsa_aes_128_sha" = lock-false;
				"security.ssl3.dhe_rsa_camellia_128_sha" = lock-false;
				"security.ssl3.dhe_rsa_aes_128_sha" = lock-false;
				"security.ssl3.ecdhe_ecdsa_aes_128_gcm_sha256" = lock-false; # 0xc02b TLSv1.2
				"security.ssl3.ecdhe_rsa_aes_128_gcm_sha256" = lock-false; # 0xc02f TLSv1.2
				"security.tls13.aes_128_gcm_sha256" = lock-false; # 0x1301 TLSv1.3

				# PREF: Disable RC4
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1138882
				# https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2013-2566
				"security.ssl3.ecdh_ecdsa_rc4_128_sha" = lock-false;
				"security.ssl3.ecdh_rsa_rc4_128_sha" = lock-false;
				"security.ssl3.ecdhe_ecdsa_rc4_128_sha" = lock-false;
				"security.ssl3.ecdhe_rsa_rc4_128_sha" = lock-false;
				"security.ssl3.rsa_rc4_128_md5" = lock-false;
				"security.ssl3.rsa_rc4_128_sha" = lock-false;
				"security.tls.unrestricted_rc4_fallback" = lock-false;

				# PREF: Disable 3DES
				"security.ssl3.dhe_dss_des_ede3_sha" = lock-false;
				"security.ssl3.dhe_rsa_des_ede3_sha" = lock-false;
				"security.ssl3.ecdh_ecdsa_des_ede3_sha" = lock-false;
				"security.ssl3.ecdh_rsa_des_ede3_sha" = lock-false;
				"security.ssl3.ecdhe_ecdsa_des_ede3_sha" = lock-false;
				"security.ssl3.ecdhe_rsa_des_ede3_sha" = lock-false;
				"security.ssl3.rsa_des_ede3_sha" = lock-false;
				"security.ssl3.rsa_fips_des_ede3_sha" = lock-false;
				"security.ssl3.deprecated.rsa_des_ede3_sha" = lock-false;

				# PREF: Disable ciphers with ECDH (non-ephemeral)
				"security.ssl3.ecdh_rsa_aes_256_sha" = lock-false;
				"security.ssl3.ecdh_ecdsa_aes_256_sha" = lock-false;

				# PREF: Disable 256 bits ciphers without PFS
				"security.ssl3.rsa_camellia_256_sha" = lock-false;

				# PREF: Disable non-ECDHE RSA ciphers
				"security.ssl3.rsa_aes_128_gcm_sha256" = lock-false;
				"security.ssl3.rsa_aes_256_gcm_sha384" = lock-false;

				# PREF: Enable ChaCha20 and Poly1305 (Firefox >= 47)
				# https://bugzilla.mozilla.org/show_bug.cgi?id=917571
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1247860
				"security.ssl3.ecdhe_ecdsa_chacha20_poly1305_sha256" = lock-true;
				"security.ssl3.ecdhe_rsa_chacha20_poly1305_sha256" = lock-true;

				# PREF: Disable ciphers susceptible to the logjam attack
				"security.ssl3.dhe_rsa_camellia_256_sha" = lock-false;
				"security.ssl3.dhe_rsa_aes_256_sha" = lock-false;

				# PREF: Disable ciphers with DSA (max 1024 bits)
				"security.ssl3.dhe_dss_aes_128_sha" = lock-false;
				"security.ssl3.dhe_dss_aes_256_sha" = lock-false;
				"security.ssl3.dhe_dss_camellia_128_sha" = lock-false;
				"security.ssl3.dhe_dss_camellia_256_sha" = lock-false;

				# PREF: Disable ciphers with CBC & SHA-1
				"security.ssl3.rsa_aes_256_sha" = lock-false; # 0x35
				"security.ssl3.rsa_aes_128_sha" = lock-false; # 0x2f
				"security.ssl3.ecdhe_rsa_aes_256_sha" = lock-false; # 0xc014
				"security.ssl3.ecdhe_ecdsa_aes_256_sha" = lock-false; # 0xc00a

				# PREF: Enable X25519Kyber768Draft00 (post-quantum key exchange) [FF Nightly 2024-01-18+]
				"security.tls.enable_kyber" = lock-true;
      }; # Preferences
    }; # policies
  }; # programs.firefox
}
