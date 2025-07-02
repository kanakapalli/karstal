import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controller/theme_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock user data
    const userName = 'Kanak Sharma';
    const userEmail = 'kanak.sharma@email.com';
    const userImage = 'https://randomuser.me/api/portraits/men/32.jpg';
    final List<_ProfileSection> sections = [
      _ProfileSection('User Identity', Icons.person, '/profile/identity'),
      _ProfileSection('Knowledge Base', Icons.folder, '/profile/knowledge'),
      _ProfileSection('Permissions & Privacy', Icons.lock, '/profile/privacy'),
      _ProfileSection('Notifications & Nudges', Icons.notifications, '/profile/notifications'),
      _ProfileSection('Streaming & Chat', Icons.chat, '/profile/chat'),
      _ProfileSection('Agent Customization', Icons.psychology, '/profile/agents'),
      _ProfileSection('Subscription & Monetization', Icons.monetization_on, '/profile/subscription'),
      _ProfileSection('Advanced Settings', Icons.settings, '/profile/advanced'),
      _ProfileSection('Security & Access', Icons.security, '/profile/security'),
      _ProfileSection('Legal / Feedback / Support', Icons.help, '/profile/legal'),
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(userImage),
              ),
            ),
            const SizedBox(height: 18),
            Text(userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            Text(userEmail, style: const TextStyle(fontSize: 15, color: Colors.white70)),
            const SizedBox(height: 32),
            // Theme switcher
            Consumer(
              builder: (context, ref, _) {
                final themeMode = ref.watch(themeModeProvider);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.light_mode, color: Colors.amber),
                    Switch(
                      value: themeMode == ThemeMode.dark,
                      onChanged: (val) {
                        ref.read(themeModeProvider.notifier).setTheme(val ? ThemeMode.dark : ThemeMode.light);
                      },
                      activeColor: Colors.amber,
                    ),
                    const Icon(Icons.dark_mode, color: Colors.blue),
                    const SizedBox(width: 12),
                    Text(
                      themeMode == ThemeMode.dark ? 'Dark Mode' : 'Light Mode',
                      style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: sections.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.white24),
                itemBuilder: (context, i) {
                  final section = sections[i];
                  return ListTile(
                    leading: Icon(section.icon, color: Colors.white),
                    title: Text(section.title, style: const TextStyle(color: Colors.white)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                    onTap: () => context.push(section.route),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => context.go('/login'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection {
  final String title;
  final IconData icon;
  final String route;
  const _ProfileSection(this.title, this.icon, this.route);
}
