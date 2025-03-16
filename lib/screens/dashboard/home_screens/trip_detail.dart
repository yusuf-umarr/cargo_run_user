// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:cargo_run/config/config.dart';
import 'package:cargo_run/models/order.dart';
import 'package:cargo_run/providers/order_provider.dart';
import 'package:cargo_run/screens/dashboard/avatar_glow.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/location.dart';
import 'package:cargo_run/widgets/delivery_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class TripDetailWidget extends StatefulWidget {
  final Order order;

  const TripDetailWidget({
    super.key,
    required this.order,
  });

  @override
  State<TripDetailWidget> createState() => _TripDetailWidgetState();
}

class _TripDetailWidgetState extends State<TripDetailWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  bool showPopup = true;

  bool isShowCard = true;
  List<LatLng> polylineCoordinates = [];

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  double riderLat = 6.64638;
  double riderLong = 3.517462;

  late LatLng _initialPosition;
  late GoogleMapController mapController;

  CameraPosition? cposition;

  void getLocation() async {
    Position position = await determinePosition();
    debugPrint('position: $position');
    _initialPosition = LatLng(position.latitude, position.longitude);
    final CameraPosition kGooglePlex = CameraPosition(
      target: _initialPosition,
      zoom: 14.4746,
    );

    if (mounted) {
      setState(() {
        cposition = kGooglePlex;
        riderLat = position.latitude;
        riderLong = position.latitude;
      });
    }
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(
          //source
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
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(
            point.latitude,
            point.longitude,
          ),
        );
      }
      setState(() {});
    }
  }

  Future<void> setCustomMarkerIcon() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/sourceIcon.png")
        .then((icon) {
      sourceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/destinationIcon.png")
        .then((icon) {
      destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/riderIcon.png")
        .then((icon) {
      currentLocationIcon = icon;
    });
  }

  @override
  void initState() {
    // getLocation();
    setCustomMarkerIcon();

    getPolyPoints();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // final provider = ref.watch(requestController);
    return SizedBox(
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: size.height * 0.4,
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.order.addressDetails!.lat!.toDouble(),
                      widget.order.addressDetails!.lng!.toDouble(),
                    ),
                    zoom: 13.5,
                  ),
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId("route"),
                      points: polylineCoordinates,
                      color: primaryColor1,
                      width: 6,
                    )
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId("riderLocation"),
                      icon: currentLocationIcon,
                      position: LatLng(
                        widget.order.riderLocation!.lat!,
                        widget.order.riderLocation!.lng!,
                      ),
                    ),
                    Marker(
                      markerId: const MarkerId("source"),
                      position: LatLng(
                        widget.order.addressDetails!.lat!.toDouble(),
                        widget.order.addressDetails!.lng!.toDouble(),
                      ),
                      icon: sourceIcon,
                    ),
                    Marker(
                        markerId: const MarkerId("destination"),
                        position: LatLng(
                          widget.order.receiverDetails!.lat!.toDouble(),
                          widget.order.receiverDetails!.lng!.toDouble(),
                        ),
                        icon: destinationIcon),
                  },
                  onMapCreated: (mapController) {
                    _controller.complete(mapController);
                  },
                ),
              ),
            ],
          ),
       
        ],
      ),
    );
  }
}
