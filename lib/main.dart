import 'package:chat/core/services/notification/chat_notification_service.dart';
import 'package:chat/pages/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ChatNotificationService()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF171637)),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const InitialPage(),
      ),
    );
  }
}
