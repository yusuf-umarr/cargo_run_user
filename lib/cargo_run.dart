import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';

class CargoRun extends StatelessWidget {
  CargoRun({super.key});

  final _appRouter = AppRouter();
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MaterialApp.router(
        // navigatorKey: CargoRun.navigatorKey,
        theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.config(),
        // routerDelegate: AutoRouterDelegate(
        //   _appRouter,
        //   navigatorObservers: () => [
        //     TalkerRouteObserver(talker),
        //   ],
        // ),
      ),
    );
  }
}
