import 'package:cargo_run/screens/alerts/account_creation_success.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../../styles/app_colors.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/page_widgets/appbar_widget.dart';
import '../../providers/auth_provider.dart';
import '../../utils/shared_prefs.dart';

class PhoneVerifyScreen extends StatefulWidget {
  const PhoneVerifyScreen({super.key});

  @override
  State<PhoneVerifyScreen> createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final OtpFieldController _otpController = OtpFieldController();
  String otp = '';

  void navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SuccessScreen(
          successRedirectRoute: SuccessRedirectRoute.verifyPage,
        ),
      ),
    );
  }

  void showSnackBar(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: appBarWidget(context, title: 'Verification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Please enter the verification code sent to your email address',
                  style: TextStyle(
                    fontSize: 17.0,
                    color: greyText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      OTPTextField(
                        length: 5,
                        width: MediaQuery.of(context).size.width,
                        fieldWidth: size.width * 0.13,
                        controller: _otpController,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        style: const TextStyle(fontSize: 20),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.box,
                        onCompleted: (pin) {
                          setState(() {
                            otp = pin;
                          });
                        },
                        onChanged: (val) {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100.0),
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
                                await watch.verifyOTP(
                                    otp: otp, email: sharedPrefs.email);
                                if (watch.loadingState ==
                                    LoadingState.success) {
                                  navigate();
                                } else {
                                  showSnackBar(watch.errorMessage);
                                }
                              }
                            },
                          );
                  },
                ),
                const SizedBox(height: 25.0),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      text: 'Didn\'t receive the code? ',
                      style: const TextStyle(
                        color: greyText,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await context
                                  .read<AuthProvider>()
                                  .getOTP(
                                    email: sharedPrefs.email,
                                  )
                                  .then((v) => showSnackBar("Otp sent"));
                            },
                          text: 'Resend',
                          style: const TextStyle(
                            color: primaryColor2,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
