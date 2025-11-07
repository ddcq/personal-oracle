
import 'package:get_it/get_it.dart';
import 'package:oracle_d_asgard/services/cache_service.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/services/database_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => GamificationService());
  getIt.registerLazySingleton(() => SoundService());
  getIt.registerLazySingleton(() => DatabaseService());
  getIt.registerLazySingleton(() => CacheService());
}
