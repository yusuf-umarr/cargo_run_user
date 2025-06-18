import 'dart:developer';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cargo_run/providers/bottom_nav_provider.dart';
import 'package:cargo_run/providers/order_provider.dart';
import 'package:cargo_run/screens/dashboard/home_screens/home_screen.dart';
import 'package:cargo_run/screens/dashboard/profile_screens/view_profile_screen.dart';
import 'package:cargo_run/screens/dashboard/shipment_screens/shipment_screen.dart';
import 'package:cargo_run/services/notification_service.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/env.dart';
import 'package:cargo_run/utils/shared_prefs.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:upgrader/upgrader.dart';

class BottomNavBar extends StatefulWidget {
  static const String routeName = '/bottomNav';
  const BottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  io.Socket? socket;

  List<Widget> pages = [
    const HomeScreen(),
    const ShipmentScreen(),
    const ViewProfileScreen(),
  ];

  @override
  void initState() {
    _connectSocket();
    Provider.of<OrderProvider>(context, listen: false).getOrders();
    Provider.of<OrderProvider>(context, listen: false).getNotification();
    Provider.of<OrderProvider>(context, listen: false).getPrice();
    super.initState();
  }

  @override
  void dispose() {
   disposeSocket();
    super.dispose();
  }

   void disposeSocket() {
    socket!.disconnect();
  }

  //connecting websocket
  void _connectSocket() async {
          final orderVM = Provider.of<OrderProvider>(context, listen: false);
    log("_connectSocket() started....");

    try {
      socket = io.io(Env.endpointUrlSocket, <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
        'forceNew': true,
        // 'Connection', 'upgrade'
      });

      socket!.connect();
      socket!.onConnect((data) {
        socket!.emit(
          'join',
          {
            "socketId": socket!.id!,
            "userId": sharedPrefs.userId,
            "type": "User"
          },
        );
        context.read<OrderProvider>().setSocketIo(socket);
        socket!.emit('order');
        socket!.on('join', (data) {
          log("on join=====:$data");
          log("on join=userId from user app====:${sharedPrefs.userId}"); //673b1ed9495935e124162eb6
        });
      });

      //fetch all notifications
      socket!.on(sharedPrefs.userId, (data) async {
        try {
          context.read<OrderProvider>().getOrders();
          Provider.of<OrderProvider>(context, listen: false).getNotification();

          await NotificationService.showNotification(
              title: "Order ",
              body: "${data['msg']}",
              payload: {
                "navigate": "true",
              },
              actionButtons: [
                NotificationActionButton(
                  key: 'Preview',
                  label: 'Preview',
                  actionType: ActionType.Default,
                  color: Colors.green,
                )
              ]);
        } catch (e) {
          log("notifications error:$e");
        }
      });

      //fetch ongoing ride rider's loaction
      // if (mounted) {
      socket!.on("${sharedPrefs.userId}-location", (data) async {

  
        // log("rider-location:${data['data']['lat']}");

        try {
          // var res = data['data'];
        orderVM.getOngoingRiderCoordinate(
                lat: data['data']['lat'],
                lng: data['data']['lng'],
              );
        } catch (e) {
          log(" get coordinate error:$e");
        }
      });
      // }
      socket!.on("payment-${sharedPrefs.userId}", (data) async {
        try {
          context.read<OrderProvider>().getOrders();
          Provider.of<OrderProvider>(context, listen: false).getNotification();

          await NotificationService.showNotification(
              title: "Payment ",
              body: "${data['msg']}",
              payload: {
                "navigate": "true",
              },
              actionButtons: [
                NotificationActionButton(
                  key: 'Preview',
                  label: 'Preview',
                  actionType: ActionType.Default,
                  color: Colors.green,
                )
              ]);
        } catch (e) {
          log("notifications error:$e");
        }
      });
      //get available rider in user's coordinate
      socket!.on("location-${sharedPrefs.userId}", (data) async {
        // log("get riders in my proximity:${data}");
        //get riders in my proximity:ing

        //
        try {
          if (mounted) {
            Future.delayed(const Duration(seconds: 1), () {
              context.read<OrderProvider>().getAvailableDrivers(data);
            });
          }
        } catch (e) {
          log("get riders error:$e");
        }
      });

      socket!.onAny(
        (event, data) {
          // print(
          //   "event:$event, data:$data",

          // log("event:$event, data:$data");
        },
      );
    } catch (e) {
      debugPrint("socket error:${e.toString()}");
    }
  }

//
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BottomNavProvider>();

    return PopScope(
      onPopInvokedWithResult: (a, b) {},
      canPop: false,
      child: UpgradeAlert(
        dialogStyle: UpgradeDialogStyle.cupertino,
        child: Scaffold(
          body: pages[provider.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: provider.currentIndex,
            selectedItemColor: primaryColor1,
            unselectedItemColor: Colors.black54,
            backgroundColor: Colors.white,
            showUnselectedLabels: true,
            selectedFontSize: 10.0,
            unselectedFontSize: 10.0,
            elevation: 5,
            onTap: (index) {
              provider.setNavbarIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.home_2,
                  size: 26,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.clipboard_text,
                  size: 26,
                ),
                label: 'Shipments',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.user,
                  size: 26,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
