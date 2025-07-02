import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controller/chat_controller.dart';
import '../../../utils/constants.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (context, i) => const Divider(thickness: 1, height: 1),
              itemBuilder: (context, i) {
                final chat = chats[i];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(chat.avatarUrl)),
                  title: Text(chat.name),
                  subtitle: Text(chat.lastMessage),
                  onTap: () => context.push('/chat/${chat.id}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text('Add Calendar Permissions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                minimumSize: const Size(220, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                context.push('/contacts');
              },
            ),
          ),
        ],
      ),
    );
  }
}
