'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "ff68ed1a54d1b53c4b3b300fe4cd2791",
"icons/Icon-maskable-512.png": "ff68ed1a54d1b53c4b3b300fe4cd2791",
"icons/Icon-192.png": "23bd64d063f503ec5a2427f9ab41db32",
"icons/Icon-maskable-192.png": "23bd64d063f503ec5a2427f9ab41db32",
"manifest.json": "1bf603c2272364e0d7de22d631f4d694",
"index.html": "33dd71b6aac77a5d3250f162dc7a39ac",
"/": "33dd71b6aac77a5d3250f162dc7a39ac",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "72658d9fbd78f8f1d727f6c127ced2cf",
"assets/assets/resources/langs/en-US.json": "1f627f10fea034578c51271eafe8200e",
"assets/assets/resources/langs/fr-FR.json": "adbcf63b28b56d6179ba306ad2a09550",
"assets/assets/images/qix/fenrir.webp": "5034bd39d9a4d1f776864729061a6a93",
"assets/assets/images/qix/grass.webp": "6a30b7ffb848a385c374908d0d8b6c1e",
"assets/assets/images/icons/icon_1.png": "6a7f0d586238762db837fd44ce6c5977",
"assets/assets/images/stories/chatiment_1.webp": "52d839958d8fa61f78ca35eff55a4489",
"assets/assets/images/stories/peche_4.webp": "169747f7429b2a84ab41af1e50b0137a",
"assets/assets/images/stories/mead_4.webp": "d2ce0f7458fcffd5f78f30a8a39299d5",
"assets/assets/images/stories/fenrir_5.webp": "556fe9b52832bac60b5aa551e14d15f3",
"assets/assets/images/stories/ases_vanes_4.webp": "fa595afb7e67f21461a179450213e02e",
"assets/assets/images/stories/chatiment_2.webp": "2fa482139a2338ff23fdcd4f16f127b3",
"assets/assets/images/stories/creation_1.webp": "099043bb2f70bb4f4ddf8552fbf9a365",
"assets/assets/images/stories/fenrir_4.webp": "1f4ca65fbaffb4edd233c4c895557818",
"assets/assets/images/stories/loading.webp": "ebd1b109cc5dc4bf741500d82f9e3d84",
"assets/assets/images/stories/mead_5.webp": "dea5622083157c697050e194c6300ecc",
"assets/assets/images/stories/thor_4.webp": "4d381e13901d73c3e6176a38639a1655",
"assets/assets/images/stories/creation_4.webp": "05f0a57f9e3545b2c6d7088c0523d9ae",
"assets/assets/images/stories/ases_vanes_1.webp": "5334479e93540c254d9acfd30e9ef92c",
"assets/assets/images/stories/wall_5.webp": "63442b4bcb106e9a6c4a32615a18a932",
"assets/assets/images/stories/peche_5.webp": "c31fbd7a90abde809fe9fa3cb9835f68",
"assets/assets/images/stories/ases_vanes_5.webp": "293a33deb5aa025d15d7707e4ba0106d",
"assets/assets/images/stories/peche_1.webp": "7703bcfb887ee5521ab0db7f4e33fc0f",
"assets/assets/images/stories/mead_1.webp": "354833171150ef257c4c8601a1adda9d",
"assets/assets/images/stories/wall_2.webp": "14afac73502b144f62d5e52a54e457ae",
"assets/assets/images/stories/wall_6.webp": "87f73ae8534f15e7fa9de4579824581e",
"assets/assets/images/stories/ases_vanes_6.webp": "0185b24e7787848d93e6cf13bf691d07",
"assets/assets/images/stories/forge_3.webp": "5a6e7f06eb5aafa885ba6a2ce871222f",
"assets/assets/images/stories/peche_3.webp": "3f5e97c0e8583723e776ab68e2da2a89",
"assets/assets/images/stories/fenrir_2.webp": "0a8acc9f51c7c4efd52287b554f8bcc2",
"assets/assets/images/stories/thor_5.webp": "2139068ddd038b93a1aab02c0fab020e",
"assets/assets/images/stories/baldr_3.webp": "a8b622c81ca3a6c466c521a168b1cadd",
"assets/assets/images/stories/thor_1.webp": "58ef0989b0ba41f9fd0dc25a650f7f2a",
"assets/assets/images/stories/forge_1.webp": "9fbd35de2e5ab23d334ba7b438d953b2",
"assets/assets/images/stories/mead_6.webp": "adc32fda4185a3e8243b0143725ce769",
"assets/assets/images/stories/baldr_5.webp": "775aed8b2feec8b182b1040573aafe9e",
"assets/assets/images/stories/wall_1.webp": "4f331940f72abce4cbe805ea60e57257",
"assets/assets/images/stories/fenrir_3.webp": "330f6114a0bc24be31745e291159a9b9",
"assets/assets/images/stories/forge_2.webp": "447b828729fe2a2b8bf96040cbfe5bb4",
"assets/assets/images/stories/ases_vanes_2.webp": "72221a35fd10ef2251854b0ff0f74dd5",
"assets/assets/images/stories/baldr_2.webp": "7da03ff5c106287edb8525d5ba0330ec",
"assets/assets/images/stories/wall_3.webp": "7b68e3d4bcd3df09bc47813a114a6020",
"assets/assets/images/stories/wall_7.webp": "0c728aedb11e6cbbd149e7aa5d99b844",
"assets/assets/images/stories/chatiment_4.webp": "8359740f8c521c5047686b5545493be3",
"assets/assets/images/stories/ases_vanes_3.webp": "cdc9ccf4684289dae3a870ffe068aa90",
"assets/assets/images/stories/forge_5.webp": "e6591b64c2ddf509088bf1932dec1ea2",
"assets/assets/images/stories/forge_4.webp": "a051bf8d276eb9d09e01fe951fa2d452",
"assets/assets/images/stories/baldr_1.webp": "be44c26b8e7a777b7dcfa59aca287c3b",
"assets/assets/images/stories/mead_3.webp": "9d6c8e66aba529f25bada205c060b3b1",
"assets/assets/images/stories/fenrir_1.webp": "e7e4fb87ba1d6434194fb1d7d8f839ae",
"assets/assets/images/stories/thor_2.webp": "6bb918b310f13a5e1923bc284e88eaff",
"assets/assets/images/stories/chatiment_6.webp": "57e2b9dcc1eaef09cc24f1461209d6fc",
"assets/assets/images/stories/peche_2.webp": "f6c265325e689848f3b72503f4863d7f",
"assets/assets/images/stories/creation_5.webp": "2928ed8476639cc79dd03d79bffe6946",
"assets/assets/images/stories/thor_3.webp": "97d5821e8e306022d812b5267941aca2",
"assets/assets/images/stories/wall_4.webp": "3e2fd754ef4c264d3f9aeebe2d89aa43",
"assets/assets/images/stories/creation_3.webp": "606527debc20f4a022b786613c65798b",
"assets/assets/images/stories/mead_2.webp": "6ddf6ae8b25f6a9291cdd4db8dda814e",
"assets/assets/images/stories/chatiment_3.webp": "ec53ad2716565980d33d6000fc02c898",
"assets/assets/images/stories/creation_2.webp": "91a4acde3c90d3446ee3dd15c709b42d",
"assets/assets/images/stories/baldr_4.webp": "f9c302810b9d7653070a6fe35f195b07",
"assets/assets/images/stories/chatiment_5.webp": "c9e910d4c358354c43c9bdcbe643d47a",
"assets/assets/images/odin-happy.webp": "74e73e54ff026cf9da379cdad285ac2e",
"assets/assets/images/odin_chibi.png": "eaa7ca1bc9b705f43b0e47bb2ddde46e",
"assets/assets/images/explosion.png": "fa54f02463d5f28ce7b197dbb492d87c",
"assets/assets/images/blocks/p.webp": "dba9ca4d081654a103484bab1ad28d63",
"assets/assets/images/blocks/x.webp": "1981ede788a937dfe5049f0eb6bc7cee",
"assets/assets/images/blocks/t.webp": "2dec7373d69cb96e1f3bbc532e6d8a12",
"assets/assets/images/blocks/i2.webp": "16ed18c8d9c00a1d17c0ff2f20514a39",
"assets/assets/images/blocks/l.webp": "bff61b13c1ee2c5ed62a426c870c1ccd",
"assets/assets/images/blocks/u.webp": "ed2e9675e3bcfa870c5ec0923a2727f5",
"assets/assets/images/blocks/q.webp": "69c535a8e83d0cae9f68212ce2e4f5d8",
"assets/assets/images/blocks/i3.webp": "b9e17e4f231f527adc774079dd72241e",
"assets/assets/images/cards/chibi/hrimthurs.webp": "9e7f423e669ccc735fe9b943ab400d91",
"assets/assets/images/cards/chibi/helheim.webp": "e78c0eb0c0ea44a7998c33a63f37ae6d",
"assets/assets/images/cards/chibi/huginnmuninn.webp": "85af80297cc430dc4c5c26fbc46c61d1",
"assets/assets/images/cards/chibi/frigg.webp": "1a5d15fb00be811e10d898359cd2483d",
"assets/assets/images/cards/chibi/gungnir.webp": "f8d86cf6b65b7bad177fdad0fb877e9f",
"assets/assets/images/cards/chibi/njord.webp": "9ca61698474beeafacdc4857781e7349",
"assets/assets/images/cards/chibi/gui.webp": "bf5f1553b70ddd191d1e198d73d3e698",
"assets/assets/images/cards/chibi/hofund.webp": "df9685c7ca321d0fce3f0e7decb83752",
"assets/assets/images/cards/chibi/bifrost.webp": "a640e97c3b00557f35ea225de32480c0",
"assets/assets/images/cards/chibi/yggdrasil.webp": "ad5bdd2e588fa8ebcc9f34eaa489dbeb",
"assets/assets/images/cards/chibi/thrym.webp": "c17000f4f6955ceaf8c58521d6838210",
"assets/assets/images/cards/chibi/draupnir.webp": "2173206c4b4067eb1fefc32087999c1b",
"assets/assets/images/cards/chibi/sif.webp": "d721ee1fd146cc93b2d02b15fd8989f0",
"assets/assets/images/cards/chibi/hel.webp": "4c90c4a7d0e14b88beec438e714198a2",
"assets/assets/images/cards/chibi/idunn.webp": "ab9fdb7ecca4f4ee6f2ad9a84ca01481",
"assets/assets/images/cards/chibi/heimdall.webp": "672a7184edb6268fcaaa575d3cf593c2",
"assets/assets/images/cards/chibi/skadi.webp": "27500bfe6775907fc6e49539dc8e6798",
"assets/assets/images/cards/chibi/audhumla.webp": "5a4809a86f7066d72a4c4bd68ae61f13",
"assets/assets/images/cards/chibi/brokkr_sindri.webp": "dd83607504efa85ebca65d1852624161",
"assets/assets/images/cards/chibi/svadilfari.webp": "ff5189f3614d94d0d8c579fd156996b5",
"assets/assets/images/cards/chibi/bragi.webp": "3ad44a997805e56015bbef75d201a819",
"assets/assets/images/cards/chibi/fenrir.webp": "62846833a9faa6a9c1829c2ac637074a",
"assets/assets/images/cards/chibi/gjallarhorn.webp": "96bb2b028c46f4c6bffa737427f29828",
"assets/assets/images/cards/chibi/sleipnir.webp": "4e05fe8e5830ebf211f2f66fcc0896db",
"assets/assets/images/cards/chibi/baldr.webp": "42a68d8025afa23f684a89d72b9abed2",
"assets/assets/images/cards/chibi/tyr.webp": "3993ab90cb2d4cf70aafb98996b63ca6",
"assets/assets/images/cards/chibi/odin.webp": "8803e4b8040a0165eac2673ac288f9a4",
"assets/assets/images/cards/chibi/jormungandr.webp": "4a23b03ba5267db9017b099139c2ffd6",
"assets/assets/images/cards/chibi/loki.webp": "f6c7b1863725a54dbb6363a98948f2f7",
"assets/assets/images/cards/chibi/ymir.webp": "6505ee06a990a189abe99a813beed19d",
"assets/assets/images/cards/chibi/brisingamen.webp": "1a6cc269e9e26d0e7a99758cdc82b19f",
"assets/assets/images/cards/chibi/freyja.webp": "8726519d607b251ff5b83227175e9527",
"assets/assets/images/cards/chibi/gleipnir.webp": "2ba152930e5a8a99f5bede6d5b75b599",
"assets/assets/images/cards/chibi/ginnungagap.webp": "6f354c7f1d32814b5f965ea69a601ef6",
"assets/assets/images/cards/chibi/thor.webp": "45fb8e78804856c19d58cda83676ab55",
"assets/assets/images/cards/chibi/mjollnir.webp": "e07314652fac743eefe6b08bf19fd2f7",
"assets/assets/images/cards/premium/hrimthurs.webp": "304627faf28869132c32cee453399d3d",
"assets/assets/images/cards/premium/helheim.webp": "c2d4946a023b4a114aa576bdd3fb9c97",
"assets/assets/images/cards/premium/huginnmuninn.webp": "e750ef5e74c6e5b2129bc1640f890c31",
"assets/assets/images/cards/premium/frigg.webp": "1dcb278852c9f995f96787e208f30d0a",
"assets/assets/images/cards/premium/gungnir.webp": "67ffc1b76b39b52fbea922ac659e0c3e",
"assets/assets/images/cards/premium/njord.webp": "53d35de349824d62bd073829f3dc9372",
"assets/assets/images/cards/premium/gui.webp": "bfd4aa4d997dd0eb50ff8393d14f18ea",
"assets/assets/images/cards/premium/hofund.webp": "8d3be4e1e039cdf1f46c3f7f1437ce8c",
"assets/assets/images/cards/premium/bifrost.webp": "778e15d35e8f3eb368f028f661dbe7ae",
"assets/assets/images/cards/premium/yggdrasil.webp": "487c14c47d54dc8b17ef8051a0fc59a7",
"assets/assets/images/cards/premium/thrym.webp": "b03c3ae44a2547845735cfac73da2624",
"assets/assets/images/cards/premium/draupnir.webp": "3b0a48124c32bb74bb2b2bb633bccb9d",
"assets/assets/images/cards/premium/sif.webp": "faab36150c692161751e2d31f7d25c73",
"assets/assets/images/cards/premium/hel.webp": "0bc861d54680dca6cfaebac2e92f2106",
"assets/assets/images/cards/premium/idunn.webp": "1f792e9cab1c37e70afcd20eeaa6e09a",
"assets/assets/images/cards/premium/heimdall.webp": "ca4785af94248380a028525bacaeb4d4",
"assets/assets/images/cards/premium/skadi.webp": "d871552bd1df31d89546874fa6e92a1c",
"assets/assets/images/cards/premium/audhumla.webp": "cbc6830587b4a8aadf260d04c7ff63e5",
"assets/assets/images/cards/premium/brokkr_sindri.webp": "03ab9690f412062d2dd269a78ab41f03",
"assets/assets/images/cards/premium/svadilfari.webp": "0a93684eeea7675c6fcc51845990c708",
"assets/assets/images/cards/premium/bragi.webp": "fd918619a9d3cbdc7abed5e37b57ed2b",
"assets/assets/images/cards/premium/fenrir.webp": "79e3b5f4e8696a3d46a90fa27d48724e",
"assets/assets/images/cards/premium/gjallarhorn.webp": "0659f1d486a2dc5ed2f1bcf60f2205eb",
"assets/assets/images/cards/premium/sleipnir.webp": "bd8428b979c43b605bbe11b401911f5f",
"assets/assets/images/cards/premium/baldr.webp": "73062154e8e9921780235c07c79650bd",
"assets/assets/images/cards/premium/tyr.webp": "3dc653413ab6c378799131855cf53b9c",
"assets/assets/images/cards/premium/odin.webp": "fdbf1c1ff8d6a239b093bc834582f9e1",
"assets/assets/images/cards/premium/jormungandr.webp": "2c83047a0b6fc961cd7872fa33bf9271",
"assets/assets/images/cards/premium/loki.webp": "0229e1552c9aeafade389559e2bd2ac0",
"assets/assets/images/cards/premium/ymir.webp": "5f55305983de6069424fb6d4f866e445",
"assets/assets/images/cards/premium/brisingamen.webp": "f1a9e528ca3a2c56ae59aa6d72ecd91f",
"assets/assets/images/cards/premium/freyja.webp": "b1332e5762a110474abdc4da1954a3c1",
"assets/assets/images/cards/premium/gleipnir.webp": "fbed4a62bf31989002ac4e270770e9d1",
"assets/assets/images/cards/premium/ginnungagap.webp": "28eb6a2055902a7ec4a4bfa29f2caa68",
"assets/assets/images/cards/premium/thor.webp": "764abb2a6309b1198f73961c419d964e",
"assets/assets/images/cards/premium/mjollnir.webp": "0ced0b102481108967b479b23dbbcca4",
"assets/assets/images/cards/epic/hrimthurs.webp": "78f89e614cb3a30d026f5275cde25831",
"assets/assets/images/cards/epic/helheim.webp": "d6c60b52f4672f79a2bbc95a2290663e",
"assets/assets/images/cards/epic/huginnmuninn.webp": "078fbc5a74bc0e4e6fea6f9e01891117",
"assets/assets/images/cards/epic/frigg.webp": "0bfbdf0279747fa8696bf5d4e930891f",
"assets/assets/images/cards/epic/gungnir.webp": "2595c0bda230e1a18b5b660f68d9506e",
"assets/assets/images/cards/epic/njord.webp": "0eec58fa13d8e583fc6ff68138a893da",
"assets/assets/images/cards/epic/gui.webp": "0cd33e36ca8b0a77680963a6beb044dc",
"assets/assets/images/cards/epic/hofund.webp": "d08b8a8eb0cc7c5852ef43bb43562153",
"assets/assets/images/cards/epic/bifrost.webp": "db832866f35721515c7a36f2cc9d48ba",
"assets/assets/images/cards/epic/yggdrasil.webp": "aa0660e7ff39565de4cafabdb758cfe2",
"assets/assets/images/cards/epic/thrym.webp": "a72986feea43d4fafa0831965776cbf8",
"assets/assets/images/cards/epic/draupnir.webp": "297df01eaf934fc61cba4c84bfbe16f0",
"assets/assets/images/cards/epic/sif.webp": "489f92f89fa9af4e8d8cb7d95b9320cd",
"assets/assets/images/cards/epic/hel.webp": "05e3c03248dc1bd116385fe2a2074a0f",
"assets/assets/images/cards/epic/idunn.webp": "d4586167a0b42c9e94c5e62c9670a6d5",
"assets/assets/images/cards/epic/heimdall.webp": "4eb45f234411085000e235470c3246cf",
"assets/assets/images/cards/epic/skadi.webp": "76c98f3deac76d044cd3888efa15a4f0",
"assets/assets/images/cards/epic/audhumla.webp": "79cceab2f9f8e12904c1f68448bfdce7",
"assets/assets/images/cards/epic/brokkr_sindri.webp": "be5a8fc57a0c8adead4cc107333b9d25",
"assets/assets/images/cards/epic/svadilfari.webp": "7fe80b0f852617a87c2e69e52038f8e9",
"assets/assets/images/cards/epic/bragi.webp": "e3bf2b4608be054e0e7a6b59c024a845",
"assets/assets/images/cards/epic/fenrir.webp": "15684c8dd7592ec6e8b295fee5fbcdfc",
"assets/assets/images/cards/epic/gjallarhorn.webp": "305cfea6637a6315ee7bd926287fd121",
"assets/assets/images/cards/epic/sleipnir.webp": "122c370811d9b9e9ee8a3c6f47550aa4",
"assets/assets/images/cards/epic/baldr.webp": "0ddf3a45ac6d87230a3475b389b36c78",
"assets/assets/images/cards/epic/tyr.webp": "ec79f90cf864e5eed988da10fa6abd7f",
"assets/assets/images/cards/epic/odin.webp": "742f2cae289798c9c8ccd70eb0c83246",
"assets/assets/images/cards/epic/jormungandr.webp": "b086518d3b1d5f60701e04560b9cfc22",
"assets/assets/images/cards/epic/loki.webp": "8de3062eb486be615718b147d50d51ca",
"assets/assets/images/cards/epic/ymir.webp": "236ce41585477420e5a16d49f4635098",
"assets/assets/images/cards/epic/brisingamen.webp": "98dbb2400f89028dfef067f942981ef6",
"assets/assets/images/cards/epic/freyja.webp": "2dc47748dd19ed3270e025664d7d76ae",
"assets/assets/images/cards/epic/gleipnir.webp": "7097f664493d4deaf0fb61e58de0a034",
"assets/assets/images/cards/epic/ginnungagap.webp": "fc70b0facd6664a530b3d4d09d926b3f",
"assets/assets/images/cards/epic/thor.webp": "7a94b591de1f986ef2244baad42bf4db",
"assets/assets/images/cards/epic/mjollnir.webp": "7efeff33b900dbdcc29b6b6cd886d95a",
"assets/assets/images/characters.png": "99f1b56aa116313f681eb00712c007f5",
"assets/assets/images/heads/frigg.webp": "d1d76f2138bce167e9e740ff22df48ba",
"assets/assets/images/heads/freya.webp": "a6afbda4469bc045497697c61e14cfff",
"assets/assets/images/heads/astrid.webp": "aeba027b55d396212d0fce7d39827143",
"assets/assets/images/heads/freydis.webp": "3c047dec5ab61509f39a00edd8e3ab97",
"assets/assets/images/heads/ingrid.webp": "f42e072ee3f6fd26f928797fb472237e",
"assets/assets/images/heads/bjorn.webp": "a3d37af6402ce785e8b3ce44196f1628",
"assets/assets/images/heads/ragnar.webp": "eff0dd3e691836c3bda80ea63e655f58",
"assets/assets/images/heads/tyr.webp": "e67eec69c73c30e663b5425264063f95",
"assets/assets/images/heads/sven.webp": "2a13a947148da8e6fc6cb80f5bd24e78",
"assets/assets/images/heads/odin.webp": "a9244ecc756bc88d3eaeffa189962df5",
"assets/assets/images/heads/loki.webp": "006ad01430066b902bd2acb6775ed9d3",
"assets/assets/images/heads/thor.webp": "1af10079b1ae21035c49709eb75d3622",
"assets/assets/images/sea.webp": "fdc3407248bb271f3297aff47e0bdd10",
"assets/assets/images/snake/apple_golden.png": "3c2b18c48ce3da2ca63ab682ef6e05b1",
"assets/assets/images/snake/snake_body.png": "a57e94282926a4675de82d4c70041c65",
"assets/assets/images/snake/apple_rotten.png": "264f1e23007fea986ed9ff0dc9785d50",
"assets/assets/images/snake/snake_head.png": "120786a361c500bbe4ae6a76b31a3e3d",
"assets/assets/images/snake/apple_regular.png": "75c68346edf7c5dd729ac8791bc37b24",
"assets/assets/images/snake/stone.webp": "895390eb5dcede93ac06b3698b7d81ab",
"assets/assets/images/odin_sad.png": "a9767c667e29716c627a239aaaaa7dc0",
"assets/assets/images/home_illu.png": "940a3fac5d6252a10d0fcb9433547e6c",
"assets/assets/images/sparkle.png": "704e423f6ec0d24cd3f69dfafc9dcc42",
"assets/assets/images/puzzle_chibi.png": "e565b7d5f32fd4b2bb73b3cdb7d665d7",
"assets/assets/images/backgrounds/defeated.jpg": "3eb22aa6a2f7df446c53f70e6a169927",
"assets/assets/images/backgrounds/wall.webp": "e603d5a7d3cd786e66705f66c17db184",
"assets/assets/images/backgrounds/asgard.jpg": "0ad13d4fb2a3456ece301ba3f378f925",
"assets/assets/images/backgrounds/landscape.jpg": "6e18f5ed443dd482f92be0896acdc094",
"assets/assets/images/preliminary/order_the_scrolls.webp": "688412aab80ae3ad403735d5f6fdbbf0",
"assets/assets/images/preliminary/asgard_wall.webp": "c7e5ec699b5051d561f665a52ed5132f",
"assets/assets/images/preliminary/qix.webp": "90e590eea1ac074909becb1790228f5f",
"assets/assets/images/preliminary/word_search.webp": "18d1ac018281ec5a5fd2db3dc4056e24",
"assets/assets/images/preliminary/snake.webp": "cd6e8ca6a5e8583f52fc8932144c4fea",
"assets/assets/fonts/Amarante-Regular.ttf": "7f5e1b28879bb26a4ced2512b6f2e0d0",
"assets/assets/fonts/AmaticSC-Bold.ttf": "1920369a73a4108567c63ef769a1c520",
"assets/assets/audio/reading.mp3": "571ba04fc46bc46b000a60bd18c97a13",
"assets/assets/audio/ambiance.mp3": "9bee1cb1fb87f4b7f17f00ff722cd5e4",
"assets/fonts/MaterialIcons-Regular.otf": "99dee9dded79678bb06b319f8ef28f5b",
"assets/NOTICES": "c057acf757e93c190df3e98966cec0b0",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/FontManifest.json": "e75775e3ae774102f89fe668b713a0a0",
"assets/AssetManifest.bin": "791333d16191b4296071f865d5e1a478",
"assets/AssetManifest.json": "85f78967e3e66f9c6f17e1f17aa13aa0",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"favicon.png": "ea235fc94c15aa3b23ce2cab960e2229",
"flutter_bootstrap.js": "968ed2c1ac4d07acfe0e677b43b0fe43",
"version.json": "34f0e1ca96123e8e0f4de9cdde7de7af",
"main.dart.js": "1ad709938e4f4a1e8e64200ffa760316"};
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
