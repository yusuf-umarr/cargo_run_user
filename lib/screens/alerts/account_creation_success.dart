import 'dart:async';
import 'package:cargo_run/screens/authentication/login_screen.dart';
import 'package:cargo_run/screens/authentication/phone_verify_screen.dart';
import 'package:cargo_run/screens/bottom_nav/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

enum SuccessRedirectRoute {
  registeredPage,
  verifyPage,
  orderSummay,
  forgotPass
}

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PhoneVerifyScreen(),
          ),
        );
      } else if (widget.successRedirectRoute ==
          SuccessRedirectRoute.verifyPage) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else if (widget.successRedirectRoute ==
          SuccessRedirectRoute.orderSummay) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
          (Route<dynamic> route) => false,
        );
      } else if (widget.successRedirectRoute ==
          SuccessRedirectRoute.forgotPass) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (Route<dynamic> route) => false,
        );
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
                          SuccessRedirectRoute.verifyPage
                      ? "Account Verified Successful"
                      : widget.successRedirectRoute ==
                              SuccessRedirectRoute.forgotPass
                          ? "Passowrd reset successful"
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
                          SuccessRedirectRoute.verifyPage
                      ? "You can now log into your account"
                      : widget.successRedirectRoute ==
                              SuccessRedirectRoute.forgotPass
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
