
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@example.com',
      query: 'subject=About Oracle d\'Asgard',
    );

    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'about_screen_appbar_title'.tr(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontFamily: AppTextStyles.amaticSC,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSectionTitle(context, 'about_screen_about_title'.tr()),
              _buildSectionContent(
                context,
                'about_screen_about_content'.tr(),
              ),
              _buildSectionTitle(context, 'about_screen_contribution_title'.tr()),
              _buildSectionContent(
                context,
                'about_screen_contribution_content'.tr(),
              ),
              _buildLink(context, 'about_screen_github_link'.tr(), 'https://github.com/ddcq/personal-oracle'),
              _buildSectionTitle(context, 'about_screen_legal_title'.tr()),
              _buildLink(context, 'about_screen_terms_link'.tr(), 'https://www.example.com/terms'),
              _buildLink(context, 'about_screen_privacy_link'.tr(), 'https://www.example.com/privacy'),
              ListTile(
                title: Text('about_screen_contact_us'.tr(), style: TextStyle(color: Colors.white, fontFamily: AppTextStyles.amaticSC, fontSize: 22)),
                trailing: Icon(Icons.email, color: Colors.white),
                onTap: _launchEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontFamily: AppTextStyles.amaticSC,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildSectionContent(BuildContext context, String content) {
    return Text(
      content,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
    );
  }

  Widget _buildLink(BuildContext context, String title, String url) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white, fontFamily: AppTextStyles.amaticSC, fontSize: 22)),
      trailing: Icon(Icons.open_in_new, color: Colors.white),
      onTap: () => _launchUrl(url),
    );
  }
}
