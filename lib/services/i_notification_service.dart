abstract class INotificationService {
  Future<void> initialize();
  Future<void> showFastStarted({required Duration fastingDuration});
  Future<void> showFastCompleted();
  Future<void> cancelAll();
  Future<void> scheduleFastCompletionNotification({
    required DateTime completionTime,
  });
}