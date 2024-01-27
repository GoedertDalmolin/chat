import 'package:chat/core/models/chat_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class ChatNotificationService with ChangeNotifier {
  final List<ChatNotification> _items = [];

  List<ChatNotification> get items {
    return [..._items];
  }

  int get itemsCount {
    return items.length;
  }

  add(ChatNotification notification) {
    _items.add(notification);
    notifyListeners();
  }

  remove(int i) {
    _items.removeAt(i);
    notifyListeners();
  }

  // Push Notification
  Future init() async {
    await _configureForeground();
    await _configureBackground();
    await _configureTerminated();
  }

  Future<bool> get _isAuthorized async {
    final messaging = FirebaseMessaging.instance;

    var settings = await messaging.requestPermission();

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future _configureForeground() async {
    if (await _isAuthorized) {
      FirebaseMessaging.onMessage.listen(_messageHandler);
    }
  }

  Future _configureBackground() async {
    if (await _isAuthorized) {
      FirebaseMessaging.onMessageOpenedApp.listen(_messageHandler);
    }
  }

  Future _configureTerminated() async {
    if (await _isAuthorized) {
      RemoteMessage? initialMsg = await FirebaseMessaging.instance.getInitialMessage();

      _messageHandler(initialMsg);
    }
  }

  _messageHandler(RemoteMessage? msg) {
    if (msg == null || msg.notification == null) return;

    if (msg.notification == null) return;

    add(ChatNotification(
      title: msg.notification!.title ?? '',
      body: msg.notification!.body ?? '',
    ));
  }
}
