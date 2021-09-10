import 'package:flutter/material.dart';
import 'package:flutter_meedu/flutter_meedu.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_controller.dart';
import 'package:google_maps/app/ui/pages/home/widgets/google_map.dart';
import 'package:flutter_meedu/meedu.dart';
import 'controller/home_state.dart';

final homeProvider = StateProvider<HomeController, HomeState>(
  (_) => HomeController(),
);

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, loadingWidget) {
          // only rebuild if the loading field changes
          final loading = ref.select(
            homeProvider.select((_) => _.loading),
          );
          if (loading) {
            return loadingWidget!;
          }
          return const MapView();
        },
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
