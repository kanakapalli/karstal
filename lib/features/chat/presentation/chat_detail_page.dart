import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controller/chat_controller.dart';
import '../../../services/ai_character_service.dart';
import '../model/ai_character.dart';
import '../../../widgets/chat_bubble.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:lottie/lottie.dart';

class ChatDetailPage extends ConsumerStatefulWidget {
  final String chatId;
  const ChatDetailPage({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isBotTyping = false;
  AICharacter? agent;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  static const String _speechLogTag = '[KARSTAL-SPEECH]';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _loadAgent();
  }

  Future<void> _loadAgent() async {
    final characters = await AICharacterService.loadCharacters();
    setState(() {
      agent = characters.firstWhere((c) => c.id.toString() == widget.chatId);
    });
  }

  void _startListening() async {
    log('$_speechLogTag Initializing speech recognition');
    bool available = await _speech.initialize(
      onStatus: (status) {
        log('$_speechLogTag Status: $status');
        if (status == 'notListening' || status == 'done') {
          setState(() => _isListening = false);
          log('$_speechLogTag Listening stopped, mic icon should show');
        }
      },
      onError: (error) {
        log('$_speechLogTag Error: $error');
        setState(() => _isListening = false);
      },
    );
    log('$_speechLogTag Speech available: $available');
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          log('$_speechLogTag Recognized: ${result.recognizedWords} (final: ${result.finalResult})');
          setState(() {
            messageController.text = result.recognizedWords;
            messageController.selection = TextSelection.fromPosition(
              TextPosition(offset: messageController.text.length),
            );
            if (result.finalResult) {
              _isListening = false;
              log('$_speechLogTag Final result, listening stopped.');
            }
          });
        },
        listenFor: const Duration(minutes: 2), // Increased listening duration
        pauseFor: const Duration(seconds: 2),
        localeId: 'en_US',
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );
      log('$_speechLogTag Listening started, animation should show');
    } else {
      log('$_speechLogTag Speech recognition not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    final chats = ref.watch(chatControllerProvider);
    final chat = chats.firstWhere((c) => c.id == widget.chatId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181C),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            if (agent != null)
              GestureDetector(
                onTap: () => context.push('/agent/${agent!.id}'),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(agent!.profileImage),
                  radius: 18,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chat.name, style: const TextStyle(color: Colors.white)),
                  const Text('Online', style: TextStyle(fontSize: 12, color: Colors.green)),
                ],
              ),
            ),
          ],
        ),
        actions: [],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                itemCount: chat.messages.length + (isBotTyping ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i < chat.messages.length) {
                    final msg = chat.messages[i];
                    return ChatBubble(
                      text: msg.text,
                      isUser: msg.isUser,
                      time: msg.time,
                      avatarUrl: null, // No avatar in bubble
                      isTyping: false,
                    );
                  } else {
                    // Bot is typing bubble
                    return ChatBubble(
                      text: '',
                      isUser: false,
                      time: DateTime.now(),
                      avatarUrl: null,
                      isTyping: true,
                    );
                  }
                },
              ),
            ),
            Container(
              color: const Color(0xFF18181C),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF23232A),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: messageController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              minLines: 1,
                              maxLines: 4,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () async {
                              log('$_speechLogTag Mic button tapped. isListening: $_isListening');
                              if (_isListening) {
                                log('$_speechLogTag Stopping speech recognition');
                                await _speech.stop();
                                setState(() => _isListening = false);
                                log('$_speechLogTag Listening stopped by user, mic icon should show');
                              } else {
                                _startListening();
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _isListening ? Colors.amber.withOpacity(0.2) : Colors.transparent,
                                shape: BoxShape.circle,
                                boxShadow: _isListening
                                    ? [
                                        BoxShadow(
                                          color: Colors.amber.withOpacity(0.5),
                                          blurRadius: 16,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Center(
                                child: _isListening
                                    ? Lottie.asset(
                                        'assets/lottie/loading-circle.json',
                                        width: 28,
                                        height: 28,
                                        fit: BoxFit.contain,
                                        repeat: true,
                                      )
                                    : const Icon(Icons.mic, color: Colors.amber),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      if (messageController.text.isNotEmpty) {
                        final text = messageController.text;
                        messageController.clear();
                        setState(() => isBotTyping = true);
                        await ref.read(chatControllerProvider.notifier)
                            .sendMessageWithBotReply(widget.chatId, text);
                        setState(() => isBotTyping = false);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
