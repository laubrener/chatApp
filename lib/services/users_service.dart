import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;
import '../global/environment.dart';
import '../models/user_model.dart';
import '../models/users_model.dart';

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      Uri url = Uri.parse('${Environment.apiUrl}/users');
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });
      final usersResponse = usersModelFromJson(resp.body);
      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }
}
