import 'package:cargo_run/providers/order_provider.dart';
import 'package:cargo_run/screens/dashboard/home_screens/notification_screen.dart';
import 'package:cargo_run/screens/dashboard/home_screens/standard/request_rider.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:cargo_run/widgets/page_widgets/delivery_card.dart';
import 'package:cargo_run/widgets/page_widgets/tracking_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int history = 0;
  String greeting = '';
  DateTime now = DateTime.now();

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
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
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: primaryColor2,
                      child: Center(
                        child: Text(
                          'EO',
                          style: TextStyle(color: Colors.white, fontSize: 25),
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
                          sharedPrefs.fullName,
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
                                builder: (context) =>
                                    const NotificationScreen()));
                      },
                      child: const Icon(
                        Iconsax.notification,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60.0),
                trackingTextField(),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select your Preferred Delivery Service',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: blackText,
                  ),
                ),
                GridView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  children: [
                    GestureDetector(
                      onTap: () {
                        context
                            .read<OrderProvider>()
                            .setDeliveryService("standard");

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const RequestRider(type: 'standard'),
                          ),
                        );
                      },
                      child: const DeliveryServiceCard(
                        image: 'ds1.png',
                        text: 'Standard Delivery',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context
                            .read<OrderProvider>()
                            .setDeliveryService("bulk");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const RequestRider(type: 'bulk'),
                          ),
                        );
                      },
                      child: const DeliveryServiceCard(
                        image: 'ds2.png',
                        text: 'Bulk Shipping',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
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

          Consumer<OrderProvider>(builder: (context, otherVM, _) {
            otherVM.orders
                .sort((a, b) => b!.createdAt!.compareTo(a!.createdAt!));

            if (otherVM.orders.isNotEmpty) {
              return Column(
                children: List.generate(otherVM.orders.length, (int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TrackingCard(
                      order: otherVM.orders[index]!,
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
          // Expanded(
          //   child: Consumer<OrderProvider>(builder: (context, watch, _) {
          //     if (watch.orders.isNotEmpty) {
          //       return ListView.builder(
          //         padding:
          //             const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
          //         itemCount: watch.orders.length,
          //         itemBuilder: (context, index) => Padding(
          //           padding: const EdgeInsets.symmetric(vertical: 8.0),
          //           child: TrackingCard(
          //             order: watch.orders[index]!,
          //           ),
          //         ),
          //       );
          //     }
          //     return const Center(
          //       child: Text(
          //         'No Tracking History',
          //         style: TextStyle(
          //           fontSize: 20,
          //         ),
          //       ),
          //     );
          //   }),
          // ),
        ],
      ),
    );
  }

  Widget trackingTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Enter Tracking Number',
                hintStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Iconsax.location, color: primaryColor2),
        ],
      ),
    );
  }
}
