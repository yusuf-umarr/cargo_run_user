import 'package:cargo_run/models/order.dart';
import 'package:cargo_run/providers/order_provider.dart';
import 'package:cargo_run/screens/bottom_nav/bottom_nav_bar.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/util.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CancelOrderWidget extends StatelessWidget {
  const CancelOrderWidget({
    super.key,
    required this.order,
  });

  final  Order order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child:
          Consumer<OrderProvider>(builder: (context, orderVM, _) {
        if (orderVM.orderStatus == OrderStatus.loading) {
          return const LoadingButton(
            backgroundColor: primaryColor1,
            textColor: Colors.white,
          );
        }
    
        return AppButton(
          text: 'Cancel order',
          hasIcon: false,
          textColor: Colors.white,
          backgroundColor: primaryColor1,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Cancel Order'),
                  content: const Text(
                      'Are you sure you want to cancel this order?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                          // Navigator.pop(context);
                        context
                            .read<OrderProvider>()
                            .cancelOrder(order.id!)
                            .then((x) {
                              showSnackBar(context, message: 'Order canceled', color: primaryColor1);
                          Future.delayed(
                              const Duration(seconds: 2), () {
                            if (orderVM.orderStatus ==
                                OrderStatus.success) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BottomNavBar(),
                                ),
                              );
                            }
                          });
                        });
                      
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                );
              },
            );
          },
        );
      }),
    );
  }
}