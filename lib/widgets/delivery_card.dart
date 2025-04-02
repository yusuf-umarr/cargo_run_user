import 'package:cargo_run/models/order.dart';
import 'package:cargo_run/styles/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeliveryCard extends StatefulWidget {
  final Order order;

  const DeliveryCard({
    super.key,
    required this.order,
  });

  @override
  State<DeliveryCard> createState() => _DeliveryCardState();
}

class _DeliveryCardState extends State<DeliveryCard> {
  // _callNumber(String phone) async {
  //   bool? res = await FlutterPhoneDirectCaller.callNumber(phone);
  // }

  // int order = 1;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 15.0),
      width: size.width,
      decoration: BoxDecoration(
        color: primaryColor1,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                (widget.order.status == "accepted")
                    ? "The rider is few\nminutes away"
                    : (widget.order.status == 'picked')
                        ? "Order is en route\nto destination"
                        : (widget.order.status == 'arrived')
                            ? "Order has arrived\ndestination point"
                            : " ",
                style: const TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          rowItem(title: 'Order ID', value: '${widget.order.orderId}'),
          const SizedBox(height: 5.0),
          ListTile(
            visualDensity: const VisualDensity(
              horizontal: -4,
            ),
            title: Text(
              widget.order.receiverDetails!.name!,
              style: const TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              widget.order.receiverDetails!.address!,
              style: const TextStyle(
                fontSize: 11.0,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          rowItem(title: 'Delivery Fee', value: '₦ ${widget.order.price!.toStringAsFixed(2)}'),
          const SizedBox(height: 15.0),
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
          style: GoogleFonts.roboto(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: primaryColor2,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
