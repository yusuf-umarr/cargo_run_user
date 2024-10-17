import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/providers/auth_provider.dart';
import 'package:cargo_run/utils/app_router.gr.dart';
import 'package:cargo_run/widgets/app_textfields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../styles/app_colors.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/page_widgets/appbar_widget.dart';

@RoutePage()
class InputPhoneScreen extends StatefulWidget {
  const InputPhoneScreen({super.key});

  @override
  State<InputPhoneScreen> createState() => _InputPhoneScreenState();
}

class _InputPhoneScreenState extends State<InputPhoneScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void navigate() {
    context.router.push(const PhoneVerifyRoute());
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
        child: appBarWidget(context, title: 'Verification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 20.0),
              const Text(
                "Please enter your Email Address so we can send you your verification code",
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
                            if (_formKey.currentState!.validate()) {
                              await watch.getOTP(email: _emailController.text);
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
