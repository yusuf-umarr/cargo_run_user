import 'dart:developer';

import 'package:another_stepper/another_stepper.dart';
import 'package:cargo_run/providers/app_provider.dart';
import 'package:cargo_run/providers/order_provider.dart';
import 'package:cargo_run/screens/dashboard/home_screens/trip_route_page.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:cargo_run/widgets/page_widgets/appbar_widget.dart';
import 'package:cargo_run/widgets/page_widgets/payment_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/order.dart';

class ShipmentDetailsScreen extends StatefulWidget {
  final Order? order;
  const ShipmentDetailsScreen({super.key, required this.order});

  @override
  State<ShipmentDetailsScreen> createState() => _ShipmentDetailsScreenState();
}

class _ShipmentDetailsScreenState extends State<ShipmentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    List<StepperData> stepperData = [
      StepperData(
        title: StepperText(
          widget.order!.addressDetails!.landMark!,
          textStyle: const TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: greyText,
            decorationThickness: 0.5,
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: primaryColor1,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: const Icon(Icons.looks_one, color: Colors.white),
        ),
      ),
      StepperData(
        title: StepperText(
          widget.order!.receiverDetails!.address!,
          textStyle: const TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: greyText,
            decorationThickness: 0.5,
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: primaryColor2,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: const Icon(Icons.looks_two, color: Colors.white),
        ),
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: appBarWidget(context, title: 'Order detail', hasBackBtn: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Order Id: ',
                      style: const TextStyle(
                        color: blackText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: widget.order!.orderId,
                          style: const TextStyle(
                            color: primaryColor1,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Order Status: ',
                      style: const TextStyle(
                        color: blackText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: widget.order!.status!.toLowerCase() == "picked"
                              ? "ON GOING"
                              : widget.order!.status!.toUpperCase(),
                          style: const TextStyle(
                            color: primaryColor1,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 5,
                  ),
                  child: AnotherStepper(
                    stepperList: stepperData,
                    stepperDirection: Axis.vertical,
                  ),
                ),
                if (widget.order!.status == "pending" ||
                    widget.order!.status == "delivered") ...[
                  //         Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  //   child: AppButton(
                  //     text: 'Get help with order',
                  //     hasIcon: false,
                  //     textColor: Colors.white,
                  //     backgroundColor: primaryColor1.withOpacity(0.7),
                  //     onPressed: () {
                  //       // Navigator.push(
                  //       //   context,
                  //       //   MaterialPageRoute(
                  //       //     builder: (context) => TripRoutePage(
                  //       //       order: widget.order!,
                  //       //     ),
                  //       //   ),
                  //       // );
                  //     },
                  //   ),
                  // ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: AppButton(
                      text: 'Preview',
                      hasIcon: false,
                      textColor: Colors.white,
                      backgroundColor: primaryColor1.withOpacity(0.7),
                      onPressed: () {
                        log("coordinate:${widget.order!.riderLocation!.lat}");
                        log("coordinate:${widget.order!.riderLocation!.lng}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripRoutePage(
                              order: widget.order!,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                PaymentSummaryCard(
                  deliveryFee: widget.order!.price != null
                      ? widget.order!.price!.toStringAsFixed(2).toString()
                      : "0",
                  paymentStatus: widget.order!.paymentStatus!,
                ),
                if (widget.order!.paymentStatus!.toLowerCase() ==
                    "pending") ...[
                  if (widget.order!.status! == "picked" ||
                          widget.order!.status! == "successful" ||
                          widget.order!.status! == "delivered"
                      // ||

                      // widget.order!.status! == "pending" ||
                      // widget.order!.status! == "accepted"

                      ) ...[
                    Consumer<OrderProvider>(builder: (context, orderVM, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: orderVM.orderStatus == OrderStatus.loading
                            ? const LoadingButton(
                                textColor: Colors.white,
                                backgroundColor: primaryColor2,
                              )
                            : AppButton(
                                text: 'Pay now',
                                hasIcon: false,
                                textColor: Colors.white,
                                backgroundColor: primaryColor2,
                                onPressed: () {
                                  context.read<OrderProvider>().initiatePayment(
                                        widget.order!.id!,
                                        widget.order!.price.toString(),
                                        context,
                                      );
                                },
                              ),
                      );
                    }),
                  ]
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
