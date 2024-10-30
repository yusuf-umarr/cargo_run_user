import 'package:cargo_run/screens/authentication/login_screen.dart';
import 'package:cargo_run/screens/authentication/register_screen.dart';
import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../widgets/app_buttons.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor1,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const SizedBox(height: 120),
              Image.asset(
                'assets/images/bg.png',
                height: 70,
              ),
              const SizedBox(height: 60),
              const Text(
                'Faster is Always Better',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Congratulations on taking the first step towards a seamless and effective courier experience with Cargorun! We're thrilled to have you on board",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              AppButton(
                text: 'Create Account',
                onPressed: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                },
              ),
              const SizedBox(height: 15),
              AppButton(
                backgroundColor: primaryColor2,
                textColor: Colors.white,
                text: 'Login as an Existing User',
                onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
