import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/models/messages_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global/environment.dart';

class ChatService with ChangeNotifier {
  late User userTo;

  Future<List<Message>?> getChat(String userID) async {
    Uri url = Uri.parse('${Environment.apiUrl}/messages/$userID');
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken()
    });
    final messagesResp = messagesModelFromJson(resp.body);

    return messagesResp.messages;
  }
}
