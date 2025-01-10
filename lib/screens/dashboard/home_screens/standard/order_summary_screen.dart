import 'dart:ui';

import 'package:another_stepper/another_stepper.dart';
import 'package:cargo_run/screens/bottom_nav/bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/order_provider.dart';
import '../../../../widgets/app_buttons.dart';
import '../../../../widgets/page_widgets/appbar_widget.dart';
import '../../../../styles/app_colors.dart';
import '../../../../widgets/page_widgets/payment_summary_card.dart';

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({super.key});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    List<StepperData> stepperData = [
      StepperData(
        title: StepperText( 
          "Pickup",
          textStyle: const TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: StepperText(
          orderProvider.currentOrder!.addressDetails!.landMark!,
          textStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        iconWidget: Container(
          decoration: const BoxDecoration(
              color: primaryColor1,
              borderRadius: BorderRadius.all(Radius.circular(30))),
        ),
      ),
      StepperData(
        title: StepperText(
          "Destination",
          textStyle: const TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: StepperText(
          orderProvider.currentOrder!.receiverDetails!.address!,
          textStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        iconWidget: Container(
          decoration: const BoxDecoration(
              color: primaryColor2,
              borderRadius: BorderRadius.all(Radius.circular(30))),
        ),
      ),
    ];
    return Scaffold(
        backgroundColor: const Color(0xffF3F3F3),
        appBar: appBarWidget(context, title: 'Order Summary', hasBackBtn:true),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Details', 
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AnotherStepper(
                        verticalGap: 45,
                        iconHeight: 10,
                        iconWidth: 10,
                        stepperList: stepperData,
                        stepperDirection: Axis.vertical,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: PaymentSummaryCard(
                    deliveryFee: '2000',
                    paymentStatus: 'Paid',
                    removeMargin: true,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: AppButton(
                    text: 'Confirm Order',
                    hasIcon: false,
                    textColor: Colors.white,
                    backgroundColor: primaryColor1,
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierColor: Colors.transparent,
                          builder: (context) {
                            return Dialog(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: const Center(
                                  child: SizedBox(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Text(
                                          'Order Confirmed',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text("We're connecting you to a rider"),
                                        SizedBox(height: 20),
                                        CupertinoActivityIndicator(
                                          radius: 25,
                                          color: primaryColor1,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                      Future.delayed(const Duration(seconds: 3), () {
                       // ignore: use_build_context_synchronously
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>const BottomNavBar()));
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),);
  }
}
