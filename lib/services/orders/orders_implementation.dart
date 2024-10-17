import 'dart:convert';
import 'dart:developer';

import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/env.dart';
import '/models/api_response.dart';
import '/models/order.dart';
import '/services/orders/orders_abstract.dart';

class OrdersImpl implements OrdersService {
  @override
  Future<Either<ErrorResponse, ApiResponse>> deleteOrder(
      {required String orderId}) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<ErrorResponse, ApiResponse>> getOrder(String orderId) async {
    String token = sharedPrefs.token;
    var url = Uri.parse('${Env.endpointUrl}/order?_id=$orderId');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        return Right(ApiResponse.fromJson(jsonResponse));
      } else {
        return Left(ErrorResponse(message: jsonResponse['error']['msg']));
      }
    } catch (e) {
      return Left(ErrorResponse(message: 'Error: $e'));
    }
  }

  @override
  Future<Either<ErrorResponse, ApiResponse>> createOrder(
    AddressDetails addressDetails,
    ReceiverDetails receiverDetails,
    String deliveryOption,
    String deliveryService,
  ) async {
    String token = sharedPrefs.token;
    var url = Uri.parse('${Env.endpointUrl}/order');
    Map<String, dynamic> body = {
      'addressDetails': addressDetails.toJson(),
      'receiverDetails': receiverDetails.toJson(),
      'deliveryOption': 'express',
      'deliveryService': 'standard',
    };
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      log("Delivery res${response.body}");
      var jsonResponse = jsonDecode(response.body);
      return Right(ApiResponse.fromJson(jsonResponse));
    } catch (e) {
      debugPrint(e.toString());
      return Left(ErrorResponse(message: 'Error: $e'));
    }
  }

  @override
  Future<Either<ErrorResponse, ApiResponse>> initializePayment(
      {required String orderId, required String amount}) async {
    var url = Uri.parse('${Env.endpointUrl}/transaction/initiate');
    Map<String, dynamic> body = {
      'orderId': orderId,
      'amount': amount,
      'userId': sharedPrefs.userId,
      'email': sharedPrefs.email,
    };

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefs.token}',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      debugPrint(response.body);
      var jsonResponse = jsonDecode(response.body);

      return Right(ApiResponse.fromJson(jsonResponse));
    } catch (e) {
      return Left(ErrorResponse(message: 'Error: $e'));
    }
  }

  @override
  Future<Either<ErrorResponse, ApiResponse>> getOrders() async {
    var url = Uri.parse('${Env.endpointUrl}/order?_id=${sharedPrefs.userId}');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefs.token}',
    };

    log("sharedPrefs.userId:${sharedPrefs.userId}");

    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      log(response.body);
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        return Right(ApiResponse.fromJson(jsonResponse));
      } else {
        return Left(ErrorResponse(message: jsonResponse['errors']['msg']));
      }
    } catch (e) {
      return Left(ErrorResponse(message: 'Error: $e'));
    }
  }
}
