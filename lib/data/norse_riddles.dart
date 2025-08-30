/// Represents a single enigma from Norse mythology.
class NorseRiddle {
  /// The name of the god, creature, or object. The answer to the riddle.
  final String name;

  /// A list of short, enigmatic definitions or clues.
  final List<String> clues;

  const NorseRiddle({required this.name, required this.clues});
}

/// A comprehensive list of riddles from Norse mythology,
/// sorted by the length of the answer's name.
const List<NorseRiddle> norseRiddles = [
  // 3 Letters
  NorseRiddle(
    name: 'TYR',
    clues: [
      'J’ai sacrifié ma main pour enchaîner un loup.',
      'Je suis le dieu manchot de la justice et de la guerre héroïque.',
      'Mon nom est synonyme de courage.',
    ],
  ),
  // 4 Letters
  NorseRiddle(
    name: 'ODIN',
    clues: [
      'J’ai échangé un œil contre la sagesse.',
      'Mes deux corbeaux parcourent le monde pour m’informer.',
      'Je suis le Père de Tout, régnant depuis Asgard.',
    ],
  ),
  NorseRiddle(
    name: 'THOR',
    clues: ['Mon char est tiré par des boucs.', 'Je suis le protecteur de Midgard et le fils d’Odin.', 'Le tonnerre gronde quand je lance mon marteau.'],
  ),
  NorseRiddle(
    name: 'LOKI',
    clues: ['Je suis le père de monstres et le maître de la tromperie.', 'Mon sang s’est mêlé à celui d’Odin.', 'Je change de forme comme je change d’avis.'],
  ),
  // 5 Letters
  NorseRiddle(
    name: 'FREYA',
    clues: [
      'Je pleure des larmes d’or pour mon époux parti.',
      'Je règne sur le Fólkvangr et reçois la moitié des guerriers morts.',
      'Mon collier, Brísingamen, est le plus beau des trésors.',
    ],
  ),
  NorseRiddle(
    name: 'FRIGG',
    clues: [
      'Je connais le destin de tous, mais je garde le silence.',
      'Je suis l’épouse d’Odin et la reine d’Asgard.',
      'J’ai pleuré la mort de mon fils lumineux.',
    ],
  ),
  // 6 Letters
  NorseRiddle(
    name: 'FENRIR',
    clues: [
      'Ma mâchoire, une fois ouverte, touche le ciel et la terre.',
      'Les dieux m’ont enchaîné par la ruse avec un ruban de soie.',
      'Je dévorerai Odin lors de la dernière bataille.',
    ],
  ),
  NorseRiddle(
    name: 'ASGARD',
    clues: ['Je suis la forteresse des dieux Ases.', 'Mes murs ont été construits par un géant et son cheval.', 'Le pont arc-en-ciel mène à mes portes.'],
  ),
  NorseRiddle(
    name: 'HUGINN',
    clues: ['Chaque matin, je pars pour ne revenir qu’au soir.', 'Je suis la Pensée qui vole pour le Père de Tout.', 'Mon frère est la Mémoire.'],
  ),
  // 7 Letters
  NorseRiddle(
    name: 'BIFROST',
    clues: [
      'Je suis un pont de feu gardé par un dieu vigilant.',
      'Mes trois couleurs relient le monde des hommes à celui des dieux.',
      'Je me briserai sous le poids des géants à la fin des temps.',
    ],
  ),
  NorseRiddle(
    name: 'MJOLNIR',
    clues: ['Je reviens toujours à la main de mon maître.', 'Mon vol dans le ciel est le son du tonnerre.', 'Je suis le broyeur, terreur des géants.'],
  ),
  NorseRiddle(
    name: 'MIDGARD',
    clues: ['Je suis le royaume des mortels.', 'Un serpent géant entoure mes côtes.', 'Je suis protégé par le fils d’Odin au marteau.'],
  ),
  NorseRiddle(
    name: 'VALHALLA',
    clues: [
      'Mon toit est couvert de boucliers dorés.',
      'Ici, les guerriers d’élite festoient et combattent chaque jour.',
      'Je suis le grand hall d’Odin pour les morts valeureux.',
    ],
  ),
  // 8 Letters
  NorseRiddle(
    name: 'GUNGNIR',
    clues: [
      'Je suis la lance qui ne manque jamais sa cible.',
      'Mon propriétaire s’est pendu à un arbre avec moi dans le flanc.',
      'Un serment prêté sur ma pointe est inviolable.',
    ],
  ),
  NorseRiddle(
    name: 'RAGNAROK',
    clues: [
      'Je suis le crépuscule des dieux.',
      'Le soleil deviendra noir et la terre sombrera dans la mer.',
      'Je suis une fin, mais aussi un nouveau commencement.',
    ],
  ),
  // 9 Letters
  NorseRiddle(
    name: 'YGGDRASIL',
    clues: ['Mes racines unissent trois mondes.', 'Je suis l’Arbre du Monde, un frêne éternel.', 'Un aigle, un écureuil et un dragon vivent en moi.'],
  ),
  NorseRiddle(
    name: 'VALKYRIES',
    clues: [
      'Nous chevauchons les cieux, choisissant les morts au combat.',
      'Nous servons Odin, portant les héros au Valhalla.',
      'Nos noms résonnent sur les champs de bataille.',
    ],
  ),
  NorseRiddle(
    name: 'JOTUNHEIM',
    clues: [
      'Je suis le royaume des géants, au-delà de Midgard.',
      'Mes montagnes sont froides et mes habitants redoutables.',
      'C’est ici que Thor vient souvent chercher querelle.',
    ],
  ),
  // 10 Letters
  NorseRiddle(
    name: 'NIDAVELLIR',
    clues: [
      'Mes forges résonnent des coups de marteau.',
      'Je suis le royaume souterrain des artisans du métal.',
      'C’est ici que naissent les plus grands trésors des dieux.',
      'Mes habitants fuient la lumière du soleil.',
    ],
  ),
  NorseRiddle(
    name: 'HVERGELMIR',
    clues: [
      'Je suis la source de toutes les rivières, au cœur de Niflheim.',
      'Mon chaudron bouillonne, et mes eaux gèlent tout sur leur passage.',
      'C’est de moi que naissent les onze fleuves d’Élivágar.',
    ],
  ),
  // 11 Letters
  NorseRiddle(
    name: 'GJALLARHORN',
    clues: [
      'Mon son peut être entendu dans tous les mondes.',
      'Je suis la corne d’alarme du gardien du Bifrost.',
      'J’annoncerai le début de la bataille finale.',
    ],
  ),
  NorseRiddle(
    name: 'JORMUNGANDR',
    clues: [
      'Je suis si grand que j’encercle le monde des hommes.',
      'Je suis le Serpent de Midgard, enfant de Loki.',
      'Mon ennemi juré est le dieu du tonnerre.',
    ],
  ),
];
