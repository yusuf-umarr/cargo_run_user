// // ignore_for_file: use_build_context_synchronously

// import 'dart:developer';

// // import 'package:auto_route/auto_route.dart';
// import 'package:cargo_run/providers/order_provider.dart';
// import 'package:cargo_run/screens/dashboard/home_screens/standard/delivery_summary.dart';
// import 'package:cargo_run/styles/app_colors.dart';
// import 'package:cargo_run/utils/util.dart';
// import 'package:cargo_run/widgets/app_buttons.dart';
// import 'package:cargo_run/widgets/app_textfields.dart';
// import 'package:cargo_run/widgets/page_widgets/appbar_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:group_button/group_button.dart';
// import 'package:provider/provider.dart';
// import 'package:nb_utils/nb_utils.dart' as util;

// class BulkDeliveryDetailsScreen extends StatefulWidget {
//   const BulkDeliveryDetailsScreen({super.key});

//   @override
//   State<BulkDeliveryDetailsScreen> createState() =>
//       _BulkDeliveryDetailsScreenState();
// }

// class _BulkDeliveryDetailsScreenState extends State<BulkDeliveryDetailsScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController _recipientsNameController =
//       TextEditingController();
//   final TextEditingController _recipientsPhoneController =
//       TextEditingController();
//   final TextEditingController _recipientsAddressController =
//       TextEditingController();
//   final TextEditingController _packageCategoryController =
//       TextEditingController();
//   final TextEditingController _deliveryOption = TextEditingController();
//   final TextEditingController _latController = TextEditingController();
//   final TextEditingController _longController = TextEditingController();
//   bool expressDelivery = false;
//   bool normalDelivery = false;
//   bool isTypingPickUp = false;

//   @override
//   void dispose() {
//     _latController.dispose();
//     _longController.dispose();
//     _recipientsNameController.dispose();
//     _recipientsPhoneController.dispose();
//     _recipientsAddressController.dispose();
//     _packageCategoryController.dispose();
//     _deliveryOption.dispose();
//     super.dispose();
//   }

//   void navigate() async {
//     await context.read<OrderProvider>().getDistancePrice();

//     if (context.read<OrderProvider>().distanceModel != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DeliverySummary(
//             isExpressDelivery: expressDelivery,
//           ),
//         ),
//       );
//     } else {
//       log("price could be fteched");
//     }
//   }

//   void showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: const Color(0xffF3F3F3),
//       appBar:
//           appBarWidget(context, title: 'Delivery Details', hasBackBtn: true),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 25.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10.0),
//                 const Text(
//                   'Send large quantities of packages effortlessly\nwith our Bulk Shipment feature.',
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w500,
//                     color: primaryColor1,
//                   ),
//                 ),
//                 const SizedBox(height: 10.0),
//                 const Text(
//                   'Delivery Option',
//                   style: TextStyle(
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 10.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     deliveryOption(
//                       normalDelivery,
//                       title: 'Normal',
//                       width: size.width * 0.42,
//                       onTap: () {
//                         setState(() {
//                           normalDelivery = true;
//                           expressDelivery = false;
//                         });
//                         context
//                             .read<OrderProvider>()
//                             .setDeliveryOption("normal");
//                       },
//                       image: 'bulk-normal',
//                     ),
//                     deliveryOption(
//                       expressDelivery,
//                       title: 'Express',
//                       width: size.width * 0.42,
//                       onTap: () {
//                         setState(() {
//                           expressDelivery = true;
//                           normalDelivery = false;
//                           _deliveryOption.text = 'Express ';
//                         });
//                         context
//                             .read<OrderProvider>()
//                             .setDeliveryOption("express");
//                       },
//                       image: 'bulk-express',
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10.0),
//                 const Text(
//                   'Please note that express delivery charge extra 10% cost.',
//                   style: TextStyle(
//                     fontSize: 15.0,
//                     color: greyText,
//                   ),
//                 ),
//                 const SizedBox(height: 30.0),
//                 const Text(
//                   "Reciever's Details",
//                   style: TextStyle(
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                 AppTextField(
//                   labelText: 'Recipients Name',
//                   hintText: 'Recipients Name',
//                   controller: _recipientsNameController,
//                   noLabel: true,
//                 ),
//                 const SizedBox(height: 20.0),
//                 AppTextField(
//                   labelText: 'Recipients Phone Number',
//                   hintText: 'Phone Number',
//                   controller: _recipientsPhoneController,
//                   isNumber: true,
//                   keyboardType: TextInputType.phone,
//                   noLabel: true,
//                 ),
//                 const SizedBox(height: 20.0),
//                 // AppTextField(
//                 //   labelText: 'Recipients Address',
//                 //   hintText: 'Address',
//                 //   controller: _recipientsAddressController,
//                 //   noLabel: true,
//                 // ),
//                 recipientAddressTextField(),
//                 const SizedBox(height: 30.0),
//                 const Text(
//                   "Package Category",
//                   style: TextStyle(
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const Text(
//                   'What are you sending?',
//                   style: TextStyle(
//                     fontSize: 14.0,
//                     color: greyText,
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                 //grouped buttons
//                 Align(
//                   alignment: Alignment.center,
//                   child: GroupButton(
//                     isRadio: true,
//                     buttons: const [
//                       'Documents',
//                       'Food',
//                       'Clothing',
//                       'Electronics',
//                       'Liquid',
//                       'Glass',
//                     ],
//                     options: GroupButtonOptions(
//                       unselectedBorderColor: primaryColor2,
//                       unselectedTextStyle: const TextStyle(
//                         color: primaryColor2,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       selectedShadow: const [],
//                       unselectedShadow: const [],
//                       selectedColor: primaryColor2,
//                       unselectedColor: Colors.transparent,
//                       selectedTextStyle: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     onSelected: (val, i, selected) {
//                       debugPrint('Button: $val, index: $i $selected');
//                       _packageCategoryController.text = val;
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 30.0),
//                 Consumer<OrderProvider>(
//                   builder: (context, watch, _) {
//                     return (watch.orderStatus == OrderStatus.loading)
//                         ? const LoadingButton(
//                             textColor: Colors.white,
//                             backgroundColor: primaryColor1,
//                           )
//                         : AppButton(
//                             text: 'Next',
//                             hasIcon: true,
//                             textColor: Colors.white,
//                             backgroundColor: primaryColor1,
//                             onPressed: () async {
//                               if (_formKey.currentState!.validate()) {
//                                 watch.addRecipientDetails(
//                                   _recipientsNameController.text,
//                                   _recipientsPhoneController.text,
//                                   _recipientsAddressController.text,
//                                   _packageCategoryController.text,
//                                   _deliveryOption.text,
//                                   _latController.text,
//                                   _latController.text,
//                                 );
//                                 navigate();
//                                 // await watch.placeOrder().then((value) => {
//                                 //       if (watch.orderStatus ==
//                                 //           OrderStatus.pending)
//                                 //         {navigate()}
//                                 //       else
//                                 //         {showSnackBar(watch.errorMessage)}
//                                 //     });
//                               }
//                             },
//                           );
//                   },
//                 ),
//                 const SizedBox(height: 30.0),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget deliveryOption(
//     bool picked, {
//     required String title,
//     required double width,
//     VoidCallback? onTap,
//     required String image,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 350),
//         width: width,
//         padding: const EdgeInsets.all(15.0),
//         decoration: BoxDecoration(
//           color: (picked == true) ? primaryColor1 : Colors.white,
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Column(
//           children: [
//             Image.asset(
//               'assets/images/$image.png',
//               color: (picked == true) ? Colors.white : Colors.black,
//               height: 50,
//             ),
//             const SizedBox(height: 10.0),
//             Text(
//               '$title Delivery',
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//                 color: (picked == true) ? Colors.white : Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Consumer recipientAddressTextField() {
//     return Consumer<OrderProvider>(builder: (context, otherVM, _) {
//       return Column(
//         children: [
//           isTypingPickUp
//               ? Builder(builder: (context) {
//                   if (otherVM.dSearchResults.isNotEmpty) {
//                     return Card(
//                       child: Column(
//                         children: otherVM.dSearchResults.map<Widget>((x) {
//                           return ListTile(
//                             onTap: () async {
//                               try {
//                                 _recipientsAddressController.text =
//                                     x.placePrediction.text.text;

//                                 isTypingPickUp = false;

//                                 // List<Location> locations =
//                                 //     await locationFromAddress(
//                                 //         x.placePrediction.text.text);

//                                 // _latController.text =
//                                 //     locations[0].latitude.toString();
//                                 // _longController.text =
//                                 //     locations[0].longitude.toString();

//                                 setState(() {});
//                                 if (mounted) {
//                                   FocusScope.of(context).unfocus();
//                                 }
//                               } catch (e) {
//                                 util.toast("Network error, please retry");

//                                 _recipientsAddressController.clear();
//                                 log("error:$e");
//                               }
//                             },
//                             title: Text(
//                               x.placePrediction.text.text,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodySmall!
//                                   .copyWith(color: Colors.black),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     );
//                   }
//                   return const SizedBox.shrink();
//                 })
//               : const SizedBox(),
//           Util.inputField2(
//             externalText: "Recipients address",
//             hint: "Enter address",
//             controller: _recipientsAddressController,
//             validator: (value) => value!.isEmpty ? '*Field is required' : null,
//             onChanged: (query) {
//               if (query != "") {
//                 setState(() {
//                   isTypingPickUp = true;
//                 });
//               } else {
//                 setState(() {
//                   isTypingPickUp = false;
//                 });
//               }
//               otherVM.getAutocompletePlaces(query);
//             },
//           ),
//         ],
//       );
//     });
//   }
// //
// }
