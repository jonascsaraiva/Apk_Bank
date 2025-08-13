import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AppSettings extends ChangeNotifier {
  late SharedPreferences _prefs;
  Map<String, String> locale = {'locale': 'pt_BR', 'name': 'R\$'};

  AppSettings() {
    _loadSettings();
  }

  _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    final local = _prefs.getString('locale') ?? 'pt_BR';
    final name = _prefs.getString('name') ?? 'R\$';
    locale = {'locale': local, 'name': name};
    notifyListeners();
  }

  setLocale(String local, String name) async {
    await _prefs.setString('locale', local);
    await _prefs.setString('name', name);
    locale = {'locale': local, 'name': name};
    notifyListeners();
  }

  String formatarPreco(double valor) {
    final format = NumberFormat.currency(
      locale: locale['locale'],
      symbol: locale['name'],
    );
    return format.format(valor);
  }
}
