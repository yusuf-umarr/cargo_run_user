import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/app_router.gr.dart';
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

    io.Socket? _socket;

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

    void connectSocket() async {
    final chatVM = context.read<OrderProvider>();
    try {
      //http://192.168.43.39:8080
      //https://same-faith-api.onrender.com
      _socket = io.io('https://same-faith-api.onrender.com', <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
        'forceNew': true,
        // 'Connection', 'upgrade'
      });

      _socket!.connect();
      _socket!.onConnect((da) {
        _socket!.emit('join', {"name": "currentUserId", "type": "Users"});
        _socket!.on('join', (data) {
          // log("joined=====:$data");
        });
        chatVM.setSocketIo(_socket);

        // _socket!.on('broadcastMessage', (data) async {
        //   String userId = await chatVM.localCache.read(key: "userId") ?? "";

        //   // Check if the incoming message is intended for the current user
        //   if (userId == data['recipientId']) {
        //     if (data['chatId'] == chatVM.chatId) {
            

        //       // chatVM.setIncomingMessage(mssg);
        //     }
        //   }
        // });
      });

      _socket!.onAny(
        (event, data) {
          // print(
          //   "event:$event, data:$data",
          // );
          // log(
          //   "event:$event, data:$data",
          // );
        },
      );
    } catch (e) {
      debugPrint("socket error:${e.toString()}");
    }
  }

  @override
  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    super.dispose();
  }
}
