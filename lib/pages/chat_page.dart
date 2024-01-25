import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/pages/components/messages.dart';
import 'package:chat/pages/components/new_message.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BGD Chat'),
        actions: [
          PopupMenuButton(
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'Logout',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 12,),
                    Text('Sair'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if(value == 'Logout') {
                AuthService().logout();
              }
            },
          ),
        ],
      ),
      body: const SafeArea(
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
