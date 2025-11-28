import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:luarsekolah/core/services/local_notification_service.dart';

/// Service for (FCM)
class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Store FCM token
  String? _token;
  String? get token => _token;

  /// Initialize FCM and get token
  Future<void> initialize() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get FCM token
        _token = await _messaging.getToken();

        if (_token != null) {
          if (kDebugMode) {
            print('═══════════════════════════════════════════════════════');
            print('FCM Token:');
            print(_token);
            print('═══════════════════════════════════════════════════════');
          }
        } else {
          if (kDebugMode) {
            print(' Failed to get FCM token');
          }
        }

        _setupForegroundHandler();
      } else {
        if (kDebugMode) {
          print('FCM notification permission denied');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing FCM: $e');
      }
    }
  }

  /// Setup handler for FCM messages when app is in foreground
  void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('📩 FCM Message received (foreground):');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
      }

      // Extract notification data
      final notification = message.notification;
      if (notification != null) {
        final title = notification.title ?? 'Notification';
        final body = notification.body ?? '';

        // Timestamp as ID
        final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

        LocalNotificationService.instance.show(
          id: notificationId,
          title: title,
          body: body,
          channelId: 'fcm_channel',
          channelName: 'FCM Notifications',
          channelDescription: 'Notifikasi dari Firebase Cloud Messaging',
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
          presentSound: true,
        );
      }
    });
  }
}
