import 'package:luarsekolah/core/services/local_notification_service.dart';

enum TodoNotificationType { created, toggled, deleted }

class SendTodoNotificationUseCase {
  final LocalNotificationService _notificationService;

  SendTodoNotificationUseCase(this._notificationService);

  /// Use case send notification based on type, todo text, and todo ID
  Future<void> call({
    required TodoNotificationType type,
    required String todoText,
    required String todoId,
  }) async {
    final (title, body) = _getNotificationContent(type, todoText);
    final notificationId = _notificationService.generateNotificationId(todoId);

    await _notificationService.show(
      id: notificationId,
      title: title,
      body: body,
      channelId: 'todo_channel',
      channelName: 'Todo Notifications',
      channelDescription: 'Notifikasi untuk perubahan todo',
    );
  }

  /// Get notification content based on type
  (String title, String body) _getNotificationContent(
    TodoNotificationType type,
    String todoText,
  ) {
    switch (type) {
      case TodoNotificationType.created:
        return ('Todo successfully created', 'Todo "$todoText" has been added');
      case TodoNotificationType.toggled:
        return ('Todo updated', 'Todo "$todoText" status has been changed');
      case TodoNotificationType.deleted:
        return (
          'Todo successfully deleted',
          'Todo "$todoText" has been deleted',
        );
    }
  }
}
