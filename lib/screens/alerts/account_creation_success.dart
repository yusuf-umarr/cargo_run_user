import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/screens/dashboard/bottom_nav.dart';
import 'package:cargo_run/utils/app_router.gr.dart';
import 'package:flutter/material.dart';

enum SuccessRedirectRoute { registeredPage, verifyPage, orderSummay }

@RoutePage()
class SuccessScreen extends StatefulWidget {
  final SuccessRedirectRoute successRedirectRoute;
  const SuccessScreen(
      {super.key,
      this.successRedirectRoute = SuccessRedirectRoute.registeredPage});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    // setState(() => sharedPrefs.isLoggedIn = true);
    Timer(const Duration(seconds: 3), () {
      if (widget.successRedirectRoute == SuccessRedirectRoute.registeredPage) {
        context.router.push(const PhoneVerifyRoute());
      } else if (widget.successRedirectRoute ==
          SuccessRedirectRoute.verifyPage) {
        context.router.replace(const LoginRoute());
      } else if (widget.successRedirectRoute ==
          SuccessRedirectRoute.orderSummay) {
        context.router.replaceAll([
          const HomeRoute(),
        ]);
      }
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
              widget.successRedirectRoute == SuccessRedirectRoute.registeredPage
                  ? 'Account Creation Successful'
                  : widget.successRedirectRoute ==
                          SuccessRedirectRoute.registeredPage
                      ? "Account Verified Successful"
                      : "Order request completed",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              widget.successRedirectRoute == SuccessRedirectRoute.registeredPage
                  ? 'Otp verification code has been sent to your registered email.'
                  : widget.successRedirectRoute ==
                          SuccessRedirectRoute.registeredPage
                      ? "You can now log into your account"
                      : "Please wait while we process your request",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17.0,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
