import 'package:cargo_run/services/notification_service.dart';
import 'package:cargo_run/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cargo_run.dart';
import 'utils/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  await NotificationService.initializeNotification();
  setupServiceLocator();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(CargoRun(
      usedApp: sharedPrefs.usedApp,
      token: sharedPrefs.token,
    ));
  });
}


//com.cargo_run.app

//com.cargorun.user..app 

//com.cargo_run.app