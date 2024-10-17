import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/app_router.gr.dart';
import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:cargo_run/widgets/app_textfields.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

@RoutePage()
class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final TextEditingController name =
      TextEditingController(text: sharedPrefs.fullName);
  final TextEditingController phone =
      TextEditingController(text: sharedPrefs.phone);
  final TextEditingController email =
      TextEditingController(text: sharedPrefs.email);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.router.push(const GetHelpRoute()),
                      child: const Text(
                        'Get Help',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                          color: blackText,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          context.router.push(const EditProfileRoute()),
                      icon: const Icon(
                        Iconsax.setting_2,
                        size: 35,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Image.asset('assets/images/pp.png', height: size.height * 0.1),
                const SizedBox(height: 40.0),
                AppTextField(
                    labelText: 'Name', isPassword: false, controller: name),
                const SizedBox(height: 20.0),
                AppTextField(
                    labelText: 'Phone Number',
                    isPassword: false,
                    controller: phone),
                const SizedBox(height: 20.0),
                AppTextField(
                    labelText: 'Email', isPassword: false, controller: email),
                const SizedBox(height: 40.0),
                AppButton(
                  text: 'Sign out',
                  hasIcon: false,
                  textColor: Colors.white,
                  backgroundColor: primaryColor1,
                  onPressed: () async {
                    sharedPrefs.clearAll();
                    context.router.pushAndPopUntil(
                      const LoginRoute(),
                      predicate: (route) => false,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
