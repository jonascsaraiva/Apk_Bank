import 'package:flutter/material.dart';
import 'package:teste_1/settings.dart';
import 'package:teste_1/home_page.dart';
import 'package:teste_1/login_page.dart';
import 'package:teste_1/register.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  // Notifier global para o tema
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.light,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.white),
            fontFamily: 'PlayfairDisplay',
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            iconTheme: IconThemeData(color: Colors.white),
            fontFamily: 'PlayfairDisplay',
          ),
          themeMode: currentMode,
          routes: {
            '/': (context) => const LoginPage(),
            '/home': (context) => const HomePage(),
            '/register': (context) => const Register(),
            '/settings': (context) => const Settings(),
          },
        );
      },
    );
  }
}
