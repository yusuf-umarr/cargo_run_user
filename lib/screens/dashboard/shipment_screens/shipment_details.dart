import 'package:another_stepper/another_stepper.dart';
import 'package:cargo_run/providers/order_provider.dart';
import 'package:cargo_run/screens/dashboard/home_screens/trip_route_page.dart';
import 'package:cargo_run/screens/dashboard/widget/cancel_order.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:cargo_run/widgets/page_widgets/appbar_widget.dart';
import 'package:cargo_run/widgets/page_widgets/payment_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/order.dart';

import 'dart:developer' as dev;

class ShipmentDetailsScreen extends StatefulWidget {
  final Order? order;
  const ShipmentDetailsScreen({super.key, required this.order});

  @override
  State<ShipmentDetailsScreen> createState() => _ShipmentDetailsScreenState();
}

class _ShipmentDetailsScreenState extends State<ShipmentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    dev.log("widget.order!.riderLocation here :${widget.order!.riderLocation}");

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
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20)
                          .copyWith(bottom: 20),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: primaryColor1),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: widget.order!.riderId?.profileImage !=
                                          null
                                      ? Image.network(
                                          widget.order!.riderId!.profileImage!,
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/images/profile-icon.png',
                                          height: 60,
                                          width: 60,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.order!.riderId?.fullName ?? "NIL ",
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.order!.riderId?.phone! ?? "NIL",
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: greyText,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  border: Border.all(color: primaryColor1),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  widget.order!.riderId?.vehicle?.plateNumber ??
                                      "NIL NIL NIL",
                                  style: const TextStyle(
                                    color: primaryColor1,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Order Id: ',
                              style: const TextStyle(
                                color: blackText,
                                fontSize: 13,
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
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              text: 'Order Status: ',
                              style: const TextStyle(
                                color: blackText,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: widget.order!.status!.toLowerCase() ==
                                          "picked"
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
                        ],
                      ),
                    ),
                    // const SizedBox(height: 20),
                    PaymentSummaryCard(
                      deliveryFee: widget.order!.price != null
                          ? widget.order!.price!.toStringAsFixed(2).toString()
                          : "0",
                      paymentStatus: widget.order!.paymentStatus!,
                    ),

                    if (widget.order!.paymentStatus!.toLowerCase() ==
                        "pending") ...[
                      if (widget.order!.status! == "picked" ||
                          widget.order!.status! == "accepted" ||
                          widget.order!.status! == "successful" ||
                          widget.order!.status! == "delivered" ||
                          widget.order!.status! == "arrived") ...[
                        Consumer<OrderProvider>(builder: (context, orderVM, _) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: orderVM.orderStatus == OrderStatus.loading
                                ? const SizedBox(
                                    child: LoadingButton(
                                      textColor:
                                          Color.fromARGB(255, 34, 18, 18),
                                      backgroundColor: primaryColor2,
                                    ),
                                  )
                                : AppButton(
                                    text: 'Pay now',
                                    hasIcon: false,
                                    textColor: Colors.white,
                                    backgroundColor: primaryColor2,
                                    onPressed: () {
                                      context
                                          .read<OrderProvider>()
                                          .initiatePayment(
                                            widget.order!.id!,
                                            widget.order!.price.toString(),
                                            context,
                                          );
                                    },
                                  ),
                          );
                        }),
                      ]
                    ],
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
                    const SizedBox(height: 20),
                    if (widget.order!.status!.toLowerCase() != "delivered") ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: AppButton(
                        text: 'Preview',
                        hasIcon: false,
                        textColor: Colors.white,
                        backgroundColor: primaryColor1.withOpacity(0.7),
                        onPressed: () {
                          // log("coordinate:${widget.order!.riderLocation!.lat}");
                          // log("coordinate:${widget.order!.riderLocation!.lng}");
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
                    if (widget.order!.status! == "pending") ...[
                      CancelOrderWidget(order: widget.order!),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
