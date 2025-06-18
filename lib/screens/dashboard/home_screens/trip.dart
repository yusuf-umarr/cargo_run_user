// trip_route_page.dart

import 'dart:async';
import 'package:cargo_run/config/config.dart';
import 'package:cargo_run/models/order.dart';
import 'package:cargo_run/providers/order_provider.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/location.dart';
import 'package:cargo_run/widgets/delivery_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class TripRoutePage extends StatefulWidget {
  final Order order;

  const TripRoutePage({super.key, required this.order});

  @override
  State<TripRoutePage> createState() => _TripRoutePageState();
}

class _TripRoutePageState extends State<TripRoutePage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  List<LatLng> polylineCoordinates = [];
  late GoogleMapController mapController;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor riderIcon = BitmapDescriptor.defaultMarker;

  bool showPopup = true;

  @override
  void initState() {
    super.initState();
    setCustomMarkerIcon();
    getPolyPoints();
    // Provider.of<OrderProvider>(context, listen: false)
    //     .initSocketConnection(widget.order.id!); // socket
  }

  @override
  void dispose() {
    // Provider.of<OrderProvider>(context, listen: false).disposeSocket();
    super.dispose();
  }

  Future<void> setCustomMarkerIcon() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/images/sourceIcon.png");
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/images/destinationIcon.png");
    riderIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/images/delivery.png");
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(
          widget.order.addressDetails!.lat!.toDouble(),
          widget.order.addressDetails!.lng!.toDouble(),
        ),
        destination: PointLatLng(
          widget.order.receiverDetails!.lat!.toDouble(),
          widget.order.receiverDetails!.lng!.toDouble(),
        ),
        mode: TravelMode.driving,
      ),
      googleApiKey: googleApiKey,
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Consumer<OrderProvider>(
            builder: (context, orderVM, _) {
              Set<Marker> markers = {
                Marker(
                  markerId: const MarkerId('source'),
                  position: LatLng(
                    widget.order.addressDetails!.lat!.toDouble(),
                    widget.order.addressDetails!.lng!.toDouble(),
                  ),
                  icon: sourceIcon,
                ),
                Marker(
                  markerId: const MarkerId('destination'),
                  position: LatLng(
                    widget.order.receiverDetails!.lat!.toDouble(),
                    widget.order.receiverDetails!.lng!.toDouble(),
                  ),
                  icon: destinationIcon,
                ),
              };

              if (orderVM.riderLat != null && orderVM.riderLng != null) {
                final riderPosition =
                    LatLng(orderVM.riderLat!, orderVM.riderLng!);

                markers.add(
                  Marker(
                    markerId: const MarkerId('rider'),
                    position: riderPosition,
                    icon: riderIcon,
                  ),
                );

                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  final controller = await _controller.future;
                  controller.animateCamera(
                    CameraUpdate.newLatLng(riderPosition),
                  );
                });
              }

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.order.addressDetails!.lat!.toDouble(),
                    widget.order.addressDetails!.lng!.toDouble(),
                  ),
                  zoom: 13.5,
                ),
                onMapCreated: (controller) {
                  _controller.complete(controller);
                  mapController = controller;
                },
                polylines: {
                  Polyline(
                    polylineId: const PolylineId("route"),
                    points: polylineCoordinates,
                    color: primaryColor1,
                    width: 6,
                  )
                },
                markers: markers,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              );
            },
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: primaryColor1,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Iconsax.arrow_left, color: Colors.white),
              ),
            ),
          ),

          // Rider/Delivery Info Card
          Positioned(
            bottom: -20,
            left: size.width * 0.1,
            right: size.width * 0.1,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: showPopup ? size.height * 0.38 : 0,
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: showPopup
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ]
                    : [],
              ),
              child: showPopup
                  ? Stack(
                      children: [
                        DeliveryCard(order: widget.order),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showPopup = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                children: [
                                  Text("Hide card"),
                                  Icon(Icons.arrow_downward),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),

          if (!showPopup)
            Positioned(
              right: 5,
              bottom: 20,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showPopup = true;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Text("Show card"),
                      Icon(Icons.arrow_upward),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
