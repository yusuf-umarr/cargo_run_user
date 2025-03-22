import 'package:cargo_run/providers/auth_provider.dart';
import 'package:cargo_run/screens/authentication/verify_otp.dart';
import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:cargo_run/widgets/app_textfields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../styles/app_colors.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/page_widgets/appbar_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VerifyOtpScreen(),
      ),
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: appBarWidget(context, title: 'Forgot password',hasBackBtn: true),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 20.0),
              const Text(
                "Please enter your email address so we can send you your otp code",
                style: TextStyle(
                  fontSize: 17.0,
                  color: greyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 60.0),
              Form(
                key: _formKey,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AppTextField(
                          controller: _emailController,
                          labelText: 'Email Address',
                          isEmail: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Consumer<AuthProvider>(
                builder: (context, watch, _) {
                  return (watch.loadingState == LoadingState.loading)
                      ? const LoadingButton(
                          backgroundColor: primaryColor1,
                          textColor: Colors.white,
                        )
                      : AppButton(
                          text: 'Continue',
                          hasIcon: true,
                          backgroundColor: primaryColor1,
                          textColor: Colors.white,
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            sharedPrefs.email = _emailController.text;
                            if (_formKey.currentState!.validate()) {
                              await watch.forgotPassword(
                                  email: _emailController.text);
                              if (watch.loadingState == LoadingState.success) {
                                navigate();
                              } else {
                                showSnackBar(watch.errorMessage);
                              }
                            }
                          },
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
