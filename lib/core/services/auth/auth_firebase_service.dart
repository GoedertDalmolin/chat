import 'dart:io';
import 'dart:async';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

    final signup = await Firebase.initializeApp(
      name: 'userSignup',
      options: Firebase.app().options,
    );

    final auth = FirebaseAuth.instanceFor(app: signup);

    var credential = await auth.createUserWithEmailAndPassword(email: email, password: password);

    if (credential.user == null) return;

    if (credential.user != null) {
      final imageName = '${credential.user!.uid}.jpg';
      final imageUrl = await _uploadUserImage(image, imageName);

      await credential.user?.updateDisplayName(name);
      await credential.user?.updatePhotoURL(imageUrl);

      await login(email, password);

      await _saveChatUser(
        _toChatUser(credential.user!, imageUrl),
      );
    }

    await signup.delete();
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
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);
    await imageRef.putFile(image).whenComplete(() => null);

    return await imageRef.getDownloadURL();
  }

  Future _saveChatUser(ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);

    await docRef.set({
      'name': user.name,
      'email': user.email,
      'imageUrl': user.imageUrl,
    });
  }

  static ChatUser _toChatUser(User user, [String? imageUrl]) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: imageUrl ?? user.photoURL ?? 'assets/images/avatar.png',
    );
  }
}
