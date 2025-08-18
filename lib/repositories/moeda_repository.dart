import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:teste_1/database/db.dart';
import 'package:teste_1/models/moeda.dart';

class MoedaRepository extends ChangeNotifier {
  List<Moeda> _tabela = [];
  late Timer intervalo;

  List<Moeda> get tabela => _tabela;

  MoedaRepository() {
    _setupMoedasTable();
    _setupDadosTableMoedas();
    _readMoedasTable();
    _refreshPrecos();
  }

  _refreshPrecos() async {
    intervalo = Timer.periodic(Duration(minutes: 5), (_) => checkPrecos());
  }

  checkPrecos() async {
    String uri = 'https://api.coinbase.com/v2/assets/prices?base=BRL';
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> moedas = json['data'];
      Database db = await DB.instance.database;
      Batch batch = db.batch();

      _tabela.forEach((atual) {
        moedas.forEach((novo) {
          if (atual.baseId == novo['base_id']) {
            final moeda = novo['prices'];
            final preco = moeda['latest_price'];
            final timestamp = DateTime.parse(preco['timestamp']);

            batch.update(
              'moedas',
              {
                'preco': moeda['latest'],
                'timestamp': timestamp.millisecondsSinceEpoch,
                'mudancaHora': preco['percent_change']['hour'].toString(),
                'mudancaDia': preco['percent_change']['day'].toString(),
                'mudancaSemana': preco['percent_change']['week'].toString(),
                'mudancaMes': preco['percent_change']['month'].toString(),
                'mudancaAno': preco['percent_change']['year'].toString(),
                'mudancaPeriodoTotal': preco['percent_change']['all']
                    .toString(),
              },
              where: 'baseId = ?',
              whereArgs: [atual.baseId],
            );
          }
        });
      });
      await batch.commit(noResult: true);
      await _readMoedasTable();
    }
  }

  _readMoedasTable() async {
    Database db = await DB.instance.database;
    List resultados = await db.query('moedas');

    _tabela = resultados.map((row) {
      return Moeda(
        baseId: row['baseId']?.toString() ?? '',
        icone: row['icone']?.toString() ?? '',
        sigla: row['sigla']?.toString() ?? '',
        nome: row['nome']?.toString() ?? '',
        preco: double.tryParse(row['preco']?.toString() ?? '0') ?? 0,
        timestamp: row['timestamp'] != null
            ? DateTime.fromMillisecondsSinceEpoch(row['timestamp'])
            : DateTime.now(),
        mudancaHora:
            double.tryParse(row['mudancaHora']?.toString() ?? '0') ?? 0,
        mudancaDia: double.tryParse(row['mudancaDia']?.toString() ?? '0') ?? 0,
        mudancaSemana:
            double.tryParse(row['mudancaSemana']?.toString() ?? '0') ?? 0,
        mudancaMes: double.tryParse(row['mudancaMes']?.toString() ?? '0') ?? 0,
        mudancaAno: double.tryParse(row['mudancaAno']?.toString() ?? '0') ?? 0,
        mudancaPeriodoTotal:
            double.tryParse(row['mudancaPeriodoTotal']?.toString() ?? '0') ?? 0,
      );
    }).toList();

    notifyListeners();
  }

  _moedasTableIsEmpty() async {
    Database db = await DB.instance.database;
    List resultados = await db.query('moedas');
    return resultados.isEmpty;
  }

  _setupDadosTableMoedas() async {
    if (await _moedasTableIsEmpty()) {
      String uri = 'https://api.coinbase.com/v2/assets/search?base=BRL';

      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> moedas = json['data'];
        Database db = await DB.instance.database;
        Batch batch = db.batch();

        for (var moeda in moedas) {
          final precoData = moeda['latest_price'] ?? {};
          final amount = precoData['amount']?['amount']?.toString() ?? '0';
          final timestampStr = precoData['timestamp']?.toString();
          final timestamp = timestampStr != null
              ? DateTime.tryParse(timestampStr) ?? DateTime.now()
              : DateTime.now();

          final percentChange = precoData['percent_change'] ?? {};

          batch.insert('moedas', {
            'baseId': moeda['id']?.toString() ?? '',
            'sigla': moeda['symbol']?.toString() ?? '',
            'nome': moeda['name']?.toString() ?? '',
            'icone': moeda['image_url']?.toString() ?? '',
            'preco': amount,
            'timestamp': timestamp.millisecondsSinceEpoch,
            'mudancaHora': percentChange['hour']?.toString() ?? '0',
            'mudancaDia': percentChange['day']?.toString() ?? '0',
            'mudancaSemana': percentChange['week']?.toString() ?? '0',
            'mudancaMes': percentChange['month']?.toString() ?? '0',
            'mudancaAno': percentChange['year']?.toString() ?? '0',
            'mudancaPeriodoTotal': percentChange['all']?.toString() ?? '0',
          });
        }

        await batch.commit(noResult: true);
      }
    }
  }

  _setupMoedasTable() async {
    final String table = '''
      CREATE TABLE IF NOT EXISTS moedas (
        baseId TEXT PRIMARY KEY,
        sigla TEXT,
        nome TEXT,
        icone TEXT,
        preco TEXT,
        timestamp INTEGER,
        mudancaHora TEXT,
        mudancaDia TEXT,
        mudancaSemana TEXT,
        mudancaMes TEXT,
        mudancaAno TEXT,
        mudancaPeriodoTotal TEXT
      );
    ''';
    Database db = await DB.instance.database;
    await db.execute(table);
  }
}
