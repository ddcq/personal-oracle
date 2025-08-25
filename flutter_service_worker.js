'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "9b43df13ca02bb6e970539c3a709621e",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"favicon.png": "2f27bf2f8633c35c097bfafbd9c13dda",
"icons/Icon-maskable-512.png": "026d4cb10714b2da87e4690d64f3880a",
"icons/Icon-maskable-192.png": "c2aee65e8ce190e1b9e8ae1a242c9e67",
"icons/Icon-512.png": "026d4cb10714b2da87e4690d64f3880a",
"icons/Icon-192.png": "c2aee65e8ce190e1b9e8ae1a242c9e67",
"manifest.json": "8bdb1450ca6728a8d163c39554a3e8e1",
"version.json": "c59f408b4ce3e245a23f78480eb8637b",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"main.dart.js": "9310bd0046ade9aae7326b6c4618bff8",
"index.html": "33dd71b6aac77a5d3250f162dc7a39ac",
"/": "33dd71b6aac77a5d3250f162dc7a39ac",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/FontManifest.json": "867316486ca771588dea7c68f4b7ac50",
"assets/NOTICES": "f5593e9687acff316f0f67a24b3f62ad",
"assets/AssetManifest.json": "0e136dbd3bc00fd5f13b3415cd9debd7",
"assets/AssetManifest.bin": "1c41d15d02a22acf0126941ab01c310a",
"assets/AssetManifest.bin.json": "c91921100f20ae9a7a98826c0fb1cccd",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/MaterialIcons-Regular.otf": "172d5eacdef65a8b36c317c7040cad8e",
"assets/assets/odin.svg": "e259a7979c09b08b12eeb5323022d69b",
"assets/assets/images/heads/frigg.png": "516d29b2e3f02a68242174e72d315c67",
"assets/assets/images/heads/thor.png": "27c5b14924e4772eb076ac4217f6a17d",
"assets/assets/images/heads/viking_head_6.png": "5dbdb3dda8d3255f920f121e04c1a017",
"assets/assets/images/heads/viking_head_3.png": "61100947eb5d1f98a69605eab9bbb802",
"assets/assets/images/heads/tyr.png": "aada1592c43d869efad0248d22697292",
"assets/assets/images/heads/viking_head_4.png": "e529aaa7da2fb79ca6d56f5a3614260a",
"assets/assets/images/heads/freya.png": "5f179a48a2ea0ac918d993fcf7d8a902",
"assets/assets/images/heads/odin.png": "8d966e35e65664ed517b2e030bf216ab",
"assets/assets/images/heads/loki.png": "cc24ca88d808d5a6b58045d9bbc16b95",
"assets/assets/images/heads/viking_head_1.png": "cf7a3b28b9c4e3169c3f17fe686ad46c",
"assets/assets/images/heads/viking_head_2.png": "883091f06cf9209e139033d84515ae12",
"assets/assets/images/heads/viking_head_5.png": "e0ec9c4784ab23f402949fb93bab4d22",
"assets/assets/images/stone.png": "9e6517cf96c6ea200aff8f7eb56a4863",
"assets/assets/images/characters.png": "45cefc86bca99334ea20e99a3c576580",
"assets/assets/images/happy_face.svg": "b8241d52549006a8ce6ae9c8ae241d75",
"assets/assets/images/odin_sad.png": "a9767c667e29716c627a239aaaaa7dc0",
"assets/assets/images/backgrounds/asgard.jpg": "677f55f995b906131f2a4f686c38f65f",
"assets/assets/images/backgrounds/wall.webp": "e603d5a7d3cd786e66705f66c17db184",
"assets/assets/images/backgrounds/defeated.jpg": "3eb22aa6a2f7df446c53f70e6a169927",
"assets/assets/images/backgrounds/landscape.jpg": "6e18f5ed443dd482f92be0896acdc094",
"assets/assets/images/games/snake-graphics.png": "f20532e30a3b3f26d20b846a6f55d256",
"assets/assets/images/games/banner.png": "4d4b850e7c1b1f549f493145b7767658",
"assets/assets/images/apple_golden.png": "a3f25aa2ccbb112d87db83d4082d48d1",
"assets/assets/images/home_illu.png": "940a3fac5d6252a10d0fcb9433547e6c",
"assets/assets/images/icons/icon.png": "0287eadfff84c4feb99d71d9908a87b3",
"assets/assets/images/icons/icon_loki.jpg": "bc59dde221fee8da63ccdf8fecc16730",
"assets/assets/images/odin_sad.jpg": "d464491467a6b2a817b2c9d1c2728e4d",
"assets/assets/images/odin_chibi.png": "eaa7ca1bc9b705f43b0e47bb2ddde46e",
"assets/assets/images/stories/forge_4.jpg": "69142244a3963ec60c01a17d6541cb7b",
"assets/assets/images/stories/fenrir_4.jpg": "2c79168d0ea2969444f0618701a675a4",
"assets/assets/images/stories/fenrir_5.jpg": "18a05d177f7e956b2ccc367b4ffb6b4b",
"assets/assets/images/stories/fenrir_1.jpg": "0fc3c8e037eee92eef7ade841980d1ae",
"assets/assets/images/stories/wall_5.jpg": "e640bf2dc7d7e7a311e4f01389af1bd9",
"assets/assets/images/stories/fenrir_2.jpg": "a593624c3529a2a9fd97dd8b44cb9b25",
"assets/assets/images/stories/baldr_4.jpg": "56e6b78e1b3dfba63f793d52ca918518",
"assets/assets/images/stories/baldr_1.jpg": "8e2e3b3fd2614e190221690b9725c5c5",
"assets/assets/images/stories/creation_3.jpg": "78fdee23ef7c3b93ed31cd222942466a",
"assets/assets/images/stories/fenrir_3.jpg": "a2b5cce503f6ed55abb321b24e6e45a5",
"assets/assets/images/stories/creation_2.jpg": "40ef8ac7ab6f073b26c0b0710daf24e0",
"assets/assets/images/stories/baldr_2.jpg": "5b465495e584544ce185c568e4bf2846",
"assets/assets/images/stories/wall_2.jpg": "5938e3fd5eaaa53ab6a31d57d4f1833f",
"assets/assets/images/stories/forge_2.jpg": "111c4e3ae8ab00c2009c006ef665e48b",
"assets/assets/images/stories/thor_4.jpg": "94b7feab4410ad3c993061eec3d2a48d",
"assets/assets/images/stories/creation_5.jpg": "fa29ce8a96c4af409eda37187905013e",
"assets/assets/images/stories/forge_5.jpg": "86e20bf93baac428898f51e5e152042d",
"assets/assets/images/stories/wall_1.jpg": "f3315e9929b3207f1bdc8ccd47db4956",
"assets/assets/images/stories/forge_3.jpg": "1c987c6aebbca26ac4082464f8db04ab",
"assets/assets/images/stories/thor_5.jpg": "323b6b32715710082a440e15619dd252",
"assets/assets/images/stories/wall_7.jpg": "b409645bd4c70d9ca07ee1e3568ae050",
"assets/assets/images/stories/wall_3.jpg": "b2e579833e6c54f8ca088ed8fa211be3",
"assets/assets/images/stories/creation_4.jpg": "588817c328a19f1d9ad5e757698d9d20",
"assets/assets/images/stories/baldr_3.jpg": "ad6036becd2e31a9543b181533d16045",
"assets/assets/images/stories/thor_2.jpg": "acc9bb11c1be85ff8b07bb0e382acbb0",
"assets/assets/images/stories/creation_1.jpg": "29492f176fbc691612df683319363e2e",
"assets/assets/images/stories/wall_6.jpg": "8361322bcc5d371e40f23a8d4551bdb5",
"assets/assets/images/stories/forge_1.jpg": "77205e59470f071fc511bd16aa23a4fd",
"assets/assets/images/stories/thor_3.jpg": "e7a9b95fe0f49e8a2ded4acb90bc1562",
"assets/assets/images/stories/wall_4.jpg": "928b4b7ca0fe702ede09a9bceb485f45",
"assets/assets/images/stories/baldr_5.jpg": "bb18d3feae81d24ca6a61c84c2d88040",
"assets/assets/images/stories/thor_1.jpg": "9f6df12c9a64c7bcaae69b1c25786377",
"assets/assets/images/apple_regular.png": "06205fa10818cb57891cade7cec0b7ca",
"assets/assets/images/cards/epic/frigg.jpg": "cd97072a3a7842050a11a293d06a420d",
"assets/assets/images/cards/epic/ymir.jpg": "09eb4db8c2ade351fbfc2869f2865124",
"assets/assets/images/cards/epic/gungnir.jpg": "505c316a465a7ba844b5f4175ff6d0c0",
"assets/assets/images/cards/epic/baldr.jpg": "d43e4befadbc96134bc3b970fe23d71b",
"assets/assets/images/cards/epic/gui.jpg": "017d6aa5246347c69d9e1476418c0e22",
"assets/assets/images/cards/epic/fenrir.jpg": "beed359e97edb581b17aef7f4c1a7765",
"assets/assets/images/cards/epic/freyja.jpg": "f520be131eef4c4026f8f0c7b34a3db8",
"assets/assets/images/cards/epic/ginnungagap.jpg": "eca5d3b1a93858aa1d89fa0adbaf72d7",
"assets/assets/images/cards/epic/hrimthurs.jpg": "fa989760b5eea08e597afd19409d9622",
"assets/assets/images/cards/epic/mjollnir.jpg": "ebf19adcefcf1e2c5d81c2ec78dd2f53",
"assets/assets/images/cards/epic/sleipnir.jpg": "f5c197c920cd962ba5c2622c2343e256",
"assets/assets/images/cards/epic/svadilfari.jpg": "6f52831f8a3ff810cdc874be61f751ea",
"assets/assets/images/cards/epic/gleipnir.jpg": "cc0a32fca5a61ee6a15f3d043976b331",
"assets/assets/images/cards/epic/skadi.jpg": "ad8154f1bcb9e5429784e078d84e4011",
"assets/assets/images/cards/epic/brokkr_sindri.jpg": "29968b1258d8338959001f649e211bfa",
"assets/assets/images/cards/epic/sif.jpg": "a87260d468ed30e2b80f1831be373014",
"assets/assets/images/cards/epic/helheim.jpg": "8d4b5f75c483dc31b3f19dddc8095a43",
"assets/assets/images/cards/epic/huginnmuninn.jpg": "0d2cab36b3ee8d4df20f6ac2f80c00ae",
"assets/assets/images/cards/epic/audhumla.jpg": "1623a38fc118581d9fe50778371fb4a0",
"assets/assets/images/cards/epic/odin.jpg": "3b173f06ac65ad613c60bb5ab8decc5b",
"assets/assets/images/cards/epic/hel.jpg": "aa4a2154698b2222a901af0767078501",
"assets/assets/images/cards/epic/tyr.jpg": "df27fe629e2668dcd3283d799682bf35",
"assets/assets/images/cards/epic/thrym.jpg": "2fe1d60d9948d690d5676a913aea0d51",
"assets/assets/images/cards/epic/draupnir.jpg": "2185ecc78fbf23c97ff312c041aa7a9e",
"assets/assets/images/cards/chibi/frigg.jpg": "9c0d9cf75c519d590dfc140e5cdfd29a",
"assets/assets/images/cards/chibi/njord.jpg": "04ddb3c0a3d8412b6638406711ead3b4",
"assets/assets/images/cards/chibi/thor.jpg": "b0f9ccc2e5607c5142a45a4561b64abd",
"assets/assets/images/cards/chibi/ymir.jpg": "2e6fbae463e0aa9ca2b3540533988285",
"assets/assets/images/cards/chibi/gungnir.jpg": "6174aecd6ce94225aeffdc0194d58629",
"assets/assets/images/cards/chibi/baldr.jpg": "1c278cba4fd131dae6f7bc65e2489063",
"assets/assets/images/cards/chibi/gui.jpg": "b1baf8e08eaaec2c5caaf6d64788c466",
"assets/assets/images/cards/chibi/fenrir.jpg": "32e51400e891d26864c06fcf9b657812",
"assets/assets/images/cards/chibi/bifrost.jpg": "50dab74793e617c873f5a38a01662fdd",
"assets/assets/images/cards/chibi/brisingamen.jpg": "9fe55eb14478a44659b07b0f3ce3e550",
"assets/assets/images/cards/chibi/freyja.jpg": "7f38bd1c87ac3e3d3825c829e2024805",
"assets/assets/images/cards/chibi/hofund.jpg": "fbce43cfaac5685e952ba93c31476e15",
"assets/assets/images/cards/chibi/yggdrasil.jpg": "64f52d9dd1785f294574e2a37219bb6b",
"assets/assets/images/cards/chibi/loki.jpg": "8a081fea71fb341a5dae4e7d4fe141ff",
"assets/assets/images/cards/chibi/heimdall.jpg": "a6910dcfec3382dd95c9043ce03c7f9f",
"assets/assets/images/cards/chibi/ginnungagap.jpg": "bc577d9d542ba79cadf5bada808d88d4",
"assets/assets/images/cards/chibi/hrimthurs.jpg": "bd234afb5b212907ac22db9e2cffcc8d",
"assets/assets/images/cards/chibi/mjollnir.jpg": "7e3767456e6b0044fc0a8ae5cc9b0028",
"assets/assets/images/cards/chibi/gjallarhorn.jpg": "eccccbabe8e5afe3841f4bf71e6afcd1",
"assets/assets/images/cards/chibi/bragi.jpg": "6032854f04b5c77f100a9fbf835e6f0c",
"assets/assets/images/cards/chibi/svadilfari.jpg": "67100ec4d7c5d5201b116f9a9a94da64",
"assets/assets/images/cards/chibi/gleipnir.jpg": "592e3f09babe530e0b97c639951803ab",
"assets/assets/images/cards/chibi/jormungandr.jpg": "5fa5ed1dc8a9d080289581073b9c38ef",
"assets/assets/images/cards/chibi/skadi.jpg": "2c38f646f03914e330509797bfa036fe",
"assets/assets/images/cards/chibi/brokkr_sindri.jpg": "3e8ba9a91d7f47285d44ad62502a5ac9",
"assets/assets/images/cards/chibi/sif.jpg": "32721998eb1a2169dba5bdfbd6251493",
"assets/assets/images/cards/chibi/helheim.jpg": "e3d0cb555d30b6fd9bb60dab9c52b250",
"assets/assets/images/cards/chibi/huginnmuninn.jpg": "577ea7180966cc97e06d15894d6eeade",
"assets/assets/images/cards/chibi/audhumla.jpg": "f42542bdff32e8ed139f0a1bd9d33f95",
"assets/assets/images/cards/chibi/odin.jpg": "519a68b89a5cbff700f6627b107da787",
"assets/assets/images/cards/chibi/hel.jpg": "e7b0b2ff25a40c25f327bb97fb43395c",
"assets/assets/images/cards/chibi/tyr.jpg": "caa958f73efbe2e31bba415e1d7a1131",
"assets/assets/images/cards/chibi/thrym.jpg": "12e303147170839ede807b70e2fc93e3",
"assets/assets/images/cards/chibi/idunn.jpg": "f74ae79d9ea6bd1b4424a86e50a830a3",
"assets/assets/images/cards/chibi/draupnir.jpg": "69e1c26bd0aa33e382d628f827fd9b4b",
"assets/assets/images/cards/premium/frigg.jpg": "1c7cd927bebbc1deb773953ccecfc2c8",
"assets/assets/images/cards/premium/njord.jpg": "4d7aa7c713a6143e743c673b12bc61b6",
"assets/assets/images/cards/premium/thor.jpg": "f42b51f8daee33f9eb9481cf5947d874",
"assets/assets/images/cards/premium/ymir.jpg": "fe6d5e506dc00350727ea5f5a45c0ad6",
"assets/assets/images/cards/premium/gungnir.jpg": "60b7cefc58aad5a4ce4a9a04015a60a3",
"assets/assets/images/cards/premium/baldr.jpg": "6b282970ed41cc54ec80c1b9e9f37f2c",
"assets/assets/images/cards/premium/gui.jpg": "6adc7ff43bda84ab2b1c69ba7f8042e4",
"assets/assets/images/cards/premium/fenrir.jpg": "b258f40562bc7d1a1796e7f753b06d1d",
"assets/assets/images/cards/premium/bifrost.jpg": "6f349d0335c528c8854cae65e3f7d32c",
"assets/assets/images/cards/premium/brisingamen.jpg": "555c818e907e70721e4947cfef4fe0cc",
"assets/assets/images/cards/premium/freyja.jpg": "8ff5e26c6a64af21e02efaed2f14891b",
"assets/assets/images/cards/premium/hofund.jpg": "16039417d77226b362080a20aee374cc",
"assets/assets/images/cards/premium/yggdrasil.jpg": "60b106bf2ece7d650c192097ae35c26a",
"assets/assets/images/cards/premium/loki.jpg": "c58b365c235fff84e13bade34a15e73a",
"assets/assets/images/cards/premium/heimdall.jpg": "560b194354221330e6fae54446a82f40",
"assets/assets/images/cards/premium/ginnungagap.jpg": "d78b58299e2e72561c7e03d9809dd4d9",
"assets/assets/images/cards/premium/hrimthurs.jpg": "b6141cc94cb262bf6833b9b79ac1cec1",
"assets/assets/images/cards/premium/mjollnir.jpg": "f1cd48cc3f1393d11f001099acee9e92",
"assets/assets/images/cards/premium/gjallarhorn.jpg": "00931adb105390fa15b36805aa04c92c",
"assets/assets/images/cards/premium/bragi.jpg": "9dd980e7ebb44771f02ff80555ce118a",
"assets/assets/images/cards/premium/svadilfari.jpg": "0b30379e37df7bad64ea2cf0e8361b14",
"assets/assets/images/cards/premium/gleipnir.jpg": "95e3e8bf498bfd37f79353de813a5e87",
"assets/assets/images/cards/premium/jormungandr.jpg": "7ba0116b74c8b92062f05f61c0184a85",
"assets/assets/images/cards/premium/skadi.jpg": "c3c2911776778585dec30520b15567b3",
"assets/assets/images/cards/premium/brokkr_sindri.jpg": "ec758bf02de476d81f104f6f5a064eb4",
"assets/assets/images/cards/premium/sif.jpg": "8088fe4bf6c747338737976f8cf22199",
"assets/assets/images/cards/premium/helheim.jpg": "9349e53b9351a8aea4a32aa966acbe49",
"assets/assets/images/cards/premium/huginnmuninn.jpg": "650d50b0ef920852bc6934c53fce9678",
"assets/assets/images/cards/premium/audhumla.jpg": "8c590c6c4303ee9d83ee5bf8fc5e2d3c",
"assets/assets/images/cards/premium/odin.jpg": "cf44da571adceeb8f28370572898c98c",
"assets/assets/images/cards/premium/hel.jpg": "e6cf37ab5a5c6fe2148b1ded84722565",
"assets/assets/images/cards/premium/tyr.jpg": "36ac3e883b2e414c2f34d196b5b4f4a6",
"assets/assets/images/cards/premium/thrym.jpg": "9a77b9ded33fd24a0a21962cf848e602",
"assets/assets/images/cards/premium/idunn.jpg": "840230ddd7a3c55baf6cbf7307d59a57",
"assets/assets/images/cards/premium/draupnir.jpg": "3ad020bbd793e9bd49ebc2e708964384",
"assets/assets/images/snake_head.png": "dea96360b9a18a65c35e30a086e44e61",
"assets/assets/images/apple_rotten.png": "803c8f2c15d265deabb36aacc82510f8",
"assets/assets/images/chibi_smiley.svg": "21235df783b0248d562e6893b09fddbc",
"assets/assets/images/puzzle_chibi.png": "e565b7d5f32fd4b2bb73b3cdb7d665d7",
"assets/assets/reading.mp3": "571ba04fc46bc46b000a60bd18c97a13",
"assets/assets/ambiance.mp3": "9bee1cb1fb87f4b7f17f00ff722cd5e4",
"assets/assets/fonts/Amarante-Regular.ttf": "7f5e1b28879bb26a4ced2512b6f2e0d0",
"assets/assets/fonts/AmaticSC-Bold.ttf": "1920369a73a4108567c63ef769a1c520",
"assets/assets/fonts/NotoSansRunic-Regular.ttf": "5c93dcdbc6d624af2b936e101ad707f3"};
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
