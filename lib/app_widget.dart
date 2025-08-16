import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_1/configs/theme_settings.dart';
import 'package:teste_1/list_pages.dart/favoritas_page.dart';
import 'package:teste_1/list_pages.dart/moedas_page.dart';
import 'package:teste_1/list_pages.dart/conversor_page.dart';
import 'package:teste_1/list_pages.dart/counter_page.dart';
//import 'package:teste_1/home_page.dart';
import 'package:teste_1/configs/configuracoa_page.dart';
import 'package:teste_1/widgets/auth_check.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeSettings(),
      child: Consumer<ThemeSettings>(
        builder: (context, themeSettings, _) {
          return MaterialApp(
            title: 'wallet Monitor app',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: false,
              brightness: Brightness.light,
              iconTheme: const IconThemeData(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              fontFamily: 'PlayfairDisplay',
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              iconTheme: const IconThemeData(color: Colors.white),
              fontFamily: 'PlayfairDisplay',
            ),
            themeMode: themeSettings.isDark ? ThemeMode.dark : ThemeMode.light,

            initialRoute: '/',

            routes: {
              '/': (context) => const AuthCheck(),
              //'/home': (context) => const HomePage(), primeira rota sempre é o /, então não precisa dessa rota aqui
              '/settings': (context) => Settings(),
              '/contador': (context) => const ContadorPage(),
              '/conversor': (context) => const ConversorPage(),
              '/moedas_page': (context) => MoedasPage(),
              '/favoritas_page.dart': (context) => FavoritasPage(),
            },
          );
        },
      ),
    );
  }
}
