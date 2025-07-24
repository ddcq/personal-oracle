'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "597c88ba66231302adcba8dc9fbd564a",
"assets/assets/images/heads/freya.png": "5f179a48a2ea0ac918d993fcf7d8a902",
"assets/assets/images/heads/loki.png": "cc24ca88d808d5a6b58045d9bbc16b95",
"assets/assets/images/heads/thor.png": "27c5b14924e4772eb076ac4217f6a17d",
"assets/assets/images/heads/frigg.png": "516d29b2e3f02a68242174e72d315c67",
"assets/assets/images/heads/tyr.png": "aada1592c43d869efad0248d22697292",
"assets/assets/images/heads/odin.png": "8d966e35e65664ed517b2e030bf216ab",
"assets/assets/images/apple_regular.png": "06205fa10818cb57891cade7cec0b7ca",
"assets/assets/images/cards/ginnungagap_card.jpg": "eca5d3b1a93858aa1d89fa0adbaf72d7",
"assets/assets/images/cards/frigg_card.jpg": "cd97072a3a7842050a11a293d06a420d",
"assets/assets/images/cards/sif_card.jpg": "a87260d468ed30e2b80f1831be373014",
"assets/assets/images/cards/fenrir_card.jpg": "beed359e97edb581b17aef7f4c1a7765",
"assets/assets/images/cards/audhumla_card.jpg": "1623a38fc118581d9fe50778371fb4a0",
"assets/assets/images/cards/gui_card.jpg": "017d6aa5246347c69d9e1476418c0e22",
"assets/assets/images/cards/odin_card.jpg": "3b173f06ac65ad613c60bb5ab8decc5b",
"assets/assets/images/cards/freya_card.jpg": "f520be131eef4c4026f8f0c7b34a3db8",
"assets/assets/images/cards/sleipnir_card.jpg": "f5c197c920cd962ba5c2622c2343e256",
"assets/assets/images/cards/mjollnir_card.jpg": "ebf19adcefcf1e2c5d81c2ec78dd2f53",
"assets/assets/images/cards/brokkr_sindri_card.jpg": "29968b1258d8338959001f649e211bfa",
"assets/assets/images/cards/gleipnir_card.jpg": "cc0a32fca5a61ee6a15f3d043976b331",
"assets/assets/images/cards/draupnir_card.jpg": "2185ecc78fbf23c97ff312c041aa7a9e",
"assets/assets/images/cards/tyr_card.jpg": "df27fe629e2668dcd3283d799682bf35",
"assets/assets/images/cards/baldr_card.jpg": "d43e4befadbc96134bc3b970fe23d71b",
"assets/assets/images/cards/svadilfari_card.jpg": "6f52831f8a3ff810cdc874be61f751ea",
"assets/assets/images/cards/hrimthurs_card.jpg": "fa989760b5eea08e597afd19409d9622",
"assets/assets/images/cards/thrym_card.jpg": "2fe1d60d9948d690d5676a913aea0d51",
"assets/assets/images/cards/ymir_card.jpg": "09eb4db8c2ade351fbfc2869f2865124",
"assets/assets/images/cards/gungnir_card.jpg": "505c316a465a7ba844b5f4175ff6d0c0",
"assets/assets/images/apple_golden.png": "a3f25aa2ccbb112d87db83d4082d48d1",
"assets/assets/images/apple_rotten.png": "803c8f2c15d265deabb36aacc82510f8",
"assets/assets/images/stories/baldr_1.jpg": "8e2e3b3fd2614e190221690b9725c5c5",
"assets/assets/images/stories/fenrir_3.jpg": "a2b5cce503f6ed55abb321b24e6e45a5",
"assets/assets/images/stories/baldr_3.jpg": "ad6036becd2e31a9543b181533d16045",
"assets/assets/images/stories/wall_1.jpg": "f3315e9929b3207f1bdc8ccd47db4956",
"assets/assets/images/stories/forge_1.jpg": "77205e59470f071fc511bd16aa23a4fd",
"assets/assets/images/stories/thor_2.jpg": "acc9bb11c1be85ff8b07bb0e382acbb0",
"assets/assets/images/stories/wall_3.jpg": "b2e579833e6c54f8ca088ed8fa211be3",
"assets/assets/images/stories/creation_2.jpg": "40ef8ac7ab6f073b26c0b0710daf24e0",
"assets/assets/images/stories/forge_3.jpg": "1c987c6aebbca26ac4082464f8db04ab",
"assets/assets/images/stories/forge_2.jpg": "111c4e3ae8ab00c2009c006ef665e48b",
"assets/assets/images/stories/fenrir_1.jpg": "0fc3c8e037eee92eef7ade841980d1ae",
"assets/assets/images/stories/forge_4.jpg": "69142244a3963ec60c01a17d6541cb7b",
"assets/assets/images/stories/baldr_5.jpg": "bb18d3feae81d24ca6a61c84c2d88040",
"assets/assets/images/stories/creation_5.jpg": "fa29ce8a96c4af409eda37187905013e",
"assets/assets/images/stories/fenrir_4.jpg": "2c79168d0ea2969444f0618701a675a4",
"assets/assets/images/stories/thor_4.jpg": "94b7feab4410ad3c993061eec3d2a48d",
"assets/assets/images/stories/creation_4.jpg": "588817c328a19f1d9ad5e757698d9d20",
"assets/assets/images/stories/thor_3.jpg": "e7a9b95fe0f49e8a2ded4acb90bc1562",
"assets/assets/images/stories/fenrir_5.jpg": "18a05d177f7e956b2ccc367b4ffb6b4b",
"assets/assets/images/stories/baldr_4.jpg": "56e6b78e1b3dfba63f793d52ca918518",
"assets/assets/images/stories/thor_5.jpg": "323b6b32715710082a440e15619dd252",
"assets/assets/images/stories/wall_2.jpg": "5938e3fd5eaaa53ab6a31d57d4f1833f",
"assets/assets/images/stories/creation_1.jpg": "29492f176fbc691612df683319363e2e",
"assets/assets/images/stories/baldr_2.jpg": "5b465495e584544ce185c568e4bf2846",
"assets/assets/images/stories/creation_3.jpg": "78fdee23ef7c3b93ed31cd222942466a",
"assets/assets/images/stories/fenrir_2.jpg": "a593624c3529a2a9fd97dd8b44cb9b25",
"assets/assets/images/stories/forge_5.jpg": "86e20bf93baac428898f51e5e152042d",
"assets/assets/images/stories/thor_1.jpg": "9f6df12c9a64c7bcaae69b1c25786377",
"assets/assets/images/games/banner.png": "4d4b850e7c1b1f549f493145b7767658",
"assets/assets/images/games/snake-graphics.png": "f20532e30a3b3f26d20b846a6f55d256",
"assets/assets/images/odin_chibi.png": "eaa7ca1bc9b705f43b0e47bb2ddde46e",
"assets/assets/images/characters.png": "45cefc86bca99334ea20e99a3c576580",
"assets/assets/images/icons/icon.png": "0287eadfff84c4feb99d71d9908a87b3",
"assets/assets/images/home_illu.png": "940a3fac5d6252a10d0fcb9433547e6c",
"assets/assets/images/backgrounds/wall.webp": "e603d5a7d3cd786e66705f66c17db184",
"assets/assets/images/backgrounds/landscape.jpg": "6e18f5ed443dd482f92be0896acdc094",
"assets/assets/images/backgrounds/asgard.jpg": "677f55f995b906131f2a4f686c38f65f",
"assets/assets/images/stone.png": "9e6517cf96c6ea200aff8f7eb56a4863",
"assets/assets/fonts/NotoSansRunic-Regular.ttf": "5c93dcdbc6d624af2b936e101ad707f3",
"assets/assets/fonts/AmaticSC-Bold.ttf": "1920369a73a4108567c63ef769a1c520",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "047595bb3267eb5fbc0cae60ce586b3d",
"assets/AssetManifest.json": "a1f46dd8fd6dabf3a6186636c41a7e9c",
"assets/fonts/MaterialIcons-Regular.otf": "3b884b3c40a94b3b6efe66120511cfe6",
"assets/AssetManifest.bin.json": "8d7f3f991beabde83a9b740d287ee29e",
"assets/NOTICES": "a92350b40e7b0ad4760ec9c746fa0099",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"version.json": "c59f408b4ce3e245a23f78480eb8637b",
"manifest.json": "59f31d11a5a94cf20794090955f99f61",
"flutter_bootstrap.js": "1b2afe1b2cba6cf0e9c3123f226f8812",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"index.html": "33dd71b6aac77a5d3250f162dc7a39ac",
"/": "33dd71b6aac77a5d3250f162dc7a39ac",
"favicon.png": "90f174102023840556e0bcd222ee14d5",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"icons/Icon-512.png": "90f174102023840556e0bcd222ee14d5",
"icons/Icon-192.png": "90f174102023840556e0bcd222ee14d5",
"icons/Icon-maskable-512.png": "90f174102023840556e0bcd222ee14d5",
"icons/Icon-maskable-192.png": "90f174102023840556e0bcd222ee14d5",
"main.dart.js": "29511c8119178a3c01ea4ff4a457dce0"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
