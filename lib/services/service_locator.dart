import 'package:get_it/get_it.dart';

import 'authentication/auth_abstract.dart';
import 'authentication/auth_implementation.dart';
import 'orders/orders_abstract.dart';
import 'orders/orders_implementation.dart';
import 'user/user_abstract.dart';
import 'user/user_implementation.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<AuthService>(() => AuthImpl());
  serviceLocator.registerLazySingleton<UserService>(() => UserImpl());
  serviceLocator.registerLazySingleton<OrdersService>(() => OrdersImpl());
}
