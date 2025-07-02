import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'services/hive_service.dart';
import 'features/auth/controller/theme_controller.dart';
import 'features/auth/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load .env from assets for mobile compatibility
  await dotenv.load(fileName: 'assets/.env');
  await HiveService.init();
  final isLoggedIn = HiveService.getIsLoggedIn();
  runApp(ProviderScope(child: AppInitializer(isLoggedIn: isLoggedIn)));
}

class AppInitializer extends StatefulWidget {
  final bool isLoggedIn;
  const AppInitializer({super.key, required this.isLoggedIn});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _initialized = false;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(isLoggedIn: widget.isLoggedIn);
    Future.delayed(Duration.zero, () async {
      setState(() => _initialized = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      );
    }
    return KarstalApp(router: _router);
  }
}

class KarstalApp extends ConsumerWidget {
  final GoRouter router;
  const KarstalApp({super.key, required this.router});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Karstal Chat',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
