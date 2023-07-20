import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket socket;

  ServerStatus get serverStatus => _serverStatus;

  void connect() async {
    final token = await AuthService.getToken();

    socket = IO.io(Environment.socketUrl, {
      "transports": ["websocket"],
      "autoConnect": true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });
    socket.on('connect', (_) {
      _serverStatus = ServerStatus.online;
      print("conectado");
      notifyListeners();
    });
    socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.offline;
      print("desconectado");
      notifyListeners();
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
