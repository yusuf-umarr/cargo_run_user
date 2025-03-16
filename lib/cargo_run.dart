import 'package:cargo_run/providers/app_provider.dart';
import 'package:cargo_run/screens/onboard/auth_check.dart';
import 'package:cargo_run/screens/onboard/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CargoRun extends StatelessWidget {
  final String? usedApp;
  final String? token;
  const CargoRun({super.key, this.usedApp, this.token,});

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
          home: MyWidget(usedApp: usedApp, token:token),),
    );
  }
}

class MyWidget extends StatelessWidget {
  final String? usedApp;
  final String? token;
  const MyWidget({super.key, this.usedApp, this.token,});

  @override
  Widget build(BuildContext context) {
    if (usedApp != null) {
      return const AuthCheckScreen();
    }
    return const OnboardScreen();
  }
}
