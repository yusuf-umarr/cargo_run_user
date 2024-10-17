import '../../models/api_response.dart';

abstract class UserService {
  Future<ApiResponse> getUser();
}
