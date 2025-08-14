import 'package:flutter/material.dart';
import 'package:teste_1/controller/conversor_controler.dart';

class ConversorPage extends StatefulWidget {
  const ConversorPage({super.key});

  @override
  State<ConversorPage> createState() => _ConversorPageState();
}

class _ConversorPageState extends State<ConversorPage> {
  final ConversorController _controller = ConversorController();

  late String _fromCurrency;
  late String _toCurrency;
  String _resultText = '';

  List<String> get _currencyNames =>
      _controller.currencies.map((c) => c.name).toList();

  @override
  void initState() {
    super.initState();
    _fromCurrency = _controller.fromCurrency.name;
    _toCurrency = _controller.toCurrency.name;
  }

  void _convert() {
    // Atualiza moeda de origem e destino no controller
    _controller.fromCurrency = _controller.currencies.firstWhere(
      (c) => c.name == _fromCurrency,
    );
    _controller.toCurrency = _controller.currencies.firstWhere(
      (c) => c.name == _toCurrency,
    );

    // Atualiza o texto digitado
    _controller.fromText.text =
        _controller.fromText.text; // já atualizado na UI

    double resultado = _controller.convert();

    setState(() {
      _resultText = '${resultado.toStringAsFixed(2)} $_toCurrency';
    });
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

      body: ListView(
        padding: const EdgeInsets.only(top: 80.0, left: 20, right: 20),

        children: [
          Image.asset(
            'assets/logo - Copia.png',
            fit: BoxFit.contain,
            width: 170,
            height: 170,
          ),
          const SizedBox(height: 40),

          // Valor e moeda de origem
          Row(
            children: [
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<String>(
                  value: _fromCurrency,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: _currencyNames
                      .map(
                        (name) =>
                            DropdownMenuItem(value: name, child: Text(name)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _fromCurrency = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _controller.fromText,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Moeda destino
          DropdownButtonFormField<String>(
            value: _toCurrency,
            decoration: const InputDecoration(
              labelText: 'Converter para',
              border: OutlineInputBorder(),
            ),
            items: _currencyNames
                .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _toCurrency = value!;
              });
            },
          ),
          const SizedBox(height: 20),

          // Resultado
          Text(
            _resultText,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Botão
          SizedBox(
            width: double.infinity,
            height: 50,

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 15, 68, 124),
              ),
              onPressed: _convert,
              child: const Text(
                "Converter",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
