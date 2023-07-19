// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

import 'package:chat_app/models/user_model.dart';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool ok;
  User user;
  String token;

  LoginModel({
    required this.ok,
    required this.user,
    required this.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        ok: json["ok"],
        user: User.fromJson(json["user"]),
        token: json["token"] ?? 'no token',
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "user": user.toJson(),
        "token": token,
      };
}
