import 'package:flutter/material.dart';
import 'package:flutter_meedu/state.dart';
import 'package:google_maps/app/ui/pages/splash/splash_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_meedu/page.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:flutter_meedu/router.dart' as router;

final splashProvider = SimpleProvider(
  (_) => SplashController(_.arguments as Permission),
);

class SplashPage extends PageWithArgumentsWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  void onInit(RouteSettings settings) {
    splashProvider.setArguments(Permission.locationWhenInUse);
  }

  @override
  Widget build(BuildContext context) {
    return ProviderListener<SplashController>(
      provider: splashProvider,
      onAfterFirstLayout: (_, controller) {
        controller.checkPermission();
      },
      onChange: (_, controller) {
        if (controller.routeName != null) {
          router.pushReplacementNamed(controller.routeName!);
        }
      },
      builder: (_, controller) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
