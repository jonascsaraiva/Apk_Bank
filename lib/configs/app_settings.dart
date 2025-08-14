import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AppSettings extends ChangeNotifier {
  late Box _box;

  Map<String, String> locale = {'locale': 'pt_BR', 'name': 'R\$'};

  AppSettings() {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox('settings');
    final local = _box.get('locale', defaultValue: 'pt_BR');
    final name = _box.get('name', defaultValue: 'R\$');
    locale = {'locale': local, 'name': name};
    notifyListeners();
  }

  Future<void> setLocale(String local, String name) async {
    await _box.put('locale', local);
    await _box.put('name', name);
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
