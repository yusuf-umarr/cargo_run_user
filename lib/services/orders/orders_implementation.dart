import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:cargo_run/config/config.dart';
import 'package:cargo_run/providers/order_provider.dart';

import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../../utils/env.dart';
import '/models/api_response.dart';
import '/models/order.dart';
import '/services/orders/orders_abstract.dart';

import 'dart:developer' as dev;

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
    String price,
  ) async {
    String token = sharedPrefs.token;
    var url = Uri.parse('${Env.endpointUrl}/order');

    Map<String, dynamic> body = {
      'addressDetails': addressDetails.toJson(),
      'receiverDetails': receiverDetails.toJson(),
      'deliveryOption': deliveryOption,
      'deliveryService': deliveryService,
      'price': price,
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
      dev.log("Delivery res${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        return ApiResp<dynamic>(
          success: true,
          data: jsonResponse,
          message: "successful",
        );
      } else {
        var jsonResponse = jsonDecode(response.body);
        return ApiResp<dynamic>(
          success: false,
          data: jsonResponse,
          message: "error",
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
  Future<ApiResp<dynamic>> cancelOrder(
    String orderId,
  ) async {
    String token = sharedPrefs.token;
    var url = Uri.parse('${Env.endpointUrl}/order/cancel/$orderId');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.delete(
        url,
        headers: headers,
        // body: jsonEncode(body),
      );
      dev.log("cancel order res${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        return ApiResp<dynamic>(
          success: true,
          data: jsonResponse,
          message: "successful",
        );
      } else {
        var jsonResponse = jsonDecode(response.body);
        return ApiResp<dynamic>(
          success: false,
          data: jsonResponse,
          message: "error",
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
  Future<ApiResp<dynamic>> verify(
    String reference,
    String orderId,
  ) async {
    String token = sharedPrefs.token;
    var url = Uri.parse('${Env.endpointUrl}/transaction/verify');

    Map<String, dynamic> body = {
      'reference': reference,
      'orderId': orderId,
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
      // log("verify res${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        return ApiResp<dynamic>(
          success: true,
          data: jsonResponse,
          message: "successful",
        );
      } else {
        var jsonResponse = jsonDecode(response.body);
        return ApiResp<dynamic>(
          success: false,
          data: jsonResponse,
          message: "error",
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
  Future<ApiResp<dynamic>> getNotification() async {
    String token = sharedPrefs.token;
    String userId = sharedPrefs.userId;
    var url = Uri.parse('${Env.endpointUrl}/notification?userId=$userId');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        return ApiResp<dynamic>(
          success: true,
          data: jsonResponse,
          message: "successful",
        );
      } else {
        var jsonResponse = jsonDecode(response.body);
        return ApiResp<dynamic>(
          success: false,
          data: jsonResponse,
          message: "error",
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
  Future<ApiResp<dynamic>> getPrice() async {
    String token = sharedPrefs.token;
    var url = Uri.parse('${Env.endpointUrl}/cargo-price');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      // dev.log("response price:${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        return ApiResp<dynamic>(
          success: true,
          data: jsonResponse,
          message: "successful",
        );
      } else {
        var jsonResponse = jsonDecode(response.body);
        return ApiResp<dynamic>(
          success: false,
          data: jsonResponse,
          message: "error",
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

  double roundOffNumber(double number, {int decimalPlaces = 0}) {
    double mod = pow(10.0, decimalPlaces).toDouble();
    return (number * mod).round() / mod;
  }

  @override
  Future<Either<ErrorResponse, ApiResponse>> initializePayment(
      {required String orderId, required String amount}) async {
    var url = Uri.parse('${Env.endpointUrl}/transaction/initiate');
    Map<String, dynamic> body = {
      'orderId': orderId,
      'amount': roundOffNumber(double.parse(amount)),
      'userId': sharedPrefs.userId,
      'email': sharedPrefs.email,
    };

    dev.log("orderId:$orderId");
    dev.log("amount:$amount");
    dev.log("userId:${sharedPrefs.userId}");
    dev.log("email:${sharedPrefs.email}");

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

      dev.log("payment res:${response.body}");
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
  Future<ApiResp<dynamic>> getAutocompletePlaces({
    required String input,
    required LatLng currentLatLng,
  }) async {
    try {
      PackageInfo buildKeys = await PackageInfo.fromPlatform();
      String signKey = buildKeys.buildSignature;
      String packageName = buildKeys.packageName;

      var headers = {
        'X-Goog-Api-Key': googleApiKey,
        'Content-Type': 'application/json',
        if (Platform.isAndroid) 'X-Android-Package': packageName,
        if (Platform.isAndroid) 'X-Android-Cert': signKey,
        if (Platform.isIOS) 'X-IOS-Bundle-Identifier': packageName,
      };

      var url =
          Uri.parse('https://places.googleapis.com/v1/places:autocomplete');

      var requestBody = {
        "input": input,
        "locationBias": {
          "circle": {
            "center": {
              "latitude": currentLatLng.latitude,
              "longitude": currentLatLng.longitude
            },
            "radius": 10000,
          }
        },
      };

      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: headers,
      );

      return ApiResp<dynamic>(
        success: response.statusCode == 200,
        data: jsonDecode(response.body),
        message: response.statusCode == 200 ? "Successful" : "Failed",
      );
    } catch (e) {
      dev.log(e.toString());

      return ApiResp<dynamic>(
        success: false,
        data: '$e',
        message: "An error occurred",
      );
    }
  }

  @override
  Future<ApiResp<dynamic>> getDistance({
    required LatLng sourceLatLng,
    required LatLng destinationLatLng,
  }) async {
    try {
      PackageInfo buildKeys = await PackageInfo.fromPlatform();
      String signKey = buildKeys.buildSignature;
      String packageName = buildKeys.packageName;

      var headers = {
        'X-Goog-Api-Key': googleApiKey,
        'Content-Type': 'application/json',
        if (Platform.isAndroid) 'X-Android-Package': packageName,
        if (Platform.isAndroid) 'X-Android-Cert': signKey,
        if (Platform.isIOS) 'X-IOS-Bundle-Identifier': packageName,
        'X-Goog-FieldMask': '*'
      };

      var url = Uri.parse(
          'https://routes.googleapis.com/directions/v2:computeRoutes');

      var requestBody = {
        "origin": {
          "location": {
            "latLng": {
              "latitude": sourceLatLng.latitude,
              "longitude": sourceLatLng.longitude
            }
          }
        },
        "destination": {
          "location": {
            "latLng": {
              "latitude": destinationLatLng.latitude,
              "longitude": destinationLatLng.longitude
            }
          }
        }
      };

      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: headers,
      );

      dev.log("response distnace  distance in mete====:${response.body}");

      return ApiResp<dynamic>(
        success: response.statusCode == 200,
        data: jsonDecode(response.body),
        message: response.statusCode == 200 ? "Successful" : "Failed",
      );
    } catch (e) {
      dev.log(e.toString());

      return ApiResp<dynamic>(
        success: false,
        data: '$e',
        message: "An error occurred",
      );
    }
  }

  @override
  Future<ApiResp<dynamic>> locationFromAddress(
      {required String address}) async {
    try {
      var url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$googleApiKey');

      final response = await http.get(url);

      var jsonResponse = jsonDecode(response.body);

      // log("places response:${jsonResponse}");

      return ApiResp<dynamic>(
        success: true,
        data: jsonResponse,
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

  // @override
  // Future<ApiResp<dynamic>> getDistancePrice(source, destination) async {
  //   try {
  //     log("source:$source");
  //     log("destination:$destination");
  //     var url = Uri.parse(
  //       "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destination&origins=$source&units=imperial&key=$googleApiKey",
  //     );
  //     final response = await http.get(url);

  //     var jsonResponse = jsonDecode(response.body);

  //     return ApiResp<dynamic>(
  //       success: true,
  //       data: jsonResponse,
  //       message: " successfull",
  //     );
  //   } catch (e) {
  //     log("distance ======erro $e");
  //     return ApiResp<dynamic>(
  //       success: true,
  //       data: "",
  //       message: " error",
  //     );
  //   }
  // }
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
