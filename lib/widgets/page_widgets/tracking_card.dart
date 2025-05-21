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
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackParcelScreen(order: widget.order),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: primaryColor1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: widget.order.riderId?.profileImage != null
                    ? InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: const EdgeInsets.all(20),
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: InteractiveViewer(
                                    child: Image.network(
                                      widget.order.riderId!.profileImage!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          widget.order.riderId!.profileImage!,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/images/profile-icon.png',
                        height: 40,
                        width: 40,
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.order.riderId?.fullName ?? "Pending request",
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.order.receiverDetails?.address ?? "",
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: greyText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.order.riderId?.phone! ?? "NIL",
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: primaryColor1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(6.0),
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
                    widget.order.status!.toLowerCase() == "picked"
                        ? "ON GOING"
                        : widget.order.status!.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 9),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    widget.order.riderId?.vehicle?.plateNumber ?? "NIL NIL NIL",
                    style: const TextStyle(
                      color: primaryColor1,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
