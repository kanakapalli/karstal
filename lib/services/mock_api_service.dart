import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faker/faker.dart';
import '../features/chat/model/chat.dart';
import '../features/chat/model/message.dart';

class MockApiService {
  final _faker = Faker();

  List<Chat> getChats() {
    return List.generate(10, (i) {
      final messages = [
        Message(
          text: 'Hello. How can I assist you today?',
          isUser: false,
          time: DateTime.now(),
        ),
      ];
      return Chat(
        id: i.toString(),
        name: _faker.person.name(),
        avatarUrl: 'https://i.pravatar.cc/150?img=${i + 1}',
        messages: messages,
        lastMessage: messages.last.text,
      );
    });
  }
}
