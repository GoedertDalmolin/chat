import 'dart:io';
import 'dart:async';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;

  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);

      controller.add(_currentUser);
    }
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
    final auth = FirebaseAuth.instance;

    var credential = await auth.createUserWithEmailAndPassword(email: email, password: password);

    if (credential.user == null) return;

    await credential.user?.updateDisplayName(name);
    // credential.user?.updatePhotoURL(photoURL);
  }

  @override
  Future login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future logout() async {
    FirebaseAuth.instance.signOut();
  }

  static ChatUser _toChatUser(User user) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: user.photoURL ?? 'assets/images/avatar.png',
    );
  }
}
