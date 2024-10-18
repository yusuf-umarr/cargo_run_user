import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; 
import 'package:iconsax/iconsax.dart';

import '../../../utils/location.dart';
import '../../../styles/app_colors.dart';
import '../../../widgets/delivery_card.dart';

@RoutePage()
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late LatLng _initialPosition;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  CameraPosition? cposition;

  List<LatLng> latLen = [const LatLng(6.4703, 3.2818)];

  void getLocation() async {
    Position position = await determinePosition();
    debugPrint('position: $position');
    _initialPosition = LatLng(position.latitude, position.longitude);
    CameraPosition? kGooglePlex = CameraPosition(
      target: _initialPosition,
      zoom: 3.5,
    );
    setState(() {
      cposition = kGooglePlex;
    });
  }

  @override
  void initState() {
    getLocation();
    for (int i = 0; i < latLen.length; i++) {
      _markers.add(
        // added markers
        Marker(
          markerId: MarkerId(i.toString()),
          position: latLen[i],
          infoWindow: const InfoWindow(
            title: 'HOTEL',
            snippet: '5 Star Hotel',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      setState(() {});
      _polyline.add(Polyline(
        polylineId: const PolylineId('1'),
        points: latLen,
        color: Colors.green,
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(6.4453, 3.2634),
              zoom: 17,
            ),
            markers: _markers,
            // on below line we have enabled location
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            // on below line we have enabled compass location
            compassEnabled: true,
            // on below line we have added polylines
            polylines: _polyline,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          const Positioned(
            bottom: 0,
            child: DeliveryCard(),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                context.maybePop();
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
        ],
      ),
    );
  }
}
