import 'dart:developer';

import 'package:another_stepper/another_stepper.dart';
import 'package:cargo_run/providers/order_provider.dart';
import 'package:cargo_run/screens/dashboard/home_screens/trip_route_page.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:cargo_run/widgets/page_widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/order.dart';
import '../../../styles/app_colors.dart';

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
    log("widget.order.status:${widget.order.status}");
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
    return Scaffold(
      appBar:
          appBarWidget(context, title: 'Track Your Parcel', hasBackBtn: true),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Text(
                'Order #${widget.order.orderId}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: primaryColor1,
                ),
              ),
              AnotherStepper(
                stepperDirection: Axis.vertical,
                stepperList: stepperData,
              ),
              const SizedBox(height: 20),
              if (activeStep >= 1) ...[
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
                if (widget.order.paymentStatus!.toLowerCase() == "pending") ...[
                  if (widget.order.status! == "picked" ||
                      widget.order.status! == "successful" ||
                      widget.order.status! == "delivered") ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Consumer<OrderProvider>(
                          builder: (context, orderVM, _) {
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
                    ),
                  ]
                ]
              ]
            ],
          ),
        ),
      ),
    );
  }
}
