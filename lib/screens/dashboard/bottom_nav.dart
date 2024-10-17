import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../providers/order_provider.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late OrderStatus _orderStatus;
  @override
  void initState() {
    _orderStatus = OrderStatus.loading;
    Provider.of<OrderProvider>(context, listen: false).getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        ShipmentRoute(),
        ViewProfileRoute(),
      ],
      transitionBuilder: (context, child, animation) => FadeTransition(
        opacity: animation,
        // the passed child is technically our animated selected-tab page
        child: child,
      ),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            elevation: 10,
            selectedItemColor: primaryColor1,
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) {
              // here we switch between tabs
              tabsRouter.setActiveIndex(index);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.home_2,
                  color: greyText,
                ),
                activeIcon: Icon(
                  Iconsax.home_2,
                  color: primaryColor1,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.clipboard_text,
                  color: greyText,
                ),
                activeIcon: Icon(
                  Iconsax.clipboard_text,
                  color: primaryColor1,
                ),
                label: 'Shipments',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.user,
                  color: greyText,
                ),
                activeIcon: Icon(
                  Iconsax.user,
                  color: primaryColor1,
                ),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
