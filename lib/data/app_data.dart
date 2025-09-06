
import 'package:flutter/material.dart';
import '../models/deity.dart';
import '../models/question.dart';
import '../models/answer.dart';

class AppData {
  static const Map<String, Deity> deities = {
    'odin': Deity(
      id: 'odin',
      name: 'Odin',
      title: 'Le Père de Tout',
      icon: 'assets/images/heads/odin.webp',
      traits: {'wisdom': 5, 'cunning': 4, 'honor': 3},
      description: 'Sage et rusé, tu cherches la connaissance avant tout. Comme Odin, tu es prêt à sacrifier pour comprendre les mystères du monde.',
      dailyChallenge: 'Apprends quelque chose de nouveau aujourd\'hui',
      colors: [Color(0xFF334155), Color(0xFF0F172A)],
    ),
    'thor': Deity(
      id: 'thor',
      name: 'Thor',
      title: 'Le Tonnerre',
      icon: 'assets/images/heads/thor.webp',
      traits: {'courage': 5, 'strength': 5, 'honor': 4},
      description: 'Fort et courageux, tu protèges ceux qui t\'entourent. Comme Thor, tu affrontes les défis de front avec détermination.',
      dailyChallenge: 'Aide quelqu\'un dans le besoin aujourd\'hui',
      colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
    ),
    'freya': Deity(
      id: 'freya',
      name: 'Freyja',
      title: 'Dame de l\'Amour',
      icon: 'assets/images/heads/freya.webp',
      traits: {'passion': 5, 'wisdom': 3, 'nature': 4},
      description: 'Passionnée et intuitive, tu suis ton cœur. Comme Freyja, tu apportes beauté et amour dans le monde.',
      dailyChallenge: 'Exprime ta gratitude à quelqu’un',
      colors: [Color(0xFFDB2777), Color(0xFFBE185D)],
    ),
    'tyr': Deity(
      id: 'tyr',
      name: 'Týr',
      title: 'Le Juste',
      icon: 'assets/images/heads/tyr.webp',
      traits: {'justice': 5, 'honor': 5, 'courage': 3},
      description: 'Droit et honorable, tu défends la justice. Comme Týr, tu sacrifie pour ce qui est juste, même à grands frais.',
      dailyChallenge: 'Défends ce qui est juste aujourd\'hui',
      colors: [Color(0xFFD97706), Color(0xFFB45309)],
    ),
    'loki': Deity(
      id: 'loki',
      name: 'Loki',
      title: 'Le Changeur de Forme',
      icon: 'assets/images/heads/loki.webp',
      traits: {'cunning': 5, 'passion': 3, 'wisdom': 2},
      description: 'Créatif et imprévisible, tu trouves des solutions uniques. Comme Loki, tu remets en question l\'ordre établi.',
      dailyChallenge: 'Trouve une solution créative à un problème',
      colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
    ),
    'frigg': Deity(
      id: 'frigg',
      name: 'Frigg',
      title: 'La Protectrice',
      icon: 'assets/images/heads/frigg.webp',
      traits: {'wisdom': 4, 'honor': 4, 'nature': 3},
      description: 'Sage et protectrice, tu veilles sur ton entourage. Comme Frigg, tu anticipes et préviens les dangers.',
      dailyChallenge: 'Prends soin de ta famille ou tes proches',
      colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
    ),
    'bjorn': Deity(
      id: 'bjorn',
      name: 'Bjorn',
      title: "l'Ours des Glaces",
      icon: 'assets/images/heads/bjorn.webp',
      traits: {'strength': 5, 'courage': 4, 'honor': 3},
      description: "Ta force est légendaire, aussi implacable qu'une avalanche. Tu protèges ton clan avec une férocité silencieuse, et ta loyauté est le roc sur lequel tes alliés bâtissent leur confiance.",
      dailyChallenge: "Protège quelqu'un ou quelque chose aujourd'hui.",
      colors: [Color(0xFFD97706), Color(0xFFB45309)],
    ),
    'astrid': Deity(
      id: 'astrid',
      name: 'Astrid',
      title: "la Visionnaire Étoilée",
      icon: 'assets/images/heads/astrid.webp',
      traits: {'wisdom': 5, 'cunning': 3, 'nature': 2},
      description: "Tu lis l'avenir dans les étoiles et les runes. Tes conseils sont recherchés par les rois et les jarls, car tu vois les fils du destin que d'autres ignorent.",
      dailyChallenge: "Fais confiance à ton intuition pour prendre une décision.",
      colors: [Color(0xFF334155), Color(0xFF0F172A)],
    ),
    'ragnar': Deity(
      id: 'ragnar',
      name: 'Ragnar',
      title: "le Corbeau Rusé",
      icon: 'assets/images/heads/ragnar.webp',
      traits: {'cunning': 5, 'wisdom': 4, 'courage': 2},
      description: "Ton esprit est aussi vif que ta hache. Tu excelles dans la stratégie et la tromperie, utilisant l'intelligence comme ta meilleure arme pour déjouer tes ennemis.",
      dailyChallenge: "Planifie ta journée avec une étape d'avance.",
      colors: [Color(0xFFDAA520), Color(0xFFB8860B)],
    ),
    'ingrid': Deity(
      id: 'ingrid',
      name: 'Ingrid',
      title: "la Jarl au Cœur Noble",
      icon: 'assets/images/heads/ingrid.webp',
      traits: {'honor': 5, 'justice': 4, 'wisdom': 3},
      description: "Tu commandes avec sagesse et justice. Ton peuple te suit non par peur, mais par respect et amour, car tu incarnes l'honneur et le leadership.",
      dailyChallenge: "Prends une décision juste, même si elle est difficile.",
      colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
    ),
    'sven': Deity(
      id: 'sven',
      name: 'Sven',
      title: "l'Explorateur des Mers",
      icon: 'assets/images/heads/sven.webp',
      traits: {'courage': 5, 'nature': 4, 'strength': 3},
      description: "L'horizon est ta seule véritable maison. Tu as navigué sur des eaux inconnues et bravé des tempêtes monstrueuses, ton âme brûlant du désir de découvrir ce qui se trouve au-delà des cartes.",
      dailyChallenge: "Explore un nouvel endroit ou une nouvelle idée.",
      colors: [Color(0xFFDB2777), Color(0xFFBE185D)],
    ),
    'freydis': Deity(
      id: 'freydis',
      name: 'Freydis',
      title: "la Hache Intrépide",
      icon: 'assets/images/heads/freydis.webp',
      traits: {'courage': 5, 'strength': 4, 'passion': 3},
      description: "Tu es une skjaldmö, une guerrière au bouclier dont le courage inspire les chants. Tu ne recules devant aucun combat et traces ton propre chemin avec une détermination de fer.",
      dailyChallenge: "Affronte une de tes peurs, même petite.",
      colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
    ),
  };

  static const List<Question> questions = [
    Question(
      question: 'Face à un défi important, ta première réaction est :',
      answers: [
        Answer(text: 'Chercher des informations avant d\'agir', scores: {'wisdom': 2}),
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
        Answer(text: 'Terrain de défis et d\'aventures', scores: {'strength': 1, 'courage': 1}),
        Answer(text: 'Inspiration pour créativité et passion', scores: {'passion': 2, 'nature': 1}),
        Answer(text: 'Rappel de l\'ordre naturel des choses', scores: {'honor': 1, 'justice': 1}),
      ],
    ),
    Question(
      question: 'Ta plus grande peur serait :',
      answers: [
        Answer(text: 'Rester dans l\'ignorance', scores: {'wisdom': 2}),
        Answer(text: 'Être lâche face au danger', scores: {'courage': 2}),
        Answer(text: 'Perdre ta liberté créative', scores: {'cunning': 1, 'passion': 1}),
        Answer(text: 'Trahir tes principes', scores: {'honor': 2, 'justice': 1}),
      ],
    ),
    Question(
      question: 'Ton approche de l\'amour et des relations :',
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
