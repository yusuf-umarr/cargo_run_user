import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/app_router.gr.dart';
import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../providers/order_provider.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late OrderStatus _orderStatus;

    io.Socket? socket;

  @override
  void initState() {
     _connectSocket() ;
    _orderStatus = OrderStatus.loading;
    Provider.of<OrderProvider>(context, listen: false).getOrders();
    super.initState();
  }

    //connecting websocket
  void _connectSocket() async {
    log("_connectSocket() started....");


    try {
      socket = io.io(
          "https://cargo-run-test-31c2cf9f78e4.herokuapp.com",
          <String, dynamic>{
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
            "type": "Rider"
          },
        );
        context.read<OrderProvider>().setSocketIo(socket);
        socket!.emit(
          'order'
        );
        socket!.on('join', (data) {
          log("on join=====:${data}");
        });
      });

      //fetch all orders
      socket!.on('order', (data) {
        try {
          log("message${data.runtimeType}");
            //  var jsonResponse = jsonDecode(data);
         var res = data['data'];
          // context.read<OrderProvider>().getOrderData(res);
         
        } catch (e) {
          // log("orders error:${e}");
        }
      });

   

      socket!.onAny(
        (event, data) {
          // print(
          //   "event:$event, data:$data",
          // );
          // log(
          //   "event:$event, data:$data"
          // );
        },
      );
    } catch (e) {
      debugPrint("socket error:${e.toString()}");
    }
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


  @override
  void dispose() {
    socket?.disconnect();
    socket?.dispose();
    super.dispose();
  }
}
