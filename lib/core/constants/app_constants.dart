class AppConstants {
  static const Map<String, Map<String, int>> fastingProtocols = {
    '12:12': {'fastHours': 12, 'eatHours': 12},
    '16:8': {'fastHours': 16, 'eatHours': 8},
    '18:6': {'fastHours': 18, 'eatHours': 6},
  };

  static const String themeKey = 'theme_mode';
  static const String onboardingKey = 'onboarding_done';
  static const String activeSessionKey = 'active_fast_session_id';

  static const int fastStartNotificationId = 1001;
  static const int fastEndNotificationId = 1002;
  static const int foregroundServiceNotificationId = 1003;

  static const String notificationChannelId = 'mamba_fasting_channel';
  static const String notificationChannelName = 'Jejum ativo';
}
