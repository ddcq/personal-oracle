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
      icon: Icons.visibility,
      traits: {'wisdom': 5, 'cunning': 4, 'honor': 3},
      description: 'Sage et rusé, vous cherchez la connaissance avant tout. Comme Odin, vous êtes prêt à sacrifier pour comprendre les mystères du monde.',
      dailyChallenge: 'Apprenez quelque chose de nouveau aujourd\'hui',
      colors: [Color(0xFF334155), Color(0xFF0F172A)],
    ),
    'thor': Deity(
      id: 'thor',
      name: 'Thor',
      title: 'Le Tonnerre',
      icon: Icons.flash_on,
      traits: {'courage': 5, 'strength': 5, 'honor': 4},
      description: 'Fort et courageux, vous protégez ceux qui vous entourent. Comme Thor, vous affrontez les défis de front avec détermination.',
      dailyChallenge: 'Aidez quelqu\'un dans le besoin aujourd\'hui',
      colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
    ),
    'freya': Deity(
      id: 'freya',
      name: 'Freyja',
      title: 'Dame de l\'Amour',
      icon: Icons.favorite,
      traits: {'passion': 5, 'wisdom': 3, 'nature': 4},
      description: 'Passionnée et intuitive, vous suivez votre cœur. Comme Freyja, vous apportez beauté et amour dans le monde.',
      dailyChallenge: 'Exprimez votre gratitude à quelqu\'un',
      colors: [Color(0xFFDB2777), Color(0xFFBE185D)],
    ),
    'tyr': Deity(
      id: 'tyr',
      name: 'Týr',
      title: 'Le Juste',
      icon: Icons.shield,
      traits: {'justice': 5, 'honor': 5, 'courage': 3},
      description: 'Droit et honorable, vous défendez la justice. Comme Týr, vous sacrifiez pour ce qui est juste, même à grands frais.',
      dailyChallenge: 'Défendez ce qui est juste aujourd\'hui',
      colors: [Color(0xFFD97706), Color(0xFFB45309)],
    ),
    'loki': Deity(
      id: 'loki',
      name: 'Loki',
      title: 'Le Changeur de Forme',
      icon: Icons.local_fire_department,
      traits: {'cunning': 5, 'passion': 3, 'wisdom': 2},
      description: 'Créatif et imprévisible, vous trouvez des solutions uniques. Comme Loki, vous remettez en question l\'ordre établi.',
      dailyChallenge: 'Trouvez une solution créative à un problème',
      colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
    ),
    'frigg': Deity(
      id: 'frigg',
      name: 'Frigg',
      title: 'La Protectrice',
      icon: Icons.admin_panel_settings,
      traits: {'wisdom': 4, 'honor': 4, 'nature': 3},
      description: 'Sage et protectrice, vous veillez sur votre entourage. Comme Frigg, vous anticipez et prévenez les dangers.',
      dailyChallenge: 'Prenez soin de votre famille ou vos proches',
      colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
    ),
  };

  static const List<Question> questions = [
    Question(
      question: 'Face à un défi important, votre première réaction est :',
      answers: [
        Answer(
          text: 'Chercher des informations avant d\'agir',
          scores: {'wisdom': 2},
        ),
        Answer(
          text: 'Foncer tête baissée',
          scores: {'courage': 2, 'strength': 1},
        ),
        Answer(
          text: 'Trouver une approche créative',
          scores: {'cunning': 2},
        ),
        Answer(
          text: 'Rassembler les autres pour agir ensemble',
          scores: {'honor': 1, 'justice': 1},
        ),
      ],
    ),
    Question(
      question: 'Votre plus grande force est :',
      answers: [
        Answer(
          text: 'Votre capacité à comprendre les situations complexes',
          scores: {'wisdom': 2, 'cunning': 1},
        ),
        Answer(
          text: 'Votre détermination face aux obstacles',
          scores: {'strength': 2, 'courage': 1},
        ),
        Answer(
          text: 'Votre empathie et votre connexion aux autres',
          scores: {'passion': 2, 'nature': 1},
        ),
        Answer(
          text: 'Votre sens moral inébranlable',
          scores: {'justice': 2, 'honor': 1},
        ),
      ],
    ),
    Question(
      question: 'Dans un groupe, vous êtes souvent :',
      answers: [
        Answer(
          text: 'Le conseiller sage qui écoute',
          scores: {'wisdom': 2},
        ),
        Answer(
          text: 'Le leader qui prend les décisions',
          scores: {'courage': 1, 'honor': 1},
        ),
        Answer(
          text: 'Celui qui apporte créativité et nouveauté',
          scores: {'cunning': 1, 'passion': 1},
        ),
        Answer(
          text: 'Le médiateur qui résout les conflits',
          scores: {'justice': 2},
        ),
      ],
    ),
    Question(
      question: 'Votre relation à la nature est :',
      answers: [
        Answer(
          text: 'Source de réflexion et de sagesse',
          scores: {'wisdom': 1, 'nature': 2},
        ),
        Answer(
          text: 'Terrain de défis et d\'aventures',
          scores: {'strength': 1, 'courage': 1},
        ),
        Answer(
          text: 'Inspiration pour créativité et passion',
          scores: {'passion': 2, 'nature': 1},
        ),
        Answer(
          text: 'Rappel de l\'ordre naturel des choses',
          scores: {'honor': 1, 'justice': 1},
        ),
      ],
    ),
    Question(
      question: 'Votre plus grande peur serait :',
      answers: [
        Answer(
          text: 'Rester dans l\'ignorance',
          scores: {'wisdom': 2},
        ),
        Answer(
          text: 'Être lâche face au danger',
          scores: {'courage': 2},
        ),
        Answer(
          text: 'Perdre votre liberté créative',
          scores: {'cunning': 1, 'passion': 1},
        ),
        Answer(
          text: 'Trahir vos principes',
          scores: {'honor': 2, 'justice': 1},
        ),
      ],
    ),
    Question(
      question: 'Votre approche de l\'amour et des relations :',
      answers: [
        Answer(
          text: 'Profonde et réfléchie, basée sur la compréhension',
          scores: {'wisdom': 1, 'honor': 1},
        ),
        Answer(
          text: 'Protectrice et loyale envers ceux que j\'aime',
          scores: {'strength': 1, 'honor': 1},
        ),
        Answer(
          text: 'Passionnée et intense',
          scores: {'passion': 2, 'nature': 1},
        ),
        Answer(
          text: 'Équitable et respectueuse',
          scores: {'justice': 2},
        ),
      ],
    ),
  ];
}