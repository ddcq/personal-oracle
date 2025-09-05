import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/card_version.dart';

// Helper function to create all versions of a card
List<CollectibleCard> _createCardVersions({required String id, required String title, required String description, required List<String> tags}) {
  return [
    CollectibleCard(id: id, title: title, description: description, imagePath: 'cards/chibi/$id.webp', tags: tags, version: CardVersion.chibi),
    CollectibleCard(id: id, title: title, description: description, imagePath: 'cards/premium/$id.webp', tags: tags, version: CardVersion.premium),
    CollectibleCard(id: id, title: title, description: description, imagePath: 'cards/epic/$id.webp', tags: tags, version: CardVersion.epic),
  ];
}

final allCollectibleCards = [
  ..._createCardVersions(
    id: 'baldr',
    title: 'Baldr le Bon',
    description: 'Le dieu de la lumière, de la beauté et de la pureté. Sa mort fut le premier signe du Ragnarök.',
    tags: ['Baldr', 'Ragnarök'],
  ),
  ..._createCardVersions(
    id: 'frigg',
    title: 'Frigg la Mère',
    description: 'Déesse de l’amour, du mariage et de la maternité, épouse d’Odin et mère de Baldr.',
    tags: ['Frigg', 'Odin', 'Baldr'],
  ),
  ..._createCardVersions(
    id: 'gui',
    title: 'Le Gui Mortel',
    description: 'La seule plante capable de blesser Baldr, utilisée par Loki pour causer sa mort.',
    tags: ['Gui', 'Baldr', 'Loki'],
  ),
  ..._createCardVersions(
    id: 'thor',
    title: 'Thor le Protecteur',
    description: 'Le dieu du tonnerre, protecteur d’Asgard et des hommes, armé de son marteau Mjöllnir.',
    tags: ['Thor', 'Mjöllnir'],
  ),
  ..._createCardVersions(
    id: 'mjollnir',
    title: 'Mjöllnir',
    description: 'Le marteau légendaire de Thor, capable de contrôler la foudre et de revenir à son porteur.',
    tags: ['Mjöllnir', 'Thor'],
  ),
  ..._createCardVersions(
    id: 'thrym',
    title: 'Thrym le Géant',
    description: 'Le roi des géants qui vola Mjöllnir et demanda Freyja en mariage.',
    tags: ['Thrym', 'Freyja', 'Mjöllnir'],
  ),
  ..._createCardVersions(
    id: 'fenrir',
    title: 'Fenrir le Loup',
    description: 'Le loup gigantesque, fils de Loki, destiné à dévorer Odin lors du Ragnarök.',
    tags: ['Fenrir', 'Loki', 'Odin', 'Ragnarök'],
  ),
  ..._createCardVersions(
    id: 'tyr',
    title: 'Týr le Sacrifié',
    description: 'Le dieu de la guerre et de la justice, qui sacrifia sa main pour enchaîner Fenrir.',
    tags: ['Tyr', 'Fenrir'],
  ),
  ..._createCardVersions(
    id: 'gleipnir',
    title: 'Gleipnir',
    description: 'La chaîne magique, fine comme un ruban, forgée par les nains pour lier Fenrir.',
    tags: ['Gleipnir', 'Fenrir'],
  ),
  ..._createCardVersions(
    id: 'ymir',
    title: 'Ymir le Géant Primordial',
    description: 'Le premier être vivant, dont le corps a servi à créer le monde.',
    tags: ['Ymir'],
  ),
  ..._createCardVersions(
    id: 'audhumla',
    title: 'Audhumla la Vache Cosmique',
    description: 'La vache primordiale qui nourrit Ymir et révéla Buri, l’ancêtre des dieux.',
    tags: ['Audhumla', 'Ymir', 'Buri'],
  ),
  ..._createCardVersions(
    id: 'ginnungagap',
    title: 'Le Ginnungagap',
    description: 'Le vide béant primordial d’où toute la création a émergé.',
    tags: ['Ginnungagap'],
  ),
  ..._createCardVersions(
    id: 'sif',
    title: 'Sif aux Cheveux d’Or',
    description: 'Déesse de la fertilité et épouse de Thor, célèbre pour sa magnifique chevelure dorée.',
    tags: ['Sif', 'Thor'],
  ),
  ..._createCardVersions(
    id: 'brokkr_sindri',
    title: 'Brokkr et Sindri',
    description: 'Les nains forgerons qui créèrent les plus grands trésors des dieux, dont Mjöllnir.',
    tags: ['Brokkr', 'Sindri', 'Mjöllnir'],
  ),
  ..._createCardVersions(
    id: 'draupnir',
    title: 'Draupnir l’Anneau',
    description: 'L’anneau magique d’Odin, capable de produire huit autres anneaux d’or toutes les neuf nuits.',
    tags: ['Draupnir', 'Odin'],
  ),
  ..._createCardVersions(
    id: 'gungnir',
    title: 'Gungnir la Lance',
    description: 'La lance d’Odin qui ne manque jamais sa cible, symbole de son pouvoir et de sa sagesse.',
    tags: ['Gungnir', 'Odin'],
  ),
  ..._createCardVersions(
    id: 'hrimthurs',
    title: 'Hrimthurs le Bâtisseur',
    description: 'Le géant qui proposa de construire la muraille d’Asgard en échange de Freyja, du soleil et de la lune.',
    tags: ['Hrimthurs', 'Freyja', 'Asgard'],
  ),
  ..._createCardVersions(
    id: 'svadilfari',
    title: 'Svadilfari le Cheval',
    description: 'Le cheval magique de Hrimthurs, dont la vitesse et la force aidèrent à la construction de la muraille.',
    tags: ['Svadilfari', 'Hrimthurs'],
  ),
  ..._createCardVersions(
    id: 'sleipnir',
    title: 'Sleipnir le Cheval à Huit Pattes',
    description: 'Le cheval d’Odin, né de l’union de Loki transformé en jument et de Svadilfari.',
    tags: ['Sleipnir', 'Odin', 'Loki', 'Svadilfari'],
  ),
  // New cards to be added
  ..._createCardVersions(
    id: 'bifrost',
    title: 'Bifrost',
    description: 'Le pont arc-en-ciel qui relie Midgard à Asgard, gardé par Heimdall.',
    tags: ['Bifrost', 'Asgard', 'Heimdall'],
  ),
  ..._createCardVersions(id: 'bragi', title: 'Bragi', description: 'Le dieu de la poésie et de l’éloquence, époux d’Idunn.', tags: ['Bragi', 'Idunn']),
  ..._createCardVersions(
    id: 'brisingamen',
    title: 'Brisingamen',
    description: 'Le collier magique de Freyja, symbole de sa beauté et de son pouvoir.',
    tags: ['Brisingamen', 'Freyja'],
  ),
  ..._createCardVersions(
    id: 'freyja',
    title: 'Freyja',
    description:
        'Déesse de l’amour, de la beauté, de la fertilité, de la guerre et de la mort. Elle accueille la moitié des guerriers morts au combat dans son palais, Folkvangr.',
    tags: ['Freyja', 'Folkvangr'],
  ),
  ..._createCardVersions(
    id: 'gjallarhorn',
    title: 'Gjallarhorn',
    description: 'La corne de Heimdall, dont le son annoncera le début du Ragnarök.',
    tags: ['Gjallarhorn', 'Heimdall', 'Ragnarök'],
  ),
  ..._createCardVersions(
    id: 'heimdall',
    title: 'Heimdall',
    description: 'Le gardien d’Asgard et du Bifrost, doté d’une ouïe et d’une vue exceptionnelles.',
    tags: ['Heimdall', 'Asgard', 'Bifrost'],
  ),
  ..._createCardVersions(id: 'hel', title: 'Hel', description: 'La déesse du royaume des morts, Helheim, fille de Loki.', tags: ['Hel', 'Helheim', 'Loki']),
  ..._createCardVersions(
    id: 'helheim',
    title: 'Helheim',
    description: 'Le royaume des morts, gouverné par la déesse Hel, où vont ceux qui ne sont pas morts au combat.',
    tags: ['Helheim', 'Hel'],
  ),
  ..._createCardVersions(id: 'hofund', title: 'Hofund', description: 'L’épée de Heimdall, brillante et puissante.', tags: ['Hofund', 'Heimdall']),
  ..._createCardVersions(
    id: 'huginnmuninn',
    title: 'Huginn et Muninn',
    description: 'Les deux corbeaux d’Odin, qui parcourent le monde et lui rapportent tout ce qu’ils voient et entendent.',
    tags: ['Huginn', 'Muninn', 'Odin'],
  ),
  ..._createCardVersions(
    id: 'idunn',
    title: 'Idunn',
    description: 'La déesse qui garde les pommes d’or, source de jeunesse éternelle pour les dieux.',
    tags: ['Idunn', 'Pommes d’or'],
  ),
  ..._createCardVersions(
    id: 'jormungandr',
    title: 'Jörmungandr',
    description: 'Le serpent de Midgard, fils de Loki, si grand qu’il encercle le monde et se mord la queue.',
    tags: ['Jörmungandr', 'Loki', 'Midgard'],
  ),
  ..._createCardVersions(
    id: 'loki',
    title: 'Loki',
    description: 'Le dieu de la discorde, de la ruse et de la malice, souvent à l’origine des problèmes des dieux.',
    tags: ['Loki'],
  ),
  ..._createCardVersions(
    id: 'njord',
    title: 'Njord',
    description: 'Le dieu de la mer, des vents et de la fertilité, père de Freyja et Freyr.',
    tags: ['Njord', 'Freyja', 'Freyr'],
  ),
  ..._createCardVersions(
    id: 'odin',
    title: 'Odin',
    description: 'Le Père de Tout, dieu suprême d’Asgard, de la sagesse, de la guerre et de la poésie.',
    tags: ['Odin', 'Asgard'],
  ),
  ..._createCardVersions(
    id: 'skadi',
    title: 'Skadi',
    description: 'La déesse géante de la chasse, de l’hiver et des montagnes, épouse de Njord.',
    tags: ['Skadi', 'Njord'],
  ),
  ..._createCardVersions(
    id: 'yggdrasil',
    title: 'Yggdrasil',
    description: 'L’Arbre Monde, un frêne gigantesque qui relie les neuf mondes de la mythologie nordique.',
    tags: ['Yggdrasil', 'Neuf Mondes'],
  ),
];

List<CollectibleCard> getCollectibleCards() {
  return allCollectibleCards;
}
