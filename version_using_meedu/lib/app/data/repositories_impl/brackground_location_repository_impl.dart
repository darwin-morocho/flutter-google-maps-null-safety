import 'package:google_maps/app/data/navite_code/brackground_location.dart';
import 'package:google_maps/app/domain/repositories/brackground_location_repository.dart';

class BackgroundLocationRepositoryImpl implements BackgroundLocationRepository {
  final BackgroundLocation _backgroundLocation;

  BackgroundLocationRepositoryImpl(this._backgroundLocation);

  @override
  Future<void> startForegroundService() {
    return _backgroundLocation.startForegroundService();
  }

  @override
  Future<void> stopForegroundService() {
   return _backgroundLocation.stopForegroundService();
  }
}
