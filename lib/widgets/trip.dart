// import 'dart:async';
// import 'dart:developer';
// import 'package:cargorun_rider/config/config.dart';
// import 'package:cargorun_rider/constants/app_colors.dart';
// import 'package:cargorun_rider/constants/location.dart';
// import 'package:cargorun_rider/models/order_model.dart';
// import 'package:cargorun_rider/providers/app_provider.dart';
// import 'package:cargorun_rider/providers/order_provider.dart';
// import 'package:cargorun_rider/widgets/page_widgets/delivery_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';

// class TripRoutePage extends StatefulWidget {
//   final OrderData order;

//   const TripRoutePage({
//     super.key,
//     required this.order,
//   });

//   @override
//   State<TripRoutePage> createState() => _TripRoutePageState();
// }

// class _TripRoutePageState extends State<TripRoutePage> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();

//   bool isShowCard = true;
//   List<LatLng> polylineCoordinates = [];

//   bool showPopup = true;

//   BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

//   double riderLat = 6.64638;
//   double riderLong = 3.517462;

//   late LatLng _initialPosition;
//   late GoogleMapController mapController;

//   CameraPosition? cposition;

//   void getLocation() async {
//     Position position = await determinePosition();
//     debugPrint('position: $position');
//     _initialPosition = LatLng(position.latitude, position.longitude);
//     final CameraPosition kGooglePlex = CameraPosition(
//       target: _initialPosition,
//       zoom: 14.4746,
//     );

//     if (mounted) {
//       setState(() {
//         cposition = kGooglePlex;
//         riderLat = position.latitude;
//         riderLong = position.latitude;
//       });
//     }
//   }

//   void getPolyPoints() async {
//     PolylinePoints polylinePoints = PolylinePoints();

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       request: PolylineRequest(
//         origin: PointLatLng(
//           riderLat,
//           riderLong,
//         ),

//         /*
//           recipientLat: widget.order.receiverDetails!.lat!,
//                             recipientLong: widget.order.receiverDetails!.lng!
//         */
//         destination: PointLatLng(
//           widget.order.receiverDetails!.lat!,
//           widget.order.receiverDetails!.lng!,
//         ),
//         mode: TravelMode.driving,
//       ),
//       googleApiKey: googleApiKey,
//     );

//     if (result.points.isNotEmpty) {
//       for (var point in result.points) {
//         polylineCoordinates.add(
//           LatLng(
//             point.latitude,
//             point.longitude,
//           ),
//         );
//       }
//       setState(() {});
//     }
//   }

//   Future<void> setCustomMarkerIcon() async {
//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration.empty, "assets/images/destinationIcon.png")
//         .then((icon) {
//       destinationIcon = icon;
//     });
//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration.empty, "assets/images/riderIcon.png")
//         .then((icon) {
//       currentLocationIcon = icon;
//     });
//   }

//   // setOrder() async {
//   //   if (widget.order != null) {
//   //     order = widget.order;
//   //   } else {
//   //     OrderData? val = context.read<OrderProvider>().order;

//   //     order = val;
//   //   }
//   // }

//   @override
//   void initState() {
//     getLocation();
//     getPolyPoints();
//     setCustomMarkerIcon();

//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     log("order status:${widget.order.status}");
//     final Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Expanded(
//                 child: SizedBox(
//                   height: size.height * 0.65,
//                   child: GoogleMap(
//                     myLocationButtonEnabled: false,
//                     zoomControlsEnabled: false,
//                     initialCameraPosition: CameraPosition(
//                       target: LatLng(riderLat, riderLong),
//                       zoom: 13.5,
//                     ),
//                     polylines: {
//                       Polyline(
//                         polylineId: const PolylineId("route"),
//                         points: polylineCoordinates,
//                         color: primaryColor1,
//                         width: 6,
//                       )
//                     },
//                     markers: {
//                       Marker(
//                         markerId: const MarkerId("riderLocation"),
//                         icon: currentLocationIcon,
//                         position: LatLng(riderLat, riderLong),
//                       ),
//                       Marker(
//                           markerId: const MarkerId("destination"),
//                           position: LatLng(
//                             widget.order.receiverDetails!.lat!,
//                             widget.order.receiverDetails!.lng!,
//                           ),
//                           icon: destinationIcon),
//                     },
//                     onMapCreated: (mapController) {
//                       _controller.complete(mapController);
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           if (!showPopup) ...[
//             Positioned(
//               right: 5,
//               bottom: 20,
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     showPopup = true;
//                   });
//                 },
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.white),
//                   child: const Row(
//                     children: [Text("Show card"), Icon(Icons.arrow_upward)],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//           Positioned(
//             top: 50,
//             left: 20,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pop();
//               },
//               child: Container(
//                 height: 50,
//                 width: 50,
//                 decoration: BoxDecoration(
//                   color: primaryColor1,
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 child: const Icon(Iconsax.arrow_left, color: Colors.white),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: -20,
//             left: MediaQuery.of(context).size.width * 0.1,
//             right: MediaQuery.of(context).size.width * 0.1,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               height: showPopup ? size.height * 0.43 : 0, // Animate height
//               width: size.width,
//               curve: Curves.easeInOut,
//               decoration: showPopup
//                   ? BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 10,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     )
//                   : BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//               child: SizedBox(
//                 child: showPopup
//                     ? Center(
//                         child: Stack(
//                           children: [
//                             Consumer<OrderProvider>(
//                               builder: (context, orderVM, _) {
//                                 return DeliveryCard(order: orderVM.order!);
//                               }
//                             ),
//                             Positioned(
//                               right: 0,
//                               top: 0,
//                               child: GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     showPopup = false;
//                                   });
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10, vertical: 5),
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Colors.white),
//                                   child: const Row(
//                                     children: [
//                                       Text("Hide card"),
//                                       Icon(Icons.arrow_downward)
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                     : null,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }