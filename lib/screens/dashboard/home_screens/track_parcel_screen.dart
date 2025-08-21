// ignore_for_file: use_build_context_synchronously

import 'package:another_stepper/another_stepper.dart';
import 'package:cargo_run/providers/order_provider.dart';
import 'package:cargo_run/screens/bottom_nav/bottom_nav_bar.dart';
import 'package:cargo_run/screens/dashboard/home_screens/trip_route_page.dart';
import 'package:cargo_run/utils/util.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:cargo_run/widgets/page_widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/order.dart';
import '../../../styles/app_colors.dart';
import 'dart:developer' as dev;

class TrackParcelScreen extends StatefulWidget {
  final Order order;
  const TrackParcelScreen({
    super.key,
    required this.order,
  });

  @override
  State<TrackParcelScreen> createState() => _TrackParcelScreenState();
}

class _TrackParcelScreenState extends State<TrackParcelScreen> {
  List<StepperData> stepperData = [];
  int activeStep = 0;

  @override
  initState() {
    if (widget.order.status == "accepted") {
      activeStep = 1;
    } else if (widget.order.status == "picked") {
      activeStep = 2;
    } else if (widget.order.status == "arrived") {
      activeStep = 3;
    } else if (widget.order.status == "delivered") {
      activeStep = 4;
    }

    stepperData = [
      StepperData(
        title: StepperText(
          "Request Accepted",
          textStyle: const TextStyle(
            color: blackText,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: StepperText(
          "Rider is on his way to pickup point.",
          textStyle: TextStyle(
            color: activeStep >= 1 ? primaryColor1 : greyText,
            fontSize: 16,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: activeStep >= 1 ? primaryColor1 : greyText,
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
      ),
      StepperData(
        title: StepperText(
          "On the Way",
          textStyle: const TextStyle(
            color: blackText,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: StepperText(
          "Your parcel has been picked up.",
          textStyle: TextStyle(
            color: activeStep >= 2 ? primaryColor1 : greyText,
            fontSize: 16,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: activeStep >= 2 ? primaryColor1 : greyText,
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
      ),
      StepperData(
        title: StepperText(
          "Rider has Arrived",
          textStyle: const TextStyle(
            color: blackText,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: StepperText(
          "Rider is outside to deliver your parcel.",
          textStyle: TextStyle(
            color: activeStep >= 3 ? primaryColor1 : greyText,
            fontSize: 16,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: activeStep >= 3 ? primaryColor1 : greyText,
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
      ),
      StepperData(
        title: StepperText(
          "Parcel Delivered",
          textStyle: const TextStyle(
            color: blackText,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: StepperText(
          "Your parcel has been delivered successfully.",
          textStyle: TextStyle(
            color: activeStep >= 4 ? primaryColor1 : greyText,
            fontSize: 16,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: activeStep >= 4 ? primaryColor1 : greyText,
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
      ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dev.log("widget.order.riderLocation:${widget.order.riderLocation}");
    return Scaffold(
      appBar:
          appBarWidget(context, title: 'Track Your Parcel', hasBackBtn: true),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                          child: widget.order.riderId?.profileImage != null
                              ? InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: const EdgeInsets.all(20),
                                        child: GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.white,
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: InteractiveViewer(
                                              child: Image.network(
                                                widget.order.riderId!
                                                    .profileImage!,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    widget.order.riderId!.profileImage!,
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/profile-icon.png',
                                  height: 60,
                                  width: 60,
                                ),
                        ),
                      )

                      // Container(
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     border: Border.all(color: primaryColor1),
                      //   ),
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(100),
                      //     child: widget.order.riderId?.profileImage != null
                      //         ? InkWell(
                      //           onTap:(){
                      //             //add a popup dialog and show the image
                      //           },
                      //           child: Image.network(
                      //               widget.order.riderId!.profileImage!,
                      //               height: 60,
                      //               width: 60,
                      //               fit: BoxFit.cover,
                      //             ),
                      //         )
                      //         : Image.asset(
                      //             'assets/images/profile-icon.png',
                      //             height: 60,
                      //             width: 60,
                      //           ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.order.riderId?.fullName ??
                            "Pending (Waiting for Driver)",
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: primaryColor1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.order.riderId?.phone! ?? "NIL",
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
                          widget.order.riderId?.vehicle?.plateNumber ??
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${widget.order.orderId}',
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor1,
                    ),
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 3),
                        child: Text(
                          'Payment status:',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        widget.order.paymentStatus!.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: primaryColor2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              // SizedBox(
              //   height: 10,
              // ),
              // if (widget.order.riderLocation != null) ...[
                if (widget.order.paymentStatus == "pending") ...[
                  if (widget.order.status!.toLowerCase() == "accepted" ||
                      widget.order.status!.toLowerCase() == "picked" ||
                      widget.order.status!.toLowerCase() == "arrived" ||
                      widget.order.status!.toLowerCase() == "delivered") ...[
                    Consumer<OrderProvider>(builder: (context, orderVM, _) {
                      if (orderVM.orderStatus == OrderStatus.loading) {
                        return const LoadingButton(
                          backgroundColor: primaryColor2,
                          textColor: Colors.white,
                        );
                      }

                      return AppButton(
                        text: 'Pay now',
                        hasIcon: false,
                        textColor: Colors.white,
                        backgroundColor: primaryColor2,
                        onPressed: () {
                          context.read<OrderProvider>().initiatePayment(
                                widget.order.id!,
                                widget.order.price.toString(),
                                context,
                              );
                        },
                      );
                    }),
                  ],
                ],
                // if (widget.order.paymentStatus == "paid") ...[

                // ] else ...[

                // if (widget.order.paymentStatus != "paid") ...[
                //   Consumer<OrderProvider>(builder: (context, orderVM, _) {
                //     if (orderVM.orderStatus == OrderStatus.loading) {
                //       return const LoadingButton(
                //         backgroundColor: primaryColor2,
                //         textColor: Colors.white,
                //       );
                //     }

                //     return AppButton(
                //       text: 'Pay now',
                //       hasIcon: false,
                //       textColor: Colors.white,
                //       backgroundColor: primaryColor2,
                //       onPressed: () {
                //         context.read<OrderProvider>().initiatePayment(
                //               widget.order.id!,
                //               widget.order.price.toString(),
                //               context,
                //             );
                //       },
                //     );
                //   }),
                // ],
              // ],
              if (widget.order.status == "pending") ...[
                Consumer<OrderProvider>(builder: (context, orderVM, _) {
                  if (orderVM.orderStatus == OrderStatus.loading) {
                    return const LoadingButton(
                      backgroundColor: primaryColor1,
                      textColor: Colors.white,
                    );
                  }

                  return AppButton(
                    text: 'Cancel ',
                    hasIcon: false,
                    textColor: Colors.white,
                    backgroundColor: primaryColor1,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Cancel 0rder '),
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
                                      .cancelOrder(widget.order.id!)
                                      .then((x) {
                                    showSnackBar(context,
                                        message: 'Order canceled',
                                        color: primaryColor1);
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
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
                })
              ],
              const SizedBox(
                height: 5,
              ),
              AnotherStepper(
                stepperDirection: Axis.vertical,
                stepperList: stepperData,
              ),
              const SizedBox(height: 20),
         if (widget.order.status!.toLowerCase() != "delivered") ...[
              if (activeStep >= 1 && activeStep <= 3) ...[
                AppButton(
                  text: 'Preview',
                  hasIcon: false,
                  backgroundColor: primaryColor1,
                  textColor: Colors.white,
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripRoutePage(
                          order: widget.order,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
