import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../configs/theme_settings.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém a instância compartilhada do ThemeSettings
    final themeSettings = Provider.of<ThemeSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 1, 46, 95),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Tema Escuro'),
            value: themeSettings.isDark,
            onChanged: (value) async {
              await themeSettings.setDark(value); // Atualiza instantaneamente
            },
          ),
        ],
      ),
    );
  }
}
