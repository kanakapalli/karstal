import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime time;
  final String? avatarUrl;
  final bool isTyping;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    required this.time,
    this.avatarUrl,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isUser && avatarUrl != null)
          Padding(
            padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 2.0),
            child: CircleAvatar(radius: 14, backgroundImage: NetworkImage(avatarUrl!)),
          ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(
              top: 4,
              bottom: 4,
              left: isUser ? 40 : 8,
              right: isUser ? 8 : 40,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF2563EB) : const Color(0xFF23232A),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                isTyping
                    ? const TypingIndicator()
                    : Text(
                        text,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                const SizedBox(height: 4),
                Text(
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 10,
                    color: isUser ? Colors.white54 : Colors.white38,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dotCountAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _dotCountAnim = StepTween(begin: 1, end: 3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotCountAnim,
      builder: (context, child) {
        final dots = '.' * _dotCountAnim.value;
        return Text(
          'Typing$dots',
          style: const TextStyle(color: Colors.white70, fontSize: 16, fontStyle: FontStyle.italic),
        );
      },
    );
  }
}
