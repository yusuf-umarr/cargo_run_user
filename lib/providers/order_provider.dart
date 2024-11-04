import 'dart:developer' as dev;
import 'package:cargo_run/models/notification_model.dart';
import 'package:cargo_run/models/order.dart';
import 'package:cargo_run/screens/bottom_nav/bottom_nav_bar.dart';
import 'package:cargo_run/screens/dashboard/home_screens/check_out.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '/services/service_locator.dart';
import '/services/orders/orders_abstract.dart';
import '/utils/shared_prefs.dart';

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

  String _distancePrice = '';
  String _category = '';
  String _deliveryService = '';
  String _url = '';
  String _deliveryOption = '';
  String _errorMessage = '';

  String get category => _category;
  String get deliveryService => _deliveryService;
  String get distancePrice => _distancePrice;
  String get deliveryOption => _deliveryOption;

  String get errorMessage => _errorMessage;
  String get url => _url;
  Order? get currentOrder => _currentOrder;
  OrderStatus get orderStatus => _orderStatus;

  List<Order?> get orders => _orders;

  List<NotificationData> get notificationModel => _notificationModel;
  List<NotificationData> _notificationModel = [];

  AddressDetails? _addressDetails;

  AddressDetails? get addressDetails => _addressDetails;

  ReceiverDetails? _receiverDetails;
  ReceiverDetails? get receiverDetails => _receiverDetails;

  List dSearchResults = [];

  io.Socket? _socket;

  setSocketIo(socket) {
    _socket = socket;
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

  void addAdrressDetails(
    String houseNo,
    String pickupAddress,
    String contactNumber,
    String lat,
    String long,
  ) {
    _addressDetails = AddressDetails(
      // houseNumber: int.parse(houseNo),
      landMark: pickupAddress,
      contactNumber: contactNumber,
      lat: double.parse(lat),
      lng: double.parse(long),
    );
    // log("_addressDetails:${_addressDetails}");
    // log("_addressDetails:${_addressDetails?.lat}");
    notifyListeners();
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
        _deliveryOption, //nornal/express
        _deliveryService, //standard/bulk
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

  Future<void> verifyPayment(String reference, context) async {
    // setOrderStatus(OrderStatus.loading);
    var response = await _ordersService.verify(reference);

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

  Future<void> searchPlaces(search) async {
    var response = await _ordersService.getAutocomplete(
      search,
    );

    if (response.success) {
      dSearchResults = response.data;
    } else {
      //
    }

    notifyListeners();
  }

  Future<void> getDistancePrice() async {
    setOrderStatus(OrderStatus.loading);
    var response = await _ordersService.getDistancePrice(
        _addressDetails?.landMark!, _receiverDetails?.address);

    if (response.success) {
      setOrderStatus(OrderStatus.success);
      _distancePrice =
          response.data['rows'][0]['elements'][0]['distance']['text'];

      log("_distancePrice:$_distancePrice");
    } else {
      setOrderStatus(OrderStatus.failed);
      log("_distancePrice  error :${response.data}");
      //
    }

    notifyListeners();
  }

  Future<void> getNotification() async {
    var response = await _ordersService.getNotification();
    if (response.success) {
      setOrderStatus(OrderStatus.success);

      //_notificationModel
      //NotificationData

      List data = response.data['data'];
      List<NotificationData> fetched =
          data.map((e) => NotificationData.fromJson(e)).toList();
      _notificationModel = fetched;
      notifyListeners();

      // dev.log("notification===:${_notificationModel}");
    } else {
      setOrderStatus(OrderStatus.failed);
      log("notification  error :${response.data}");
      //
    }

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
      final dataName = data!.orderId!;
      final input = query;

      // return false;
      return dataName.contains(input) ? true : false;
    }).toList();

    searcheOrders = suggestions;
    notifyListeners();
  }
}
