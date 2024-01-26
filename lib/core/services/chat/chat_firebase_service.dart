import 'dart:async';

import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    final store = FirebaseFirestore.instance;

    final snapshots = store.collection('chat').withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore).orderBy('createdAt', descending: true).snapshots();

    return Stream<List<ChatMessage>>.multi((controller) {
      snapshots.listen((snapshots) {
        List<ChatMessage> lista = snapshots.docs.map((doc) => doc.data()).toList();

        controller.add(lista);
      });
    });
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    final msg = ChatMessage(
      id: '',
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageUrl: user.imageUrl,
    );

    final docRef = await store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .add(msg);

    final doc = await docRef.get();
    final data = doc.data()!;

    return data;
  }

  Map<String, dynamic> _toFirestore(ChatMessage message, SetOptions? options) {
    return {
      'text': message.text,
      'createdAt': message.createdAt.toIso8601String(),
      'userId': message.userId,
      'userName': message.userName,
      'userImageUrl': message.userImageUrl,
    };
  }

  ChatMessage _fromFirestore(DocumentSnapshot<Map<String, dynamic>> data, SnapshotOptions? options) {
    return ChatMessage(
      id: data.id,
      text: data['text'],
      createdAt: DateTime.parse(data['createdAt'].toString()),
      userId: data['userId'],
      userName: data['userName'],
      userImageUrl: data['userImageUrl'],
    );
  }
}
