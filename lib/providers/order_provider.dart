import 'dart:developer';

import 'package:cargo_run/models/order.dart';
import 'package:flutter/material.dart';

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

  String _distancePrice = '';
  String _category = '';
  String _url = '';
  String _deliveryOption = '';
  String _errorMessage = '';

  String get category => _category;
  String get distancePrice => _distancePrice;
  String get deliveryOption => _deliveryOption;

  String get errorMessage => _errorMessage;
  String get url => _url;
  Order? get currentOrder => _currentOrder;
  OrderStatus get orderStatus => _orderStatus;
  List<Order?> get orders => _orders;

  AddressDetails? _addressDetails;
  ReceiverDetails? _receiverDetails;

  List dSearchResults = [];

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
    _deliveryOption = deliveryOption;
    notifyListeners();
  }

  Future<void> placeOrder() async {
    setOrderStatus(OrderStatus.loading);
    var response = await _ordersService.createOrder(
      _addressDetails!,
      _receiverDetails!,
      _deliveryOption,
      _category,
    );
    response.fold((error) {
      setOrderStatus(OrderStatus.failed);
      setErrorMessage(error.message);
    }, (success) {
      setOrderStatus(OrderStatus.pending);
      // _currentOrder = Order.fromJson(success.data);
      notifyListeners();
    });
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
    var response = await _ordersService.getDistancePrice(
        _addressDetails?.landMark!, _receiverDetails?.address);

    if (response.success) {
      _distancePrice =
          response.data['rows'][0]['elements'][0]['distance']['text'];

      log("_distancePrice:$_distancePrice");
    } else {
      //
    }

    notifyListeners();
  }

  Future<void> initiatePayment() async {
    setOrderStatus(OrderStatus.loading);
    var response = await _ordersService.initializePayment(
      orderId: _currentOrder!.id!,
      amount: (_currentOrder!.deliveryFee! + 2000.00).toString(),
    );
    response.fold((error) {
      setOrderStatus(OrderStatus.failed);
      setErrorMessage(error.message);
    }, (success) {
      debugPrint(success.data.toString());
      _url = success.data['data']['authorizationUrl'];
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

  // Future<List<Order?>> getOrders() async {
  //   List<Order?> res = [];
  //   var response = await _ordersService.getOrders();
  //   response.fold((error) {
  //     setOrderStatus(OrderStatus.failed);
  //     setErrorMessage(error.message);
  //     return [];
  //   }, (success) {
  //     debugPrint(success.data.toString());
  //     _orders = success.data.map((e) => Order.fromJson(e)).toList();
  //     res = _orders;
  //     setOrderStatus(OrderStatus.success);
  //     notifyListeners();
  //     return _orders;
  //   });
  //   return res;
  // }
}
