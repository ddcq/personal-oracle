
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = 'oracle_d_asgard_channel';
  static const channelName = 'Oracle d\'Asgard';
  static const channelDescription = 'Notifications pour l\'Oracle d\'Asgard';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      final AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      );

      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsIOS,
      );

      // Initialize timezones only once and in a safe way
      tz.initializeTimeZones();
      
      // Use UTC as fallback if local timezone fails
      try {
        tz.setLocalLocation(tz.getLocation('Europe/Paris'));
      } catch (e) {
        tz.setLocalLocation(tz.UTC);
      }

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      );
      
      _isInitialized = true;
    } catch (e) {
      // Silently fail - notifications are not critical for app startup
      _isInitialized = false;
    }
  }

  Future<void> scheduleNotification() async {
    if (!_isInitialized) {
      await init();
      if (!_isInitialized) return; // Still not initialized, skip
    }

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Odin s\'ennuie de vous !',
        'Cela fait un moment que nous ne vous avons pas vu. Relevez de nouveaux défis !',
        tz.TZDateTime.now(tz.local).add(const Duration(hours: 48)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            largeIcon: DrawableResourceAndroidBitmap('odin_notification'),
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      // Silently fail - non-critical feature
    }
  }

  Future<void> cancelAllNotifications() async {
    if (!_isInitialized) return; // Skip if not initialized
    
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      // Silently fail - non-critical feature
    }
  }
}
