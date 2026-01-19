import 'package:get_it/get_it.dart';
import 'package:oracle_d_asgard/services/cache_service.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/services/database_service.dart';
import 'package:oracle_d_asgard/services/video_cache_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<SoundService>(() => SoundService());
  getIt.registerLazySingleton(() => GamificationService());
  getIt.registerLazySingleton(() => DatabaseService());
  getIt.registerLazySingleton(() => CacheService());
  getIt.registerLazySingleton(() => VideoCacheService());
}
