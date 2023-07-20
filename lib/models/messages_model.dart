// To parse this JSON data, do
//
//     final messagesModel = messagesModelFromJson(jsonString);

import 'dart:convert';

MessagesModel messagesModelFromJson(String str) =>
    MessagesModel.fromJson(json.decode(str));

String messagesModelToJson(MessagesModel data) => json.encode(data.toJson());

class MessagesModel {
  bool ok;
  List<Message>? messages;

  MessagesModel({
    required this.ok,
    this.messages,
  });

  factory MessagesModel.fromJson(Map<String, dynamic> json) => MessagesModel(
        ok: json["ok"],
        messages: json["messages"] != []
            ? List<Message>.from(
                json["messages"]?.map((x) => Message.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "messages": messages != []
            ? List<dynamic>.from(messages!.map((x) => x.toJson()))
            : [],
      };
}

class Message {
  String? from;
  String? to;
  String? message;
  DateTime? createdAt;
  DateTime? updatedAt;

  Message({
    this.from,
    this.to,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        from: json["from"] ?? '',
        to: json["to"] ?? '',
        message: json["message"] ?? '',
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "message": message,
        "createdAt": createdAt?.toIso8601String() ?? "",
        "updatedAt": updatedAt?.toIso8601String() ?? "",
      };
}
