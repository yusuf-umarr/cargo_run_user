import 'package:cargo_run/styles/app_colors.dart';
import 'package:flutter/material.dart';

class DeliveryServiceCard extends StatelessWidget {
  final String image;
  final String text;
  const DeliveryServiceCard(
      {super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      // width: size.width * 0.3,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor1.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/$image', height: 100.0),
          const SizedBox(height: 20.0),
          Text(
            text,
            style: const TextStyle(
              color: blackText,
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
