import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/utils/app_router.gr.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SuccessScreen extends StatefulWidget {
  final bool isRegistered;
  const SuccessScreen({super.key, this.isRegistered = false});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    // setState(() => sharedPrefs.isLoggedIn = true);
    Timer(const Duration(seconds: 3), () {
      if (widget.isRegistered) {
        context.router.push(const PhoneVerifyRoute());
      } else {
        context.router.replace(const LoginRoute());
      }

      // context.router.replaceAll([const DashboardRoute()]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/success.png',
              height: 200.0,
            ),
            Text(
              widget.isRegistered
                  ? 'Account Creation Successful'
                  : "Account Verified Successful",
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              widget.isRegistered
                  ? 'Otp verification code has been sent to your registered email.'
                  : "You can now log into your account",
              style: const TextStyle(
                fontSize: 17.0,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
