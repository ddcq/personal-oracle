import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/models/deity.dart';
import 'package:oracle_d_asgard/models/question.dart';
import 'package:oracle_d_asgard/models/answer.dart';

class AppData {
  static const Map<String, Deity> deities = {
    'odin': Deity(
      id: 'odin',
      name: 'Odin',
      title: 'Le Père de Tout',
      icon: 'assets/images/heads/odin.webp',
      traits: {'wisdom': 5, 'cunning': 4, 'honor': 3},
      description: 'Sage et rusé, tu cherches la connaissance avant tout. Comme Odin, tu es prêt à sacrifier pour comprendre les mystères du monde.',
      colors: [Color(0xFF334155), Color(0xFF0F172A)],
    ),
    'thor': Deity(
      id: 'thor',
      name: 'Thor',
      title: 'Le Tonnerre',
      icon: 'assets/images/heads/thor.webp',
      traits: {'courage': 5, 'strength': 5, 'honor': 4},
      description: 'Fort et courageux, tu protèges ceux qui t’entourent. Comme Thor, tu affrontes les défis de front avec détermination.',
      colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
    ),
    'freya': Deity(
      id: 'freya',
      name: 'Freyja',
      title: 'Dame de l’Amour',
      icon: 'assets/images/heads/freya.webp',
      traits: {'passion': 5, 'wisdom': 3, 'nature': 4},
      description: 'Passionnée et intuitive, tu suis ton cœur. Comme Freyja, tu apportes beauté et amour dans le monde.',
      colors: [Color(0xFFDB2777), Color(0xFFBE185D)],
    ),
    'tyr': Deity(
      id: 'tyr',
      name: 'Týr',
      title: 'Le Juste',
      icon: 'assets/images/heads/tyr.webp',
      traits: {'justice': 5, 'honor': 5, 'courage': 3},
      description: 'Droit et honorable, tu défends la justice. Comme Týr, tu sacrifies pour ce qui est juste, même à grands frais.',
      colors: [Color(0xFFD97706), Color(0xFFB45309)],
    ),
    'loki': Deity(
      id: 'loki',
      name: 'Loki',
      title: 'Le Changeur de Forme',
      icon: 'assets/images/heads/loki.webp',
      traits: {'cunning': 5, 'passion': 3, 'wisdom': 2},
      description: 'Créatif et imprévisible, tu trouves des solutions uniques. Comme Loki, tu remets en question l’ordre établi.',
      colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
    ),
    'frigg': Deity(
      id: 'frigg',
      name: 'Frigg',
      title: 'La Protectrice',
      icon: 'assets/images/heads/frigg.webp',
      traits: {'wisdom': 4, 'honor': 4, 'nature': 3},
      description: 'Sage et protectrice, tu veilles sur ton entourage. Comme Frigg, tu anticipes et préviens les dangers.',
      colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
    ),
    'bjorn': Deity(
      id: 'bjorn',
      name: 'Bjorn',
      title: 'l’Ours des Glaces',
      icon: 'assets/images/heads/bjorn.webp',
      traits: {'strength': 5, 'courage': 4, 'honor': 3},
      description:
          'Ta force est légendaire, aussi implacable qu’une avalanche. Tu protèges ton clan avec une férocité silencieuse, et ta loyauté est le roc sur lequel tes alliés bâtissent leur confiance.',
      colors: [Color(0xFFD97706), Color(0xFFB45309)],
    ),
    'astrid': Deity(
      id: 'astrid',
      name: 'Astrid',
      title: 'la Visionnaire Étoilée',
      icon: 'assets/images/heads/astrid.webp',
      traits: {'wisdom': 5, 'cunning': 3, 'nature': 2},
      description:
          'Tu lis l’avenir dans les étoiles et les runes. Tes conseils sont recherchés par les rois et les jarls, car tu vois les fils du destin que d’autres ignorent.',
      colors: [Color(0xFF334155), Color(0xFF0F172A)],
    ),
    'ragnar': Deity(
      id: 'ragnar',
      name: 'Ragnar',
      title: 'le Corbeau Rusé',
      icon: 'assets/images/heads/ragnar.webp',
      traits: {'cunning': 5, 'wisdom': 4, 'courage': 2},
      description:
          'Ton esprit est aussi vif que ta hache. Tu excelles dans la stratégie et la tromperie, utilisant l’intelligence comme ta meilleure arme pour déjouer tes ennemis.',
      colors: [Color(0xFFDAA520), Color(0xFFB8860B)],
    ),
    'ingrid': Deity(
      id: 'ingrid',
      name: 'Ingrid',
      title: 'la Jarl au Cœur Noble',
      icon: 'assets/images/heads/ingrid.webp',
      traits: {'honor': 5, 'justice': 4, 'wisdom': 3},
      description:
          'Tu commandes avec sagesse et justice. Ton peuple te suit non par peur, mais par respect et amour, car tu incarnes l’honneur et le leadership.',
      colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
    ),
    'sven': Deity(
      id: 'sven',
      name: 'Sven',
      title: 'l’Explorateur des Mers',
      icon: 'assets/images/heads/sven.webp',
      traits: {'courage': 5, 'nature': 4, 'strength': 3},
      description:
          'L’horizon est ta seule véritable maison. Tu as navigué sur des eaux inconnues et bravé des tempêtes monstrueuses, ton âme brûlant du désir de découvrir ce qui se trouve au-delà des cartes.',
      colors: [Color(0xFFDB2777), Color(0xFFBE185D)],
    ),
    'freydis': Deity(
      id: 'freydis',
      name: 'Freydis',
      title: 'la Hache Intrépide',
      icon: 'assets/images/heads/freydis.webp',
      traits: {'courage': 5, 'strength': 4, 'passion': 3},
      description:
          'Tu es une skjaldmö, une guerrière au bouclier dont le courage inspire les chants. Tu ne recules devant aucun combat et traces ton propre chemin avec une détermination de fer.',
      colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
    ),
    'audhumla': Deity(
      id: 'audhumla',
      name: 'Audhumla',
      title: 'La Vache Cosmique',
      icon: 'assets/images/cards/chibi/audhumla.webp',
      traits: {'nature': 5, 'wisdom': 3, 'strength': 2},
      description: 'Tu es la source de toute vie, nourrissant le monde de ton essence. Comme Audhumla, tu es patient et généreux, un pilier de la création.',
      colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
    ),
    'baldr': Deity(
      id: 'baldr',
      name: 'Baldr',
      title: 'Le Dieu Lumineux',
      icon: 'assets/images/cards/chibi/baldr.webp',
      traits: {'honor': 5, 'passion': 4, 'wisdom': 3},
      description:
          'Pur et aimé de tous, tu incarnes la lumière et la beauté. Comme Baldr, ta présence apporte joie et harmonie, mais tu es aussi vulnérable aux forces obscures.',
      colors: [Color(0xFFFFD700), Color(0xFFDAA520)],
    ),
    'bragi': Deity(
      id: 'bragi',
      name: 'Bragi',
      title: 'Le Poète Divin',
      icon: 'assets/images/cards/chibi/bragi.webp',
      traits: {'cunning': 4, 'passion': 5, 'wisdom': 3},
      description:
          'Maître des mots et de la musique, tu inspires et émeus les cœurs. Comme Bragi, tu utilises l’art pour raconter des histoires et célébrer la vie.',
      colors: [Color(0xFFA0522D)],
    ),
    'fenrir': Deity(
      id: 'fenrir',
      name: 'Fenrir',
      title: 'Le Loup Inchaîné',
      icon: 'assets/images/cards/chibi/fenrir.webp',
      traits: {'strength': 5, 'cunning': 4, 'courage': 3},
      description: 'Puissant et indomptable, tu représentes la force brute et la liberté. Comme Fenrir, tu es une force de la nature, difficile à contenir.',
      colors: [Color(0xFF212121)],
    ),
    'heimdall': Deity(
      id: 'heimdall',
      name: 'Heimdall',
      title: 'Le Gardien des Ponts',
      icon: 'assets/images/cards/chibi/heimdall.webp',
      traits: {'wisdom': 5, 'honor': 4, 'courage': 3},
      description: 'Vigilant et perspicace, tu es le protecteur des royaumes. Comme Heimdall, tu as une perception aiguë et une loyauté inébranlable.',
      colors: [Color(0xFF1565C0)],
    ),
    'hel': Deity(
      id: 'hel',
      name: 'Hel',
      title: 'La Souveraine des Morts',
      icon: 'assets/images/cards/chibi/hel.webp',
      traits: {'cunning': 5, 'justice': 4, 'wisdom': 3},
      description:
          'Juste et impartiale, tu régnes sur le royaume des défunts. Comme Hel, tu acceptes la dualité de la vie et de la mort, et tu traites chacun avec équité.',
      colors: [Color(0xFF455A64)],
    ),
    'hrimthurs': Deity(
      id: 'hrimthurs',
      name: 'Hrimthurs',
      title: 'Le Géant de Givre',
      icon: 'assets/images/cards/chibi/hrimthurs.webp',
      traits: {'strength': 5, 'nature': 4, 'courage': 3},
      description:
          'Imposant et ancien, tu es une force primordiale de la nature. Comme Hrimthurs, tu es résistant et inébranlable, représentant la puissance des éléments.',
      colors: [Color(0xFF64B5F6)],
    ),
    'idunn': Deity(
      id: 'idunn',
      name: 'Idunn',
      title: 'La Gardienne des Pommes',
      icon: 'assets/images/cards/chibi/idunn.webp',
      traits: {'nature': 5, 'passion': 4, 'wisdom': 3},
      description:
          'Source de jeunesse et de vitalité, tu maintiens l’équilibre de la vie. Comme Idunn, tu es généreux et bienveillant, apportant renouveau et fraîcheur.',
      colors: [Color(0xFF689F38)],
    ),
    'jormungandr': Deity(
      id: 'jormungandr',
      name: 'Jörmungandr',
      title: 'Le Serpent Monde',
      icon: 'assets/images/cards/chibi/jormungandr.webp',
      traits: {'strength': 5, 'cunning': 4, 'nature': 3},
      description:
          'Immense et mystérieux, tu encercles le monde, une force inéluctable. Comme Jörmungandr, tu es une présence puissante et silencieuse, gardien des profondeurs.',
      colors: [Color(0xFF303F9F)],
    ),
    'njord': Deity(
      id: 'njord',
      name: 'Njord',
      title: 'Le Dieu des Mers et des Vents',
      icon: 'assets/images/cards/chibi/njord.webp',
      traits: {'nature': 5, 'wisdom': 4, 'passion': 3},
      description:
          'Calme et généreux, tu maîtrises les océans et apportes la prospérité. Comme Njord, tu es une force apaisante, mais aussi puissante et imprévisible.',
      colors: [Color(0xFF0097A7)],
    ),
    'sif': Deity(
      id: 'sif',
      name: 'Sif',
      title: 'La Déesse aux Cheveux d’Or',
      icon: 'assets/images/cards/chibi/sif.webp',
      traits: {'nature': 4, 'honor': 3, 'passion': 2},
      description:
          'Belle et fertile, tu symbolises l’abondance et la récolte. Comme Sif, tu es une source de vie et de prospérité, apportant la richesse à ceux qui t’entourent.',
      colors: [Color(0xFFFFA000)],
    ),
    'skadi': Deity(
      id: 'skadi',
      name: 'Skadi',
      title: 'La Déesse Chasseresse',
      icon: 'assets/images/cards/chibi/skadi.webp',
      traits: {'nature': 5, 'courage': 4, 'strength': 3},
      description:
          'Indépendante et sauvage, tu es la maîtresse des montagnes et des hivers. Comme Skadi, tu es résiliente et déterminée, préférant la liberté des grands espaces.',
      colors: [Color(0xFF455A64)],
    ),
    'sleipnir': Deity(
      id: 'sleipnir',
      name: 'Sleipnir',
      title: 'Le Cheval à Huit Pattes',
      icon: 'assets/images/cards/chibi/sleipnir.webp',
      traits: {'cunning': 4, 'strength': 5, 'nature': 3},
      description:
          'Rapide et loyal, tu es le plus noble des destriers, capable de traverser les mondes. Comme Sleipnir, tu es un compagnon fiable et un guide sûr.',
      colors: [Color(0xFF616161)],
    ),
    'svadilfari': Deity(
      id: 'svadilfari',
      name: 'Svadilfari',
      title: 'Le Cheval Bâtisseur',
      icon: 'assets/images/cards/chibi/svadilfari.webp',
      traits: {'strength': 5, 'cunning': 4, 'nature': 3},
      description:
          'Puissant et infatigable, tu es capable de réaliser des exploits de construction. Comme Svadilfari, tu es un travailleur acharné et un bâtisseur de l’impossible.',
      colors: [Color(0xFF5D4037)],
    ),
    'thrym': Deity(
      id: 'thrym',
      name: 'Thrym',
      title: 'Le Roi des Géants',
      icon: 'assets/images/cards/chibi/thrym.webp',
      traits: {'strength': 5, 'cunning': 4, 'passion': 3},
      description:
          'Puissant et exigeant, tu es un adversaire redoutable. Comme Thrym, tu es une force à ne pas sous-estimer, capable de défier même les dieux.',
      colors: [Color(0xFF424242)],
    ),
    'ymir': Deity(
      id: 'ymir',
      name: 'Ymir',
      title: 'Le Géant Primordial',
      icon: 'assets/images/cards/chibi/ymir.webp',
      traits: {'strength': 5, 'nature': 5, 'wisdom': 3},
      description:
          'Ancien et colossal, tu es l’origine de toute existence. Comme Ymir, tu es une force fondamentale, un pilier du monde, dont la présence est immense et silencieuse.',
      colors: [Color(0xFF263238), Color(0xFF212121)],
    ),
  };

  static const List<Question> questions = [
    Question(
      question: 'Face à un défi important, ta première réaction est :',
      answers: [
        Answer(text: 'Chercher des informations avant d’agir', scores: {'wisdom': 2}),
        Answer(text: 'Foncer tête baissée', scores: {'courage': 2, 'strength': 1}),
        Answer(text: 'Trouver une approche créative', scores: {'cunning': 2}),
        Answer(text: 'Rassembler les autres pour agir ensemble', scores: {'honor': 1, 'justice': 1}),
      ],
    ),
    Question(
      question: 'Ta plus grande force est :',
      answers: [
        Answer(text: 'Ta capacité à comprendre les situations complexes', scores: {'wisdom': 2, 'cunning': 1}),
        Answer(text: 'Ta détermination face aux obstacles', scores: {'strength': 2, 'courage': 1}),
        Answer(text: 'Ton empathie et ta connexion aux autres', scores: {'passion': 2, 'nature': 1}),
        Answer(text: 'Ton sens moral inébranlable', scores: {'justice': 2, 'honor': 1}),
      ],
    ),
    Question(
      question: 'Dans un groupe, tu es souvent :',
      answers: [
        Answer(text: 'Le conseiller sage qui écoute', scores: {'wisdom': 2}),
        Answer(text: 'Le leader qui prend les décisions', scores: {'courage': 1, 'honor': 1}),
        Answer(text: 'Celui qui apporte créativité et nouveauté', scores: {'cunning': 1, 'passion': 1}),
        Answer(text: 'Le médiateur qui résout les conflits', scores: {'justice': 2}),
      ],
    ),
    Question(
      question: 'Ta relation à la nature est :',
      answers: [
        Answer(text: 'Source de réflexion et de sagesse', scores: {'wisdom': 1, 'nature': 2}),
        Answer(text: 'Terrain de défis et d’aventures', scores: {'strength': 1, 'courage': 1}),
        Answer(text: 'Inspiration pour créativité et passion', scores: {'passion': 2, 'nature': 1}),
        Answer(text: 'Rappel de l’ordre naturel des choses', scores: {'honor': 1, 'justice': 1}),
      ],
    ),
    Question(
      question: 'Ta plus grande peur serait :',
      answers: [
        Answer(text: 'Rester dans l’ignorance', scores: {'wisdom': 2}),
        Answer(text: 'Être lâche face au danger', scores: {'courage': 2}),
        Answer(text: 'Perdre ta liberté créative', scores: {'cunning': 1, 'passion': 1}),
        Answer(text: 'Trahir tes principes', scores: {'honor': 2, 'justice': 1}),
      ],
    ),
    Question(
      question: 'Ton approche de l’amour et des relations :',
      answers: [
        Answer(text: 'Profonde et réfléchie, basée sur la compréhension', scores: {'wisdom': 1, 'honor': 1}),
        Answer(text: 'Protectrice et loyale envers ceux que tu aimes', scores: {'strength': 1, 'honor': 1}),
        Answer(text: 'Passionnée et intense', scores: {'passion': 2, 'nature': 1}),
        Answer(text: 'Équitable et respectueuse', scores: {'justice': 2}),
      ],
    ),
    Question(
      question: 'Quel rôle préfères-tu dans un travail de groupe ?',
      answers: [
        Answer(text: 'Leader stratégique', scores: {'wisdom': 2, 'honor': 1}),
        Answer(text: 'Celui qui motive tout le monde', scores: {'courage': 2, 'passion': 1}),
        Answer(text: 'Le créatif qui casse les codes', scores: {'cunning': 2, 'passion': 1}),
        Answer(text: 'Celui qui équilibre et apaise', scores: {'nature': 1, 'justice': 2}),
      ],
    ),
    Question(
      question: 'Quel environnement te ressemble le plus ?',
      answers: [
        Answer(text: 'Une bibliothèque silencieuse', scores: {'wisdom': 2, 'cunning': 1}),
        Answer(text: 'Une arène de combat', scores: {'strength': 2, 'courage': 1}),
        Answer(text: 'Une forêt enchantée', scores: {'nature': 2, 'passion': 1}),
        Answer(text: 'Une salle du trône', scores: {'honor': 1, 'justice': 2}),
      ],
    ),
    Question(
      question: 'Comment réagis-tu face à une injustice ?',
      answers: [
        Answer(text: 'Tu réfléchis puis agis avec sagesse', scores: {'wisdom': 2, 'justice': 1}),
        Answer(text: 'Tu protèges les plus faibles par la force', scores: {'strength': 2, 'honor': 1}),
        Answer(text: 'Tu manipules pour renverser la situation', scores: {'cunning': 2, 'justice': 1}),
        Answer(text: 'Tu t’indignes et cherches la paix', scores: {'passion': 2, 'nature': 1}),
      ],
    ),
    Question(
      question: 'Quel type de pouvoir préfèrerais-tu ?',
      answers: [
        Answer(text: 'Lire dans les pensées', scores: {'wisdom': 2, 'cunning': 1}),
        Answer(text: 'Devenir invincible', scores: {'strength': 2, 'courage': 1}),
        Answer(text: 'Voyager entre les mondes', scores: {'cunning': 1, 'nature': 2}),
        Answer(text: 'Apaiser les cœurs', scores: {'passion': 2, 'justice': 1}),
      ],
    ),
    Question(
      question: 'Si tu étais un héros de film, tu serais…',
      answers: [
        Answer(text: 'Le mentor mystérieux', scores: {'wisdom': 2, 'honor': 1}),
        Answer(text: 'Le guerrier loyal', scores: {'strength': 2, 'courage': 1}),
        Answer(text: 'Le trickster imprévisible', scores: {'cunning': 2, 'passion': 1}),
        Answer(text: 'La figure douce mais redoutable', scores: {'nature': 2, 'justice': 1}),
      ],
    ),
    Question(
      question: 'Quel type de défi t’attire le plus ?',
      answers: [
        Answer(text: 'Résoudre une énigme ancienne', scores: {'wisdom': 2, 'cunning': 1}),
        Answer(text: 'Affronter un dragon', scores: {'strength': 2, 'courage': 1}),
        Answer(text: 'Retourner une situation désespérée', scores: {'cunning': 2, 'honor': 1}),
        Answer(text: 'Réunir des ennemis autour d’une table', scores: {'justice': 2, 'passion': 1}),
      ],
    ),
  ];
}
