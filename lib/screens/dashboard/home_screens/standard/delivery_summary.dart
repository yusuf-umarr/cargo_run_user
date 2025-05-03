import 'dart:developer';
import 'dart:developer' as dev;
import 'package:cargo_run/screens/alerts/account_creation_success.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:cargo_run/utils/util.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:cargo_run/widgets/page_widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart' as util;
import 'package:provider/provider.dart';
import '../../../../providers/order_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class DeliverySummary extends StatefulWidget {
  final bool isExpressDelivery;
  const DeliverySummary({super.key, this.isExpressDelivery = false});

  @override
  State<DeliverySummary> createState() => _DeliverySummaryState();
}

class _DeliverySummaryState extends State<DeliverySummary> {
  bool getPrice = false;
  bool pickedCash = false;
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? imageFile;

  String deliveryPrice = '';

  void saveImageD(Uint8List image) async {
    try {
      if (image != null) {
        final directory = await getTemporaryDirectory();

        final file = File('${directory.path}/shared_image.png');
        await file.writeAsBytes(image);

        await Share.shareXFiles([XFile(file.path)], text: 'Receipt');
      }
    } catch (e) {
      log("Error: $e");
    }
  }

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
    // final OrderProvider _orderVM = context.watch<OrderProvider>();

    final Size size = MediaQuery.of(context).size;
    final orderVM = context.watch<OrderProvider>();
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: AppBar(
        toolbarHeight: 120, // default is 56
        toolbarOpacity: 0.5,
        backgroundColor: primaryColor1,
        elevation: 0,
        leadingWidth: double.infinity,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: SvgPicture.asset(
                  'assets/images/arrow-left.svg',
                  width: 30,
                ),
              ),
              const Spacer(),
              const Text(
                "Summary",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                screenshotController.capture().then((Uint8List? image) {
                  //Capture Done
                  setState(() {
                    image;
                  });
                  // log("image:$image");
                  saveImageD(image!);
                }).catchError((onError) {
                  log(onError);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: const Icon(
                  Icons.share,
                  color: primaryColor1,
                ),
              ),
            ),
          )
        ],
      ),
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
                    Screenshot(
                      controller: screenshotController,
                      child: Column(
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
                        ],
                      ),
                    ),
                    Consumer<OrderProvider>(
                      builder: (context, watch, _) {
                        return (watch.orderStatus == OrderStatus.loading)
                            ? const LoadingButton(
                                textColor: Colors.white,
                                backgroundColor: primaryColor1,
                              )
                            : AppButton(
                                text: 'Confirm order',
                                hasIcon: false,
                                textColor: Colors.white,
                                backgroundColor: primaryColor1,
                                onPressed: () async {
                                  await watch
                                      .placeOrder(deliveryPrice)
                                      .then((value) {
                                    if (watch.orderStatus ==
                                        OrderStatus.success) {
                                      navigate();
                                    } else {
                                      util.toast(
                                          "Unable to create order, please try again");
                                    }
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

  String getPrices(
      {required String distanceInMeters,
      bool isExpressDelivery = false,
      required dynamic pricePerMeters}) {
    double subTotal = 0.0;

    dev.log("get---distanceInMeters${distanceInMeters}");

    try {
      double total =
          pricePerMeters * double.parse(removeMiSuffix(distanceInMeters));

      if (isExpressDelivery) {
        subTotal = total + (total * 0.10);
      } else {
        subTotal = total;
      }

      deliveryPrice = subTotal.toString();
      return formatAmount(subTotal.toString());
    } catch (e) {
      util.toast("Error fetching price, Please try again");
      return '';
    }
  }

  String getTotalPrice(
      {required String distanceInMeters,
      bool isExpressDelivery = false,
      required dynamic pricePerMeters}) {
    double total = 0;
    try {
      log("distanceInMeters--:$distanceInMeters");

      total = pricePerMeters * double.parse(removeMiSuffix(distanceInMeters));
      return formatAmount(total.toString());
    } catch (e) {
      util.toast("Error fetching price, please agian");
      return '';
    }
  }

  String getTenPercent(
      {required String distanceInMeters, required int pricePerMeters}) {
    double subTotal = 0.0;
    try {
      double total =
          pricePerMeters * double.parse(removeMiSuffix(distanceInMeters));
      subTotal = total * (10 / 100);
      return formatAmount(subTotal.toString());
    } catch (e) {
      util.toast("Error fetching price, please agian");
      return "";
    }
  }

  Widget _paymentSummary(Size size) {
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
          Row(
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: size.height * 0.04,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 20),
          rowItem(
              title: 'Total',
              value:
                  '₦ ${getTotalPrice(distanceInMeters: order.distanceMeters.toString(), isExpressDelivery: widget.isExpressDelivery, pricePerMeters: order.priceModel)}'),
          const SizedBox(height: 10),
          widget.isExpressDelivery
              ? rowItem(
                  title: 'Express Delivery\nCharge(10%)',
                  value:
                      '₦${getTenPercent(distanceInMeters: order.distanceMeters.toString(), pricePerMeters: order.priceModel)}')
              : const SizedBox.shrink(),
          const SizedBox(height: 10),

          rowItem(
              title: 'Subtotal',
              value: '₦ ${getPrices(
                distanceInMeters: order.distanceMeters.toString(),
                isExpressDelivery: widget.isExpressDelivery,
                pricePerMeters: order.priceModel,
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
              Expanded(
                flex: 3,
                child: Text(
                  '$title name :',
                  style: const TextStyle(
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
