import 'dart:convert';
import 'dart:developer';

import 'package:cargo_run/config/config.dart';
import 'package:cargo_run/models/place_model.dart';
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
  Future<ApiResp<dynamic>> createOrder(
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Delivery res${response.body}");
        var jsonResponse = jsonDecode(response.body);
        return ApiResp<dynamic>(
          success: true,
          data: jsonResponse,
          message: " error",
        );
      } else {
        log("Delivery res${response.body}");
        var jsonResponse = jsonDecode(response.body);
        return ApiResp<dynamic>(
          success: false,
          data: jsonResponse,
          message: " successfull",
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return ApiResp<dynamic>(
        success: false,
        data: "$e",
        message: " error",
      );
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
    var url = Uri.parse('${Env.endpointUrl}/order');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefs.token}',
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      // log(response.body);
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

  @override
  Future<ApiResp<dynamic>> getAutocomplete(searchTerm) async {
    try {
      var url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchTerm&key=$googleApiKey');
      // var url =
      //     'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchTerm&key=$googleApiKey';

      final response = await http.get(url);

      var jsonResponse = jsonDecode(response.body);

      var jsonResults = jsonResponse['predictions'] as List;
      var places =
          jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();

      // log("places:${jsonResults}");

      return ApiResp<dynamic>(
        success: true,
        data: places,
        // data: jsonResults.map((place) => PlaceSearch.fromJson(place)).toList(),
        message: " successfull",
      );
    } catch (e) {
      return ApiResp(
        success: false,
        message: "A server error occurred",
        data: '',
      );
    }
  }

  @override
  Future<ApiResp<dynamic>> getDistancePrice(source, destination) async {
    try {
      var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destination&origins=$source&units=imperial&key=$googleApiKey",
      );
      final response = await http.get(url);

      var jsonResponse = jsonDecode(response.body);

      return ApiResp<dynamic>(
        success: true,
        data: jsonResponse,
        message: " successfull",
      );
    } catch (e) {
      log("distance ======erro $e");
      return ApiResp<dynamic>(
        success: true,
        data: "",
        message: " error",
      );
    }
  }
}

class ApiResp<T> {
  final bool success;
  final T? data;
  final String message;
  ApiResp({
    required this.success,
    this.data,
    required this.message,
  });
}



//AIzaSyAec2eFqVYW4pqBNakXG9eLE6xId1TXFK8
