import 'package:cargo_run/providers/order_provider.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class DeliveryCard extends StatefulWidget {
  const DeliveryCard({super.key});

  @override
  State<DeliveryCard> createState() => _DeliveryCardState();
}

class _DeliveryCardState extends State<DeliveryCard> {
  int order = 1;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orderP = Provider.of<OrderProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      width: size.width * 1,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            (order == 1)
                ? "Your rider 6 minutes away"
                : (order == 2)
                    ? "Your Rider has arrived at the pickup location"
                    : "Riding to Destination",
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10.0),
          rowItem(title: 'Order ID', value: '186792'),
          const SizedBox(height: 10.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/pp.png',
              height: 40,
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            visualDensity: const VisualDensity(
              horizontal: -4,
            ),
            title: const Text(
              'Samuel Olisa',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              orderP.currentOrder!.receiverDetails!.address!,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
            trailing: const SizedBox(
              width: 58,
              child: Row(
                children: [
                  Icon(Iconsax.call, color: primaryColor1),
                  SizedBox(width: 10),
                  Icon(Iconsax.message, color: primaryColor1),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          rowItem(title: 'Delivery Fee', value: '₦ 1,980.00'),
          const SizedBox(height: 25.0),
          (order == 1)
              ? AppButton(
                  text: 'Cancel Request',
                  hasIcon: false,
                  width: size.width * 0.6,
                  textColor: Colors.white,
                  backgroundColor: primaryColor1,
                  height: 45,
                  textSize: 16,
                  onPressed: () {
                    setState(() {
                      order = 2;
                    });
                  },
                )
              : (order == 2)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.4,
                          child: AppButton(
                            text: 'Start',
                            hasIcon: false,
                            textColor: primaryColor1,
                            onPressed: () {
                              setState(() {
                                order = 3;
                              });
                            },
                            height: 45,
                            textSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.4,
                          child: AppButton(
                            text: 'Cancel',
                            hasIcon: false,
                            textColor: Colors.white,
                            backgroundColor: primaryColor2,
                            onPressed: () {
                              setState(() {
                                order = 1;
                              });
                            },
                            height: 45,
                            textSize: 14,
                          ),
                        )
                      ],
                    )
                  : AppButton(
                      text: 'Package Delivered',
                      hasIcon: false,
                      textColor: Colors.white,
                      backgroundColor: primaryColor1,
                      width: size.width * 0.6,
                      height: 45,
                      textSize: 16,
                      onPressed: () => Navigator.pop(context),
                    )
        ],
      ),
    );
  }

  Widget rowItem({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
            color: primaryColor1,
          ),
        ),
      ],
    );
  }
}
