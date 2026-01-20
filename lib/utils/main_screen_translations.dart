/// Hard-coded translations for main screen to ensure instant loading
class MainScreenTranslations {
  static const Map<String, Map<String, String>> translations = {
    'en_US': {
      'main_screen_title': 'Oracle of Asgard',
      'main_screen_play': "Let's Play",
      'main_screen_trophies': 'Trophies',
      'main_screen_profile': 'Profile',
      'main_screen_guardian_deity': 'My Guardian Deity',
      'main_screen_settings': 'Settings',
      'main_screen_rewards': 'My Rewards',
    },
    'fr_FR': {
      'main_screen_title': "Oracle d'Asgard",
      'main_screen_play': 'Mini-jeux',
      'main_screen_trophies': 'Trophées',
      'main_screen_profile': 'Profil',
      'main_screen_guardian_deity': 'Ma divinité gardienne',
      'main_screen_settings': 'Paramètres',
      'main_screen_rewards': 'Mes récompenses',
    },
    'es_ES': {
      'main_screen_title': 'Oráculo de Asgard',
      'main_screen_play': 'Jugar',
      'main_screen_trophies': 'Trofeos',
      'main_screen_profile': 'Perfil',
      'main_screen_guardian_deity': 'Mi Deidad Guardiana',
      'main_screen_settings': 'Ajustes',
      'main_screen_rewards': 'Mis Recompensas',
    },
  };

  static String translate(String key, String locale) {
    final localeKey = locale.replaceAll('-', '_');
    return translations[localeKey]?[key] ?? translations['en_US']?[key] ?? key;
  }
}
