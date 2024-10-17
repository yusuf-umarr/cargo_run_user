import 'dart:convert';

import 'package:cargo_run/utils/env.dart';
import 'package:cargo_run/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;
import '/models/api_response.dart';
import '/services/user/user_abstract.dart';

class UserImpl implements UserService {
  @override
  Future<ApiResponse> getUser() async {
    var url = Uri.parse('${Env.endpointUrl}/user');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPrefs.token}',
    };
    try {
      var res = await http.get(url, headers: headers);
      var jsonResponse = jsonDecode(res.body);
      var apiResponse = ApiResponse.fromJson(jsonResponse);
      return apiResponse;
    } catch (e) {
      return ApiResponse.fromJson({
        'success': false,
        'msg': 'Error: $e',
        'error': {'msg': 'Error: $e'}
      });
    }
  }
}
