import 'package:dio/dio.dart';
import 'package:flutter_meedu/flutter_meedu.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:google_maps/app/data/navite_code/brackground_location.dart';
import 'package:google_maps/app/data/providers/local/geolocator_wrapper.dart';
import 'package:google_maps/app/data/providers/remote/reverse_geocode_api.dart';
import 'package:google_maps/app/data/providers/remote/routes_api.dart';
import 'package:google_maps/app/data/providers/remote/search_api.dart';
import 'package:google_maps/app/data/repositories_impl/brackground_location_repository_impl.dart';
import 'package:google_maps/app/data/repositories_impl/reverse_geocode_repository_impl.dart';
import 'package:google_maps/app/data/repositories_impl/routes_repository_impl.dart';
import 'package:google_maps/app/data/repositories_impl/search_repository_impl.dart';
import 'package:google_maps/app/domain/repositories/reverse_geocode_repository.dart';
import 'package:google_maps/app/domain/repositories/routes_repository.dart';
import 'package:google_maps/app/domain/repositories/search_repository.dart';
import 'domain/repositories/brackground_location_repository.dart';

void injectDependencies() {
  final dio = Dio();
  Get.i.lazyPut<GeolocatorWrapper>(
    () => GeolocatorWrapper(),
  );

  Get.i.lazyPut<ReverseGeocodeRepository>(
    () => ReverseGeocodeRepositoryImpl(
      ReverseGeocodeAPI(dio),
    ),
  );

  Get.i.lazyPut<RoutesRepository>(
    () => RoutesRepositoryImpl(
      RoutesAPI(dio),
    ),
  );

  Get.i.lazyPut<SearchRepository>(
    () => SearchRepositoryImpl(
      SearchAPI(dio),
    ),
  );

  Get.i.lazyPut<BackgroundLocationRepository>(
    () => BackgroundLocationRepositoryImpl(
      BackgroundLocation(),
    ),
  );
}
