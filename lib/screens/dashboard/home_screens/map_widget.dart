// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:cargo_run/models/order.dart';
import 'package:cargo_run/utils/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:developer' as dev;

class MapWidget extends StatefulWidget {
  final Order order;

  const MapWidget({
    super.key,
    required this.order,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  bool showPopup = true;

  bool isShowCard = true;

  BitmapDescriptor bikeIcon = BitmapDescriptor.defaultMarker;

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
      });
    }
  }

  Future<void> setCustomMarkerIcon() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/delivery.png")
        .then((icon) {
      bikeIcon = icon;
    });
    setState(() {});
  }

  @override
  void initState() {
    // getLocation();
    setCustomMarkerIcon();

    // dev.log(
    //     "widget.order.addressDetails!.lat!:${widget.order.addressDetails!.lat!}");
    // dev.log(
    //     "widget.order.addressDetails!.long!:${widget.order.addressDetails!.lng!}");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<LatLng> availableRiders = [
    LatLng(8.4790523, 4.5352917999999995),
    LatLng(8.455685, 4.5444),
    LatLng(8.5373, 4.5444),
    // LatLng(
    //   widget.order.addressDetails!.lat!.toDouble(),
    //   widget.order.addressDetails!.lng!.toDouble(),
    // ),
  ];

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
                  markers: availableRiders.map((LatLng position) {
                    return Marker(
                      markerId: MarkerId(position.toString()),
                      position: position,
                      icon: bikeIcon,
                    );
                  }).toSet(),
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



/*

      // markers: {
                  //   Marker(
                  //     markerId: const MarkerId("availableRider"),
                  //     position:

                  //     LatLng(
                  //       widget.order.addressDetails!.lat!.toDouble(),
                  //       widget.order.addressDetails!.lng!.toDouble(),
                  //     ),
                  //     icon: bikeIcon,
                  //   ),
                  // },
*/