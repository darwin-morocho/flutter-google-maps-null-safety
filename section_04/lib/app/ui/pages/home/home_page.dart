import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/data/providers/local/geolocator_wrapper.dart';
import 'package:google_maps/app/data/providers/remote/reverse_geocode_api.dart';
import 'package:google_maps/app/data/providers/remote/routes_api.dart';
import 'package:google_maps/app/data/repositories_impl/reverse_geocode_repository_impl.dart';
import 'package:google_maps/app/data/repositories_impl/routes_repository_impl.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_controller.dart';
import 'package:google_maps/app/ui/pages/home/widgets/google_map.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) {
        final dio = Dio();
        return HomeController(
          geolocator: GeolocatorWrapper(),
          routesRepository: RoutesRepositoryImpl(
            RoutesAPI(dio),
          ),
          reverseGeocodeRepository: ReverseGeocodeRepositoryImpl(
            ReverseGeocodeAPI(dio),
          ),
        );
      },
      child: Scaffold(
        body: Selector<HomeController, bool>(
          selector: (_, controller) => controller.state.loading,
          builder: (context, loading, loadingWidget) {
            if (loading) {
              return loadingWidget!;
            }
            return const MapView();
          },
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
