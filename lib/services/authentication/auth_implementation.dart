import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/models/api_response.dart';
import '/utils/shared_prefs.dart';
import '../../utils/env.dart';

import 'auth_abstract.dart';

class AuthImpl implements AuthService {
  @override
  Future<Either<ErrorResponse, ApiResponse>> registerUser({
    required String email,
    required String fullName,
    required String password,
    required String phone,
  }) async {
    var url = Uri.parse('${Env.endpointUrl}/user');
    debugPrint('URL: $url');
    var body = {
      'email': email,
      'fullName': fullName,
      'password': password,
      'phone': phone,
    };
    var headers = {'Content-Type': 'application/json'};
    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      var jsonResponse = jsonDecode(response.body);

      log('Response: ${jsonResponse['data']}');
      if (jsonResponse['success'] == true) {
        // sharedPrefs.token = jsonResponse['data']['token'];
        sharedPrefs.userId = jsonResponse['data']['_id'];
        sharedPrefs.fullName = fullName;
        sharedPrefs.phone = phone;
        sharedPrefs.email = email;
        return Right(ApiResponse.fromJson(jsonResponse));
      } else {
        return Left(ErrorResponse(message: jsonResponse['errors']['msg']));
      }
    } catch (e) {
      debugPrint('Network error');
      return Left(ErrorResponse(message: 'Network error'));
    }
  }

  @override
  Future<Either<ErrorResponse, ApiResponse>> loginUser({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };
    Map<String, String> headers = {'Content-Type': 'application/json'};
    try {
      var response = await http.post(
        Uri.parse('${Env.endpointUrl}/user/login'),
        headers: headers,
        body: jsonEncode(body),
      );
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        sharedPrefs.token = jsonResponse['data']['token'];
        sharedPrefs.userId = jsonResponse['data']['_id'];
        sharedPrefs.fullName = jsonResponse['data']['fullName'];
        sharedPrefs.phone = jsonResponse['data']['phone'];
        sharedPrefs.email = email;
        return Right(ApiResponse.fromJson(jsonResponse));
      } else {
        // log("log response:${jsonResponse}");
        return Left(ErrorResponse(message: jsonResponse['errors']['msg']));
      }
    } catch (e) {
      return Left(ErrorResponse(message: 'Network error'));
    }
  }

  @override
  Future<Either<ErrorResponse, ApiResponse>> forgotPassword(
      {required String email}) async {
    final Map<String, dynamic> body = {
      'email': email,
    };
    // final Map<String, String> headers = {'Content-Type': 'application/json'};
    String responseBody;

    try {
      var response = await http.post(
        Uri.parse('${Env.endpointUrl}/auth/forgot-password'),
        body: body,
        // headers: headers,
      );
      responseBody = response.body;
      var jsonResponse = jsonDecode(responseBody);

      log("forgot pass jsonResponse:$jsonResponse");
      if (jsonResponse['success'] == true) {
        return Right(ApiResponse.fromJson(jsonResponse));
      } else {
        return Left(ErrorResponse(message: jsonResponse['errors']['msg']));
      }
    } catch (e) {
      return Left(ErrorResponse(message: 'Network error'));
    }
  }

  @override
  Future<Either<ErrorResponse, ApiResponse>> getOTP(
      {required String email}) async {
    String token = sharedPrefs.token;
    String userId = sharedPrefs.userId;

    log("userId userId:$userId");
    log("email email:$email");

    final Map<String, dynamic> body = {
      'id': userId,
      'email': email,
    };
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    try {
      var response = await http.post(
        Uri.parse('${Env.endpointUrl}/auth/resend-otp'),
        headers: headers,
        body: jsonEncode(body),
      );
      var jsonResponse = jsonDecode(response.body);
      log("otp response:$jsonResponse");
      if (jsonResponse['success'] == true) {
        sharedPrefs.email = email;
        return Right(ApiResponse.fromJson(jsonResponse));
      } else {
        return Left(ErrorResponse(message: jsonResponse['errors']['msg']));
      }
    } catch (e) {
      return Left(ErrorResponse(message: 'Network error'));
    }
  }

  @override
  Future<Either<ErrorResponse, ApiResponse>> resetPassword({
    required String otp,
    required String password,
  }) async {
    final Map<String, dynamic> body = {
      'email': sharedPrefs.email,
      'newPassword': password,
      'otp': otp,
    };

    // final Map<String, String> headers = {'Content-Type': 'application/json'};
    String responseBody;

    try {
      var response = await http.patch(
        Uri.parse('${Env.endpointUrl}/auth/reset-password'),
        body: body,
        // headers: headers,
      );
      responseBody = response.body;
      var jsonResponse = jsonDecode(responseBody);

      log("reset-pass=======jsonResponse:$jsonResponse");
      if (jsonResponse['success'] == true) {
        return Right(ApiResponse.fromJson(jsonResponse));
      } else {
        return Left(ErrorResponse(message: jsonResponse['errors']['msg']));
      }
    } catch (e) {
      return Left(ErrorResponse(message: 'Network error'));
    }
  }

  @override
  Future<Either<ErrorResponse, ApiResponse>> verifyOTP({
    required String email,
    required String otp,
  }) async {
    final Map<String, dynamic> body = {
      'email': email,
      'otp': otp,
    };
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefs.token}'
    };
    try {
      var response = await http.post(
        Uri.parse('${Env.endpointUrl}/auth/verify'),
        headers: headers,
        body: jsonEncode(body),
      );
      var jsonResponse = jsonDecode(response.body);
      debugPrint('Response: $jsonResponse');
      if (jsonResponse['success'] == true) {
        return Right(ApiResponse.fromJson(jsonResponse));
      } else {
        return Left(ErrorResponse(message: jsonResponse['errors']['msg']));
      }
    } catch (e) {
      return Left(ErrorResponse(message: 'Network error'));
    }
  }
  @override
  Future<Either<ErrorResponse, ApiResponse>> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final Map<String, dynamic> body = {
      'fullName': name,
      'email': email,
      'phone': phone,
    };
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefs.token}'
    };
    try {
      var response = await http.patch(
        Uri.parse('${Env.endpointUrl}/user'),
        headers: headers,
        body: jsonEncode(body),
      );
      var jsonResponse = jsonDecode(response.body);
     log('update Response: $jsonResponse');
      if (jsonResponse['success'] == true) {
        return Right(ApiResponse.fromJson(jsonResponse));
      } else {
        return Left(ErrorResponse(message: jsonResponse['errors']['msg']));
      }
    } catch (e) {
      return Left(ErrorResponse(message: 'Network error'));
    }
  }
  @override
  Future<Either<ErrorResponse, ApiResponse>> deleteAccount(

  ) async {
   
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefs.token}'
    };
    try {
      var response = await http.delete(
        Uri.parse('${Env.endpointUrl}/user/delete'),
        headers: headers,
      );
      var jsonResponse = jsonDecode(response.body);
     log('update Response: $jsonResponse');
      if (jsonResponse['success'] == true) {
        return Right(ApiResponse.fromJson(jsonResponse));
      } else {
        return Left(ErrorResponse(message: jsonResponse['errors']['msg']));
      }
    } catch (e) {
      return Left(ErrorResponse(message: 'Network error'));
    }
  }
}
