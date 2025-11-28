import 'package:get_it/get_it.dart';
import 'package:oracle_d_asgard/services/cache_service.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/services/database_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Eager singleton for services that need to be initialized at startup
  final soundService = SoundService();
  await soundService.init();
  getIt.registerSingleton<SoundService>(soundService);

  // Lazy singletons for other services
  getIt.registerLazySingleton(() => GamificationService());
  getIt.registerLazySingleton(() => DatabaseService());
  getIt.registerLazySingleton(() => CacheService());
}
