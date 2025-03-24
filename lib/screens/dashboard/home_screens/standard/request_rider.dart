// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cargo_run/screens/dashboard/home_screens/bulk/bulk_delivery_details_screen.dart';
import 'package:cargo_run/screens/dashboard/home_screens/standard/delivery_details_screen.dart';
import 'package:cargo_run/utils/util.dart';
import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:nb_utils/nb_utils.dart' as util;
// import 'package:location_picker_text_field/open_street_location_picker.dart';
import 'package:provider/provider.dart';
// import 'package:cargo_run/providers/order_provider.dart';
import '../../../../styles/app_colors.dart';
import '../../../../widgets/app_buttons.dart';
import '../../../../widgets/app_textfields.dart';
import '../../../../widgets/page_widgets/appbar_widget.dart';
import '../../../../providers/order_provider.dart';
import 'dart:developer' as dev;

class RequestRider extends StatefulWidget {
  final String type;
  const RequestRider({super.key, required this.type});

  @override
  State<RequestRider> createState() => _RequestRiderState();
}

class _RequestRiderState extends State<RequestRider> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();
  final TextEditingController _pickupAddressController =
      TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  double pickUpAdrrLong = 0;
  double pickUpAdrrLat = 0;
  double dropOffAdrrLong = 0;
  double dropOffAdrrLat = 0;

  bool isTypingPickUp = false;

  @override
  void dispose() {
    _houseNoController.dispose();
    _latController.dispose();
    _longController.dispose();
    _pickupAddressController.dispose();
    _contactNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context, title: 'Pickup details', hasBackBtn: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40.0),
                const Text(
                  'Complete the below fields ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30.0),

                // AppTextField(
                //   noLabel: false,
                //   labelText: 'House No',
                //   hintText: 'House No.',
                //   keyboardType: TextInputType.number,
                //   controller: _houseNoController,
                // ),
                // const SizedBox(height: 20.0),

                pickUpAddressTextField(),

                const SizedBox(height: 20.0),

                AppTextField(
                  noLabel: false,
                  labelText: 'Phone No',
                  hintText: 'Phone No',
                  isPhone: false,
                  keyboardType: TextInputType.phone,
                  controller: _contactNumberController,
                ),
                // const Spacer(),
                const SizedBox(height: 50.0),
                Consumer<OrderProvider>(builder: (context, watch, _) {
                  return AppButton(
                    text: 'Next',
                    hasIcon: true,
                    textColor: Colors.white,
                    backgroundColor: primaryColor1,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        watch
                            .addAdrressDetails(
                                _houseNoController.text,
                                _pickupAddressController.text,
                                _contactNumberController.text,
                                _latController.text,
                                _longController.text)
                            .then((x) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DeliveryDetailsScreen(),
                            ),
                          );
                        });
                      }
                    },
                  );
                }),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Consumer pickUpAddressTextField() {
    return Consumer<OrderProvider>(builder: (context, orderVM, _) {
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
                                _pickupAddressController.text =
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
                                      "_latController.text:${_latController.text}");
                                  dev.log(
                                      "_longController.text:${_longController.text}");
                                });

                                setState(() {});
                              } catch (e) {
                                util.toast("Network error, please retry");
                                _pickupAddressController.clear();
                                log("source addr err:$e");
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
            externalText: "Pick up address",
            hint: "Enter address",
            controller: _pickupAddressController,
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
}
