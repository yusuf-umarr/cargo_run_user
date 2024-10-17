import 'package:cargo_run/models/order.dart';
import 'package:dartz/dartz.dart';

import '../../models/api_response.dart';

abstract class OrdersService {
  Future<Either<ErrorResponse, ApiResponse>> getOrder(String orderId);

  Future<Either<ErrorResponse, ApiResponse>> createOrder(
    AddressDetails addressDetails,
    ReceiverDetails receiverDetails,
    String deliveryOption,
    String deliveryService,
  );

  Future<Either<ErrorResponse, ApiResponse>> initializePayment({
    required String orderId,
    required String amount,
  });

  Future<Either<ErrorResponse, ApiResponse>> getOrders();

  Future<Either<ErrorResponse, ApiResponse>> deleteOrder({
    required String orderId,
  });
}
