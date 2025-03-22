// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:cargo_run/models/order.dart';
import 'package:cargo_run/providers/app_provider.dart';
import 'package:cargo_run/providers/order_provider.dart';
import 'package:cargo_run/screens/dashboard/widget/countdown.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:cargo_run/utils/location.dart';
import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:developer' as dev;

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

// class _MapWidgetState extends State<MapWidget> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   bool showPopup = true;

//   bool isShowCard = true;

//   BitmapDescriptor bikeIcon = BitmapDescriptor.defaultMarker;

//   late LatLng _initialPosition;
//   late GoogleMapController mapController;

//   CameraPosition? cposition;

//   @override
//   void initState() {
//     getLocation();
//     setCustomMarkerIcon();
//     super.initState();
//   }
//   void getLocation() async {
//     Position position = await determinePosition();
//     debugPrint('position: $position');
//     _initialPosition = LatLng(position.latitude, position.longitude);
//     final CameraPosition kGooglePlex = CameraPosition(
//       target: _initialPosition,
//       zoom: 14.4746,
//     );
//     setState(() {

//     });

//     if (mounted) {
//       setState(() {
//         cposition = kGooglePlex;
//       });
//     }
//   }

//   Future<void> setCustomMarkerIcon() async {
//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration.empty, "assets/images/delivery.png")
//         .then((icon) {
//       bikeIcon = icon;
//        setState(() {});
//     });

//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     final orderProvider = context.watch<OrderProvider>();
//     return SizedBox(
//       child: Stack(
//         children: [
//           Column(
//             children: [
//               SizedBox(
//                 height: size.height * 0.4,
//                 child: GoogleMap(
//                   myLocationButtonEnabled: false,
//                   zoomControlsEnabled: false,
//                   initialCameraPosition: CameraPosition(
//                     target: LatLng(
//                     _initialPosition.latitude,
//                      _initialPosition.longitude,
//                     ),
//                     zoom: 13.5,
//                   ),
// markers:orderProvider.availableDriverModel.map((LatLng position) {
//   return Marker(
//     markerId: MarkerId(position.toString()),
//     position: position,
//     icon: bikeIcon,
//   );
// }).toSet(),
//                   onMapCreated: (mapController) {
//                     _controller.complete(mapController);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

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
    getLocation();
    setCustomMarkerIcon();
  }

  void getLocation() async {
    Position position = await determinePosition();
    debugPrint('position: $position');
    getAvailableDrivers(position);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      cposition = CameraPosition(target: _initialPosition!, zoom: 14.4746);
    });

    // Future.delayed(Duration(seconds: 1),(){
    //     Provider.of<OrderProvider>(context, listen: false).   socket!.emit(
    //     'location',
    //     {
    //       "lat": position.latitude,
    //       "lng": position.longitude,
    //       "userId": sharedPrefs.userId,
    //     },
    //   );
    // });
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
