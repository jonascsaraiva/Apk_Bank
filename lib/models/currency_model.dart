class CurrencyModel {
  final String name;
  final double real;
  final double dolar;
  final double euro;
  final double bitcoin;

  CurrencyModel({
    required this.name,
    required this.real,
    required this.dolar,
    required this.euro,
    required this.bitcoin,
  });

  static List<CurrencyModel> getCurrencies() {
    return <CurrencyModel>[
      CurrencyModel(
        name: 'Real',
        real: 1.0,
        dolar: 0.18,
        euro: 0.16,
        bitcoin: 0.0000015,
      ),
      CurrencyModel(
        name: 'Dolar',
        real: 5.43,
        dolar: 1.0,
        euro: 0.86,
        bitcoin: 0.0000083,
      ),
      CurrencyModel(
        name: 'Euro',
        real: 6.32,
        dolar: 1.16,
        euro: 1.0,
        bitcoin: 0.0000096,
      ),
      CurrencyModel(
        name: 'Bitcoin',
        real: 655693.62,
        dolar: 120602.80,
        euro: 103722.54,
        bitcoin: 1.0,
      ),
    ];
  }
}
