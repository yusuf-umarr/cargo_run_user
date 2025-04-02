import 'package:cargo_run/screens/dashboard/shipment_screens/shipment_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart';
import '../../styles/app_colors.dart';

class ShipmentCard extends StatelessWidget {
  final Order order;
  const ShipmentCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShipmentDetailsScreen(order: order)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Order',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: blackText,
                          ),
                        ),
                        TextSpan(
                          text: ' #${order.orderId}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: primaryColor1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    DateFormat.yMMMMd()
                        .format(DateTime.parse(order.createdAt!)),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: blackText,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    order.receiverDetails!.address!,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: blackText,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  order.status!.toLowerCase() == "picked"
                      ? "ON GOING"
                      : order.status!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: switch (order.status!) {
                      'pending' => Colors.orange,
                      'delivered' => greenText,
                      'cancelled' => redText,
                      _ => blackText
                    },
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  order.price!=null?
                  "₦${order.price!.toStringAsFixed(2)}":"0",
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  order.paymentStatus == "paid" ? "PAID" : "",
                  style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: greenText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
