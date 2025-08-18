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
        ChangeNotifierProvider(create: (_) => AppSettings()),
        ChangeNotifierProvider(create: (_) => ThemeSettings()),

        //Providdr importante abaixo:
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => MoedaRepository()),
        ChangeNotifierProvider(
          create: (context) =>
              ContaRepository(moedas: context.read<MoedaRepository>()),
        ),
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(
          create: (context) => FavoritasRepository(
            auth: context.read<AuthService>(),
            moedas: context.read<MoedaRepository>(),
          ),
        ),
      ],
      child: const AppWidget(),
    ),
  );
}
