import 'dart:async';

import 'package:cargo_run/services/notification_service.dart';
import 'package:cargo_run/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'cargo_run.dart';
import 'utils/shared_prefs.dart';
import 'services/service_locator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  await NotificationService.initializeNotification();
   setupServiceLocator();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, 
  ]).then((_) {
    runApp(CargoRun(   usedApp: sharedPrefs.usedApp));
  });
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await NotificationService.initializeNotification();
//   await sharedPrefs.init();
//   setupServiceLocator();
//   runApp(CargoRun(   usedApp: sharedPrefs.usedApp));
// }
