import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../utils/app_router.gr.dart';
import '../../../../widgets/app_buttons.dart';
import '../../../../styles/app_colors.dart';

@RoutePage()
class SuccessReviewScreen extends StatefulWidget {
  const SuccessReviewScreen({super.key});

  @override
  State<SuccessReviewScreen> createState() => _SuccessReviewScreenState();
}

class _SuccessReviewScreenState extends State<SuccessReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Container(
              height: 200,
              width: 200,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: primaryColor2,
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 100,
              ),
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                Text(
                  'Review Dropped Successfully',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor1.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Dear Adesewa we appreciate your\nfeedback.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: blackText,
                  ),
                ),
              ],
            ),
            const Spacer(),
            AppButton(
                text: 'Go Home',
                hasIcon: false,
                textColor: Colors.white,
                backgroundColor: primaryColor1,
                onPressed: () => context.router.push(const DashboardRoute())),
          ],
        ),
      ),
    );
  }
}
