import 'package:cargo_run/screens/dashboard/home_screens/track_parcel_screen.dart';
import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../../models/order.dart';

class TrackingCard extends StatefulWidget {
  final Order order;
  const TrackingCard({super.key, required this.order});

  @override
  State<TrackingCard> createState() => _TrackingCardState();
}

class _TrackingCardState extends State<TrackingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TrackParcelScreen(order: widget.order)));
        },
        leading: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        title: Text(
          'Order #${widget.order.orderId}',
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: primaryColor1,
          ),
        ),
        subtitle: Text(
          widget.order.receiverDetails!.address!,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: greyText,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: switch (widget.order.status!) {
              'delivered' => primaryColor2,
              'pending' => Colors.orange,
              'cancelled' => Colors.red,
              _ => primaryColor1,
            },
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            widget.order.status!.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        ),
      ),
    );
  }
}
