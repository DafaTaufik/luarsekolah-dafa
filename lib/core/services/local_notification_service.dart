import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance = LocalNotificationService._();

  // Flutter Local Notifications Plugin
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _createNotificationChannel();

    _isInitialized = true;
  }

  /// Create a notification channel
  Future<void> createChannel(AndroidNotificationChannel channel) async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(channel);
  }

  /// Create default notification channels
  Future<void> _createNotificationChannel() async {
    // Default channels
    const defaultChannels = [
      AndroidNotificationChannel(
        'todo_channel',
        'Todo Notifications',
        description: 'Notifikasi untuk perubahan todo',
        importance: Importance.defaultImportance,
        enableVibration: false,
        playSound: false,
      ),
      AndroidNotificationChannel(
        'fcm_channel',
        'FCM Notifications',
        description: 'Notifikasi dari Firebase Cloud Messaging',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      ),
    ];

    for (final channel in defaultChannels) {
      await createChannel(channel);
    }
  }

  void _onNotificationTapped(NotificationResponse response) {}

  /// Check if notification permission is granted
  Future<bool> checkPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Generate notification ID
  int generateNotificationId(String uniqueKey) {
    return uniqueKey.hashCode.abs();
  }

  /// Base method to show notification
  Future<void> _showNotificationWithDetails({
    required int id,
    required String title,
    required String body,
    required NotificationDetails details,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    final hasPermission = await checkPermission();
    if (!hasPermission) return;

    await _notificationsPlugin.show(id, title, body, details);
  }

  /// Show notification with custom channel and settings
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    String? channelDescription,
    Importance importance = Importance.defaultImportance,
    Priority priority = Priority.defaultPriority,
    bool enableVibration = false,
    bool playSound = false,
    bool presentAlert = true,
    bool presentBadge = true,
    bool presentSound = false,
  }) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: importance,
        priority: priority,
        enableVibration: enableVibration,
        playSound: playSound,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: presentAlert,
        presentBadge: presentBadge,
        presentSound: presentSound,
      ),
    );

    await _showNotificationWithDetails(
      id: id,
      title: title,
      body: body,
      details: notificationDetails,
    );
  }
}
