import 'dart:io';

import 'package:chat_app/models/messages_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/widgets/chat_message.dart';

import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/socket_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  ChatService chatService = ChatService();
  SocketService socketService = SocketService();
  AuthService authService = AuthService();

  final List<ChatMessage> _messages = [];
  bool isTexting = false;
  @override
  void initState() {
    super.initState();

    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('personal-message', _listenToMessage);

    _loadHistory(chatService.userTo.uid);
  }

  void _loadHistory(String userID) async {
    List<Message>? chat = await chatService.getChat(userID);

    print('chat: $chat');

    final history = chat?.map((e) => ChatMessage(
        text: e.message ?? '',
        uid: e.from ?? '',
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 0))
          ..forward()));

    setState(() {
      _messages.insertAll(0, history ?? []);
    });
  }

  void _listenToMessage(dynamic payload) {
    ChatMessage message = ChatMessage(
        text: payload['message'],
        uid: payload['from'],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final userTo = chatService.userTo;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[100],
                maxRadius: 14,
                child: Text(
                  userTo.name.substring(0, 2),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                userTo.name,
                style: TextStyle(fontSize: 12, color: Colors.black87),
              )
            ],
          ),
          centerTitle: true,
          elevation: 1,
        ),
        body: Container(
          child: Column(children: [
            Flexible(
                child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, i) => _messages[i],
              itemCount: _messages.length,
              reverse: true,
            )),
            const Divider(height: 1),
            // caja de texto
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ]),
        ));
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Flexible(
              child: TextField(
            controller: _textController,
            onSubmitted: _handleSubmit,
            onChanged: (String text) {
              setState(() {
                if (text.trim().isNotEmpty) {
                  isTexting = true;
                } else {
                  isTexting = false;
                }
              });
            },
            decoration:
                const InputDecoration.collapsed(hintText: 'Send message'),
            focusNode: _focusNode,
          )),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Platform.isIOS
                ? CupertinoButton(
                    onPressed: isTexting
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
                    child: const Text("Send"),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: isTexting
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                          icon: const Icon(
                            Icons.send,
                          )),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String text) {
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage(
      text: text,
      uid: authService.user.uid,
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      isTexting = false;
      socketService.socket.emit('personal-message', {
        'from': authService.user.uid,
        'to': chatService.userTo.uid,
        'message': text
      });
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('personal-message');
    super.dispose();
  }
}
