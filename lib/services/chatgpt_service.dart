// This is a mock ChatGPT-like service for simulating responses.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faker/faker.dart';

final chatGptServiceProvider = Provider<ChatGptService>((ref) => ChatGptService());

class ChatGptService {
  final _faker = Faker();

  Future<String> getResponse(String prompt) async {
    await Future.delayed(const Duration(seconds: 1));
    return _faker.lorem.sentence();
  }
}
