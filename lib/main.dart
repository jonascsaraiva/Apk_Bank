import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_1/app_widget.dart';
import 'package:teste_1/configs/app_settings.dart';
import 'package:teste_1/configs/hive_config.dart';
import 'package:teste_1/configs/theme_settings.dart';
import 'package:teste_1/repositories/conta_repository.dart';
import 'package:teste_1/repositories/favoritas_repository.dart';
import 'package:teste_1/repositories/moeda_repository.dart';
import 'package:teste_1/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ContaRepository()),
        ChangeNotifierProvider(create: (_) => MoedaRepository()),
        ChangeNotifierProvider(
          create: (context) =>
              FavoritasRepository(auth: context.read<AuthService>()),
        ),
        ChangeNotifierProvider(create: (_) => AppSettings()),
        ChangeNotifierProvider(create: (_) => ThemeSettings()),
      ],
      child: const AppWidget(),
    ),
  );
}
