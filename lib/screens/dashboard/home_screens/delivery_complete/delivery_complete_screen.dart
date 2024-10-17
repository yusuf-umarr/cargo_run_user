import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../styles/app_colors.dart';
import '../../../../widgets/app_buttons.dart';
import '../../../../utils/app_router.gr.dart';

@RoutePage()
class DeliveryCompleteScreen extends StatefulWidget {
  const DeliveryCompleteScreen({super.key});

  @override
  State<DeliveryCompleteScreen> createState() => _DeliveryCompleteScreenState();
}

class _DeliveryCompleteScreenState extends State<DeliveryCompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        actions: [
          IconButton(
            onPressed: () =>
                context.router.replaceAll([const DashboardRoute()]),
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
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/b_check.png',
              height: 180,
            ),
            const SizedBox(height: 10),
            Text(
              'Delivery Completed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor1.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Dear Adesewa please share yourvaluable feedback. This will help us improve our services.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: blackText.withOpacity(0.7),
              ),
            ),
            const Spacer(),
            AppButton(
              text: 'Make a Review',
              hasIcon: false,
              textColor: Colors.white,
              backgroundColor: primaryColor1,
              onPressed: () => context.router.push(const ReviewRoute()),
            ),
          ],
        ),
      ),
    );
  }
}
