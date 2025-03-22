// import 'dart:async';
// import 'dart:developer';
// import 'package:cargo_run/utils/env.dart';
// import 'package:cargo_run/utils/shared_prefs.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class AuthTokenProvider with ChangeNotifier {
//   String? _token;
//   String? get token => _token;

//   Future<Map<String, dynamic>> validateToken() async {
//     var url = Uri.parse("${Env.endpointUrl}/rider");

//     final headers = {
//       'Content-Type': 'application/json',
//       "Authorization": "Bearer ${sharedPrefs.token}"
//     };
  

//     try {
//       final response = await http.get(
//         url,
//         headers: headers,
//       );

//       log("response:${response.statusCode}");

//       if (response.statusCode == 200) {

//         return {
//           "res": true,
//         }; // Token is valid
//       } else {
//         return {"res": false};
//       }
//     } catch (e) {
//       debugPrint('Error validating token: $e');
//       return {
//         "res": false,
//       };
//     }
//   }
// }
