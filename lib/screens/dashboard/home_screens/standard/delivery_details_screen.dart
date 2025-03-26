// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:developer' as dev;
// import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/providers/order_provider.dart';
import 'package:cargo_run/screens/dashboard/home_screens/standard/delivery_summary.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/util.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:cargo_run/widgets/app_textfields.dart';
import 'package:cargo_run/widgets/page_widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:group_button/group_button.dart';
import 'package:nb_utils/nb_utils.dart' as util;
import 'package:provider/provider.dart';

// @RoutePage()
class DeliveryDetailsScreen extends StatefulWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _recipientsNameController =
      TextEditingController();
  final TextEditingController _recipientsPhoneController =
      TextEditingController();
  final TextEditingController _recipientsAddressController =
      TextEditingController();
  final TextEditingController _packageCategoryController =
      TextEditingController();
  final TextEditingController _deliveryOption = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();

  bool expressDelivery = false;
  bool normalDelivery = false;

  bool isTypingPickUp = false;

  @override
  void dispose() {
    _latController.dispose();
    _longController.dispose();
    _recipientsNameController.dispose();
    _recipientsPhoneController.dispose();
    _recipientsAddressController.dispose();
    _packageCategoryController.dispose();
    _deliveryOption.dispose();
    super.dispose();
  }

  void navigate(OrderProvider orderVM) async {
    await context
        .read<OrderProvider>()
        .calculateDistance(
          sourceLat: orderVM.addressDetails!.lat!.toDouble(),
          sourceLng: orderVM.addressDetails!.lng!.toDouble(),
          destinationLat: orderVM.receiverDetails!.lat!.toDouble(),
          destinationLng: orderVM.receiverDetails!.lng!.toDouble(),
        )
        .then((x) {
      if (context.read<OrderProvider>().distanceMeters != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeliverySummary(
              isExpressDelivery: expressDelivery,
            ),
          ),
        );
      } else {
        util.toast("Route could not be fetched! Please try again");
        log("price could be fteched");
      }
    });
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar:
          appBarWidget(context, title: "Reciever's details", hasBackBtn: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40.0),
                // const Text(
                //   'Select delivery option',
                //   style: TextStyle(
                //     fontSize: 18.0,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                // const SizedBox(height: 10.0),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     deliveryOption(normalDelivery,
                //         title: 'Normal', width: size.width * 0.42, onTap: () {
                //       setState(() {
                //         normalDelivery = true;
                //         expressDelivery = false;
                //       });
                //       context.read<OrderProvider>().setDeliveryOption('normal');
                //     }),
                //     deliveryOption(expressDelivery,
                //         title: 'Express', width: size.width * 0.42, onTap: () {
                //       setState(() {
                //         expressDelivery = true;
                //         normalDelivery = false;
                //         _deliveryOption.text = 'Express ';
                //       });
                //       context
                //           .read<OrderProvider>()
                //           .setDeliveryOption('express');
                //     }),
                //   ],
                // ),
                // const SizedBox(height: 10.0),
                // const Text(
                //   'Please note that express delivery charge extra 10% cost.',
                //   style: TextStyle(
                //     fontSize: 15.0,
                //     color: greyText,
                //   ),
                // ),

                const SizedBox(height: 10.0),
                AppTextField(
                  labelText: 'Recipients name',
                  hintText: 'Enter name',
                  controller: _recipientsNameController,
                  noLabel: false,
                ),
                const SizedBox(height: 20.0),
                AppTextField(
                  labelText: 'Recipients phone number',
                  hintText: 'Enter number',
                  controller: _recipientsPhoneController,
                  isNumber: true,
                  keyboardType: TextInputType.phone,
                  noLabel: false,
                ),
                const SizedBox(height: 20.0),
                recipientAddressTextField(),
                // AppTextField(
                //   labelText: 'Recipients Address',
                //   hintText: 'Address',
                //   controller: _recipientsAddressController,
                //   noLabel: true,
                // ),
                const SizedBox(height: 30.0),
                const Text(
                  "Package Category",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'What are you sending?',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: greyText,
                  ),
                ),
                const SizedBox(height: 20.0),
                //grouped buttons
                Align(
                  alignment: Alignment.center,
                  child: GroupButton(
                    isRadio: true,
                    buttons: const [
                      'Documents',
                      'Food',
                      'Clothing',
                      'Electronics',
                      'Liquid',
                      'Glass',
                      'Others',
                    ],
                    options: GroupButtonOptions(
                      unselectedBorderColor: primaryColor2,
                      unselectedTextStyle: const TextStyle(
                        color: primaryColor2,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      selectedShadow: const [],
                      unselectedShadow: const [],
                      selectedColor: primaryColor2,
                      unselectedColor: Colors.transparent,
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onSelected: (val, i, selected) {
                      debugPrint('Button: $val, index: $i $selected');
                      _packageCategoryController.text = val;
                    },
                  ),
                ),
                const SizedBox(height: 30.0),
                Consumer<OrderProvider>(
                  builder: (context, watch, _) {
                    return (watch.orderStatus == OrderStatus.loading)
                        ? const LoadingButton(
                            textColor: Colors.white,
                            backgroundColor: primaryColor1,
                          )
                        : AppButton(
                            text: 'Next',
                            hasIcon: true,
                            textColor: Colors.white,
                            backgroundColor: primaryColor1,
                            onPressed: () async {
                              // if (!expressDelivery && !normalDelivery) {
                              //   showSnackBar("Please select a delivery option");

                              //   return;
                              // }
                              if (_formKey.currentState!.validate()) {
                                watch.addRecipientDetails(
                                  _recipientsNameController.text,
                                  _recipientsPhoneController.text,
                                  _recipientsAddressController.text,
                                  _packageCategoryController.text,
                                  _deliveryOption.text,
                                  _latController.text,
                                  _longController.text,
                                );

                                navigate(watch);
                                // await watch.placeOrder().then((value) => {
                                //       if (watch.orderStatus ==
                                //           OrderStatus.pending)
                                //         {navigate()}
                                //       else
                                //         {showSnackBar(watch.errorMessage)}
                                //     });
                              }
                            },
                          );
                  },
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget deliveryOption(
    bool picked, {
    required String title,
    required double width,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: width,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: (picked == true) ? primaryColor1 : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Image.asset(
              'assets/images/delivery.png',
              color: (picked == true) ? Colors.white : Colors.black,
              height: 50,
            ),
            const SizedBox(height: 10.0),
            Text(
              '$title Delivery',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: (picked == true) ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Consumer recipientAddressTextField() {
    return Consumer<OrderProvider>(builder: (context, orderVM, _) {
      // final List searchedPlaces = orderVM.dSearchResults!;
      return Column(
        children: [
          isTypingPickUp
              ? Builder(builder: (context) {
                  if (orderVM.dSearchResults.isNotEmpty) {
                    return Card(
                      child: Column(
                        children: orderVM.dSearchResults.map<Widget>((x) {
                          return ListTile(
                            onTap: () async {
                              try {
                                _recipientsAddressController.text =
                                    x.placePrediction.text.text;

                                isTypingPickUp = false;

                                orderVM
                                    .locationFromAddress(
                                        addr: x.placePrediction.text.text)
                                    .then((x) {
                                  _latController.text = orderVM
                                      .locationFromAddr!
                                      .results![0]
                                      .geometry!
                                      .location!
                                      .lat
                                      .toString();
                                  _longController.text = orderVM
                                      .locationFromAddr!
                                      .results![0]
                                      .geometry!
                                      .location!
                                      .lng
                                      .toString();

                                  dev.log(
                                      "des _latController.text:${_latController.text}");
                                  dev.log(
                                      "des _longController.text:${_longController.text}");
                                });

                                setState(() {});
                                if (mounted) {
                                  FocusScope.of(context).unfocus();
                                }
                              } catch (e) {
                                util.toast("Network error, please retry");
                                _recipientsAddressController.clear();
                                log("error:$e");
                              }
                            },
                            title: Text(
                              x.placePrediction.text.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                })
              : const SizedBox(),
          Util.inputField2(
            externalText: "Recipients address",
            hint: "Enter address",
            controller: _recipientsAddressController,
            validator: (value) => value!.isEmpty ? '*Field is required' : null,
            onChanged: (query) {
              if (query != "") {
                setState(() {
                  isTypingPickUp = true;
                });
              } else {
                setState(() {
                  isTypingPickUp = false;
                });
              }
              orderVM.getAutocompletePlaces(query);
            },
          ),
        ],
      );
    });
  }
//
}
