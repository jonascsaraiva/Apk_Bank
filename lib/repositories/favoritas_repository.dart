import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teste_1/database/db_firestore.dart';
import 'package:teste_1/models/moeda.dart';
import 'package:teste_1/repositories/moeda_repository.dart';
import 'package:teste_1/services/auth_service.dart';

class FavoritasRepository extends ChangeNotifier {
  List<Moeda> _lista = [];
  late FirebaseFirestore db;
  late AuthService auth;

  FavoritasRepository({required this.auth, required MoedaRepository moedas}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await _readFavoritas();
  }

  _startFirestore() {
    db = DbFirestore.get();
  }

  _readFavoritas() async {
    if (auth.usuario != null && _lista.isEmpty) {
      final snapshot = await db
          .collection('usuarios/${auth.usuario!.uid}/favoritas')
          .get();

      snapshot.docs.forEach((doc) {
        var moedasRepo = MoedaRepository();
        Moeda moeda = moedasRepo.tabela.firstWhere(
          (moeda) => moeda.sigla == doc.get('sigla'),
        );
        _lista.add(moeda);
        notifyListeners();
      });
    }
  }

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista);

  saveAll(List<Moeda> moedas) {
    moedas.forEach((moeda) async {
      if (!_lista.any((atual) => atual.sigla == moeda.sigla)) {
        _lista.add(moeda);
        await db
            .collection('usuarios/${auth.usuario!.uid}/favoritas')
            .doc(moeda.sigla)
            .set({
              'moeda': moeda.nome,
              'sigla': moeda.sigla,
              'preco': moeda.preco,
            });
      }
    });
    notifyListeners();
  }

  remove(Moeda moeda) async {
    await db
        .collection('usuarios/${auth.usuario!.uid}/favoritas')
        .doc(moeda.sigla)
        .delete();
    _lista.remove(moeda);
    notifyListeners();
  }
}
