import 'package:another_stepper/another_stepper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/utils/app_router.gr.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:givestarreviews/givestarreviews.dart';

import '../../../../styles/app_colors.dart';

@RoutePage()
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<StepperData> stepperData = [
    StepperData(
      title: StepperText(
        "Street 22, Ogunaike Avenue, Shangisha.",
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
            borderRadius: BorderRadius.all(Radius.circular(30))),
      ),
    ),
    StepperData(
      title: StepperText(
        "44 Montgomery Rd Yaba, Lagos.",
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
            borderRadius: BorderRadius.all(Radius.circular(30))),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () => context.router.maybePop(),
            icon: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(right: 10, top: 10),
              decoration: BoxDecoration(
                color: primaryColor1,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                RichText(
                  text: const TextSpan(
                    text: 'Order ',
                    style: TextStyle(
                      color: blackText,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: '123456',
                        style: TextStyle(
                          color: primaryColor1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                AnotherStepper(
                  stepperList: stepperData,
                  stepperDirection: Axis.vertical,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'How would you rate the experience \n and service ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: blackText.withOpacity(0.9),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: StarRating(
                    size: 40,
                    spaceBetween: 10,
                    value: 0,
                    activeStarColor: primaryColor2,
                    starCount: 5,
                    onChanged: (rate) {},
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: greyText.withOpacity(0.1),
                    hintText: 'Tell us how we can improve',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: blackText.withOpacity(0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                AppButton(
                    text: 'Make a Review',
                    hasIcon: false,
                    textColor: Colors.white,
                    backgroundColor: primaryColor1,
                    onPressed: () =>
                        context.router.push(const SuccessReviewRoute()))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
