// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';
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
import 'dart:developer' as dev;

class TripRoutePage extends StatefulWidget {
  final Order order;

  const TripRoutePage({
    super.key,
    required this.order,
  });

  @override
  State<TripRoutePage> createState() => _TripRoutePageState();
}

class _TripRoutePageState extends State<TripRoutePage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  bool showPopup = true;

  bool isShowCard = true;
  List<LatLng> polylineCoordinates = [];

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor riderLocationIcon = BitmapDescriptor.defaultMarker;

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
    getPolyPoints();
  }

  void getPolyPoints() async {
    log("widget.order.status:${widget.order.status}");
    final orderVM = Provider.of<OrderProvider>(context, listen: false);
    PolylinePoints polylinePoints = PolylinePoints();
    if (widget.order.status == "accepted" &&
        orderVM.riderLat != null &&
        orderVM.riderLng != null) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(
            //source
            orderVM.riderLat!.toDouble(),
            orderVM.riderLng!.toDouble(),
          ),
          destination: PointLatLng(
            widget.order.addressDetails!.lat!.toDouble(),
            widget.order.addressDetails!.lng!.toDouble(),
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
    } else {
      if (orderVM.riderLat != null && orderVM.riderLng != null) {
        try {
          PolylineResult result =
              await polylinePoints.getRouteBetweenCoordinates(
            request: PolylineRequest(
              origin: PointLatLng(
                //source
                widget.order.receiverDetails!.lat!.toDouble(),
                widget.order.receiverDetails!.lng!.toDouble(),
              ),
              destination: PointLatLng(
                orderVM.riderLat!.toDouble(),
                orderVM.riderLng!.toDouble(),
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
        } catch (e) {
          dev.log("get polytine error:$e");
        }
      }
    }
  }

  Future<void> setCustomMarkerIcon() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/Pickuppp.png")
        .then((icon) {
      sourceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/dropOffhere.png")
        .then((icon) {
      destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/rider.png")
        .then((icon) {
      riderLocationIcon = icon;
    });
  }

  @override
  void initState() {
    getPolyPoints();
    // getLocation();
    setCustomMarkerIcon();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Consumer<OrderProvider>(builder: (context, orderVM, _) {
                  return SizedBox(
                    height: size.height * 0.65,
                    child: Consumer<OrderProvider>(
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

                        if (orderVM.riderLat != null &&
                            orderVM.riderLng != null) {
                          final riderPosition =
                              LatLng(orderVM.riderLat!, orderVM.riderLng!);

                          markers.add(
                            Marker(
                              markerId: const MarkerId('rider'),
                              position: riderPosition,
                              icon: riderLocationIcon,
                            ),
                          );

                          WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
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
                              width: 4,
                            )
                          },
                          markers: markers,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                        );
                      },
                    ),

                    /*  GoogleMap(
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
                        if (orderVM.riderLat != null)
                          Marker(
                            markerId: const MarkerId("riderLocation"),
                            icon: riderLocationIcon,
                            position: LatLng(
                              orderVM.riderLat!,
                              orderVM.riderLng!,
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
                        // _controller.complete(mapController);
                          _controller.complete(mapController);
                        mapController = mapController;
                      },
                   ),

                    */
                  );
                }),
              ),
            ],
          ),
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
          Positioned(
            bottom: -20,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: showPopup ? size.height * 0.38 : 0, // Animate height
              width: size.width,
              curve: Curves.easeInOut,
              decoration: showPopup
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
              child: SizedBox(
                child: showPopup
                    ? Center(
                        child: Stack(
                          children: [
                            Consumer<OrderProvider>(
                                builder: (context, orderVM, _) {
                              return DeliveryCard(order: widget.order);
                            }),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showPopup = false;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  child: const Row(
                                    children: [
                                      Text("Hide card"),
                                      Icon(Icons.arrow_downward)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : null,
              ),
            ),
          ),
          if (!showPopup) ...[
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
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: const Row(
                    children: [Text("Show card"), Icon(Icons.arrow_upward)],
                  ),
                ),
              ),
            ),
          ],
          // Consumer<OrderProvider>(builder: (context, orderVM, _) {
          //   return Positioned(
          //       child: Center(
          //     child: Text(
          //         "rider lat:${orderVM.riderLat} , long:${orderVM.riderLng}"),
          //   ));
          // })
        ],
      ),
    );
  }
}
