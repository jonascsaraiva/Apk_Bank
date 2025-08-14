import 'package:shared_preferences/shared_preferences.dart';

class CounterSettings {
  static const _key = 'counter_value';

  //Carrega o valor do contador, inciado em 0
  Future<int> getCounter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  //Salva o valor do contador no SharedPreferences
  Future<void> setCounter(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, value);
  }
}
