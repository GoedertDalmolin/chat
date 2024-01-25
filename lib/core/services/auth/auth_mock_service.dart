import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';

class AuthMockService implements AuthService {
  static const _defaultUser = ChatUser(
    id: '1234',
    name: 'Ana',
    email: 'teste@gmail.com',
    imageUrl: 'assets/images/avatar.png',
  );

  static final Map<String, ChatUser> _users = {
    _defaultUser.email: _defaultUser,
  };
  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;

  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _updateUser(_defaultUser);
  });

  @override
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Future signup(
    String name,
    String email,
    String password,
    File image,
  ) async {
    final newUser = ChatUser(
      id: Random().nextDouble().toString(),
      name: name,
      email: email,
      imageUrl: image.path,
    );
    _users.putIfAbsent(email, () => newUser);

    _updateUser(newUser);
  }

  @override
  Future login(String email, String password) async {
    _updateUser(_users[email]);
  }

  @override
  Future logout() async {
    _updateUser(null);
  }

  static _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller!.add(user);
  }
}
