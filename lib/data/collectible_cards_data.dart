import 'package:easy_localization/easy_localization.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/card_version.dart';

// Helper function to create all versions of a card
List<CollectibleCard> _createCardVersions({required String id, required String title, required String description, required List<String> tags}) {
  return [
    CollectibleCard(
      id: id,
      title: title,
      description: description,
      imagePath: 'cards/chibi/$id.webp',
      tags: tags,
      version: CardVersion.chibi,
      videoUrl: 'https://ddcq.github.io/video/${id}_chibi.mp4',
    ),
    CollectibleCard(
      id: id,
      title: title,
      description: description,
      imagePath: 'cards/premium/$id.webp',
      tags: tags,
      version: CardVersion.premium,
      videoUrl: 'https://ddcq.github.io/video/${id}_premium.mp4',
    ),
    CollectibleCard(
      id: id,
      title: title,
      description: description,
      imagePath: 'cards/epic/$id.webp',
      tags: tags,
      version: CardVersion.epic,
      videoUrl: 'https://ddcq.github.io/video/${id}_epic.mp4',
    ),
  ];
}

final allCollectibleCards = [
  ..._createCardVersions(
    id: 'baldr',
    title: 'collectible_card_baldr_title'.tr(),
    description: 'collectible_card_baldr_description'.tr(),
    tags: ['Baldr', 'Ragnarök'],
  ),
  ..._createCardVersions(
    id: 'frigg',
    title: 'collectible_card_frigg_title'.tr(),
    description: 'collectible_card_frigg_description'.tr(),
    tags: ['Frigg', 'Odin', 'Baldr'],
  ),
  ..._createCardVersions(
    id: 'gui',
    title: 'collectible_card_gui_title'.tr(),
    description: 'collectible_card_gui_description'.tr(),
    tags: ['Gui', 'Baldr', 'Loki'],
  ),
  ..._createCardVersions(
    id: 'thor',
    title: 'collectible_card_thor_title'.tr(),
    description: 'collectible_card_thor_description'.tr(),
    tags: ['Thor', 'Mjöllnir'],
  ),
  ..._createCardVersions(
    id: 'mjollnir',
    title: 'collectible_card_mjollnir_title'.tr(),
    description: 'collectible_card_mjollnir_description'.tr(),
    tags: ['Mjöllnir', 'Thor'],
  ),
  ..._createCardVersions(
    id: 'thrym',
    title: 'collectible_card_thrym_title'.tr(),
    description: 'collectible_card_thrym_description'.tr(),
    tags: ['Thrym', 'Freyja', 'Mjöllnir'],
  ),
  ..._createCardVersions(
    id: 'fenrir',
    title: 'collectible_card_fenrir_title'.tr(),
    description: 'collectible_card_fenrir_description'.tr(),
    tags: ['Fenrir', 'Loki', 'Odin', 'Ragnarök'],
  ),
  ..._createCardVersions(id: 'tyr', title: 'collectible_card_tyr_title'.tr(), description: 'collectible_card_tyr_description'.tr(), tags: ['Tyr', 'Fenrir']),
  ..._createCardVersions(
    id: 'gleipnir',
    title: 'collectible_card_gleipnir_title'.tr(),
    description: 'collectible_card_gleipnir_description'.tr(),
    tags: ['Gleipnir', 'Fenrir'],
  ),
  ..._createCardVersions(id: 'ymir', title: 'collectible_card_ymir_title'.tr(), description: 'collectible_card_ymir_description'.tr(), tags: ['Ymir']),
  ..._createCardVersions(
    id: 'audhumla',
    title: 'collectible_card_audhumla_title'.tr(),
    description: 'collectible_card_audhumla_description'.tr(),
    tags: ['Audhumla', 'Ymir', 'Buri'],
  ),
  ..._createCardVersions(
    id: 'ginnungagap',
    title: 'collectible_card_ginnungagap_title'.tr(),
    description: 'collectible_card_ginnungagap_description'.tr(),
    tags: ['Ginnungagap'],
  ),
  ..._createCardVersions(id: 'sif', title: 'collectible_card_sif_title'.tr(), description: 'collectible_card_sif_description'.tr(), tags: ['Sif', 'Thor']),
  ..._createCardVersions(
    id: 'brokkr_sindri',
    title: 'collectible_card_brokkr_sindri_title'.tr(),
    description: 'collectible_card_brokkr_sindri_description'.tr(),
    tags: ['Brokkr', 'Sindri', 'Mjöllnir'],
  ),
  ..._createCardVersions(
    id: 'draupnir',
    title: 'collectible_card_draupnir_title'.tr(),
    description: 'collectible_card_draupnir_description'.tr(),
    tags: ['Draupnir', 'Odin'],
  ),
  ..._createCardVersions(
    id: 'gungnir',
    title: 'collectible_card_gungnir_title'.tr(),
    description: 'collectible_card_gungnir_description'.tr(),
    tags: ['Gungnir', 'Odin'],
  ),
  ..._createCardVersions(
    id: 'hrimthurs',
    title: 'collectible_card_hrimthurs_title'.tr(),
    description: 'collectible_card_hrimthurs_description'.tr(),
    tags: ['Hrimthurs', 'Freyja', 'Asgard'],
  ),
  ..._createCardVersions(
    id: 'svadilfari',
    title: 'collectible_card_svadilfari_title'.tr(),
    description: 'collectible_card_svadilfari_description'.tr(),
    tags: ['Svadilfari', 'Hrimthurs'],
  ),
  ..._createCardVersions(
    id: 'sleipnir',
    title: 'collectible_card_sleipnir_title'.tr(),
    description: 'collectible_card_sleipnir_description'.tr(),
    tags: ['Sleipnir', 'Odin', 'Loki', 'Svadilfari'],
  ),
  ..._createCardVersions(
    id: 'bifrost',
    title: 'collectible_card_bifrost_title'.tr(),
    description: 'collectible_card_bifrost_description'.tr(),
    tags: ['Bifrost', 'Asgard', 'Heimdall'],
  ),
  ..._createCardVersions(
    id: 'bragi',
    title: 'collectible_card_bragi_title'.tr(),
    description: 'collectible_card_bragi_description'.tr(),
    tags: ['Bragi', 'Idunn'],
  ),
  ..._createCardVersions(
    id: 'brisingamen',
    title: 'collectible_card_brisingamen_title'.tr(),
    description: 'collectible_card_brisingamen_description'.tr(),
    tags: ['Brisingamen', 'Freyja'],
  ),
  ..._createCardVersions(
    id: 'freyja',
    title: 'collectible_card_freyja_title'.tr(),
    description: 'collectible_card_freyja_description'.tr(),
    tags: ['Freyja', 'Folkvangr'],
  ),
  ..._createCardVersions(
    id: 'gjallarhorn',
    title: 'collectible_card_gjallarhorn_title'.tr(),
    description: 'collectible_card_gjallarhorn_description'.tr(),
    tags: ['Gjallarhorn', 'Heimdall', 'Ragnarök'],
  ),
  ..._createCardVersions(
    id: 'heimdall',
    title: 'collectible_card_heimdall_title'.tr(),
    description: 'collectible_card_heimdall_description'.tr(),
    tags: ['Heimdall', 'Asgard', 'Bifrost', 'Gjallarhorn'],
  ),
  ..._createCardVersions(
    id: 'hel',
    title: 'collectible_card_hel_title'.tr(),
    description: 'collectible_card_hel_description'.tr(),
    tags: ['Hel', 'Helheim', 'Loki'],
  ),
  ..._createCardVersions(
    id: 'helheim',
    title: 'collectible_card_helheim_title'.tr(),
    description: 'collectible_card_helheim_description'.tr(),
    tags: ['Helheim', 'Hel'],
  ),
  ..._createCardVersions(
    id: 'hofund',
    title: 'collectible_card_hofund_title'.tr(),
    description: 'collectible_card_hofund_description'.tr(),
    tags: ['Hofund', 'Heimdall'],
  ),
  ..._createCardVersions(
    id: 'huginnmuninn',
    title: 'collectible_card_huginnmuninn_title'.tr(),
    description: 'collectible_card_huginnmuninn_description'.tr(),
    tags: ['Huginn', 'Muninn', 'Odin'],
  ),
  ..._createCardVersions(
    id: 'idunn',
    title: 'collectible_card_idunn_title'.tr(),
    description: 'collectible_card_idunn_description'.tr(),
    tags: ['Idunn', 'Bragi'],
  ),
  ..._createCardVersions(
    id: 'jormungandr',
    title: 'collectible_card_jormungandr_title'.tr(),
    description: 'collectible_card_jormungandr_description'.tr(),
    tags: ['Jörmungandr', 'Loki', 'Ragnarök'],
  ),
  ..._createCardVersions(
    id: 'loki',
    title: 'collectible_card_loki_title'.tr(),
    description: 'collectible_card_loki_description'.tr(),
    tags: ['Loki', 'Trickster'],
  ),
  ..._createCardVersions(
    id: 'njord',
    title: 'collectible_card_njord_title'.tr(),
    description: 'collectible_card_njord_description'.tr(),
    tags: ['Njord', 'Vanir'],
  ),
  ..._createCardVersions(
    id: 'odin',
    title: 'collectible_card_odin_title'.tr(),
    description: 'collectible_card_odin_description'.tr(),
    tags: ['Odin', 'Allfather'],
  ),
  ..._createCardVersions(
    id: 'skadi',
    title: 'collectible_card_skadi_title'.tr(),
    description: 'collectible_card_skadi_description'.tr(),
    tags: ['Skadi', 'Winter', 'Hunting'],
  ),
  ..._createCardVersions(
    id: 'yggdrasil',
    title: 'collectible_card_yggdrasil_title'.tr(),
    description: 'collectible_card_yggdrasil_description'.tr(),
    tags: ['Yggdrasil', 'World Tree'],
  ),
];

List<CollectibleCard> getCollectibleCards() {
  return allCollectibleCards;
}
