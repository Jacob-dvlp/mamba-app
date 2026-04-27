import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

import 'i_notification_service.dart';

class NotificationService implements INotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'mamba_fast';
  static const _channelName = 'Mamba Fast Tracker';
  static const _fastCompletionId = 1;
  static const _fastStartedId = 2;
  static const _fastCompletedId = 3;

  @override
  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  @override
  Future<void> showFastStarted({required Duration fastingDuration}) async {
    final hours = fastingDuration.inHours;
    await _plugin.show(
      _fastStartedId,
      'Jejum iniciado! 🚀',
      'Seu jejum de $hours horas começou. Você consegue!',
      _notificationDetails(),
    );
  }

  @override
  Future<void> showFastCompleted() async {
    await _plugin.show(
      _fastCompletedId,
      'Jejum concluído! 🎉',
      'Parabéns! Você completou seu jejum. Hora de comer com consciência.',
      _notificationDetails(),
    );
  }

  @override
  Future<void> scheduleFastCompletionNotification({
    required DateTime completionTime,
  }) async {
    if (completionTime.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      _fastCompletionId,
      'Jejum concluído! 🎉',
      'Você completou seu protocolo de jejum. Bom trabalho!',
      _toTZDateTime(completionTime),
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Notificações do Mamba Fast Tracker',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  _toTZDateTime(DateTime dateTime) {
    return dateTime;
  }
}
