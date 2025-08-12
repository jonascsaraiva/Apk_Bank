import 'package:flutter/material.dart';
import 'package:teste_1/models/moeda.dart';

class MoedaRepository extends ChangeNotifier {
  List<Moeda> _tabela = [
    Moeda(
      icone: 'assets/bitcoin.png',
      nome: 'Bitcoin',
      sigla: 'BTC',
      preco: 164603.00,
      baseId: '',
      timestamp: DateTime.now(),
      mudancaHora: 12,
      mudancaDia: 12,
      mudancaSemana: 12,
      mudancaMes: 12,
      mudancaAno: 12,
      mudancaPeriodoTotal: 12,
    ),
    Moeda(
      icone: 'assets/ethereum.png',
      nome: 'Ethereum',
      sigla: 'ETH',
      preco: 9716.00,
      timestamp: DateTime.now(),
      mudancaHora: 12,
      mudancaDia: 12,
      mudancaSemana: 12,
      mudancaMes: 12,
      mudancaAno: 12,
      mudancaPeriodoTotal: 12,
      baseId: '',
    ),
    Moeda(
      icone: 'assets/xrp.png',
      nome: 'XRP',
      sigla: 'XRP',
      preco: 3.34,
      timestamp: DateTime.now(),
      mudancaHora: 12,
      mudancaDia: 12,
      mudancaSemana: 12,
      mudancaMes: 12,
      mudancaAno: 12,
      mudancaPeriodoTotal: 12,
      baseId: '',
    ),
    Moeda(
      icone: 'assets/cardano.png',
      nome: 'Cardano',
      sigla: 'ADA',
      preco: 6.32,
      timestamp: DateTime.now(),
      mudancaHora: 12,
      mudancaDia: 12,
      mudancaSemana: 12,
      mudancaMes: 12,
      mudancaAno: 12,
      mudancaPeriodoTotal: 12,
      baseId: '',
    ),
    Moeda(
      icone: 'assets/usdcoin.png',
      nome: 'USD Coin',
      sigla: 'USDC',
      preco: 5.02,
      timestamp: DateTime.now(),
      mudancaHora: 12,
      mudancaDia: 12,
      mudancaSemana: 12,
      mudancaMes: 12,
      mudancaAno: 12,
      mudancaPeriodoTotal: 12,
      baseId: '',
    ),
    Moeda(
      icone: 'assets/litecoin.png',
      nome: 'Litecoin',
      sigla: 'LTC',
      preco: 669.93,
      timestamp: DateTime.now(),
      mudancaHora: 12,
      mudancaDia: 12,
      mudancaSemana: 12,
      mudancaMes: 12,
      mudancaAno: 12,
      mudancaPeriodoTotal: 12,
      baseId: '',
    ),
  ];

  List<Moeda> get tabela => _tabela;

  //  MoedaRepository() {
  //    _setupMoedasTabela() async {}
  //    ;
  //  }
}
