import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  //Auth data
  String get token => _sharedPrefs.getString('token') ?? "";
  String get userId => _sharedPrefs.getString('userId') ?? "";
  String get email => _sharedPrefs.getString('email') ?? "";
  String get phone => _sharedPrefs.getString('phone') ?? "";
  String get fullName => _sharedPrefs.getString('fullName') ?? "";
  bool get isLoggedIn => _sharedPrefs.getBool('isLoggedIn') ?? false;

  //Order data
  String get orderStatus => _sharedPrefs.getString('orderStatus') ?? "";
  String get orderId => _sharedPrefs.getString('orderId') ?? "";
  String get lat => _sharedPrefs.getString('lat') ?? "";
  String get lng => _sharedPrefs.getString('lng') ?? "";

  set token(String value) {
    _sharedPrefs.setString('token', value);
  }

  set userId(String value) {
    _sharedPrefs.setString('userId', value);
  }

  set email(String value) {
    _sharedPrefs.setString('email', value);
  }

  set phone(String value) {
    _sharedPrefs.setString('phone', value);
  }

  set fullName(String value) {
    _sharedPrefs.setString('fullName', value);
  }

  set isLoggedIn(bool value) {
    _sharedPrefs.setBool('isLoggedIn', value);
  }

  set orderStatus(String value) {
    _sharedPrefs.setString('orderStatus', value);
  }

  set orderId(String value) {
    _sharedPrefs.setString('orderId', value);
  }

  set lat(String value) {
    _sharedPrefs.setString('lat', value);
  }

  set lng(String value) {
    _sharedPrefs.setString('lng', value);
  }

  void clearAll() {
    _sharedPrefs.clear();
  }
}

final sharedPrefs = SharedPrefs();
