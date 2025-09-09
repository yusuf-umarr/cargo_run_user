// ignore_for_file: use_build_context_synchronously

import 'package:cargo_run/providers/auth_provider.dart';
import 'package:cargo_run/screens/authentication/login_screen.dart';
import 'package:cargo_run/screens/dashboard/profile_screens/get_help_screen.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:cargo_run/widgets/app_textfields.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

  bool isEditing = false;

  void logout(BuildContext context) {
    sharedPrefs.clearAll();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void showLogoutSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      elevation: 0,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FractionallySizedBox(
            heightFactor: 0.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: 56,
                  child: AppBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    leadingWidth: 62,
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.cancel),
                    ),
                    centerTitle: true,
                    title: Text(
                      "Take a break from Cargo run?",
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    scrolledUnderElevation: 0,
                    bottom: const PreferredSize(
                      preferredSize: Size.fromHeight(1),
                      child: Divider(color: Colors.grey),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => logout(context),
                  child: const Text("Log out"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Top Row with Help and Logout
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () =>   whatsApp(),
                      child: const Text(
                        'Get Help',
                        style: TextStyle(fontSize: 20.0, color: blackText),
                      ),
                    ),
                    IconButton(
                      onPressed: showLogoutSheet,
                      icon: const Icon(Iconsax.logout, size: 35),
                    ),
                  ],
                ),

                const SizedBox(height: 10.0),

                // Profile Avatar and Edit Button
                Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: primaryColor2,
                      child: Text(
                        sharedPrefs.fullName.isNotEmpty
                            ? sharedPrefs.fullName.substring(0, 1).toUpperCase()
                            : "",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: toggleEditing,
                      icon: Icon(isEditing ? Icons.cancel : Icons.edit,
                          color: primaryColor1),
                      label: Text(
                        isEditing ? "Cancel Edit" : "Edit Profile",
                        style: const TextStyle(color: primaryColor1),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30.0),

                // Editable Profile Fields
                AppTextField(
                  labelText: 'Name',
                  isPassword: false,
                  controller: name,
                  enabled: isEditing,
                ),
                const SizedBox(height: 20.0),
                AppTextField(
                  labelText: 'Phone Number',
                  isPassword: false,
                  controller: phone,
                  enabled: isEditing,
                ),
                const SizedBox(height: 20.0),
                AppTextField(
                  labelText: 'Email',
                  isPassword: false,
                  controller: email,
                  enabled: isEditing,
                ),

                const SizedBox(height: 40.0),

                // Update Button
                if (isEditing)
                  authProvider.loadingState == LoadingState.loading
                      ? const LoadingButton(
                          backgroundColor: primaryColor1,
                          textColor: Colors.white,
                        )
                      : AppButton(
                          text: 'Update Profile',
                          hasIcon: false,
                          textColor: Colors.white,
                          backgroundColor: primaryColor1,
                          onPressed: () {
                            sharedPrefs.fullName = name.text;
                            sharedPrefs.phone = phone.text;
                            sharedPrefs.email = email.text;

                            authProvider.updateProfile(
                              name: name.text,
                              phone: phone.text,
                              email: email.text,
                            );

                            setState(() {
                              isEditing = false;
                            });
                          },
                        ),

                SizedBox(height: screenSize.height * 0.05),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Account"),
                          content: const Text(
                              "Are you sure you want to delete your account? This action cannot be undone."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                authProvider.deleteAccount().then((value) {
                                  if (authProvider.loadingState ==
                                      LoadingState.success) {
                                    logout(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Failed to delete account. Please try again."),
                                      ),
                                    );
                                  }
                                });
                                // Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      "Delete Account",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

   whatsApp() {
    return launchUrl(
      Uri.parse(
        'whatsapp://send?phone=',
      ),
    );
  }
}
