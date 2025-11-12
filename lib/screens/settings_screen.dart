import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';



import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/app_restart_wrapper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _shareApp() async {
    const String appLink = 'https://play.google.com/store/apps/details?id=net.forhimandus.oracledasgard';
    await SharePlus.instance.share(ShareParams(text: 'settings_screen_share_text'.tr(namedArgs: {'appLink': appLink})));
  }

  Future<void> _rateApp() async {
    await _launchUrl('https://play.google.com/store/apps/details?id=net.forhimandus.oracledasgard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            context.go('/');
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: Container(
          color: Colors.black.withAlpha(128),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
            _buildSectionTitle('profile_screen_settings'.tr()),
            _buildSoundSettings(),
            const SizedBox(height: 10),
            _buildLanguageSettings(),
            const SizedBox(height: 20),
            _buildSectionTitle('settings_screen_support_us_title'.tr()),
            Column(
              children: [
                _buildLink('settings_screen_support_kofi'.tr(), 'https://ko-fi.com/forhimandus'),
                _buildLink('settings_screen_support_buymeacoffee'.tr(), 'https://buymeacoffee.com/ddcq'),
                ListTile(
                  title: Text('settings_screen_share_app'.tr(), style: const TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.share, color: Colors.white),
                  onTap: _shareApp,
                ),
                ListTile(
                  title: Text('settings_screen_rate_app'.tr(), style: const TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.star, color: Colors.white),
                  onTap: _rateApp,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text('settings_screen_about_button'.tr(), style: const TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.info_outline, color: Colors.white),
              onTap: () => context.go('/about'),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
          fontFamily: AppTextStyles.amaticSC,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 40,
          letterSpacing: 2.0,
          shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLink(String title, String url) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.open_in_new, color: Colors.white),
      onTap: () => _launchUrl(url),
    );
  }

  Widget _buildSoundSettings() {
    final soundService = getIt<SoundService>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'profile_screen_ambient_music'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: AppTextStyles.amaticSC, fontSize: 22),
          ),
          ListenableBuilder(
            listenable: soundService,
            builder: (context, child) {
              return Switch(
                value: !soundService.isMuted,
                onChanged: (value) {
                  soundService.setMuted(!value);
                },
                activeTrackColor: Colors.green,
                inactiveTrackColor: Colors.grey,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSettings() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'profile_screen_language'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: AppTextStyles.amaticSC, fontSize: 22),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<Locale>(
              value: context.locale,
              underline: const SizedBox(),
              dropdownColor: Colors.black87,
              items: [
                DropdownMenuItem(
                  value: const Locale('en', 'US'),
                  child: Row(
                    children: [
                      Text('🇺🇸', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text('profile_screen_language_english'.tr(), style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: const Locale('fr', 'FR'),
                  child: Row(
                    children: [
                      Text('🇫🇷', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text('profile_screen_language_french'.tr(), style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: const Locale('es', 'ES'),
                  child: Row(
                    children: [
                      Text('🇪🇸', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text('profile_screen_language_spanish'.tr(), style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
              onChanged: (Locale? newLocale) async {
                if (newLocale != null && newLocale != context.locale) {
                  await context.setLocale(newLocale);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('language_code', newLocale.languageCode);
                  await prefs.setString('country_code', newLocale.countryCode ?? '');
                  
                  // Restart the app to apply language changes everywhere
                  if (mounted) {
                    AppRestartWrapper.restartApp(context);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
