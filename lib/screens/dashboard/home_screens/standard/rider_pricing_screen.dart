
// import 'package:cargo_run/styles/app_colors.dart';
// import 'package:cargo_run/widgets/app_buttons.dart';
// import 'package:cargo_run/widgets/page_widgets/appbar_widget.dart';
// import 'package:flutter/material.dart';
// // import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';

// import '../../../../providers/order_provider.dart';
// import 'pay_screen.dart';

// class RiderPricingScreen extends StatefulWidget {
//   final bool isExpressDelivery;
//   const RiderPricingScreen({super.key, this.isExpressDelivery = false});

//   @override
//   State<RiderPricingScreen> createState() => _RiderPricingScreenState();
// }

// class _RiderPricingScreenState extends State<RiderPricingScreen> {
//   bool getPrice = false;
//   bool pickedCash = false;

//   @override
//   void initState() {
//     Future.delayed(const Duration(seconds: 3), () {
//       setState(() {
//         getPrice = true;
//       });
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF3F3F3),
//       appBar: appBarWidget(context, title: 'Pricing'),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
//         child: (getPrice == false)
//             ? Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   const Center(
//                     child: CircularProgressIndicator(
//                       color: primaryColor1,
//                     ),
//                   ),
//                   Text(
//                     'Calculating price...',
//                     style: GoogleFonts.roboto(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               )
//             : Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   _paymentSummary(),
//                   const SizedBox(height: 20),
//                   _paymentMethod(),
//                   const Spacer(),
//                   Consumer<OrderProvider>(
//                     builder: (context, watch, _) {
//                       return (watch.orderStatus == OrderStatus.loading)
//                           ? const LoadingButton(
//                               textColor: Colors.white,
//                               backgroundColor: primaryColor1,
//                             )
//                           : AppButton(
//                               text: 'Next',
//                               hasIcon: true,
//                               textColor: Colors.white,
//                               backgroundColor: primaryColor1,
//                               onPressed: () async {
//                                 await watch.initiatePayment().then((value) {
//                                   showBottomSheet(
//                                     context: context,
//                                     builder: (context) => PayScreen(
//                                       url: watch.url,
//                                     ),
//                                   );
//                                 });
//                               },
//                             );
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//       ),
//     );
//   }

//   String removeMiSuffix(String input) {
//     if (input.endsWith(' mi')) {
//       return input.substring(0, input.length - 3);
//     }
//     return input;
//   }

//   String getPrices({
//     required String distanceInMiles,
//     bool isExpressDelivery = false,
//   }) {
//     int pricePerMile = 1000;
//     double subTotal = 0.0;

//     double total = pricePerMile * double.parse(removeMiSuffix(distanceInMiles));

//     if (isExpressDelivery) {
//       subTotal = total + (total * 0.10);
//     } else {
//       subTotal = total;
//     }

//     return subTotal.toStringAsFixed(2);
//   }

//   String getTotalPrice({
//     required String distanceInMiles,
//     bool isExpressDelivery = false,
//   }) {
//     int pricePerMile = 1000;

//     double total = pricePerMile * double.parse(removeMiSuffix(distanceInMiles));

//     return total.toStringAsFixed(2);
//   }

//   String getTenPercent({
//     required String distanceInMiles,
//   }) {
//     int pricePerMile = 1000; //#1000 per mile
//     double subTotal = 0.0;
//     double total = pricePerMile * double.parse(removeMiSuffix(distanceInMiles));
//     subTotal = total * (10 / 100);
//     return subTotal.toStringAsFixed(2);
//   }

//   Widget _paymentSummary() {
//     final order = context.read<OrderProvider>();
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Payment Summary',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 20),
//           rowItem(
//               title: 'Total',
//               value: '₦ ${getTotalPrice(
//                 distanceInMiles: order.distancePrice,
//                 isExpressDelivery: widget.isExpressDelivery,
//               )}'),
//           const SizedBox(height: 10),
//           widget.isExpressDelivery
//               ? rowItem(
//                   title: 'Express Delivery\nCharge(10%)',
//                   value: '₦${getTenPercent(
//                     distanceInMiles: order.distancePrice,
//                   )}')
//               : const SizedBox.shrink(),
//           const SizedBox(height: 10),

//           rowItem(
//               title: 'Subtotal',
//               value: '₦ ${getPrices(
//                 distanceInMiles: order.distancePrice,
//                 isExpressDelivery: widget.isExpressDelivery,
//               )}'),

//           const Divider(
//             thickness: 1,
//             color: Colors.grey,
//           ),
//           // rowItem(title: 'Total', value: '₦${order.distancePrice + 2000.00}'),
//         ],
//       ),
//     );
//   }

//   Widget _paymentMethod() {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Payment Method',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 20),
//           method(value: 'cash', text: 'Cash', icon: Iconsax.money_34),
//           const Divider(),
//           method1(value: 'card', text: 'Card', icon: Iconsax.card),
//         ],
//       ),
//     );
//   }

//   Widget rowItem({required String title, required String value}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           "$title :",
//           style: const TextStyle(
//             fontSize: 15.0,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         Text(
//           value,
//           style: GoogleFonts.roboto(
//             fontSize: 15.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget method(
//       {required String value, required String text, required IconData icon}) {
//     return Row(
//       children: [
//         Icon(icon, color: primaryColor1),
//         const SizedBox(width: 10),
//         Text(
//           text,
//           style: const TextStyle(
//             fontSize: 16.0,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const Spacer(),
//         Radio(
//           value: true,
//           groupValue: pickedCash,
//           onChanged: (value) {
//             setState(() {
//               pickedCash = true;
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget method1(
//       {required String value, required String text, required IconData icon}) {
//     return Row(
//       children: [
//         Icon(icon, color: primaryColor1),
//         const SizedBox(width: 10),
//         Text(
//           text,
//           style: const TextStyle(
//             fontSize: 16.0,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const Spacer(),
//         Radio(
//           value: false,
//           groupValue: pickedCash,
//           onChanged: (value) {
//             setState(() {
//               pickedCash = true;
//             });
//           },
//         ),
//       ],
//     );
//   }
// }
