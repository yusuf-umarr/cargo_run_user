import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/utils/util.dart';
import 'package:flutter/material.dart';
// import 'package:location_picker_text_field/open_street_location_picker.dart';
import 'package:provider/provider.dart';
// import 'package:cargo_run/providers/order_provider.dart';
import '../../../../styles/app_colors.dart';
import '../../../../widgets/app_buttons.dart';
import '../../../../widgets/app_textfields.dart';
import '../../../../widgets/page_widgets/appbar_widget.dart';
import '../../../../providers/order_provider.dart';
import '../../../../utils/app_router.gr.dart';

@RoutePage()
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
      TextEditingController(text: "+234");

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
      appBar: appBarWidget(context, title: 'Pickup Details'),
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
                  'Address Details',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10.0),

                AppTextField(
                  noLabel: false,
                  labelText: 'House No',
                  hintText: 'House No.',
                  keyboardType: TextInputType.number,
                  controller: _houseNoController,
                  
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Address ",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),

                pickUpAddressTextField(),
                // LocationPicker(
                //   label: "From",
                //   controller: _pickupAddressController,
                //   onSelect: (data) {
                //     _pickupAddressController.text = data.displayname;
                //     _latController.text = data.latitude.toString();
                //     _longController.text = data.longitude.toString();
                //     log("longitude:${data.longitude}");
                //     log("latitude:${data.latitude}");
                //   },
                // ),
                const SizedBox(height: 20.0),

                AppTextField(
                  noLabel: false,
                  labelText: 'Contact Number',
                  hintText: 'Contact Number',
                  isPhone: false,
                  keyboardType: TextInputType.phone,
                  controller: _contactNumberController,
                ),
                // const Spacer(),
                Consumer<OrderProvider>(builder: (context, watch, _) {
                  return AppButton(
                    text: 'Next',
                    hasIcon: true,
                    textColor: Colors.white,
                    backgroundColor: primaryColor1,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        watch.addAdrressDetails(
                            _houseNoController.text,
                            _pickupAddressController.text,
                            _contactNumberController.text,
                            _latController.text,
                            _longController.text);
                        if (widget.type == 'bulk') {
                          context.router.push(const BulkDeliveryDetailsRoute());
                        } else {
                          context.router.push(const DeliveryDetailsRoute());
                        }
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

  Widget textField(String hint,
      {bool? isPhone, TextEditingController? controller}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              keyboardType:
                  (isPhone == true) ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
              validator: (value) =>
                  value!.isEmpty ? '*Field cannot be empty' : null,
            ),
          ),
        ],
      ),
    );
  }

    Consumer pickUpAddressTextField() {
    return Consumer<OrderProvider>(builder: (context, otherVM, _) {
      final List searchedPlaces = otherVM.dSearchResults!;
      return Column(
        children: [
          isTypingPickUp
              ? Card(
                  child: Column(
                    children: searchedPlaces.map<Widget>((x) {
                      return ListTile(
                        onTap: () async {
                          _pickupAddressController.text = x.description;

                          isTypingPickUp = false;

                          setState(() {});
                        },
                        title: Text(
                          x.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox(),
          Util.inputField2(
            externalText: "Pick up address",
            hint: "enter address",
            controller: _pickupAddressController,
            // validator: Util.validateName,
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
              // SearchData(query);
              otherVM.searchPlaces(query);
            },
          ),
        ],
      );
    });
  }
//
}
