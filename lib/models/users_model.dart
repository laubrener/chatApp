// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

import 'package:chat_app/models/user_model.dart';

UsersModel usersModelFromJson(String str) =>
    UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
  bool ok;
  List<User> users;

  UsersModel({
    required this.ok,
    required this.users,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        ok: json["ok"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}
