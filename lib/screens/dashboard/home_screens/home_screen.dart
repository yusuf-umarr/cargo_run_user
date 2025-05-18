import 'package:cargo_run/providers/order_provider.dart';
import 'package:cargo_run/screens/dashboard/avatar_glow.dart';
import 'package:cargo_run/screens/dashboard/home_screens/notification_screen.dart';
import 'package:cargo_run/screens/dashboard/home_screens/standard/request_rider.dart';
import 'package:cargo_run/screens/dashboard/home_screens/map_widget.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/location.dart';
import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:cargo_run/widgets/page_widgets/delivery_card.dart';
import 'package:cargo_run/widgets/page_widgets/tracking_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String getFirstWord(String input) {
    return input.split(" ").first;
  }

  int history = 0;
  String greeting = '';
  DateTime now = DateTime.now();

  bool isTyping = false;

  @override
  void initState() {
    // startCountdown();
    getPosition();
    Provider.of<OrderProvider>(context, listen: false).getOrders();

    setState(() {
      greeting = switch (now.hour) {
        >= 6 && < 12 => 'Good Morning,',
        >= 12 && < 18 => 'Good Afternoon,',
        _ => 'Good Evening,',
      };
    });

    super.initState();
  }

  void getPosition() async {
    Position position = await determinePosition();
    if (mounted) {
      context.read<OrderProvider>().setLocationCoordinate(
            lat: position.latitude,
            long: position.longitude,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final OrderProvider orderVM = context.watch<OrderProvider>();
    if (orderVM.availableDriverList.isEmpty) {
      getPosition();
    }
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.35,
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 30.0,
              ),
              decoration: const BoxDecoration(
                color: primaryColor1,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: primaryColor2,
                        child: Center(
                          child: Text(
                            sharedPrefs.fullName.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //automated greeting text that is in sync with the time of the day
                          Text(
                            greeting,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            getFirstWord(sharedPrefs.fullName),
                            style: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                        child: const Icon(
                          Iconsax.notification,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  trackingTextField(),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
            if (!isTyping)
              SizedBox(
                height: size.height * 0.4,
              ),
            // SizedBox(height: size.height * 0.05),
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<OrderProvider>(builder: (context, orderVM, _) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'Tracking History',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: blackText,
                          ),
                        ),
                      ),
                      if (isTyping) ...[
                        ...List.generate(orderVM.searcheOrders.length,
                            (int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TrackingCard(
                              order: orderVM.orders[index]!,
                            ),
                          );
                        }),
                      ] else ...[
                        Consumer<OrderProvider>(builder: (context, orderVM, _) {
                          orderVM.orders.sort((a, b) {
                            // Prioritize "pending" orders
                            if (a!.status == 'pending' &&
                                b!.status != 'pending') {
                              return -1;
                            } else if (a.status != 'pending' &&
                                b!.status == 'pending') {
                              return 1;
                            } else {
                              // If both have the same status, sort by createdAt in descending order
                              return b!.createdAt!.compareTo(
                                a.createdAt!,
                              );
                            }
                          });

                          if (orderVM.orders.isNotEmpty) {
                            return Column(
                              children: List.generate(orderVM.orders.length,
                                  (int index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TrackingCard(
                                    order: orderVM.orders[index]!,
                                  ),
                                );
                              }),
                            );
                          }
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text(
                                'No Tracking History',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          );
                        }),
                      ]
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
        if (!isTyping)
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<OrderProvider>(builder: (context, orderVM, _) {
                  return SizedBox(
                    child: Builder(
                      builder: (context) {
                        orderVM.orders.sort((a, b) {
                          if (a!.status == 'pending' &&
                              b!.status != 'pending') {
                            return -1;
                          } else if (a.status != 'pending' &&
                              b!.status == 'pending') {
                            return 1;
                          } else {
                            return b!.createdAt!.compareTo(a.createdAt!);
                          }
                        });

                        if (orderVM.orders.isNotEmpty) {
                          bool hasPendingOrder = orderVM.orders
                              .any((order) => order!.status == "pending");

                          return Builder(builder: (context) {
                            return SizedBox(
                              height: size.height * 0.48,
                              child: Stack(
                                children: [
                                  if (hasPendingOrder) ...[
                                    SafeArea(
                                        child: MapWidget(
                                            order: orderVM.orders.first!)),
                                    SizedBox(
                                      height: size.height * 0.3,
                                      width: size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AvatarGlow(
                                            glowColor: greenColor,
                                            glowRadiusFactor: 2.5,
                                            glowCount: 8,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 25),
                                              child: Image.asset(
                                                'assets/images/confirmation.png',
                                                height: 8,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ] else ...[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: size.height * 0.15),
                                      child: SizedBox(
                                          height: size.height * 0.25,
                                          child: createRequest(context)),
                                    )
                                  ]
                                ],
                              ),
                            );
                          });
                        }

                        return createRequest(context);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }

  Row createRequest(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            context.read<OrderProvider>().setDeliveryService("standard");

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RequestRider(type: 'standard'),
              ),
            );
          },
          child: const DeliveryServiceCard(
            image: 'ds1.png',
            text: 'Create request',
          ),
        ),
      ],
    );
  }

  Widget trackingTextField() {
    return Consumer<OrderProvider>(builder: (context, orderVM, _) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                readOnly: orderVM.orders.isEmpty,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter Tracking Number',
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  orderVM.trackOrders(value);
                  if (value.isNotEmpty) {
                    setState(() {
                      isTyping = true;
                    });
                  } else {
                    setState(() {
                      isTyping = false;
                    });
                  }
                },
              ),
            ),
            const Icon(Iconsax.location, color: primaryColor2),
          ],
        ),
      );
    });
  }
}
