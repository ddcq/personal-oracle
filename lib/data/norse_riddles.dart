import 'package:easy_localization/easy_localization.dart';
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
final List<NorseRiddle> norseRiddles = [
  // 3 Letters
  NorseRiddle(
    name: 'TYR',
    clues: [
      'norse_riddle_tyr_clue_1'.tr(),
      'norse_riddle_tyr_clue_2'.tr(),
      'norse_riddle_tyr_clue_3'.tr(),
    ],
  ),
  // 4 Letters
  NorseRiddle(
    name: 'ODIN',
    clues: [
      'norse_riddle_odin_clue_1'.tr(),
      'norse_riddle_odin_clue_2'.tr(),
      'norse_riddle_odin_clue_3'.tr(),
    ],
  ),
  NorseRiddle(
    name: 'THOR',
    clues: [
      'norse_riddle_thor_clue_1'.tr(),
      'norse_riddle_thor_clue_2'.tr(),
      'norse_riddle_thor_clue_3'.tr(),
    ],
  ),
  NorseRiddle(
    name: 'LOKI',
    clues: [
      'norse_riddle_loki_clue_1'.tr(),
      'norse_riddle_loki_clue_2'.tr(),
      'norse_riddle_loki_clue_3'.tr(),
    ],
  ),
  // 5 Letters
  NorseRiddle(
    name: 'FREYA',
    clues: [
      'norse_riddle_freya_clue_1'.tr(),
      'norse_riddle_freya_clue_2'.tr(),
      'norse_riddle_freya_clue_3'.tr(),
    ],
  ),
  NorseRiddle(
    name: 'FRIGG',
    clues: [
      'norse_riddle_frigg_clue_1'.tr(),
      'norse_riddle_frigg_clue_2'.tr(),
      'norse_riddle_frigg_clue_3'.tr(),
    ],
  ),
  // 6 Letters
  NorseRiddle(
    name: 'FENRIR',
    clues: [
      'norse_riddle_fenrir_clue_1'.tr(),
      'norse_riddle_fenrir_clue_2'.tr(),
      'norse_riddle_fenrir_clue_3'.tr(),
    ],
  ),
  NorseRiddle(
    name: 'ASGARD',
    clues: [
      'norse_riddle_asgard_clue_1'.tr(),
      'norse_riddle_asgard_clue_2'.tr(),
      'norse_riddle_asgard_clue_3'.tr(),
    ],
  ),
  NorseRiddle(
    name: 'HUGINN',
    clues: [
      'norse_riddle_huginn_clue_1'.tr(),
      'norse_riddle_huginn_clue_2'.tr(),
      'norse_riddle_huginn_clue_3'.tr(),
    ],
  ),
  // 7 Letters
  NorseRiddle(
    name: 'BIFROST',
    clues: [
      'norse_riddle_bifrost_clue_1'.tr(),
      'norse_riddle_bifrost_clue_2'.tr(),
      'norse_riddle_bifrost_clue_3'.tr(),
    ],
  ),
  NorseRiddle(
    name: 'MJOLNIR',
    clues: [
      'norse_riddle_mjolnir_clue_1'.tr(),
      'norse_riddle_mjolnir_clue_2'.tr(),
      'norse_riddle_mjolnir_clue_3'.tr(),
    ],
  ),
  NorseRiddle(
    name: 'MIDGARD',
    clues: [
      'norse_riddle_midgard_clue_1'.tr(),
      'norse_riddle_midgard_clue_2'.tr(),
      'norse_riddle_midgard_clue_3'.tr(),
    ],
  ),
  NorseRiddle(
    name: 'VALHALLA',
    clues: [
      'norse_riddle_valhalla_clue_1'.tr(),
      'norse_riddle_valhalla_clue_2'.tr(),
      'norse_riddle_valhalla_clue_3'.tr(),
    ],
  ),
  // 8 Letters
  NorseRiddle(
    name: 'GUNGNIR',
    clues: [
      'norse_riddle_gungnir_clue_1'.tr(),
      'norse_riddle_gungnir_clue_2'.tr(),
      'norse_riddle_gungnir_clue_3'.tr(),
    ],
  ),
  NorseRiddle(
    name: 'RAGNAROK',
    clues: [
      'norse_riddle_ragnarok_clue_1'.tr(),
      'norse_riddle_ragnarok_clue_2'.tr(),
      'norse_riddle_ragnarok_clue_3'.tr(),
    ],
  ),
  // 9 Letters
  NorseRiddle(
    name: 'YGGDRASIL',
    clues: [
      'norse_riddle_yggdrasil_clue_1'.tr(),
      'norse_riddle_yggdrasil_clue_2'.tr(),
      'norse_riddle_yggdrasil_clue_3'.tr(),
    ],
  ),
  NorseRiddle(
    name: 'VALKYRIES',
    clues: [
      'norse_riddle_valkyries_clue_1'.tr(),
      'norse_riddle_valkyries_clue_2'.tr(),
      'norse_riddle_valkyries_clue_3'.tr(),
    ],
  ),
  NorseRiddle(
    name: 'JOTUNHEIM',
    clues: [
      'norse_riddle_jotunheim_clue_1'.tr(),
      'norse_riddle_jotunheim_clue_2'.tr(),
      'norse_riddle_jotunheim_clue_3'.tr(),
    ],
  ),
  // 10 Letters
  NorseRiddle(
    name: 'NIDAVELLIR',
    clues: [
      'norse_riddle_nidavellir_clue_1'.tr(),
      'norse_riddle_nidavellir_clue_2'.tr(),
      'norse_riddle_nidavellir_clue_3'.tr(),
      'norse_riddle_nidavellir_clue_4'.tr(),
    ],
  ),
  NorseRiddle(
    name: 'HVERGELMIR',
    clues: [
      'norse_riddle_hvergelmir_clue_1'.tr(),
      'norse_riddle_hvergelmir_clue_2'.tr(),
      'norse_riddle_hvergelmir_clue_3'.tr(),
    ],
  ),
  // 11 Letters
  NorseRiddle(
    name: 'GJALLARHORN',
    clues: [
      'norse_riddle_gjallarhorn_clue_1'.tr(),
      'norse_riddle_gjallarhorn_clue_2'.tr(),
      'norse_riddle_gjallarhorn_clue_3'.tr(),
    ],
  ),
  NorseRiddle(
    name: 'JORMUNGANDR',
    clues: [
      'norse_riddle_jormungandr_clue_1'.tr(),
      'norse_riddle_jormungandr_clue_2'.tr(),
      'norse_riddle_jormungandr_clue_3'.tr(),
    ],
  ),
];
