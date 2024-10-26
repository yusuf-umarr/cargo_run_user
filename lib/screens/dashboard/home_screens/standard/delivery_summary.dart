import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/screens/alerts/account_creation_success.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:cargo_run/widgets/page_widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../providers/order_provider.dart';
import 'pay_screen.dart';

class DeliverySummary extends StatefulWidget {
  final bool isExpressDelivery;
  const DeliverySummary({super.key, this.isExpressDelivery = false});

  @override
  State<DeliverySummary> createState() => _DeliverySummaryState();
}

class _DeliverySummaryState extends State<DeliverySummary> {
  bool getPrice = false;
  bool pickedCash = false;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        getPrice = true;
      });
    });
    super.initState();
  }

  void navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SuccessScreen(
          successRedirectRoute: SuccessRedirectRoute.orderSummay,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final orderVM = context.watch<OrderProvider>();
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: appBarWidget(context, title: 'Summary'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: (getPrice == false)
              ? Column(
                  children: [
                    const SizedBox(height: 10),
                    const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor1,
                      ),
                    ),
                    Text(
                      'Calculating price...',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    const SizedBox(height: 10),
                    _paymentSummary(size),
                    const SizedBox(height: 20),
                    detailCard(
                      size,
                      title: "Sender",
                      name: sharedPrefs.fullName,
                      phone: "${orderVM.addressDetails!.contactNumber}",
                      address: "${orderVM.addressDetails!.landMark}",
                    ),
                    const SizedBox(height: 20),
                    detailCard(
                      size,
                      title: "Recipient",
                      name: "${orderVM.receiverDetails!.name}",
                      phone: "${orderVM.receiverDetails!.phone}",
                      address: "${orderVM.receiverDetails!.address}",
                    ),
                    const SizedBox(height: 40),
                    Consumer<OrderProvider>(
                      builder: (context, watch, _) {
                        return (watch.orderStatus == OrderStatus.loading)
                            ? const LoadingButton(
                                textColor: Colors.white,
                                backgroundColor: primaryColor1,
                              )
                            : AppButton(
                                text: 'Proceed',
                                hasIcon: false,
                                textColor: Colors.white,
                                backgroundColor: primaryColor1,
                                onPressed: () async {
                                  await watch.placeOrder().then((value) {
                                    navigate();
                                  });
                                },
                              );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
        ),
      ),
    );
  }

  String removeMiSuffix(String input) {
    if (input.endsWith(' mi')) {
      return input.substring(0, input.length - 3);
    }
    return input;
  }

  String getPrices({
    required String distanceInMiles,
    bool isExpressDelivery = false,
  }) {
    int pricePerMile = 1000;
    double subTotal = 0.0;

    double total = pricePerMile * double.parse(removeMiSuffix(distanceInMiles));

    if (isExpressDelivery) {
      subTotal = total + (total * 0.10);
    } else {
      subTotal = total;
    }

    return subTotal.toStringAsFixed(2);
  }

  String getTotalPrice({
    required String distanceInMiles,
    bool isExpressDelivery = false,
  }) {
    log("distanceInMiles:$distanceInMiles");
    int pricePerMile = 1000;

    double total = pricePerMile * double.parse(removeMiSuffix(distanceInMiles));

    return total.toStringAsFixed(2);
  }

  String getTenPercent({
    required String distanceInMiles,
  }) {
    int pricePerMile = 1000; //#1000 per mile
    double subTotal = 0.0;
    double total = pricePerMile * double.parse(removeMiSuffix(distanceInMiles));
    subTotal = total * (10 / 100);
    return subTotal.toStringAsFixed(2);
  }

  Widget _paymentSummary(size) {
    final order = context.read<OrderProvider>();
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            'Payment details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(),
          const SizedBox(height: 20),
          rowItem(
              title: 'Total',
              value: '₦ ${getTotalPrice(
                distanceInMiles: order.distancePrice,
                isExpressDelivery: widget.isExpressDelivery,
              )}'),
          const SizedBox(height: 10),
          widget.isExpressDelivery
              ? rowItem(
                  title: 'Express Delivery\nCharge(10%)',
                  value: '₦${getTenPercent(
                    distanceInMiles: order.distancePrice,
                  )}')
              : const SizedBox.shrink(),
          const SizedBox(height: 10),

          rowItem(
              title: 'Subtotal',
              value: '₦ ${getPrices(
                distanceInMiles: order.distancePrice,
                isExpressDelivery: widget.isExpressDelivery,
              )}'),

          // rowItem(title: 'Total', value: '₦${order.distancePrice + 2000.00}'),
        ],
      ),
    );
  }

  Widget detailCard(
    size, {
    required String title,
    required String name,
    required String phone,
    required String address,
  }) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title details',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Recipient name :',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Phone number :',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Address :',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  address,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget rowItem({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title :",
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget method(
      {required String value, required String text, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, color: primaryColor1),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Radio(
          value: true,
          groupValue: pickedCash,
          onChanged: (value) {
            setState(() {
              pickedCash = true;
            });
          },
        ),
      ],
    );
  }

  Widget method1(
      {required String value, required String text, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, color: primaryColor1),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Radio(
          value: false,
          groupValue: pickedCash,
          onChanged: (value) {
            setState(() {
              pickedCash = true;
            });
          },
        ),
      ],
    );
  }
}
