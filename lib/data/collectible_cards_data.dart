import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/card_version.dart';
import 'package:easy_localization/easy_localization.dart';

// Helper function to create all versions of a card
List<CollectibleCard> _createCardVersions({
  required String id,
  required String titleKey,
  required String descriptionKey,
  required List<String> tags,
}) {
  return [
    CollectibleCard(
      id: id,
      title: titleKey.tr(),
      description: descriptionKey.tr(),
      imagePath: 'cards/chibi/$id.webp',
      tags: tags,
      version: CardVersion.chibi,
      videoUrl: 'https://ddcq.github.io/video/${id}_chibi.mp4',
      price: 50, // Chibi price
    ),
    CollectibleCard(
      id: id,
      title: titleKey.tr(),
      description: descriptionKey.tr(),
      imagePath: 'cards/premium/$id.webp',
      tags: tags,
      version: CardVersion.premium,
      videoUrl: 'https://ddcq.github.io/video/${id}_premium.mp4',
      price: 100, // Premium price
    ),
    CollectibleCard(
      id: id,
      title: titleKey.tr(),
      description: descriptionKey.tr(),
      imagePath: 'cards/epic/$id.webp',
      tags: tags,
      version: CardVersion.epic,
      videoUrl: 'https://ddcq.github.io/video/${id}_epic.mp4',
      price: 150, // Epic price
    ),
  ];
}

List<CollectibleCard> getAllCollectibleCards() {
  return [
    ..._createCardVersions(
      id: 'baldr',
      titleKey: 'collectible_card_baldr_title',
      descriptionKey: 'collectible_card_baldr_description',
      tags: ['Baldr', 'Ragnarök'],
    ),
    ..._createCardVersions(
      id: 'frigg',
      titleKey: 'collectible_card_frigg_title',
      descriptionKey: 'collectible_card_frigg_description',
      tags: ['Frigg', 'Odin', 'Baldr'],
    ),
    ..._createCardVersions(
      id: 'thor',
      titleKey: 'collectible_card_thor_title',
      descriptionKey: 'collectible_card_thor_description',
      tags: ['Thor', 'Mjöllnir'],
    ),
    ..._createCardVersions(
      id: 'mjollnir',
      titleKey: 'collectible_card_mjollnir_title',
      descriptionKey: 'collectible_card_mjollnir_description',
      tags: ['Mjöllnir', 'Thor'],
    ),
    ..._createCardVersions(
      id: 'thrym',
      titleKey: 'collectible_card_thrym_title',
      descriptionKey: 'collectible_card_thrym_description',
      tags: ['Thrym', 'Freyja', 'Mjöllnir'],
    ),
    ..._createCardVersions(
      id: 'fenrir',
      titleKey: 'collectible_card_fenrir_title',
      descriptionKey: 'collectible_card_fenrir_description',
      tags: ['Fenrir', 'Loki', 'Odin', 'Ragnarök'],
    ),
    ..._createCardVersions(
      id: 'tyr',
      titleKey: 'collectible_card_tyr_title',
      descriptionKey: 'collectible_card_tyr_description',
      tags: ['Tyr', 'Fenrir'],
    ),
    ..._createCardVersions(
      id: 'gleipnir',
      titleKey: 'collectible_card_gleipnir_title',
      descriptionKey: 'collectible_card_gleipnir_description',
      tags: ['Gleipnir', 'Fenrir'],
    ),
    ..._createCardVersions(
      id: 'ymir',
      titleKey: 'collectible_card_ymir_title',
      descriptionKey: 'collectible_card_ymir_description',
      tags: ['Ymir'],
    ),
    ..._createCardVersions(
      id: 'audhumla',
      titleKey: 'collectible_card_audhumla_title',
      descriptionKey: 'collectible_card_audhumla_description',
      tags: ['Audhumla', 'Ymir', 'Buri'],
    ),
    ..._createCardVersions(
      id: 'ginnungagap',
      titleKey: 'collectible_card_ginnungagap_title',
      descriptionKey: 'collectible_card_ginnungagap_description',
      tags: ['Ginnungagap'],
    ),
    ..._createCardVersions(
      id: 'sif',
      titleKey: 'collectible_card_sif_title',
      descriptionKey: 'collectible_card_sif_description',
      tags: ['Sif', 'Thor'],
    ),
    ..._createCardVersions(
      id: 'brokkr_sindri',
      titleKey: 'collectible_card_brokkr_sindri_title',
      descriptionKey: 'collectible_card_brokkr_sindri_description',
      tags: ['Brokkr', 'Sindri', 'Mjöllnir'],
    ),
    ..._createCardVersions(
      id: 'draupnir',
      titleKey: 'collectible_card_draupnir_title',
      descriptionKey: 'collectible_card_draupnir_description',
      tags: ['Draupnir', 'Odin'],
    ),
    ..._createCardVersions(
      id: 'gungnir',
      titleKey: 'collectible_card_gungnir_title',
      descriptionKey: 'collectible_card_gungnir_description',
      tags: ['Gungnir', 'Odin'],
    ),
    ..._createCardVersions(
      id: 'hrimthurs',
      titleKey: 'collectible_card_hrimthurs_title',
      descriptionKey: 'collectible_card_hrimthurs_description',
      tags: ['Hrimthurs', 'Freyja', 'Asgard'],
    ),
    ..._createCardVersions(
      id: 'svadilfari',
      titleKey: 'collectible_card_svadilfari_title',
      descriptionKey: 'collectible_card_svadilfari_description',
      tags: ['Svadilfari', 'Hrimthurs'],
    ),
    ..._createCardVersions(
      id: 'sleipnir',
      titleKey: 'collectible_card_sleipnir_title',
      descriptionKey: 'collectible_card_sleipnir_description',
      tags: ['Sleipnir', 'Odin', 'Loki', 'Svadilfari'],
    ),
    ..._createCardVersions(
      id: 'bifrost',
      titleKey: 'collectible_card_bifrost_title',
      descriptionKey: 'collectible_card_bifrost_description',
      tags: ['Bifrost', 'Asgard', 'Heimdall'],
    ),
    ..._createCardVersions(
      id: 'bragi',
      titleKey: 'collectible_card_bragi_title',
      descriptionKey: 'collectible_card_bragi_description',
      tags: ['Bragi', 'Idunn'],
    ),
    ..._createCardVersions(
      id: 'brisingamen',
      titleKey: 'collectible_card_brisingamen_title',
      descriptionKey: 'collectible_card_brisingamen_description',
      tags: ['Brisingamen', 'Freyja'],
    ),
    ..._createCardVersions(
      id: 'freyja',
      titleKey: 'collectible_card_freyja_title',
      descriptionKey: 'collectible_card_freyja_description',
      tags: ['Freyja', 'Folkvangr'],
    ),
    ..._createCardVersions(
      id: 'gjallarhorn',
      titleKey: 'collectible_card_gjallarhorn_title',
      descriptionKey: 'collectible_card_gjallarhorn_description',
      tags: ['Gjallarhorn', 'Heimdall', 'Ragnarök'],
    ),
    ..._createCardVersions(
      id: 'heimdall',
      titleKey: 'collectible_card_heimdall_title',
      descriptionKey: 'collectible_card_heimdall_description',
      tags: ['Heimdall', 'Asgard', 'Bifrost', 'Gjallarhorn'],
    ),
    ..._createCardVersions(
      id: 'hel',
      titleKey: 'collectible_card_hel_title',
      descriptionKey: 'collectible_card_hel_description',
      tags: ['Hel', 'Helheim', 'Loki'],
    ),
    ..._createCardVersions(
      id: 'helheim',
      titleKey: 'collectible_card_helheim_title',
      descriptionKey: 'collectible_card_helheim_description',
      tags: ['Helheim', 'Hel'],
    ),
    ..._createCardVersions(
      id: 'hofund',
      titleKey: 'collectible_card_hofund_title',
      descriptionKey: 'collectible_card_hofund_description',
      tags: ['Hofund', 'Heimdall'],
    ),
    ..._createCardVersions(
      id: 'huginnmuninn',
      titleKey: 'collectible_card_huginnmuninn_title',
      descriptionKey: 'collectible_card_huginnmuninn_description',
      tags: ['Huginn', 'Muninn', 'Odin'],
    ),
    ..._createCardVersions(
      id: 'idunn',
      titleKey: 'collectible_card_idunn_title',
      descriptionKey: 'collectible_card_idunn_description',
      tags: ['Idunn', 'Bragi'],
    ),
    ..._createCardVersions(
      id: 'jormungandr',
      titleKey: 'collectible_card_jormungandr_title',
      descriptionKey: 'collectible_card_jormungandr_description',
      tags: ['Jörmungandr', 'Loki', 'Ragnarök'],
    ),
    ..._createCardVersions(
      id: 'loki',
      titleKey: 'collectible_card_loki_title',
      descriptionKey: 'collectible_card_loki_description',
      tags: ['Loki', 'Trickster'],
    ),
    ..._createCardVersions(
      id: 'njord',
      titleKey: 'collectible_card_njord_title',
      descriptionKey: 'collectible_card_njord_description',
      tags: ['Njord', 'Vanir'],
    ),
    ..._createCardVersions(
      id: 'odin',
      titleKey: 'collectible_card_odin_title',
      descriptionKey: 'collectible_card_odin_description',
      tags: ['Odin', 'Allfather'],
    ),
    ..._createCardVersions(
      id: 'skadi',
      titleKey: 'collectible_card_skadi_title',
      descriptionKey: 'collectible_card_skadi_description',
      tags: ['Skadi', 'Winter', 'Hunting'],
    ),
    ..._createCardVersions(
      id: 'yggdrasil',
      titleKey: 'collectible_card_yggdrasil_title',
      descriptionKey: 'collectible_card_yggdrasil_description',
      tags: ['Yggdrasil', 'World Tree'],
    ),
  ];
}

final allCollectibleCards = getAllCollectibleCards();
