import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/notification/chat_notification_service.dart';
import 'package:chat/pages/components/messages.dart';
import 'package:chat/pages/components/new_message.dart';
import 'package:chat/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                    SizedBox(
                      width: 12,
                    ),
                    Text('Sair'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'Logout') {
                AuthService().logout();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Badge(
              backgroundColor: Theme.of(context).primaryColor,
              offset: const Offset(-5, 5),
              label: Text('${Provider.of<ChatNotificationService>(context).itemsCount}'),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const NotificationPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications),
              ),
            ),
          )
        ],
      ),
      body: const SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     var notification = const ChatNotification(
      //       title: 'Atenção',
      //       body: 'Mais uma notificacao.',
      //     );
      //     Provider.of<ChatNotificationService>(context, listen: false).add(notification);
      //   },
      //   child: const Icon(Icons.notification_add),
      // ),
    );
  }
}
