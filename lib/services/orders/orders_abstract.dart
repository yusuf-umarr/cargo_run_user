import 'package:cargo_run/models/order.dart';
import 'package:cargo_run/services/orders/orders_implementation.dart';
import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/api_response.dart';

abstract class OrdersService {
  Future<Either<ErrorResponse, ApiResponse>> getOrder(String orderId);

  Future<ApiResp<dynamic>> createOrder(
    AddressDetails addressDetails,
    ReceiverDetails receiverDetails,
    String deliveryOption,
    String deliveryService,
    String price,
  );
  Future<ApiResp<dynamic>> cancelOrder(
  
    String orderId,
  );
  Future<ApiResp<dynamic>> verify(
    String reference,
    String orderId,
  );
  Future<ApiResp<dynamic>> getNotification();
  Future<ApiResp<dynamic>> getPrice();

  Future<Either<ErrorResponse, ApiResponse>> initializePayment({
    required String orderId,
    required String amount,
  });

  Future<Either<ErrorResponse, ApiResponse>> getOrders();
  // Future<Either<ErrorResponse, ApiResponse>> getPrice();

  Future<Either<ErrorResponse, ApiResponse>> deleteOrder({
    required String orderId,
  });

    Future<ApiResp<dynamic>> locationFromAddress({required String address }) ;
  Future<ApiResp<dynamic>> getAutocompletePlaces({
    required String input,
    required LatLng currentLatLng,
  });
  Future<ApiResp<dynamic>> getDistance({
    required LatLng sourceLatLng,
    required LatLng destinationLatLng,
  });

  // Future<ApiResp<dynamic>> getDistancePrice(source, destination);
}
