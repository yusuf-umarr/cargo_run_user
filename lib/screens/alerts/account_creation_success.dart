
import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/utils/app_router.gr.dart';
import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    setState(() => sharedPrefs.isLoggedIn = true);
    Timer(const Duration(milliseconds: 500), () {
      context.router.replaceAll([const DashboardRoute()]);
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
            const Text(
              'Account Creation Successful',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'There are many variations of passages of Lorem Ispum available. But the majority have suffered alteration in some form by injected humour or randomised words.',
              style: TextStyle(
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
