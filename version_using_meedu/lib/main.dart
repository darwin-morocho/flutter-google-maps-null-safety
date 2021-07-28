import 'package:flutter/material.dart';
import 'package:google_maps/app/inject_dependencies.dart';
import 'package:google_maps/app/ui/routes/pages.dart';
import 'package:google_maps/app/ui/routes/routes.dart';
import 'package:flutter_meedu/router.dart' as router;

void main() {
  injectDependencies();
  router.setDefaultTransition(router.Transition.fadeIn);
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.SPLASH,
      navigatorKey: router.navigatorKey,
      navigatorObservers: [
        router.observer,
      ],
      routes: appRoutes,
    );
  }
}
