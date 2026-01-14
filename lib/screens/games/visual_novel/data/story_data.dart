/// Story data for the Norse Mythology Visual Novel
/// Based on the narrative design from visualnovel.md
library;

import '../models/visual_novel_models.dart';

class StoryData {
  static Story get lokiStory => Story(
    title: "L'Oracle d'Asgard - Loki",
    description: "L'épopée de Loki aux multiples destins",
    acts: [
      _createActII(),
      // Additional acts will be added here
    ],
    scenes: {..._actIIScenes},
  );

  // ACTE II - L'Utile (Structure narrative arborescente)
  static Act _createActII() {
    return Act(
      number: 2,
      title: "L'Utile",
      description: "Quand l'ennui mène à la destinée",
      sceneIds: [
        'scene_root_bored_loki',
        'scene_first_choice',
        // Chemin malice (50%)
        'scene_malice_hair_cut',
        'scene_malice_thor_fury',
        'scene_malice_promise_hair',
        // Chemin ivre (30%)
        'scene_drunk_mead_fest',
        'scene_drunk_accident',
        'scene_drunk_thor_discovery',
        'scene_drunk_choice_promise',
        // Branches communes et fins multiples
        'scene_dwarves_sons_ivaldi',
        'scene_bet_brokkr_eitri',
        'scene_sabotage_attempts',
        'scene_endings_multiple',
      ],
      isUnlocked: true,
    );
  }

  static Map<String, Scene> get _actIIScenes => {
    // ========== SCÈNE RACINE ==========
    'scene_root_bored_loki': Scene(
      id: 'scene_root_bored_loki',
      type: SceneType.dialogue,
      title: "L'Ennui d'Asgard",
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(speaker: "Narrateur", text: "*Dans les palais dorés d'Asgard, l'éternité pèse sur l'esprit de Loki*"),
        DialogueLine(
          speaker: "Loki",
          text: "Encore une journée parfaite… Trop parfaite. L'ordre, l'harmonie, la perfection éternelle d'Asgard… Comme c'est… ennuyeux.",
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(
          speaker: "Narrateur",
          text: "*Loki déambule dans les jardins dorés, son regard tombe sur Sif qui dort paisiblement près de la fontaine*",
          characterImage: 'assets/images/vn/sif_asleep.webp',
        ),
        DialogueLine(
          speaker: "Loki",
          text: "Ah, la belle Sif… Ses cheveux dorés flottent dans la brise matinale comme des fils de lumière. Si sereins… si prévisibles.",
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(speaker: "Narrateur", text: "*Au loin, un tonneau d'hydromel abandonné par les festivités d'hier attire l'attention*"),
        DialogueLine(
          speaker: "Loki",
          text:
              "Hmm… Que faire de cette journée qui s'annonce si... ordinaire ? L'appel de la malice chatouille mon âme, mais l'hydromel chante aussi ses charmes…",
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
      ],
      nextSceneId: 'scene_first_choice',
    ),

    // ========== PREMIER CHOIX CRUCIAL ==========
    'scene_first_choice': Scene(
      id: 'scene_first_choice',
      type: SceneType.choice,
      title: "L'Ennui Créateur",
      content: "Comment Loki va-t-il briser la monotonie de cette journée parfaite ?",
      choices: [
        Choice(
          id: 'path_malice_cut_hair',
          text: "Couper les cheveux de Sif (Malice pure)",
          description: "Un geste impulsif, délibéré... La malice à l'état pur. Ses cheveux dorés seraient si beaux une fois coupés. [50% des destins]",
          consequence: EmotionalConsequence(prideChange: 8, bitternessChange: 3),
          nextSceneId: 'scene_malice_hair_cut',
        ),
        Choice(
          id: 'path_drunk_mead_fest',
          text: "Boire le tonneau d'hydromel (Fête solo)",
          description: "Pourquoi ne pas faire ma propre fête ? L'hydromel chasse l'ennui et apporte l'hilarité ! [30% des destins]",
          consequence: EmotionalConsequence(lucidityChange: -5, loyaltyChange: 2),
          nextSceneId: 'scene_drunk_mead_fest',
        ),
        Choice(
          id: 'path_ignore_proactive',
          text: "Ignorer Sif et partir aux forges",
          description: "L'ennui peut mener à la création. Pourquoi ne pas visiter les forgerons ? [20% des destins - Chemin mineur]",
          consequence: EmotionalConsequence(lucidityChange: 8, prideChange: -2),
          nextSceneId: 'scene_proactive_forges',
        ),
      ],
    ),

    // ========== CHEMIN MALICE (50% des runs) ==========
    'scene_malice_hair_cut': Scene(
      id: 'scene_malice_hair_cut',
      type: SceneType.dialogue,
      title: "L'Acte de Malice Pure",
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(
          speaker: "Loki",
          text: "La perfection de ces cheveux dorés... il est temps de créer un peu de chaos dans ce monde trop ordonné.",
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(
          speaker: "Narrateur",
          text: "*Avec une précision diabolique, Loki s'approche de Sif endormie et tranche ses magnifiques cheveux d'un geste fluide*",
        ),
        DialogueLine(
          speaker: "Loki",
          text: "Voilà ! L'art du chaos instantané. Cette sensation d'adrénaline pure... Délicieuse !",
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(speaker: "Sif", text: "MES CHEVEUX ! QUI... QUI A OSÉ FAIRE CELA ?!", characterImage: 'assets/images/vn/sif_shocked.webp'),
        DialogueLine(
          speaker: "Loki",
          text: "Bonjour Sif ! Tu as... un style très avant-gardiste maintenant !",
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
      ],
      nextSceneId: 'scene_malice_thor_fury',
    ),

    'scene_malice_thor_fury': Scene(
      id: 'scene_malice_thor_fury',
      type: SceneType.dialogue,
      title: "La Fureur de Thor",
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(speaker: "Sif", text: "LOKI ! THOR ! VIENS VOIR CE QUE TON FRÈRE A FAIT !", characterImage: 'assets/images/vn/sif_shocked.webp'),
        DialogueLine(speaker: "Thor", text: "Qu'est-ce qui... PAR LES BARBES D'ODIN ! Tes cheveux !", characterImage: 'assets/images/vn/thor_angry.webp'),
        DialogueLine(speaker: "Narrateur", text: "*Thor saisit violemment Loki par le col, ses yeux lançant des éclairs*"),
        DialogueLine(
          speaker: "Thor",
          text: "TU VAS ME REMPLACER SES CHEVEUX IMMÉDIATEMENT, OU JE TE BRISE EN MILLE MORCEAUX !",
          characterImage: 'assets/images/vn/thor_angry.webp',
        ),
        DialogueLine(
          speaker: "Loki",
          text: "Ah ! Thor, toujours si... expressif ! Écoute, j'ai peut-être une solution...",
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
      ],
      nextSceneId: 'scene_malice_promise_hair',
    ),

    'scene_malice_promise_hair': Scene(
      id: 'scene_malice_promise_hair',
      type: SceneType.dialogue,
      title: "La Promesse Dorée",
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(
          speaker: "Loki",
          text: "Je peux lui créer des cheveux encore plus magnifiques ! Des cheveux d'or véritable, forgés par les fils d'Ívaldi !",
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
        DialogueLine(speaker: "Thor", text: "Tu as intérêt à tenir ta promesse, frère. Car sinon...", characterImage: 'assets/images/vn/thor_angry.webp'),
        DialogueLine(speaker: "Narrateur", text: "*Et voilà comment la malice pure de Loki l'entraîne vers les forges légendaires...*"),
      ],
      nextSceneId: 'scene_dwarves_sons_ivaldi',
    ),

    // ========== CHEMIN IVRE (30% des runs - NOUVEAU!) ==========
    'scene_drunk_mead_fest': Scene(
      id: 'scene_drunk_mead_fest',
      type: SceneType.dialogue,
      title: "Fête Solo - L'Hydromel Appelle",
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(
          speaker: "Loki",
          text: "Ah ! Ce tonneau d'hydromel oublié... Pourquoi attendre une fête quand on peut en créer une soi-même ?",
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(speaker: "Narrateur", text: "*Loki s'approche du tonneau et commence à boire directement au goulot*"),
        DialogueLine(
          speaker: "Loki",
          text: "Mmh ! *glou glou* Délicieux ! *hic* L'ennui s'envole déjà ! *bulle* Encore un peu...",
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(speaker: "Narrateur", text: "*Animation : Loki vide méthodiquement le tonneau, des bulles s'échappent, l'écran vacille légèrement*"),
        DialogueLine(
          speaker: "Loki",
          text: "*Hic* Voilà ! *rote* Maintenant tout Asgard me paraît... plus amusant ! *titube*",
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
      ],
      nextSceneId: 'scene_drunk_accident',
    ),

    'scene_drunk_accident': Scene(
      id: 'scene_drunk_accident',
      type: SceneType.dialogue,
      title: "L'Accident Alcoolisé",
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(
          speaker: "Loki",
          text: "*Titube* Bon... juste un petit somme près de la belle Sif... *hic* Que pourrait-il arriver ?",
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(
          speaker: "Narrateur",
          text: "*Loki, complètement ivre, trébuche avec ses ciseaux de jardinage et coupe ACCIDENTELLEMENT les cheveux de Sif*",
          characterImage: 'assets/images/vn/sif_asleep.webp',
        ),
        DialogueLine(
          speaker: "Loki",
          text: "*Hic* Oups ! Mes... mes ciseaux ont glissé ! C'est... c'est la faute du miel ! *rote*",
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
        DialogueLine(speaker: "Sif", text: "MES CHEVEUX ! LOKI ! QU'AS-TU FAIT ?!", characterImage: 'assets/images/vn/sif_shocked.webp'),
        DialogueLine(
          speaker: "Loki",
          text: "*Hic* Je... Je peux tout expliquer ! C'était un accident ! L'hydromel, tu vois... *hoquet*",
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
      ],
      nextSceneId: 'scene_drunk_thor_discovery',
    ),

    'scene_drunk_thor_discovery': Scene(
      id: 'scene_drunk_thor_discovery',
      type: SceneType.dialogue,
      title: "Thor et l'Ivrogne Coupable",
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(
          speaker: "Sif",
          text: "THOR ! VIENS VOIR CE QUE TON FRÈRE A FAIT ! IL EST IVRE MORT !",
          characterImage: 'assets/images/vn/sif_shocked.webp',
        ),
        DialogueLine(
          speaker: "Thor",
          text: "Par les barbes d'Odin ! Tes cheveux ! Et toi Loki... tu pues l'hydromel à des lieues !",
          characterImage: 'assets/images/vn/thor_angry.webp',
        ),
        DialogueLine(
          speaker: "Loki",
          text: "*Hic* Thor mon frère ! *rote* C'était... un accident ! L'hydromel et... les ciseaux... *hoquet*",
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
        DialogueLine(
          speaker: "Thor",
          text: "MÊME BOURRÉ, TA MALICE PUE ! Comment peux-tu être si maladroit et si destructeur à la fois ?!",
          characterImage: 'assets/images/vn/thor_angry.webp',
        ),
        DialogueLine(speaker: "Narrateur", text: "*Thor saisit Loki par le col, encore plus énervé par l'ivresse évidente*"),
      ],
      nextSceneId: 'scene_drunk_choice_promise',
    ),

    'scene_drunk_choice_promise': Scene(
      id: 'scene_drunk_choice_promise',
      type: SceneType.choice,
      title: "Promesse d'Ivrogne",
      content: "Comment Loki va-t-il essayer de se rattraper, même ivre ?",
      choices: [
        Choice(
          id: 'drunk_promise_yes',
          text: "Promettre des cheveux d'or (en bafouillant)",
          description: "*Hic* Je... je peux faire mieux ! Des cheveux d'or ! Chez les... les fils d'Ívaldi ! *rote*",
          consequence: EmotionalConsequence(loyaltyChange: 2, lucidityChange: -3),
          nextSceneId: 'scene_dwarves_sons_ivaldi_drunk',
        ),
        Choice(
          id: 'drunk_blame_mead',
          text: "Blâmer l'hydromel et nier",
          description: "C'était pas moi ! C'est le tonneau qui m'a forcé ! *hoquet*",
          consequence: EmotionalConsequence(bitternessChange: 5, prideChange: -8),
          nextSceneId: 'scene_drunk_cleaning_ending',
        ),
      ],
    ),

    // ========== Scènes communes (chemin malice direct) ==========
    'scene_dwarves_sons_ivaldi': Scene(
      id: 'scene_dwarves_sons_ivaldi',
      type: SceneType.dialogue,
      title: 'Chez les Fils d\'Ívaldi',
      backgroundImage: 'assets/images/vn/dwarf_forge.webp',
      dialogues: [
        DialogueLine(
          speaker: "Narrateur",
          text:
              "Loki arrive chez les fils d'Ívaldi, déterminé à réparer le mal causé par sa malice délibérée. Les nains l'accueillent avec méfiance mais respectent sa demande directe.",
        ),
        DialogueLine(speaker: "Narrateur", text: "*Dans les forges souterraines, Brokkr et Eitri travaillent le métal*"),
        DialogueLine(
          speaker: "Brokkr",
          text: "Tu assumes ta malice, Loki. C'est déjà mieux que tes mensonges habituels.",
          characterImage: 'assets/images/vn/brokkr_suspicious.webp',
        ),
        DialogueLine(speaker: "Narrateur", text: "Les fils d'Ívaldi acceptent de créer des cheveux d'or pur pour Sif."),
      ],
      nextSceneId: 'scene_bet_brokkr_eitri',
    ),

    // ========== Variante IVRE des fils d'Ívaldi ==========
    'scene_dwarves_sons_ivaldi_drunk': Scene(
      id: 'scene_dwarves_sons_ivaldi_drunk',
      type: SceneType.dialogue,
      title: 'Chez les Fils d\'Ívaldi (Version Ivre)',
      backgroundImage: 'assets/images/vn/dwarf_forge.webp',
      dialogues: [
        DialogueLine(
          speaker: "Narrateur",
          text: "*Hic* Loki arrive en titubant chez les fils d'Ívaldi, encore étourdi par l'hydromel. Les nains le regardent avec amusement et exaspération.",
        ),
        DialogueLine(speaker: "Narrateur", text: "*Dans les forges souterraines, l'ambiance est... particulière*"),
        DialogueLine(
          speaker: "Brokkr",
          text: "Par ma barbe ! Tu pues l'hydromel, Loki ! *rire* Et tu veux qu'on forge des cheveux d'or dans cet état ?",
          characterImage: 'assets/images/vn/brokkr_amused.webp',
        ),
        DialogueLine(
          speaker: "Loki",
          text: "*Hic* Écoutez-moi... *rote* C'était un accident ! L'hydromel m'a... *hoquet* ... trahi !",
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
        DialogueLine(
          speaker: "Eitri",
          text: "Au moins, tu n'es pas venu avec des mensonges cette fois. L'ivresse rend honnête !",
          characterImage: 'assets/images/vn/eitri_amused.webp',
        ),
        DialogueLine(
          speaker: "Narrateur",
          text: 'Les nains acceptent, mais préviennent : "Ton état d\'ivresse pourrait affecter ta concentration pour les tâches à venir..."',
        ),
      ],
      nextSceneId: 'scene_bet_brokkr_eitri_drunk',
    ),

    // ========== Fin neutre 2 pour le chemin ivre ==========
    'scene_drunk_cleaning_ending': Scene(
      id: 'scene_drunk_cleaning_ending',
      type: SceneType.narrative,
      title: 'Fin : Le Serviteur Bourré',
      paragraphs: [
        'Thor, exaspéré par l\'ivresse et le déni de Loki, décide d\'une punition appropriée.',
        '"Puisque l\'hydromel te rend si... créatif, tu vas nettoyer tout Asgard ! Jusqu\'à ce que tu retrouves tes esprits !"',
        '*Montage comique : Loki titube en nettoyant les palais, encore ivre*',
        '"*Hic* Au moins... *rote* ... l\'hydromel rend le travail plus... *hoquet* ... supportable !"',
        '**FIN NEUTRE 2 : "SERVITEUR BOURRÉ"** - Loki apprend que l\'ivresse peut mener aux corvées...',
      ],
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      characterImage: 'assets/images/vn/loki_nervous.webp',
      // Fin de l'histoire - pas de nextSceneId
    ),

    // ========== PARI BROKKR/EITRI (Version normale) ==========
    'scene_bet_brokkr_eitri': Scene(
      id: 'scene_bet_brokkr_eitri',
      type: SceneType.dialogue,
      title: 'Le Pari Fatidique',
      backgroundImage: 'assets/images/vn/dwarf_forge.webp',
      dialogues: [
        DialogueLine(
          speaker: "Loki",
          text: "Mes amis nains, vos talents sont reconnus dans tous les Neuf Royaumes. Mais dites-moi... qui forge mieux ?",
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(
          speaker: "Brokkr",
          text: "Ha ! Loki, nous connaissons tes ruses ! Tu veux nous monter les uns contre les autres !",
          characterImage: 'assets/images/vn/brokkr_suspicious.webp',
        ),
        DialogueLine(
          speaker: "Eitri",
          text: "Mais... un défi pourrait être amusant, frère. Que proposes-tu, dieu espiègle ?",
          characterImage: 'assets/images/vn/eitri_interested.webp',
        ),
        DialogueLine(
          speaker: "Loki",
          text: "Un simple pari : qui créera les trois plus beaux cadeaux pour les dieux ? Ma tête comme enjeu !",
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(
          speaker: "Brokkr",
          text: "Marché conclu ! Nous allons te montrer ce qu'est la vraie forge !",
          characterImage: 'assets/images/vn/brokkr_determined.webp',
        ),
      ],
      nextSceneId: 'scene_sabotage_attempts',
    ),

    // ========== PARI BROKKR/EITRI (Version ivre) ==========
    'scene_bet_brokkr_eitri_drunk': Scene(
      id: 'scene_bet_brokkr_eitri_drunk',
      type: SceneType.dialogue,
      title: 'Le Pari Titubant',
      backgroundImage: 'assets/images/vn/dwarf_forge.webp',
      dialogues: [
        DialogueLine(
          speaker: "Loki",
          text: "*Hic* Mes amis nains... *rote* Qui... qui forge le mieux ? *hoquet* Entre vous deux ?",
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
        DialogueLine(
          speaker: "Brokkr",
          text: "*Rire* Par ma barbe ! Il est complètement ivre ! Tu veux faire un pari dans cet état ?",
          characterImage: 'assets/images/vn/brokkr_amused.webp',
        ),
        DialogueLine(
          speaker: "Eitri",
          text: "L'hydromel rend les paris plus... intéressants ! Que proposes-tu, Loki titubant ?",
          characterImage: 'assets/images/vn/eitri_amused.webp',
        ),
        DialogueLine(
          speaker: "Loki",
          text: "*Hic* Ma tête contre... *rote* ... vos plus beaux trésors ! *hoquet* Facile !",
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
        DialogueLine(speaker: "Narrateur", text: "*Les nains se regardent avec amusement. L'ivresse de Loki va-t-elle affecter ses talents de saboteur ?*"),
      ],
      nextSceneId: 'scene_sabotage_attempts_drunk',
    ),

    // ========== SABOTAGE NORMAL (Loki sobre) ==========
    'scene_sabotage_attempts': Scene(
      id: 'scene_sabotage_attempts',
      type: SceneType.choice,
      title: 'L\'Art du Sabotage',
      content: 'Les frères forgent avec ardeur. Mjöllnir prend forme. C\'est le moment critique...',
      choices: [
        Choice(
          id: 'sabotage_perfect',
          text: 'Sabotage précis et mesuré',
          description: 'Piquer juste assez pour raccourcir le manche, mais pas trop.',
          consequence: EmotionalConsequence(lucidityChange: 5, prideChange: 3),
          nextSceneId: 'scene_ending_canon_neutral',
        ),
        Choice(
          id: 'sabotage_minimal',
          text: 'Sabotage minimal',
          description: 'À peine effleurer la forge... Laisser presque parfait.',
          consequence: EmotionalConsequence(loyaltyChange: 3, prideChange: -2),
          nextSceneId: 'scene_ending_good_respected',
        ),
        Choice(
          id: 'sabotage_excessive',
          text: 'Sabotage excessif',
          description: 'Détruire complètement leur travail ! Vengeance totale !',
          consequence: EmotionalConsequence(bitternessChange: 8, prideChange: 5),
          nextSceneId: 'scene_ending_bad_outcast',
        ),
      ],
    ),

    // ========== SABOTAGE IVRE (Loki encore bourré) ==========
    'scene_sabotage_attempts_drunk': Scene(
      id: 'scene_sabotage_attempts_drunk',
      type: SceneType.choice,
      title: 'Sabotage Titubant',
      content: '*Hic* Les frères forgent... Mjöllnir grandit... *hoquet* Temps de... de saboter ! *rote*',
      choices: [
        Choice(
          id: 'drunk_sabotage_slow',
          text: 'Sabotage lent (Ivresse = maladresse)',
          description: '*Hic* Doucement... *rote* Mes réflexes sont... *hoquet* ... ralentis...',
          consequence: EmotionalConsequence(lucidityChange: -3, loyaltyChange: 5),
          nextSceneId: 'scene_ending_drunk_hero',
        ),
        Choice(
          id: 'drunk_sabotage_normal',
          text: 'Sabotage classique (Concentration ivre)',
          description: 'Même bourré, je peux... *hic* ... faire du sabotage ! *rote*',
          consequence: EmotionalConsequence(prideChange: 2, bitternessChange: 3),
          nextSceneId: 'scene_ending_drunk_comique',
        ),
        Choice(
          id: 'drunk_sabotage_fail',
          text: 'Sabotage raté (Trop bourré)',
          description: '*Hoquet* Je... je vais... *titube* ... Oups ! *chute*',
          consequence: EmotionalConsequence(prideChange: -10, bitternessChange: 5),
          nextSceneId: 'scene_ending_drunk_fatal',
        ),
      ],
    ),

    // ========== FINS MULTIPLES NOMMÉES ==========

    // FIN BONNE 4 : "L'Ivre Héros" (Sabotage faible car ivre = lent)
    'scene_ending_drunk_hero': Scene(
      id: 'scene_ending_drunk_hero',
      type: SceneType.narrative,
      title: 'Fin : L\'Ivre Héros',
      paragraphs: [
        '*Hic* Loki, ralenti par l\'hydromel, sabote maladroitement la forge. Sa mouche titube, ses piqûres sont faibles...',
        '*Résultat inattendu : Mjöllnir sort PARFAIT de la forge !*',
        'Thor, ébahi : "Par Odin ! Ce marteau est... magnifique ! Parfait en tous points !"',
        'Odin sourit : "L\'hydromel t\'a sauvé, Loki ! Ta maladresse a préservé l\'œuvre !"',
        '*Loki rote de satisfaction*',
        '"*Hic* Qui aurait cru que... *rote* ... l\'ivresse serait ma... *hoquet* ... meilleure alliée !"',
        '**FIN BONNE 4 : "L\'IVRE HÉROS"** - Parfois, la maladresse vaut mieux que la malice...',
      ],
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      characterImage: 'assets/images/vn/loki_mischievous.webp',
    ),

    // FIN NEUTRE COMIQUE : "Mjöllnir Court + Vomir Interdit"
    'scene_ending_drunk_comique': Scene(
      id: 'scene_ending_drunk_comique',
      type: SceneType.narrative,
      title: 'Fin : Le Renvoi Comique',
      paragraphs: [
        'Loki parvient à saboter normalement malgré son ivresse. Mjöllnir sort avec un manche court.',
        '*Jugement des dieux*',
        'Odin : "Loki, ta bouche sera cousue pour tes mensonges !"',
        '*Mais quand les nains approchent avec l\'aiguille...*',
        'Loki : "*ROOOTE* !"',
        'Thor : "Il ne peut pas s\'arrêter de roter ! Comment coudre une bouche qui rote ?"',
        '*Fous rires général. Les dieux abandonnent la punition par pitié*',
        'Loki : "*Hic* L\'hydromel... *rote* ... meilleure défense légale ! *hoquet*"',
        '**FIN NEUTRE 3 : "LE RENVOI COMIQUE"** - Quand l\'ivresse devient un bouclier juridique...',
      ],
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      characterImage: 'assets/images/vn/loki_nervous.webp',
    ),

    // FIN MAUVAISE 5 : "Hydromel Fatal"
    'scene_ending_drunk_fatal': Scene(
      id: 'scene_ending_drunk_fatal',
      type: SceneType.narrative,
      title: 'Fin : Hydromel Fatal',
      paragraphs: [
        '*Catastrophe totale !* Loki, trop bourré, titube et s\'écrase dans la forge, détruisant tout !',
        '*Les flammes s\'éteignent, les métaux se mélangent, tout est ruiné*',
        'Brokkr : "DÉSASTRE ! Notre travail de semaines... détruit !"',
        'Thor : "Cette fois, aucune excuse ! L\'hydromel ne justifie pas tout !"',
        '*Loki gémit au sol, encore ivre*',
        '"*Hic* Je... je ne voulais pas... *hoquet* Le tonneau m\'a... *rote* ... trahi !"',
        'Thor : "PLUS D\'EXCUSES ! Tu nettoieras les Neuf Royaumes !"',
        '**FIN MAUVAISE 5 : "HYDROMEL FATAL"** - L\'ivresse a ses limites... et ses conséquences.',
      ],
      backgroundImage: 'assets/images/vn/dwarf_forge.webp',
      characterImage: 'assets/images/vn/loki_nervous.webp',
    ),

    // ========== FINS DU CHEMIN MALICE NORMAL ==========

    // FIN NEUTRE 1 : Canonique (Mjöllnir court + bouche cousue)
    'scene_ending_canon_neutral': Scene(
      id: 'scene_ending_canon_neutral',
      type: SceneType.narrative,
      title: 'Fin : L\'Héritage Canonique',
      paragraphs: [
        'Le sabotage de Loki fonctionne parfaitement. Mjöllnir sort de la forge avec un manche raccourci, mais reste une arme redoutable.',
        '*Jugement à Asgard*',
        'Les dieux délibèrent. Brokkr et Eitri ont gagné le pari ! Leurs créations surpassent celles des fils d\'Ívaldi.',
        'Brokkr s\'avance vers Loki : "Ta tête nous appartient !"',
        'Loki sourit : "Prenez ma tête, mais pas mon cou ! Ils ne font qu\'un !"',
        '*Les nains, frustrés, cousent sa bouche*',
        '*Montage : Loki apprend le silence... temporairement*',
        '**FIN NEUTRE 1 : "L\'HÉRITAGE CANONIQUE"** - La malice a un prix, mais Loki trouve toujours une échappatoire...',
      ],
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      characterImage: 'assets/images/vn/loki_mischievous.webp',
    ),

    // FIN BONNE 1 : Sabotage minimal = Mjöllnir quasi-parfait
    'scene_ending_good_respected': Scene(
      id: 'scene_ending_good_respected',
      type: SceneType.narrative,
      title: 'Fin : Le Sage Repentir',
      paragraphs: [
        'Loki choisit la retenue. Son sabotage est si minimal que Mjöllnir sort presque parfait de la forge.',
        '*Réaction des dieux*',
        'Thor lève le marteau : "Il est magnifique ! Parfaitement équilibré !"',
        'Odin observe Loki avec surprise : "Tu as fait preuve de... sagesse ?"',
        '*Même les nains sont impressionnés*',
        'Brokkr : "Tu aurais pu tout détruire, mais tu as choisi la mesure. Respect, Loki."',
        '*Pour une fois, Loki est apprécié pour sa retenue*',
        '"Parfois, la malice consiste à savoir... ne pas être malicieux."',
        '**FIN BONNE 1 : "LE SAGE REPENTIR"** - La vraie ruse, c\'est parfois de ne pas en user...',
      ],
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      characterImage: 'assets/images/vn/loki_mischievous.webp',
    ),

    // FIN MAUVAISE 1 : Sabotage excessif = Paria total
    'scene_ending_bad_outcast': Scene(
      id: 'scene_ending_bad_outcast',
      type: SceneType.narrative,
      title: 'Fin : Le Paria d\'Asgard',
      paragraphs: [
        'La malice de Loki ne connaît pas de limites. Il détruit complètement la forge des frères !',
        '*Désastre total*',
        'Brokkr hurle : "NOTRE VIE DE TRAVAIL ! DÉTRUITE !"',
        'Thor, fou de rage : "CETTE FOIS, TU ES ALLÉ TROP LOIN !"',
        '*Même Odin détourne le regard*',
        '"Loki... tu as franchi une ligne. Les conséquences seront terribles."',
        '*Loki est banni d\'Asgard, seul face à sa malice destructrice*',
        '"J\'ai voulu le chaos... j\'ai obtenu la solitude."',
        '**FIN MAUVAISE 1 : "LE PARIA D\'ASGARD"** - Certaines lignes ne doivent jamais être franchies...',
      ],
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      characterImage: 'assets/images/vn/loki_nervous.webp',
    ),

    // FIN CHEMIN MINEUR : Ignorer Sif + Forges proactives
    'scene_proactive_forges': Scene(
      id: 'scene_proactive_forges',
      type: SceneType.narrative,
      title: 'Fin : L\'Artisan Inspiré',
      paragraphs: [
        'Loki choisit la voie de la création plutôt que de la destruction.',
        '*Aux forges des nains*',
        '"Je ne viens pas demander réparation d\'une faute, mais proposer collaboration !"',
        'Les nains, surpris par cette approche inhabituelle, accueillent Loki avec curiosité.',
        '*Montage : Loki aide à forger de magnifiques créations*',
        '"Pour une fois, mes talents servent la beauté plutôt que le chaos."',
        '*Asgard découvre un Loki créateur*',
        '**FIN BONNE 2 : "L\'ARTISAN INSPIRÉ"** - Parfois, l\'ennui mène à l\'épanouissement...',
      ],
      backgroundImage: 'assets/images/vn/dwarf_forge.webp',
      characterImage: 'assets/images/vn/loki_mischievous.webp',
    ),
  };
}
