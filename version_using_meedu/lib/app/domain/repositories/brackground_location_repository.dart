abstract class BackgroundLocationRepository {
  Future<void> startForegroundService();
  Future<void> stopForegroundService();
}
