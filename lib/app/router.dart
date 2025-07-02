import 'package:go_router/go_router.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/profile_page.dart';
import '../features/chat/presentation/dashboard_page.dart';
import '../features/chat/presentation/chat_detail_page.dart';
import '../features/auth/presentation/simple_section_page.dart';
import '../features/chat/presentation/agent_page.dart';
import '../features/auth/presentation/contacts_page.dart';

GoRouter createRouter({required bool isLoggedIn}) => GoRouter(
  initialLocation: isLoggedIn ? '/dashboard' : '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ChatDetailPage(chatId: id);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/profile/identity',
      builder: (context, state) => const SimpleSectionPage(title: 'User Identity'),
    ),
    GoRoute(
      path: '/profile/knowledge',
      builder: (context, state) => const SimpleSectionPage(title: 'Knowledge Base'),
    ),
    GoRoute(
      path: '/profile/privacy',
      builder: (context, state) => const SimpleSectionPage(title: 'Permissions & Privacy'),
    ),
    GoRoute(
      path: '/profile/notifications',
      builder: (context, state) => const SimpleSectionPage(title: 'Notifications & Nudges'),
    ),
    GoRoute(
      path: '/profile/chat',
      builder: (context, state) => const SimpleSectionPage(title: 'Streaming & Chat'),
    ),
    GoRoute(
      path: '/profile/agents',
      builder: (context, state) => const SimpleSectionPage(title: 'Agent Customization'),
    ),
    GoRoute(
      path: '/profile/subscription',
      builder: (context, state) => const SimpleSectionPage(title: 'Subscription & Monetization'),
    ),
    GoRoute(
      path: '/profile/advanced',
      builder: (context, state) => const SimpleSectionPage(title: 'Advanced Settings'),
    ),
    GoRoute(
      path: '/profile/security',
      builder: (context, state) => const SimpleSectionPage(title: 'Security & Access'),
    ),
    GoRoute(
      path: '/profile/legal',
      builder: (context, state) => const SimpleSectionPage(title: 'Legal / Feedback / Support'),
    ),
    GoRoute(
      path: '/agent/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AgentPage(agentId: id);
      },
    ),
    GoRoute(
      path: '/contacts',
      builder: (context, state) => const ContactsPage(),
    ),
  ],
);
