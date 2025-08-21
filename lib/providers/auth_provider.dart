import 'dart:io';

import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:cargo_run/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '/services/authentication/auth_abstract.dart';
import '/services/service_locator.dart';
import 'dart:developer' as dev;

enum LoadingState { initial, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = serviceLocator<AuthService>();
  LoadingState _loadingState = LoadingState.initial;
  String _errorMessage = '';

  String? _token;
  String? get token => _token;

  LoadingState get loadingState => _loadingState;
  String get errorMessage => _errorMessage;

  File imageUpload = File("");
  dynamic imageFile;

  void setLoadingState(LoadingState loadingState) {
    _loadingState = loadingState;
    notifyListeners();
  }

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  Future<void> registerUser({
    required String email,
    required String fullName,
    required String password,
    required String phone,
  }) async {
    setLoadingState(LoadingState.loading);
    var response = await _authService.registerUser(
      email: email,
      fullName: fullName,
      password: password,
      phone: phone,
    );
    response.fold((error) {
      setLoadingState(LoadingState.error);
      setErrorMessage(error.message);
    }, (success) {
      setLoadingState(LoadingState.success);
    });
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    setLoadingState(LoadingState.loading);
    var response = await _authService.loginUser(
      email: email,
      password: password,
    );
    response.fold((error) {
      setLoadingState(LoadingState.error);
      setErrorMessage(error.message);
    }, (success) {
      sharedPrefs.isLoggedIn = true;
      setLoadingState(LoadingState.success);
    });
  }

  Future<void> getOTP({required String email}) async {
    setLoadingState(LoadingState.loading);
    var response = await _authService.getOTP(email: email);
    response.fold((error) {
      setLoadingState(LoadingState.error);
      setErrorMessage(error.message);
    }, (success) {
      setLoadingState(LoadingState.success);
    });
  }

  Future<void> forgotPassword({required String email}) async {
    setLoadingState(LoadingState.loading);
    var response = await _authService.forgotPassword(email: email);
    response.fold((error) {
      setLoadingState(LoadingState.error);
      setErrorMessage(error.message);
    }, (success) {
      setLoadingState(LoadingState.success);
    });
  }

  Future<void> resetPassword({
    required String password,
    required String otp,
  }) async {
    setLoadingState(LoadingState.loading);
    var response = await _authService.resetPassword(
      password: password,
      otp: otp,
    );
    response.fold((error) {
      setLoadingState(LoadingState.error);
      setErrorMessage(error.message);
    }, (success) {
      setLoadingState(LoadingState.success);
    });
  }

  Future<void> verifyOTP({required String otp, required String email}) async {
    setLoadingState(LoadingState.loading);
    var response = await _authService.verifyOTP(otp: otp, email: email);
    response.fold((error) {
      setLoadingState(LoadingState.error);
      setErrorMessage(error.message);
    }, (success) {
      setLoadingState(LoadingState.success);
    });
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    setLoadingState(LoadingState.loading);
    var response = await _authService.updateProfile(
      name: name,
      email: email,
      phone: phone,
    );
    response.fold((error) {
      setLoadingState(LoadingState.error);
      setErrorMessage(error.message);
    }, (success) {
      toast("Successful");
      setLoadingState(LoadingState.success);
    });
  }
  Future<void> deleteAccount(
 
  ) async {
    setLoadingState(LoadingState.loading);
    var response = await _authService.deleteAccount(
   
    );
    response.fold((error) {
      setLoadingState(LoadingState.error);
      setErrorMessage(error.message);
    }, (success) {
      toast("Successful");
      setLoadingState(LoadingState.success);
    });
  }

  Future<void> selectImages() async {
    imageUpload = await myUploadImage();
    imageFile = imageUpload;

    if (imageFile != null) {
      Map image = {"image": imageUpload.path};

      await uploadImage(file: image);
    }

    notifyListeners();
  }

  Future<dynamic> uploadImage({
    BuildContext? context,
    file,
    int responseCode = 200,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${sharedPrefs.token}',
    };
    try {
      var request =
          http.MultipartRequest("POST", Uri.parse("UrlEndpoints.uploadImage"));

      request.headers.addAll(headers);
      request.files.add(
          await http.MultipartFile.fromPath("profileImage", imageUpload.path));

      return request.send().then((response) {
        return http.Response.fromStream(response).then((onValue) {
          debugPrint("response1:${onValue.body}");
          // authProvider.getProfile();
        });
      });
    } catch (e) {
      debugPrint("response:$e");
      return null;
    }
  }

  Future<Map<String, dynamic>> validateToken() async {
    try {
      // dev.log("validateToken called");
      var response = await _authService.loginUser(
        email: sharedPrefs.email,
        password: sharedPrefs.password,
      );

   

      dynamic res;
      response.fold((error) {
        setLoadingState(LoadingState.error);
        // dev.log("error login called");
        res = false;

        return {
          "res": false,
        };
      }, (success) {
        dev.log("success login ");

        sharedPrefs.isLoggedIn = true;
        setLoadingState(LoadingState.success);
        res = true;
        return {
          "res": true,
        };
      });
      // dev.log("none login called");

      return {
        "res": res,
      };
    } catch (e) {
      debugPrint('Error validating token: $e');
      return {
        "res": false,
      };
    }
  }
}
