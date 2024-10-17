import 'package:another_stepper/another_stepper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:cargo_run/widgets/page_widgets/appbar_widget.dart';
import 'package:cargo_run/widgets/page_widgets/payment_summary_card.dart';
import 'package:flutter/material.dart';

import '../../../models/order.dart';

@RoutePage()
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
          '${widget.order!.addressDetails!.houseNumber!}, ${widget.order!.addressDetails!.landMark!}',
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
      appBar: appBarWidget(context, title: 'Order History'),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Order: ',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: AppButton(
                  text: 'Get help with order',
                  hasIcon: false,
                  textColor: Colors.white,
                  backgroundColor: primaryColor1.withOpacity(0.7),
                ),
              ),
              PaymentSummaryCard(
                deliveryFee:
                    widget.order!.deliveryFee!.toStringAsFixed(2).toString(),
                paymentStatus: widget.order!.paymentStatus!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
