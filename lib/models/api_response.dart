class ApiResponse {
  ApiResponse({
    required this.msg,
    required this.data,
  });

  final String? msg;
  final dynamic data;

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      msg: json["msg"],
      data: json["data"],
    );
  }
}

class ErrorResponse {
  String message;

  ErrorResponse({required this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic>? json) {
    return ErrorResponse(
      message: json?['msg'],
    );
  }
}
