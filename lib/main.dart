import 'dart:async';

import 'package:cargo_run/services/service_locator.dart';
import 'package:flutter/material.dart';

import 'cargo_run.dart';
import 'utils/shared_prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  setupServiceLocator();
  runApp(CargoRun());
}
