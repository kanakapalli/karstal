import 'package:flutter/material.dart';
import 'package:karstal/services/ai_character_service.dart';
import '../model/ai_character.dart';
import 'package:go_router/go_router.dart';

class AgentPage extends StatefulWidget {
  final String agentId;
  const AgentPage({super.key, required this.agentId});

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  AICharacter? agent;

  @override
  void initState() {
    super.initState();
    _loadAgent();
  }

  Future<void> _loadAgent() async {
    final characters = await AICharacterService.loadCharacters();
    setState(() {
      agent = characters.firstWhere((c) => c.id.toString() == widget.agentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (agent == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181C),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(agent!.name, style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(agent!.profileImage),
              ),
            ),
            const SizedBox(height: 18),
            Text(agent!.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            Text(agent!.occupation, style: const TextStyle(fontSize: 15, color: Colors.white70)),
            const SizedBox(height: 18),
            Text(agent!.bio ?? '', style: const TextStyle(fontSize: 16, color: Colors.white70)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF18181C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(child: Text(agent!.systemPrompt, style: const TextStyle(color: Colors.white70))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Agent-specific settings/options
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF18181C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Agent Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.amber),
                    title: const Text('Change System Prompt', style: TextStyle(color: Colors.white)),
                    onTap: () {}, // TODO: Implement action
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.history, color: Colors.cyan),
                    title: const Text('View Chat History', style: TextStyle(color: Colors.white)),
                    onTap: () {}, // TODO: Implement action
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications_off, color: Colors.redAccent),
                    title: const Text('Mute Agent', style: TextStyle(color: Colors.white)),
                    onTap: () {}, // TODO: Implement action
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_outline, color: Colors.grey),
                    title: const Text('Clear Chat', style: TextStyle(color: Colors.white)),
                    onTap: () {}, // TODO: Implement action
                    contentPadding: EdgeInsets.zero,
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
