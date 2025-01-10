import 'package:cargo_run/providers/app_provider.dart';
import 'package:cargo_run/screens/onboard/auth_check.dart';
import 'package:cargo_run/screens/onboard/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CargoRun extends StatelessWidget {
  final String? usedApp;
  const CargoRun({super.key, this.usedApp});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.providers,
      child: MaterialApp(
          navigatorKey: CargoRun.navigatorKey,
          theme: ThemeData(
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: Colors.white,
          ),
          debugShowCheckedModeBanner: false,
          home: MyWidget(usedApp: usedApp)),
    );
  }
}

class MyWidget extends StatelessWidget {
  final String? usedApp;
  const MyWidget({super.key, this.usedApp});

  @override
  Widget build(BuildContext context) {
    if (usedApp != null) {
      return const AuthCheckScreen();
    }
    return const OnboardScreen();
  }
}
