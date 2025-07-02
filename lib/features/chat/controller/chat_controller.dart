import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/chat.dart';
import '../model/message.dart';
import '../../../services/openai_service.dart';
import '../model/ai_character.dart';
import '../../../services/ai_character_service.dart';

final chatControllerProvider = StateNotifierProvider<ChatController, List<Chat>>((ref) {
  return ChatController(
    ref.read(openAIServiceProvider),
  );
});

final openAIServiceProvider = Provider<OpenAIService>((ref) => OpenAIService(
  apiKey: dotenv.env['OPENAI_API_KEY'],
  systemPrompt: "You are a helpful AI assistant.",
));

class ChatController extends StateNotifier<List<Chat>> {
  final OpenAIService _openAIService;
  List<AICharacter> _characters = [];
  ChatController(this._openAIService) : super([]) {
    loadChats();
  }

  Future<void> loadChats() async {
    _characters = await AICharacterService.loadCharacters();
    state = _characters.map((c) => Chat(
      id: c.id.toString(),
      name: c.name,
      avatarUrl: c.profileImage,
      messages: [
        Message(
          text: 'Hello. How can I assist you today?',
          isUser: false,
          time: DateTime.now(),
        ),
      ],
      lastMessage: 'Hello. How can I assist you today?',
    )).toList();
  }

  String getSystemPrompt(String chatId) {
    final character = _characters.firstWhere((c) => c.id.toString() == chatId, orElse: () => _characters.first);
    return character.systemPrompt;
  }

  Future<void> sendMessageWithBotReply(String chatId, String text) async {
    sendMessage(chatId, text, isUser: true);
    final chatIndex = state.indexWhere((c) => c.id == chatId);
    final chat = state[chatIndex];
    final messages = chat.messages.map((m) => {
      'role': m.isUser ? 'user' : 'assistant',
      'content': m.text,
    }).toList();
    try {
      final systemPrompt = getSystemPrompt(chatId);
      final botReply = await _openAIService.getChatCompletionWithPrompt(messages, systemPrompt);
      sendMessage(chatId, botReply, isUser: false);
    } catch (e) {
      sendMessage(chatId, 'Sorry, I could not connect to OpenAI.', isUser: false);
    }
  }

  void sendMessage(String chatId, String text, {bool isUser = true}) {
    final chatIndex = state.indexWhere((c) => c.id == chatId);
    if (chatIndex == -1) return;
    final chat = state[chatIndex];
    final newMessage = Message(text: text, isUser: isUser, time: DateTime.now());
    final updatedMessages = List<Message>.from(chat.messages)..add(newMessage);
    final updatedChat = Chat(
      id: chat.id,
      name: chat.name,
      avatarUrl: chat.avatarUrl,
      messages: updatedMessages,
      lastMessage: text,
    );
    state = [
      ...state.sublist(0, chatIndex),
      updatedChat,
      ...state.sublist(chatIndex + 1),
    ];
  }
}
