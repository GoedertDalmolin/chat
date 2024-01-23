import 'dart:io';

import 'package:chat/core/models/chat_user.dart';

abstract class AuthService {
  ChatUser? get currentUser;

  Stream<ChatUser?> get userChanges;

  Future signup(
    String nome,
    String email,
    String password,
    File image,
  );

  Future login(String email, String password);

  Future logout();
}