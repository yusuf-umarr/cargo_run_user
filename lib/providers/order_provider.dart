import 'dart:developer' as dev;
import 'package:cargo_run/models/distance_model.dart';
import 'package:cargo_run/models/driver_model.dart';
import 'package:cargo_run/models/location_from_addr.dart';
import 'package:cargo_run/models/notification_model.dart';
import 'package:cargo_run/models/order.dart';
import 'package:cargo_run/models/places_model.dart';
import 'package:cargo_run/screens/bottom_nav/bottom_nav_bar.dart';
import 'package:cargo_run/screens/dashboard/home_screens/check_out.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '/services/service_locator.dart';
import '/services/orders/orders_abstract.dart';
import '/utils/shared_prefs.dart';
import 'dart:math';

enum OrderStatus {
  initial,
  loading,
  pending,
  failed,
  success,
}

class OrderProvider extends ChangeNotifier {
  final OrdersService _ordersService = serviceLocator<OrdersService>();

  OrderStatus _orderStatus = OrderStatus.initial;
  Order? _currentOrder;
  List<Order?> _orders = [];

  List searcheOrders = [];
  static const double earthRadiusKm = 6371.0;

  // String _distancePrice = '';
  String _category = '';
  String _deliveryService = '';
  final String _url = '';
  String _deliveryOption = '';
  String _errorMessage = '';

  String get category => _category;
  String get deliveryService => _deliveryService;
  // String get distancePrice => _distancePrice;
  String get deliveryOption => _deliveryOption;

  String get errorMessage => _errorMessage;
  String get url => _url;
  Order? get currentOrder => _currentOrder;
  OrderStatus get orderStatus => _orderStatus;

  List<Order?> get orders => _orders;

  List<NotificationData> get notificationModel => _notificationModel;
  List<NotificationData> _notificationModel = [];

  String? get priceModel => _priceModel;
  String? _priceModel;

  List<AvailableDriverModel> _availableDriverModel = [];

  List<AvailableDriverModel> get availableDriverModel => _availableDriverModel;

  AddressDetails? _addressDetails;

  AddressDetails? get addressDetails => _addressDetails;

  ReceiverDetails? _receiverDetails;
  ReceiverDetails? get receiverDetails => _receiverDetails;

  // List dSearchResults = [];

  // SearchPlacesModel? searchResults;

  // List<Suggestion> suggestions = [];
  List<Suggestion> dSearchResults = [];

  List availableDriverList = [];

  // DistanceModel? distanceModel;
  double? distanceMeters;

  LocationFromAddressModel? locationFromAddr;

  io.Socket? get socket => _socket;
  io.Socket? _socket;

  setSocketIo(socket) {
    _socket = socket;
    dev.log("_socket:$_socket");
  }

  void setOrderStatus(OrderStatus status) {
    _orderStatus = status;
    sharedPrefs.orderStatus = status.toString().split('.').last;
    notifyListeners();
  }

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> addAdrressDetails(
    String houseNo,
    String pickupAddress,
    String contactNumber,
    String lat,
    String long,
  ) async {
    _addressDetails = AddressDetails(
      // houseNumber: int.parse(houseNo),
      landMark: pickupAddress,
      contactNumber: contactNumber,
      lat: double.parse(lat),
      lng: double.parse(long),
    );
    log("_addressDetails:${_addressDetails}");
    log("_addressDetails:${_addressDetails?.lat}");
    notifyListeners();
  }

  void setLocationCoordinate({required double lat, required double long}) {
    if (_socket != null) {
      _socket!.emit(
        'location',
        {
          "lat": lat,
          "lng": long,
          "userId": sharedPrefs.userId,
        },
      );
    }

    dev.log("lat:$lat ---long:$long --userId:${sharedPrefs.userId}");
  }

  void setDeliveryService(String service) {
    _deliveryService = service;

    notifyListeners();
  }

  void setDeliveryOption(String option) {
    _deliveryOption = option;

    notifyListeners();
  }

  void addRecipientDetails(
    String name,
    String phone,
    String address,
    String category,
    String deliveryOption,
    String lat,
    String long,
  ) {
    _receiverDetails = ReceiverDetails(
      name: name,
      phone: phone,
      address: address,
      lat: double.parse(lat),
      lng: double.parse(long),
    );
    _category = category;

    notifyListeners();
  }

  Future<void> placeOrder(String price) async {
    setOrderStatus(OrderStatus.loading);
    var response = await _ordersService.createOrder(
        _addressDetails!,
        _receiverDetails!,
        'normal', // _deliveryOption, //nornal/express
        'standard', // _deliveryService, //standard/bulk
        price);

    dev.log("deliveryPrice:$price");

    if (response.success) {
      getOrders();
      setOrderStatus(OrderStatus.success);
      _socket!.emit("order");
    } else {
      dev.log("order error:${response.data}");
      setOrderStatus(OrderStatus.failed);
    }
  }
  Future<void> cancelOrder(String orderId) async {
    var response = await _ordersService.cancelOrder(
        orderId);

    dev.log("orderId:$orderId");

    if (response.success) {
      getOrders();
      _socket!.emit("order");
    } else {
      dev.log("order error:${response.data}");
    }
  }

  Future<void> verifyPayment(String reference, String orderId, context) async {
    // setOrderStatus(OrderStatus.loading);
    var response = await _ordersService.verify(reference, orderId);

    if (response.success) {
      getOrders();
      setOrderStatus(OrderStatus.success);
      _socket!.emit("order");
      toast("Payment successful");
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
        );
      });
    } else {
      dev.log("order error:${response.data}");
      setOrderStatus(OrderStatus.failed);
    }
  }

  Future<void> getAutocompletePlaces(search) async {
    var response = await _ordersService.getAutocompletePlaces(
      input: search,
      currentLatLng: const LatLng(-33.867, 151.195),
    );

    if (response.success) {
      if (response.data['suggestions'] != null) {
        dSearchResults = (response.data['suggestions'] as List)
            .map((item) => Suggestion.fromJson(item))
            .toList();
      }
    } else {}

    notifyListeners();
  }

  // Future<void> getDistancePrice() async {
  //   setOrderStatus(OrderStatus.loading);
  //   try {
  //     var response = await _ordersService.getDistance(
  //       sourceLatLng: LatLng(
  //           _addressDetails!.lat!.toDouble(), _addressDetails!.lng!.toDouble()),
  //       destinationLatLng: LatLng(
  //         _receiverDetails!.lat!.toDouble(),
  //         _receiverDetails!.lng!.toDouble(),
  //       ),
  //     );
  //     if (response.success) {
  //       setOrderStatus(OrderStatus.success);

  //       // distanceModel = response.data;

  //       // dev.log("distanceModel:${response.data}");

  //       distanceModel = DistanceModel.fromJson(response.data);

  //       dev.log("_distancePrice:-1--${distanceModel!.routes![0]}");
  //       distanceMeters = distanceModel!.routes![0].distanceMeters;
  //     } else {
  //       setOrderStatus(OrderStatus.failed);
  //       log("_distancePrice  error :${response.data}");
  //       //
  //     }
  //   } catch (e) {
  //     log("_distancePrice  catch error :$e");
  //   }
  //   notifyListeners();
  // }

  Future<void> locationFromAddress({required String addr}) async {
    // setOrderStatus(OrderStatus.loading);
    try {
      var response = await _ordersService.locationFromAddress(address: addr);
      if (response.success) {
        locationFromAddr = LocationFromAddressModel.fromJson(response.data);

        notifyListeners();
        dev.log("locationFromAddr:$locationFromAddr");
      } else {
        log("location er  error :${response.data}");
      }
    } catch (e) {
      dev.log("location  catch error :$e");
    }
  }

  Future<void> getNotification() async {
    var response = await _ordersService.getNotification();
    if (response.success) {
      setOrderStatus(OrderStatus.success);

      List data = response.data['data'];
      List<NotificationData> fetched =
          data.map((e) => NotificationData.fromJson(e)).toList();
      _notificationModel = fetched;
      notifyListeners();
    } else {
      setOrderStatus(OrderStatus.failed);
      log("notification  error :${response.data}");
      //
    }

    notifyListeners();
  }

  Future<void> getPrice() async {
    var response = await _ordersService.getPrice();
    if (response.success) {
      setOrderStatus(OrderStatus.success);
      _priceModel = response.data['data'][0]['price'].toString();

      notifyListeners();
    } else {
      setOrderStatus(OrderStatus.failed);
    }

    notifyListeners();
  }

  Future<void> getAvailableDrivers(dynamic data) async {
    availableDriverList = data['data'];

    // dev.log(" _availableDriverModel getAvailableDrivers  ${availableDriverList}==");

    // availableDriverList.forEach((x){

    // });

    // try {
    //   if (data is List) {
    //     _availableDriverModel = data
    //         .map(
    //             (e) => AvailableDriverModel.fromJson(e as Map<String, dynamic>))
    //         .toList();
    //   } else if (data is Map<String, dynamic>) {
    //     _availableDriverModel = [AvailableDriverModel.fromJson(data)];
    //   }
    // } catch (e) {
    //   dev.log("get drivers error here ----:$e");
    // }
    // dev.log(
    //     '_availableDriverModel- locationCoord:${_availableDriverModel[0].locationCoord}');
    notifyListeners();
  }

  Future<void> initiatePayment(String orderId, String price, context) async {
    setOrderStatus(OrderStatus.loading);
    var response = await _ordersService.initializePayment(
      orderId: orderId,
      amount: price,
    );
    response.fold((error) {
      setOrderStatus(OrderStatus.failed);
      setErrorMessage(error.message);
    }, (success) {
      // _url = success.data['data']['authorizationUrl'];
      final url = success.data['data']['authorizationUrl'];
      final ref = success.data['data']['reference'];

      dev.log("success.data['data']:${success.data['data']}");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(
            paymentUrl: url,
            reference: ref,
            orderId: orderId,
          ),
        ),
      );

      setOrderStatus(OrderStatus.success);
      notifyListeners();
    });
  }

  void getOrders() async {
    await _ordersService.getOrders().then(
          (value) => {
            value.fold((error) {
              debugPrint(error.message);
              setOrderStatus(OrderStatus.failed);
              _orders = [];
            }, (sucess) {
              setOrderStatus(OrderStatus.success);
              List<dynamic> data = sucess.data;
              List<Order?> fetched =
                  data.map((e) => Order.fromJson(e)).toList();
              _orders = fetched;
              notifyListeners();
            }),
          },
        );
  }

  void trackOrders(String query) {
    searcheOrders = _orders;

    final suggestions = _orders.where((data) {
      final dataName = data!.orderId!.toLowerCase();
      final input = query.toLowerCase();

      // return false;
      return dataName.contains(input) ? true : false;
    }).toList();

    searcheOrders = suggestions;
    notifyListeners();
  }

  // Helper method to convert degrees to radians
  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  // Method to calculate the distance in meters
  Future<void> calculateDistance({
    required double sourceLat,
    required double sourceLng,
    required double destinationLat,
    required double destinationLng,
  }) async {
    // Convert latitude and longitude from degrees to radians
    final double sourceLatRad = _toRadians(sourceLat);
    final double sourceLngRad = _toRadians(sourceLng);
    final double destinationLatRad = _toRadians(destinationLat);
    final double destinationLngRad = _toRadians(destinationLng);

    dev.log("sourceLatRad:$sourceLatRad");
    dev.log("sourceLngRad:$sourceLngRad");
    dev.log("destinationLatRad:$destinationLatRad");
    dev.log("destinationLngRad:$destinationLngRad");

    // Haversine formula
    final double dLat = destinationLatRad - sourceLatRad;
    final double dLng = destinationLngRad - sourceLngRad;

    final double a = pow(sin(dLat / 2), 2) +
        cos(sourceLatRad) * cos(destinationLatRad) * pow(sin(dLng / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    //Distance in meters (km * 1000)
    distanceMeters = (earthRadiusKm * c) * 1000;

    dev.log("distanceMeters here-:$distanceMeters");
    notifyListeners();

    // return totalDistanceMeters;
  }
}
