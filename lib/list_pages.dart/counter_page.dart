import 'package:flutter/material.dart';
import 'package:teste_1/configs/counter_settings.dart';

class ContadorPage extends StatefulWidget {
  const ContadorPage({super.key});

  @override
  State<ContadorPage> createState() => _ContadorPageState();
}

class _ContadorPageState extends State<ContadorPage> {
  int counter = 0;
  final CounterSettings counterSettings = CounterSettings();
  // carrega valor ao iniciar
  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  // atualiza a tela
  Future<void> _loadCounter() async {
    counter = await counterSettings.getCounter();
    setState(() {});
  }

  // salva valor
  Future<void> _incrementCounter() async {
    setState(() {
      counter++;
    });
    await counterSettings.setCounter(counter);
  }

  // Reseta o valor do counter
  Future<void> _resetCounter() async {
    setState(() {
      counter = 0;
    });
    await counterSettings.setCounter(counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contador',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          //Countador Indice
          Text(
            'Counter: $counter',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          //Botão de Incremetar com informação guardada em SharedSharedPreferences
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.only(
              bottom: 30,
              left: 30,
              right: 30,
              top: 30,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 70, 123),
              borderRadius: BorderRadius.circular(1000.0),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 116, 116, 116)..withValues(),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: TextButton(
                onPressed: _incrementCounter,
                child: const Text(
                  'Adicionar',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ),
          //Botão de Resetar o contador
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 0, 0),
              borderRadius: BorderRadius.circular(1000.0),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 116, 116, 116)..withValues(),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: TextButton(
                onPressed: _resetCounter,
                child: const Text(
                  'Reset',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
