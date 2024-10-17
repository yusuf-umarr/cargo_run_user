import 'package:cargo_run/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentSummaryCard extends StatelessWidget {
  final String deliveryFee;
  final String paymentStatus;
  final bool? removeMargin;
  const PaymentSummaryCard({
    super.key,
    this.removeMargin,
    required this.deliveryFee,
    required this.paymentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      margin: (removeMargin == true)
          ? const EdgeInsets.all(0)
          : const EdgeInsets.symmetric(vertical: 40.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Summary',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          rowItem(title: 'Subtotal', value: '₦ $deliveryFee'),
          const SizedBox(height: 10.0),
          rowItem(title: 'Delivery Fee', value: '₦ 2000.00'),
          const Divider(
            thickness: 1,
            color: greyText,
          ),
          rowItem(
              title: 'Total',
              value:
                  '₦ ${(double.parse(deliveryFee) + 2000.00).toStringAsFixed(2)}'),
          const SizedBox(height: 10.0),
          rowItem(
            title: 'Payment Status',
            value: paymentStatus.toUpperCase(),
            textColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget rowItem(
      {required String title, required String value, Color? textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
            color: textColor ?? blackText,
          ),
        ),
      ],
    );
  }
}
