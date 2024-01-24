import 'dart:io';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_mock_service.dart';

abstract class AuthService {
  ChatUser? get currentUser;

  Stream<ChatUser?> get userChanges;

  Future signup(
    String name,
    String email,
    String password,
    File image,
  );

  Future login(String email, String password);

  Future logout();

  factory AuthService() {
    return AuthMockService();
  }
}
