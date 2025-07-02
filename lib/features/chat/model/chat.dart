import 'message.dart';

class Chat {
  final String id;
  final String name;
  final String avatarUrl;
  final List<Message> messages;
  final String lastMessage;

  Chat({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.messages,
    required this.lastMessage,
  });
}
