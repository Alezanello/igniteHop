import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ignite_hop/theme.dart';
import 'package:ignite_hop/providers/game_provider.dart';
import 'package:ignite_hop/providers/settings_provider.dart';
import 'package:ignite_hop/screens/menu_screen.dart';
import 'package:ignite_hop/screens/game_screen.dart';
import 'package:ignite_hop/screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GameProvider()..loadHighScore(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider()..load(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Ignite Hop',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              name: 'menu',
              pageBuilder: (context, state) => NoTransitionPage(
                child: const MenuScreen(),
              ),
            ),
            GoRoute(
              path: '/game',
              name: 'game',
              pageBuilder: (context, state) => NoTransitionPage(
                child: const GameScreen(),
              ),
            ),
            GoRoute(
              path: '/settings',
              name: 'settings',
              pageBuilder: (context, state) => NoTransitionPage(
                child: const SettingsScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
