import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cargo_run/providers/auth_provider.dart';
import 'package:cargo_run/screens/authentication/login_screen.dart';
import 'package:cargo_run/screens/dashboard/profile_screens/edit_profile_screen.dart';
import 'package:cargo_run/screens/dashboard/profile_screens/get_help_screen.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:cargo_run/widgets/app_textfields.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

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

  void navigate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GetHelpScreen(),
                          ),
                        );
                      },
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
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
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
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            leadingWidth: 62,
                                            leading: IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                icon: const Icon(Icons.cancel)),
                                            centerTitle: true,
                                            title: Text(
                                              "Take a break from Cargo run?",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            scrolledUnderElevation: 0,
                                            bottom: PreferredSize(
                                              preferredSize: Size(
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  1),
                                              child: const Divider(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              sharedPrefs.clearAll();
                                              navigate();
                                            },
                                            child: const Text("Log out"))
                                      ],
                                    )),
                              );
                            });
                      },
                      icon: const Icon(
                        Iconsax.logout,
                        size: 35,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                // Consumer<AuthProvider>(builder: (context, authVM, _) {
                //   return InkWell(
                //     onTap: () async {
                //       await authVM.selectImages();
                //     },
                //     child: Stack(children: [
                //       Center(
                //         child: ClipOval(
                //           child: SizedBox.fromSize(
                //             size: const Size.fromRadius(35),
                //             child: authVM.imageFile != null
                //                 ? Image.file(File(authVM.imageUpload.path),
                //                     fit: BoxFit.cover)
                //                 : authVM.userModel?.user?.image != null
                //                     ? Image(
                //                         image: CachedNetworkImageProvider(
                //                           authVM.userModel!.user!.image!,
                //                         ),
                //                         fit: BoxFit.cover,
                //                       )
                //                     : Image.asset(
                //                         "assets/images/pp.png",
                //                       ),
                //           ),
                //         ),
                //       ),
                //       Positioned(
                //         bottom: 45,
                //         left: 45,
                //         child: GestureDetector(
                //           onTap: () async {
                //             authVM.selectImages();
                //           },
                //           child: const Icon(
                //             Icons.camera_alt_outlined,
                //             color: Colors.grey,
                //           ),
                //         ),
                //       ),
                //     ]),
                //   );
                // }),
                // Image.asset(
                //   'assets/images/pp.png',
                //   height: size.height * 0.1,
                // ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: primaryColor2,
                  child: Center(
                    child: Text(
                      sharedPrefs.fullName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                AppTextField(
                  labelText: 'Name',
                  isPassword: false,
                  controller: name,
                ),
                const SizedBox(height: 20.0),
                AppTextField(
                    labelText: 'Phone Number',
                    isPassword: false,
                    controller: phone),
                const SizedBox(height: 20.0),
                AppTextField(
                  labelText: 'Email',
                  isPassword: false,
                  controller: email,
                ),
                const SizedBox(height: 40.0),
                Consumer<AuthProvider>(builder: (context, authVM, _) {
                  return (authVM.loadingState == LoadingState.loading)
                      ? const LoadingButton(
                          backgroundColor: primaryColor1,
                          textColor: Colors.white,
                        )
                      : AppButton(
                          text: 'Update profile',
                          hasIcon: false,
                          textColor: Colors.white,
                          backgroundColor: primaryColor1,
                          onPressed: () async {
                            sharedPrefs.fullName = name.text;
                            sharedPrefs.email = email.text;
                            sharedPrefs.phone = phone.text;
                            context.read<AuthProvider>().updateProfile(
                                  name: name.text,
                                  email: email.text,
                                  phone: phone.text,
                                );
                          },
                        );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
