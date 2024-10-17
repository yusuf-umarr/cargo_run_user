import 'package:dartz/dartz.dart';

import '/models/api_response.dart';

abstract class AuthService {
  Future<Either<ErrorResponse, ApiResponse>> registerUser({
    required String fullName,
    required String password,
    required String phone,
  });

  Future<Either<ErrorResponse, ApiResponse>> loginUser({
    required String email,
    required String password,
  });

  Future<Either<ErrorResponse, ApiResponse>> getOTP({
    required String email,
  });

  Future<Either<ErrorResponse, ApiResponse>> verifyOTP({
    required String email,
    required String otp,
  });

  Future<Either<ErrorResponse, ApiResponse>> forgotPassword({
    required String email,
  });

  Future<Either<ErrorResponse, ApiResponse>> resetPassword({
    required String email,
    required String password,
  });
}
