
// import 'package:cargo_run/providers/auth_provider.dart';
// import 'package:cargo_run/screens/authentication/login_screen.dart';
// import 'package:cargo_run/screens/dashboard/profile_screens/get_help_screen.dart';
// import 'package:cargo_run/styles/app_colors.dart';
// import 'package:cargo_run/utils/shared_prefs.dart';
// import 'package:cargo_run/widgets/app_buttons.dart';
// import 'package:cargo_run/widgets/app_textfields.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';

// class ViewProfileScreen extends StatefulWidget {
//   const ViewProfileScreen({super.key});

//   @override
//   State<ViewProfileScreen> createState() => _ViewProfileScreenState();
// }

// class _ViewProfileScreenState extends State<ViewProfileScreen> {
//   final TextEditingController name =
//       TextEditingController(text: sharedPrefs.fullName);
//   final TextEditingController phone =
//       TextEditingController(text: sharedPrefs.phone);
//   final TextEditingController email =
//       TextEditingController(text: sharedPrefs.email);

//   void navigate() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const LoginScreen(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF3F3F3),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const GetHelpScreen(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         'Get Help',
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.normal,
//                           color: blackText,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         showModalBottomSheet(
//                             backgroundColor: Colors.white,
//                             elevation: 0,
//                             context: context,
//                             isScrollControlled: true,
//                             builder: (context) {
//                               return Padding(
//                                 padding: EdgeInsets.only(
//                                     bottom: MediaQuery.of(context)
//                                         .viewInsets
//                                         .bottom),
//                                 child: FractionallySizedBox(
//                                     heightFactor: 0.3,
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         const SizedBox(height: 20),
//                                         SizedBox(
//                                           height: 56,
//                                           child: AppBar(
//                                             shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(20)),
//                                             leadingWidth: 62,
//                                             leading: IconButton(
//                                                 onPressed: () {
//                                                   Navigator.of(context).pop();
//                                                 },
//                                                 icon: const Icon(Icons.cancel)),
//                                             centerTitle: true,
//                                             title: Text(
//                                               "Take a break from Cargo run?",
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .displayMedium!
//                                                   .copyWith(
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                             ),
//                                             scrolledUnderElevation: 0,
//                                             bottom: PreferredSize(
//                                               preferredSize: Size(
//                                                   MediaQuery.of(context)
//                                                       .size
//                                                       .width,
//                                                   1),
//                                               child: const Divider(
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         ElevatedButton(
//                                             onPressed: () {
//                                               sharedPrefs.clearAll();
//                                               navigate();
//                                             },
//                                             child: const Text("Log out"))
//                                       ],
//                                     )),
//                               );
//                             });
//                       },
//                       icon: const Icon(
//                         Iconsax.logout,
//                         size: 35,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10.0),
               
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: primaryColor2,
//                   child: Center(
//                     child: Text(
//                       sharedPrefs.fullName.substring(0, 1).toUpperCase(),
//                       style: const TextStyle(color: Colors.white, fontSize: 25),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40.0),
//                 AppTextField(
//                   labelText: 'Name',
//                   isPassword: false,
//                   controller: name,
//                 ),
//                 const SizedBox(height: 20.0),
//                 AppTextField(
//                     labelText: 'Phone Number',
//                     isPassword: false,
//                     controller: phone),
//                 const SizedBox(height: 20.0),
//                 AppTextField(
//                   labelText: 'Email',
//                   isPassword: false,
//                   controller: email,
//                 ),
//                 const SizedBox(height: 40.0),
//                 Consumer<AuthProvider>(builder: (context, authVM, _) {
//                   return (authVM.loadingState == LoadingState.loading)
//                       ? const LoadingButton(
//                           backgroundColor: primaryColor1,
//                           textColor: Colors.white,
//                         )
//                       : AppButton(
//                           text: 'Update profile',
//                           hasIcon: false,
//                           textColor: Colors.white,
//                           backgroundColor: primaryColor1,
//                           onPressed: () async {
//                             sharedPrefs.fullName = name.text;
//                             sharedPrefs.email = email.text;
//                             sharedPrefs.phone = phone.text;
//                             context.read<AuthProvider>().updateProfile(
//                                   name: name.text,
//                                   email: email.text,
//                                   phone: phone.text,
//                                 );
//                           },
//                         );
//                 })
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


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
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const GetHelpScreen())),
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
                        sharedPrefs.fullName.substring(0, 1).toUpperCase(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

