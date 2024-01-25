import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_mock_service.dart';
import 'package:chat/pages/auth_page.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  Future init(BuildContext context) async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        }

        return StreamBuilder<ChatUser?>(
          stream: AuthMockService().userChanges,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage();
            } else {
              return snapshot.hasData ? const ChatPage() : const AuthPage();
            }
          },
        );
      },
    );
  }
}
