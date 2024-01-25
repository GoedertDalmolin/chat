import 'package:chat/core/models/chat_notification.dart';
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
}
