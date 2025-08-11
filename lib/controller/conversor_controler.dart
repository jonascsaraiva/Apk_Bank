import 'package:flutter/widgets.dart';
import 'package:teste_1/models/currency_model.dart';

class ConversorController {
  final List<CurrencyModel> currencies;

  final TextEditingController fromText = TextEditingController();
  final TextEditingController toText = TextEditingController();

  CurrencyModel fromCurrency;
  CurrencyModel toCurrency;

  ConversorController()
    : currencies = CurrencyModel.getCurrencies(),
      fromCurrency = CurrencyModel.getCurrencies()[0], // Real
      toCurrency = CurrencyModel.getCurrencies()[1]; // Dolar

  double convert() {
    double inputValue =
        double.tryParse(fromText.text.replaceAll(',', '.')) ?? 0.0;

    if (inputValue == 0) return 0;

    // Converte para Real como base
    double valueInReal = inputValue * _getRate(fromCurrency);

    // Depois converte para moeda destino
    double convertedValue = valueInReal / _getRate(toCurrency);

    // Atualiza o texto do controlador de saída
    toText.text = convertedValue.toString();

    return convertedValue;
  }

  double _getRate(CurrencyModel currency) {
    // Retorna o valor de 1 unidade daquela moeda em Real
    switch (currency.name) {
      case 'Real':
        return 1;
      case 'Dolar':
        return currency.real; // valor do dolar em real
      case 'Euro':
        return currency.real;
      case 'Bitcoin':
        return currency.real;
      default:
        return 1;
    }
  }
}
