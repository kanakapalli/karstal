import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/chat.dart';
import '../model/message.dart';
import '../../../services/chatgpt_service.dart';

final chatDetailProvider = StateNotifierProvider.family<ChatDetailController, List<Message>, String>((ref, chatId) {
  final chatGptService = ref.read(chatGptServiceProvider);
  return ChatDetailController(chatGptService);
});

class ChatDetailController extends StateNotifier<List<Message>> {
  final ChatGptService _chatGptService;
  ChatDetailController(this._chatGptService) : super([]);

  Future<void> sendMessage(String text) async {
    state = [
      ...state,
      Message(text: text, isUser: true, time: DateTime.now()),
    ];
    final response = await _chatGptService.getResponse(text);
    state = [
      ...state,
      Message(text: response, isUser: false, time: DateTime.now()),
    ];
  }
}
