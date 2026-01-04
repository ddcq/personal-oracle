class AppEnv {
  static const String flagAds = String.fromEnvironment(
    'FLAG_ADS',
    defaultValue: 'disabled',
  );
}
