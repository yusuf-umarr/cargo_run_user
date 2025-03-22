import 'package:cargo_run/providers/auth_provider.dart';
import 'package:cargo_run/providers/auth_token_provider.dart';
import 'package:cargo_run/screens/bottom_nav/bottom_nav_bar.dart';
import 'package:cargo_run/screens/onboard/onboard_screen.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Map<String, dynamic>>(
        stream: Provider.of<AuthProvider>(context, listen: false)
            .validateToken()
            .asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor1,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final bool isTokenValid = snapshot.data!['res'] ?? false;
        

            if (isTokenValid) {
              return Builder(builder: (context) {
                return const BottomNavBar();
              });
            } else {
              return const OnboardScreen();
            }
          }
        },
      ),
    );
  }
}
