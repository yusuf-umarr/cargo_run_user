import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

import '/services/authentication/auth_abstract.dart';
import '/services/service_locator.dart';

enum LoadingState { initial, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = serviceLocator<AuthService>();
  LoadingState _loadingState = LoadingState.initial;
  String _errorMessage = '';

  LoadingState get loadingState => _loadingState;
  String get errorMessage => _errorMessage;

  void setLoadingState(LoadingState loadingState) {
    _loadingState = loadingState;
    notifyListeners();
  }

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  Future<void> registerUser({
    required String fullName,
    required String password,
    required String phone,
  }) async {
    setLoadingState(LoadingState.loading);
    var response = await _authService.registerUser(
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
}
