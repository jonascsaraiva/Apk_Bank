import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_1/configs/app_settings.dart';
import 'package:teste_1/configs/theme_settings.dart';
import 'package:teste_1/repositories/favoritas_repository.dart';
import 'package:teste_1/repositories/moedarepository.dart';

import 'app_widget.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoedaRepository()),
        ChangeNotifierProvider(create: (_) => FavoritasRepository()),
        ChangeNotifierProvider(create: (_) => AppSettings()),
        ChangeNotifierProvider(create: (_) => ThemeSettings()),
      ],
      child: const AppWidget(),
    ),
  );
}
