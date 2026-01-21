/// Story data for the Norse Mythology Visual Novel
/// Based on the narrative design from visualnovel.md
library;

import 'package:easy_localization/easy_localization.dart';
import 'package:oracle_d_asgard/screens/games/visual_novel/models/visual_novel_models.dart';

class StoryData {
  static Story get lokiStory => Story(
    title: 'vn_story_title'.tr(),
    description: 'vn_story_description'.tr(),
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
      title: 'vn_act2_title'.tr(),
      description: 'vn_act2_description'.tr(),
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
      title: 'vn_scene_root_bored_loki_title'.tr(),
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(speaker: 'vn_speaker_narrateur'.tr(), text: 'vn_scene_root_bored_loki_d1'.tr()),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_root_bored_loki_d2'.tr(),
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(
          speaker: 'vn_speaker_narrateur'.tr(),
          text: 'vn_scene_root_bored_loki_d3'.tr(),
          characterImage: 'assets/images/vn/sif_asleep.webp',
        ),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_root_bored_loki_d4'.tr(),
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(
          speaker: 'vn_speaker_narrateur'.tr(),
          text: 'vn_scene_root_bored_loki_d5'.tr(),
          characterImage: 'assets/images/vn/barrel.webp',
        ),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_root_bored_loki_dialogue_6'.tr(),
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
      ],
      nextSceneId: 'scene_first_choice',
    ),

    // ========== PREMIER CHOIX CRUCIAL ==========
    'scene_first_choice': Scene(
      id: 'scene_first_choice',
      type: SceneType.choice,
      title: 'vn_scene_first_choice_title'.tr(),
      content: 'vn_scene_first_choice_content'.tr(),
      choices: [
        Choice(
          id: 'path_malice_cut_hair',
          text: 'vn_scene_first_choice_d1'.tr(),
          description: 'vn_choice1_opt1_desc'.tr(),
          consequence: EmotionalConsequence(prideChange: 8, bitternessChange: 3),
          nextSceneId: 'scene_malice_hair_cut',
        ),
        Choice(
          id: 'path_drunk_mead_fest',
          text: 'vn_scene_first_choice_d2'.tr(),
          description: 'vn_choice1_opt2_desc'.tr(),
          consequence: EmotionalConsequence(lucidityChange: -5, loyaltyChange: 2),
          nextSceneId: 'scene_drunk_mead_fest',
        ),
        Choice(
          id: 'path_ignore_proactive',
          text: 'vn_scene_first_choice_d3'.tr(),
          description: 'vn_choice1_opt3_desc'.tr(),
          consequence: EmotionalConsequence(lucidityChange: 8, prideChange: -2),
          nextSceneId: 'scene_proactive_forges',
        ),
      ],
    ),

    // ========== CHEMIN MALICE (50% des runs) ==========
    'scene_malice_hair_cut': Scene(
      id: 'scene_malice_hair_cut',
      type: SceneType.dialogue,
      title: 'vn_malice_cut_title'.tr(),
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_malice_hair_cut_d1'.tr(),
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(
          speaker: 'vn_speaker_narrateur'.tr(),
          text: 'vn_scene_malice_hair_cut_d2'.tr(),
        ),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_malice_hair_cut_d3'.tr(),
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(speaker: 'vn_sif'.tr(), text: 'vn_scene_malice_hair_cut_d4'.tr(), characterImage: 'assets/images/vn/sif_shocked.webp'),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_malice_hair_cut_d5'.tr(),
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
      ],
      nextSceneId: 'scene_malice_thor_fury',
    ),

    'scene_malice_thor_fury': Scene(
      id: 'scene_malice_thor_fury',
      type: SceneType.dialogue,
      title: 'vn_thor_fury_title'.tr(),
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(speaker: 'vn_sif'.tr(), text: 'vn_scene_malice_thor_fury_d1'.tr(), characterImage: 'assets/images/vn/sif_shocked.webp'),
        DialogueLine(speaker: 'vn_thor'.tr(), text: 'vn_scene_malice_thor_fury_d2'.tr(), characterImage: 'assets/images/vn/thor_angry.webp'),
        DialogueLine(speaker: 'vn_speaker_narrateur'.tr(), text: 'vn_scene_malice_thor_fury_d3'.tr()),
        DialogueLine(
          speaker: 'vn_thor'.tr(),
          text: 'vn_scene_malice_thor_fury_d4'.tr(),
          characterImage: 'assets/images/vn/thor_angry.webp',
        ),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_malice_thor_fury_d5'.tr(),
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
      ],
      nextSceneId: 'scene_malice_promise_hair',
    ),

    'scene_malice_promise_hair': Scene(
      id: 'scene_malice_promise_hair',
      type: SceneType.dialogue,
      title: 'vn_promise_hair_title'.tr(),
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_malice_promise_hair_d1'.tr(),
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
        DialogueLine(speaker: 'vn_thor'.tr(), text: 'vn_scene_malice_promise_hair_d2'.tr(), characterImage: 'assets/images/vn/thor_angry.webp'),
        DialogueLine(speaker: 'vn_speaker_narrateur'.tr(), text: 'vn_scene_malice_promise_hair_d3'.tr()),
      ],
      nextSceneId: 'scene_dwarves_sons_ivaldi',
    ),

    // ========== CHEMIN IVRE (30% des runs - NOUVEAU!) ==========
    'scene_drunk_mead_fest': Scene(
      id: 'scene_drunk_mead_fest',
      type: SceneType.dialogue,
      title: 'vn_drunk_fest_title'.tr(),
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_drunk_mead_fest_d1'.tr(),
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(
          speaker: 'vn_speaker_narrateur'.tr(),
          text: 'vn_scene_drunk_mead_fest_d2'.tr(),
          characterImage: 'assets/images/vn/barrel.webp',
        ),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_drunk_mead_fest_d3'.tr(),
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(
          speaker: 'vn_speaker_narrateur'.tr(),
          text: 'vn_scene_drunk_mead_fest_d4'.tr(),
          characterImage: 'assets/images/vn/barrel.webp',
        ),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_drunk_mead_fest_d5'.tr(),
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
      ],
      nextSceneId: 'scene_drunk_accident',
    ),

    'scene_drunk_accident': Scene(
      id: 'scene_drunk_accident',
      type: SceneType.dialogue,
      title: 'vn_drunk_accident_title'.tr(),
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_drunk_accident_d1'.tr(),
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(
          speaker: 'vn_speaker_narrateur'.tr(),
          text: 'vn_scene_drunk_accident_d2'.tr(),
          characterImage: 'assets/images/vn/sif_asleep.webp',
        ),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_drunk_accident_d3'.tr(),
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
        DialogueLine(speaker: 'vn_sif'.tr(), text: 'vn_scene_drunk_accident_d4'.tr(), characterImage: 'assets/images/vn/sif_shocked.webp'),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_drunk_accident_d5'.tr(),
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
      ],
      nextSceneId: 'scene_drunk_thor_discovery',
    ),

    'scene_drunk_thor_discovery': Scene(
      id: 'scene_drunk_thor_discovery',
      type: SceneType.dialogue,
      title: 'vn_drunk_thor_title'.tr(),
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(
          speaker: 'vn_sif'.tr(),
          text: 'vn_scene_drunk_thor_discovery_d1'.tr(),
          characterImage: 'assets/images/vn/sif_shocked.webp',
        ),
        DialogueLine(
          speaker: 'vn_thor'.tr(),
          text: 'vn_scene_drunk_thor_discovery_d2'.tr(),
          characterImage: 'assets/images/vn/thor_angry.webp',
        ),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_drunk_thor_discovery_d3'.tr(),
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
        DialogueLine(
          speaker: 'vn_thor'.tr(),
          text: 'vn_scene_drunk_thor_discovery_d4'.tr(),
          characterImage: 'assets/images/vn/thor_angry.webp',
        ),
        DialogueLine(speaker: 'vn_speaker_narrateur'.tr(), text: 'vn_scene_drunk_thor_discovery_d5'.tr()),
      ],
      nextSceneId: 'scene_drunk_choice_promise',
    ),

    'scene_drunk_choice_promise': Scene(
      id: 'scene_drunk_choice_promise',
      type: SceneType.choice,
      title: 'vn_drunk_promise_title'.tr(),
      content: 'vn_drunk_promise_content'.tr(),
      choices: [
        Choice(
          id: 'drunk_promise_yes',
          text: 'vn_scene_drunk_choice_promise_d1'.tr(),
          description: 'vn_drunk_promise_opt1_desc'.tr(),
          consequence: EmotionalConsequence(loyaltyChange: 2, lucidityChange: -3),
          nextSceneId: 'scene_dwarves_sons_ivaldi_drunk',
        ),
        Choice(
          id: 'drunk_blame_mead',
          text: 'vn_scene_drunk_choice_promise_d2'.tr(),
          description: 'vn_drunk_promise_opt2_desc'.tr(),
          consequence: EmotionalConsequence(bitternessChange: 5, prideChange: -8),
          nextSceneId: 'scene_drunk_cleaning_ending',
        ),
      ],
    ),

    // ========== Scènes communes (chemin malice direct) ==========
    'scene_dwarves_sons_ivaldi': Scene(
      id: 'scene_dwarves_sons_ivaldi',
      type: SceneType.dialogue,
      title: 'vn_dwarves_title'.tr(),
      backgroundImage: 'assets/images/vn/dwarf_forge.webp',
      dialogues: [
        DialogueLine(
          speaker: 'vn_speaker_narrateur'.tr(),
          text: 'vn_dwarves_narrator_1'.tr(),
        ),
        DialogueLine(speaker: 'vn_speaker_narrateur'.tr(), text: 'vn_scene_dwarves_sons_ivaldi_d1'.tr()),
        DialogueLine(
          speaker: 'vn_brokkr'.tr(),
          text: 'vn_scene_dwarves_sons_ivaldi_d2'.tr(),
          characterImage: 'assets/images/vn/brokkr_suspicious.webp',
        ),
        DialogueLine(speaker: 'vn_speaker_narrateur'.tr(), text: 'vn_scene_dwarves_sons_ivaldi_d3'.tr()),
      ],
      nextSceneId: 'scene_bet_brokkr_eitri',
    ),

    // ========== Variante IVRE des fils d'Ívaldi ==========
    'scene_dwarves_sons_ivaldi_drunk': Scene(
      id: 'scene_dwarves_sons_ivaldi_drunk',
      type: SceneType.dialogue,
      title: 'vn_dwarves_drunk_title'.tr(),
      backgroundImage: 'assets/images/vn/dwarf_forge.webp',
      dialogues: [
        DialogueLine(
          speaker: 'vn_speaker_narrateur'.tr(),
          text: 'vn_scene_dwarves_sons_ivaldi_drunk_d1'.tr(),
        ),
        DialogueLine(speaker: 'vn_speaker_narrateur'.tr(), text: 'vn_scene_dwarves_sons_ivaldi_drunk_d2'.tr()),
        DialogueLine(
          speaker: 'vn_brokkr'.tr(),
          text: 'vn_scene_dwarves_sons_ivaldi_drunk_d3'.tr(),
          characterImage: 'assets/images/vn/brokkr_amused.webp',
        ),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_dwarves_sons_ivaldi_drunk_d4'.tr(),
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
        DialogueLine(
          speaker: 'vn_eitri'.tr(),
          text: 'vn_scene_dwarves_sons_ivaldi_drunk_d5'.tr(),
          characterImage: 'assets/images/vn/eitri_amused.webp',
        ),
        DialogueLine(
          speaker: 'vn_speaker_narrateur'.tr(),
          text: 'vn_dwarves_drunk_narrator_3'.tr(),
        ),
      ],
      nextSceneId: 'scene_bet_brokkr_eitri_drunk',
    ),

    // ========== Fin neutre 2 pour le chemin ivre ==========
    'scene_drunk_cleaning_ending': Scene(
      id: 'scene_drunk_cleaning_ending',
      type: SceneType.narrative,
      title: 'vn_ending_drunk_servant_title'.tr(),
      paragraphs: [
        'vn_ending_drunk_servant_p1'.tr(),
        'vn_ending_drunk_servant_p2'.tr(),
        'vn_ending_drunk_servant_p3'.tr(),
        'vn_ending_drunk_servant_p4'.tr(),
        'vn_ending_drunk_servant_p5'.tr(),
      ],
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      characterImage: 'assets/images/vn/loki_nervous.webp',
      // Fin de l'histoire - pas de nextSceneId
    ),

    // ========== PARI BROKKR/EITRI (Version normale) ==========
    'scene_bet_brokkr_eitri': Scene(
      id: 'scene_bet_brokkr_eitri',
      type: SceneType.dialogue,
      title: 'vn_bet_title'.tr(),
      backgroundImage: 'assets/images/vn/dwarf_forge.webp',
      dialogues: [
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_bet_brokkr_eitri_d1'.tr(),
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(
          speaker: 'vn_brokkr'.tr(),
          text: 'vn_scene_bet_brokkr_eitri_d2'.tr(),
          characterImage: 'assets/images/vn/brokkr_suspicious.webp',
        ),
        DialogueLine(
          speaker: 'vn_eitri'.tr(),
          text: 'vn_scene_bet_brokkr_eitri_d3'.tr(),
          characterImage: 'assets/images/vn/eitri_interested.webp',
        ),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_bet_brokkr_eitri_d4'.tr(),
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(
          speaker: 'vn_brokkr'.tr(),
          text: 'vn_scene_bet_brokkr_eitri_d5'.tr(),
          characterImage: 'assets/images/vn/brokkr_determined.webp',
        ),
      ],
      nextSceneId: 'scene_sabotage_attempts',
    ),

    // ========== PARI BROKKR/EITRI (Version ivre) ==========
    'scene_bet_brokkr_eitri_drunk': Scene(
      id: 'scene_bet_brokkr_eitri_drunk',
      type: SceneType.dialogue,
      title: 'vn_bet_drunk_title'.tr(),
      backgroundImage: 'assets/images/vn/dwarf_forge.webp',
      dialogues: [
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_bet_brokkr_eitri_drunk_d1'.tr(),
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
        DialogueLine(
          speaker: 'vn_brokkr'.tr(),
          text: 'vn_scene_bet_brokkr_eitri_drunk_d2'.tr(),
          characterImage: 'assets/images/vn/brokkr_amused.webp',
        ),
        DialogueLine(
          speaker: 'vn_eitri'.tr(),
          text: 'vn_scene_bet_brokkr_eitri_drunk_d3'.tr(),
          characterImage: 'assets/images/vn/eitri_amused.webp',
        ),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_scene_bet_brokkr_eitri_drunk_d4'.tr(),
          characterImage: 'assets/images/vn/loki_nervous.webp',
        ),
        DialogueLine(speaker: 'vn_speaker_narrateur'.tr(), text: 'vn_scene_bet_brokkr_eitri_drunk_d5'.tr()),
      ],
      nextSceneId: 'scene_sabotage_attempts_drunk',
    ),

    // ========== SABOTAGE NORMAL (Loki sobre) ==========
    'scene_sabotage_attempts': Scene(
      id: 'scene_sabotage_attempts',
      type: SceneType.choice,
      title: 'vn_sabotage_title'.tr(),
      content: 'vn_sabotage_content'.tr(),
      choices: [
        Choice(
          id: 'sabotage_perfect',
          text: 'vn_sabotage_opt1_text'.tr(),
          description: 'vn_sabotage_opt1_desc'.tr(),
          consequence: EmotionalConsequence(lucidityChange: 5, prideChange: 3),
          nextSceneId: 'scene_ending_canon_neutral',
        ),
        Choice(
          id: 'sabotage_minimal',
          text: 'vn_sabotage_opt2_text'.tr(),
          description: 'vn_sabotage_opt2_desc'.tr(),
          consequence: EmotionalConsequence(loyaltyChange: 3, prideChange: -2),
          nextSceneId: 'scene_ending_good_respected',
        ),
        Choice(
          id: 'sabotage_excessive',
          text: 'vn_sabotage_opt3_text'.tr(),
          description: 'vn_sabotage_opt3_desc'.tr(),
          consequence: EmotionalConsequence(bitternessChange: 8, prideChange: 5),
          nextSceneId: 'scene_ending_bad_outcast',
        ),
      ],
    ),

    // ========== SABOTAGE IVRE (Loki encore bourré) ==========
    'scene_sabotage_attempts_drunk': Scene(
      id: 'scene_sabotage_attempts_drunk',
      type: SceneType.choice,
      title: 'vn_sabotage_drunk_title'.tr(),
      content: 'vn_sabotage_drunk_content'.tr(),
      choices: [
        Choice(
          id: 'drunk_sabotage_slow',
          text: 'vn_sabotage_drunk_opt1_text'.tr(),
          description: 'vn_sabotage_drunk_opt1_desc'.tr(),
          consequence: EmotionalConsequence(lucidityChange: -3, loyaltyChange: 5),
          nextSceneId: 'scene_ending_drunk_hero',
        ),
        Choice(
          id: 'drunk_sabotage_normal',
          text: 'vn_sabotage_drunk_opt2_text'.tr(),
          description: 'vn_sabotage_drunk_opt2_desc'.tr(),
          consequence: EmotionalConsequence(prideChange: 2, bitternessChange: 3),
          nextSceneId: 'scene_ending_drunk_comique',
        ),
        Choice(
          id: 'drunk_sabotage_fail',
          text: 'vn_sabotage_drunk_opt3_text'.tr(),
          description: 'vn_sabotage_drunk_opt3_desc'.tr(),
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
      title: 'vn_ending_drunk_hero_title'.tr(),
      paragraphs: [
        'vn_ending_drunk_hero_p1'.tr(),
        'vn_ending_drunk_hero_p2'.tr(),
        'vn_ending_drunk_hero_p3'.tr(),
        'vn_ending_drunk_hero_p4'.tr(),
        'vn_ending_drunk_hero_p5'.tr(),
        'vn_ending_drunk_hero_p6'.tr(),
        'vn_ending_drunk_hero_p7'.tr(),
      ],
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      characterImage: 'assets/images/vn/loki_mischievous.webp',
    ),

    // FIN NEUTRE COMIQUE : "Mjöllnir Court + Vomir Interdit"
    'scene_ending_drunk_comique': Scene(
      id: 'scene_ending_drunk_comique',
      type: SceneType.narrative,
      title: 'vn_ending_drunk_comique_title'.tr(),
      paragraphs: [
        'vn_ending_drunk_comique_p1'.tr(),
        'vn_ending_drunk_comique_p2'.tr(),
        'vn_ending_drunk_comique_p3'.tr(),
        'vn_ending_drunk_comique_p4'.tr(),
        'vn_ending_drunk_comique_p5'.tr(),
        'vn_ending_drunk_comique_p6'.tr(),
        'vn_ending_drunk_comique_p7'.tr(),
        'vn_ending_drunk_comique_p8'.tr(),
        'vn_ending_drunk_comique_p9'.tr(),
      ],
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      characterImage: 'assets/images/vn/loki_nervous.webp',
    ),

    // FIN MAUVAISE 5 : "Hydromel Fatal"
    'scene_ending_drunk_fatal': Scene(
      id: 'scene_ending_drunk_fatal',
      type: SceneType.narrative,
      title: 'vn_ending_drunk_fatal_title'.tr(),
      paragraphs: [
        'vn_ending_drunk_fatal_p1'.tr(),
        'vn_ending_drunk_fatal_p2'.tr(),
        'vn_ending_drunk_fatal_p3'.tr(),
        'vn_ending_drunk_fatal_p4'.tr(),
        'vn_ending_drunk_fatal_p5'.tr(),
        'vn_ending_drunk_fatal_p6'.tr(),
        'vn_ending_drunk_fatal_p7'.tr(),
        'vn_ending_drunk_fatal_p8'.tr(),
      ],
      backgroundImage: 'assets/images/vn/dwarf_forge.webp',
      characterImage: 'assets/images/vn/loki_nervous.webp',
    ),

    // ========== FINS DU CHEMIN MALICE NORMAL ==========

    // FIN NEUTRE 1 : Canonique (Mjöllnir court + bouche cousue)
    'scene_ending_canon_neutral': Scene(
      id: 'scene_ending_canon_neutral',
      type: SceneType.narrative,
      title: 'vn_ending_canon_title'.tr(),
      paragraphs: [
        'vn_ending_canon_p1'.tr(),
        'vn_ending_canon_p2'.tr(),
        'vn_ending_canon_p3'.tr(),
        'vn_ending_canon_p4'.tr(),
        'vn_ending_canon_p5'.tr(),
        'vn_ending_canon_p6'.tr(),
        'vn_ending_canon_p7'.tr(),
        'vn_ending_canon_p8'.tr(),
      ],
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      characterImage: 'assets/images/vn/loki_mischievous.webp',
    ),

    // FIN BONNE 1 : Sabotage minimal = Mjöllnir quasi-parfait
    'scene_ending_good_respected': Scene(
      id: 'scene_ending_good_respected',
      type: SceneType.narrative,
      title: 'vn_ending_good_title'.tr(),
      paragraphs: [
        'vn_ending_good_p1'.tr(),
        'vn_ending_good_p2'.tr(),
        'vn_ending_good_p3'.tr(),
        'vn_ending_good_p4'.tr(),
        'vn_ending_good_p5'.tr(),
        'vn_ending_good_p6'.tr(),
        'vn_ending_good_p7'.tr(),
        'vn_ending_good_p8'.tr(),
        'vn_ending_good_p9'.tr(),
      ],
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      characterImage: 'assets/images/vn/loki_mischievous.webp',
    ),

    // FIN MAUVAISE 1 : Sabotage excessif = Paria total
    'scene_ending_bad_outcast': Scene(
      id: 'scene_ending_bad_outcast',
      type: SceneType.narrative,
      title: 'vn_ending_bad_title'.tr(),
      paragraphs: [
        'vn_ending_bad_p1'.tr(),
        'vn_ending_bad_p2'.tr(),
        'vn_ending_bad_p3'.tr(),
        'vn_ending_bad_p4'.tr(),
        'vn_ending_bad_p5'.tr(),
        'vn_ending_bad_p6'.tr(),
        'vn_ending_bad_p7'.tr(),
        'vn_ending_bad_p8'.tr(),
        'vn_ending_bad_p9'.tr(),
      ],
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      characterImage: 'assets/images/vn/loki_nervous.webp',
    ),

    // FIN CHEMIN MINEUR : Ignorer Sif + Forges proactives
    'scene_proactive_forges': Scene(
      id: 'scene_proactive_forges',
      type: SceneType.dialogue,
      title: 'vn_ending_artisan_title'.tr(),
      backgroundImage: 'assets/images/vn/asgard_palace_morning.webp',
      dialogues: [
        DialogueLine(
          speaker: 'vn_speaker_narrateur'.tr(),
          text: 'vn_ending_artisan_p1'.tr(),
        ),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_ending_artisan_p2'.tr(),
          characterImage: 'assets/images/vn/loki_thoughtful.webp',
        ),
      ],
      nextSceneId: 'scene_artisan_at_forge',
    ),
    
    'scene_artisan_at_forge': Scene(
      id: 'scene_artisan_at_forge',
      type: SceneType.dialogue,
      title: 'vn_ending_artisan_title'.tr(),
      backgroundImage: 'assets/images/vn/dwarf_forge.webp',
      dialogues: [
        DialogueLine(
          speaker: 'vn_speaker_narrateur'.tr(),
          text: 'vn_ending_artisan_p3'.tr(),
        ),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_ending_artisan_p4'.tr(),
          characterImage: 'assets/images/vn/loki_happy.webp',
        ),
        DialogueLine(
          speaker: 'vn_brokkr'.tr(),
          text: 'vn_ending_artisan_p5'.tr(),
          characterImage: 'assets/images/vn/brokkr.webp',
        ),
        DialogueLine(
          speaker: 'vn_eitri'.tr(),
          text: 'vn_ending_artisan_p6'.tr(),
          characterImage: 'assets/images/vn/eitri.webp',
        ),
      ],
      nextSceneId: 'scene_artisan_working',
    ),
    
    'scene_artisan_working': Scene(
      id: 'scene_artisan_working',
      type: SceneType.dialogue,
      title: 'vn_ending_artisan_title'.tr(),
      backgroundImage: 'assets/images/vn/dwarf_forge.webp',
      dialogues: [
        DialogueLine(
          speaker: 'vn_speaker_narrateur'.tr(),
          text: 'vn_ending_artisan_p7'.tr(),
        ),
        DialogueLine(
          speaker: 'vn_loki'.tr(),
          text: 'vn_ending_artisan_p8'.tr(),
          characterImage: 'assets/images/vn/loki_mischievous.webp',
        ),
        DialogueLine(
          speaker: 'vn_speaker_narrateur'.tr(),
          text: 'vn_ending_artisan_p9'.tr(),
          characterImage: 'assets/images/vn/asgard_palace.webp',
        ),
        DialogueLine(
          speaker: 'vn_speaker_narrateur'.tr(),
          text: 'vn_ending_artisan_p10'.tr(),
        ),
      ],
    ),
  };
}
