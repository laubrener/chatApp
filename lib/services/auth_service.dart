import 'dart:convert';

import 'package:chat_app/global/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/login_model.dart';
import '../models/user_model.dart';

class AuthService with ChangeNotifier {
  late User user;
  bool _authenticating = false;

  final _storage = FlutterSecureStorage();

  bool get authenticating => _authenticating;
  set authenticating(bool value) {
    _authenticating = value;
    notifyListeners();
  }

  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    String token = await _storage.read(key: 'token') ?? "";
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    authenticating = true;

    final data = {
      'email': email,
      'password': password,
    };

    Uri url = Uri.parse('${Environment.apiUrl}/login');
    final resp = await http.post(url, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
    });

    authenticating = false;
    if (resp.statusCode == 200) {
      LoginModel loginModel = loginModelFromJson(resp.body);
      user = loginModel.user;

      await _saveToken(loginModel.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    authenticating = true;

    final data = {
      'name': name,
      'email': email,
      'password': password,
    };

    Uri url = Uri.parse('${Environment.apiUrl}/login/new');
    final resp = await http.post(url, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
    });

    authenticating = false;
    if (resp.statusCode == 200) {
      LoginModel loginModel = loginModelFromJson(resp.body);
      user = loginModel.user;

      await _saveToken(loginModel.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    Uri url = Uri.parse('${Environment.apiUrl}/login/renew');
    final resp = await http.get(url,
        headers: {'Content-Type': 'application/json', 'x-token': token!});

    if (resp.statusCode == 200) {
      LoginModel loginModel = loginModelFromJson(resp.body);
      user = loginModel.user;

      await _saveToken(loginModel.token);

      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
