// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:cargo_run/models/order.dart';
import 'package:cargo_run/providers/order_provider.dart';
import 'package:cargo_run/screens/dashboard/widget/countdown.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

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
  final Completer<GoogleMapController> _controller = Completer();
  bool showPopup = true;
  bool isShowCard = true;

  BitmapDescriptor bikeIcon = BitmapDescriptor.defaultMarker;

  LatLng? _initialPosition; // Nullable to check initialization status
  late GoogleMapController mapController;

  CameraPosition? cposition;

  @override
  void initState() {
    super.initState();
    // getLocation();
    setCustomMarkerIcon();
  }

  void getLocation() async {
    final OrderProvider orderVM = context.read<OrderProvider>();
    if (orderVM.currentLat != null) {
      setState(() {
        _initialPosition = LatLng(orderVM.currentLat!, orderVM.currentLong!);
        cposition = CameraPosition(target: _initialPosition!, zoom: 14.4746);
      });
        // dev.log("_initialPosition:$_initialPosition");
        // dev.log("orderVM.currentLat:${orderVM.currentLat!}");
        // dev.log("orderVM.currentLat:${ orderVM.currentLong!}");
    }
  
  }

  getAvailableDrivers(Position position) {
    if (mounted) {
      context.read<OrderProvider>().setLocationCoordinate(
            lat: position.latitude,
            long: position.longitude,
          );
    }
  }

  Future<void> setCustomMarkerIcon() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/delivery.png")
        .then((icon) {
      setState(() {
        bikeIcon = icon;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final orderProvider = context.watch<OrderProvider>();
    getLocation() ;

    return SizedBox(
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: size.height * 0.4,
                child: _initialPosition == null
                    ? const Center(child: CircularProgressIndicator())

                    // Show loading while waiting for location
                    : GoogleMap(
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: _initialPosition!,
                          zoom: 13.5,
                        ),
                        onMapCreated: (mapController) {
                          _controller.complete(mapController);
                        },
                        markers: orderProvider.availableDriverList.map((posi) {
                          return Marker(
                            markerId: MarkerId(posi.toString()),
                            position: LatLng(
                              posi['locationCoord']['coordinates'][1],
                              posi['locationCoord']['coordinates'][0],
                            ),
                            icon: bikeIcon,
                          );
                        }).toSet(),
                      ),
              ),
            ],
          ),
          if (_initialPosition != null) ...[
            const Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Looking For Nearby Riders",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  backgroundColor: primaryColor2,
                ),
              ),
            ),
          ],
          if (_initialPosition != null) ...[
            Positioned(
              left: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CountdownTimer(),
              ),
            )
          ],
        ],
      ),
    );
  }
}
