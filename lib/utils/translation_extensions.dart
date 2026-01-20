import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/services/translation_service.dart';

/// Extension on String to provide translation functionality
/// Usage: 'key'.tr() or 'key'.trAsync()
extension StringTranslation on String {
  /// Synchronous translation using TranslationService
  /// Falls back to the key itself if translation not found
  String trAsync() {
    try {
      return getIt<TranslationService>().tr(this);
    } catch (e) {
      debugPrint('Translation error for key "$this": $e');
      return this;
    }
  }
}

/// Widget that rebuilds when translations are loaded
class TranslationBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) builder;

  const TranslationBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: getIt<TranslationService>(),
      builder: (context, _) => builder(context),
    );
  }
}
