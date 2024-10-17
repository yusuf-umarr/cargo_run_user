import 'package:another_stepper/another_stepper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/widgets/page_widgets/appbar_widget.dart';
import 'package:flutter/material.dart';

import '../../../models/order.dart';
import '../../../styles/app_colors.dart';

@RoutePage()
class TrackParcelScreen extends StatefulWidget {
  final Order order;
  const TrackParcelScreen({super.key, required this.order});

  @override
  State<TrackParcelScreen> createState() => _TrackParcelScreenState();
}

class _TrackParcelScreenState extends State<TrackParcelScreen> {
  List<StepperData> stepperData = [
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
        textStyle: const TextStyle(
          color: greyText,
          fontSize: 16,
        ),
      ),
      iconWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: primaryColor1,
          borderRadius: BorderRadius.all(
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
        textStyle: const TextStyle(
          color: greyText,
          fontSize: 16,
        ),
      ),
      iconWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: greyText,
          borderRadius: BorderRadius.all(
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
        textStyle: const TextStyle(
          color: greyText,
          fontSize: 16,
        ),
      ),
      iconWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: greyText,
          borderRadius: BorderRadius.all(
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
        textStyle: const TextStyle(
          color: greyText,
          fontSize: 16,
        ),
      ),
      iconWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: greyText,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context, title: 'Track Your Parcel'),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
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
          ],
        ),
      ),
    );
  }
}
