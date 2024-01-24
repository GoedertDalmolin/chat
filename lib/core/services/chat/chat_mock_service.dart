import 'dart:async';
import 'dart:math';

import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';

class ChatMockService implements ChatService {
  static final List<ChatMessage> _msgs = [
    ChatMessage(
      id: '1',
      text: 'Bom dia',
      createdAt: DateTime.now(),
      userId: '123',
      userName: 'Teste',
      userImageUrl: 'assets/images/avatar.png',
    ),
    ChatMessage(
      id: '2',
      text: 'Bom dia Teremos reunião hj',
      createdAt: DateTime.now(),
      userId: '1234',
      userName: 'Teste2',
      userImageUrl: 'assets/images/avatar.png',
    ),
    ChatMessage(
      id: '3',
      text: 'Sim. Será agora!',
      createdAt: DateTime.now(),
      userId: '12345',
      userName: 'Teste3',
      userImageUrl: 'assets/images/avatar.png',
    ),
  ];

  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _msgsStreams = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    _controller?.add(_msgs);
  });

  @override
  Stream<List<ChatMessage>> messagesStream() {
    return _msgsStreams;
  }

  @override
  Future<ChatMessage> save(String text, ChatUser user) async {
    final newMessage = ChatMessage(
      id: Random().nextDouble().toString(),
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageUrl: user.imageUrl,
    );

    _msgs.add(newMessage);

    _controller?.add(_msgs);

    return newMessage;
  }
}
