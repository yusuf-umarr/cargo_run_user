import 'dart:async';
import 'dart:developer';
import 'package:cargo_run/config/config.dart';
import 'package:cargo_run/services/orders/orders_implementation.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripRoutePage extends StatefulWidget {
  final LatLng pickUpLocation;
  final LatLng dropOffLocation;
  final LatLng riderLocation;
  final String pickUpAddr;
  final String dropOffAddr;
  final String itemName;
  final String itemImage;
  final String pickUpTime;
  const TripRoutePage({
    super.key,
    required this.dropOffLocation,
    required this.pickUpLocation,
    required this.riderLocation,
    required this.pickUpAddr,
    required this.dropOffAddr,
    required this.itemName,
    required this.itemImage,
    required this.pickUpTime,
  });

  @override
  State<TripRoutePage> createState() => _TripRoutePageState();
}

class _TripRoutePageState extends State<TripRoutePage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  bool isShowCard = true;
  Position? _currentPosition;
  List<LatLng> polylineCoordinates = [];

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    _currentPosition = position;
    setState(() {});

    log("------position.longitude.toString() ${_currentPosition!.latitude.toString()}");

    GoogleMapController googleMapController = await _controller.future;

    Future.delayed(const Duration(milliseconds: 100), () {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(zoom: 12, target: widget.pickUpLocation),
        ),
      );
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(
          widget.pickUpLocation.latitude,
          widget.pickUpLocation.longitude,
        ),
        destination: PointLatLng(
          widget.dropOffLocation.latitude,
          widget.dropOffLocation.longitude,
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
    getCurrentLocation();
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
    return Scaffold(
      body:

          // _currentPosition == null
          //     ? const Center(child: CupertinoActivityIndicator())
          //     :
          Column(
        children: [
          Expanded(
            child: SizedBox(
              height: size.height * 0.65,
              child: GoogleMap(
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: widget.pickUpLocation,
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
                      position: LatLng(8.4751, 4.6289)),
                  Marker(
                    markerId: const MarkerId("source"),
                    position: widget.pickUpLocation,
                    icon: sourceIcon,
                  ),
                  Marker(
                      markerId: const MarkerId("destination"),
                      position: widget.dropOffLocation,
                      icon: destinationIcon),
                },
                onMapCreated: (mapController) {
                  _controller.complete(mapController);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
