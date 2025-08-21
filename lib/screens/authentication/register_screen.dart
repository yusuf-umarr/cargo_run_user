import 'package:cargo_run/providers/bottom_nav_provider.dart';
import 'package:cargo_run/screens/alerts/account_creation_success.dart';
import 'package:cargo_run/screens/authentication/login_screen.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/providers/auth_provider.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:cargo_run/widgets/app_textfields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/widgets/page_widgets/appbar_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // void navigate() {
  //   context.router.push(const InputPhoneRoute());
  // }
  void navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SuccessScreen(
          successRedirectRoute: SuccessRedirectRoute.registeredPage,
        ),
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
  dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: appBarWidget(context, title: 'Create Account', hasBackBtn: true),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello,',
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          'Please create an account to continue.',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: greyText,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        AppTextField(
                          labelText: 'Full Name',
                          isPassword: false,
                          controller: _fullNameController,
                        ),
                        AppTextField(
                          labelText: 'Email ',
                          isPassword: false,
                          controller: _emailController,
                        ),
                        AppTextField(
                            labelText: 'Phone',
                            isPassword: false,
                            controller: _phoneController,
                            keyboardType: TextInputType.number),
                        AppTextField(
                          labelText: 'Password',
                          isPassword: true,
                          controller: _passwordController,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
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
                            context.read<BottomNavProvider>().setNavbarIndex(0);
                            if (_formKey.currentState!.validate()) {
                              try {
                                await watch.registerUser(
                                  email: _emailController.text,
                                  fullName: _fullNameController.text,
                                  password: _passwordController.text,
                                  phone: _phoneController.text,
                                );
                                if (watch.loadingState ==
                                    LoadingState.success) {
                                  navigate();
                                } else {
                                  showSnackBar(watch.errorMessage);
                                }
                              } catch (e) {
                                showSnackBar(e.toString());
                              }
                            }
                          },
                        );
                },
              ),
              const SizedBox(height: 10.0),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: const TextStyle(
                      color: greyText,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        text: 'Login',
                        style: const TextStyle(
                          color: primaryColor2,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }
}
