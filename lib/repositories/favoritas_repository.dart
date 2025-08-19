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
  late MoedaRepository moedasRepo;
  Stream<QuerySnapshot>? _favoritasStream;

  FavoritasRepository({required this.auth, required MoedaRepository moedas}) {
    moedasRepo = moedas;
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    _listenFavoritas();
  }

  _startFirestore() {
    db = DbFirestore.get();
  }

  /// 🔄 Escuta alterações em tempo real no Firebase
  _listenFavoritas() {
    if (auth.usuario == null) return;

    _favoritasStream = db
        .collection('usuarios/${auth.usuario!.uid}/favoritas')
        .snapshots();

    _favoritasStream!.listen((snapshot) {
      _lista.clear(); // limpa lista antes de atualizar
      for (var doc in snapshot.docs) {
        try {
          Moeda moeda = moedasRepo.tabela.firstWhere(
            (moeda) => moeda.sigla == doc.get('sigla'),
          );
          _lista.add(moeda);
        } catch (e) {
          debugPrint("Moeda não encontrada: ${doc.get('sigla')}");
        }
      }
      notifyListeners();
    });
  }

  /// 🔄 Atualização manual (usado pelo RefreshIndicator)
  Future<void> refresh() async {
    if (auth.usuario == null) return;

    final snapshot = await db
        .collection('usuarios/${auth.usuario!.uid}/favoritas')
        .get();

    _lista.clear();
    for (var doc in snapshot.docs) {
      try {
        Moeda moeda = moedasRepo.tabela.firstWhere(
          (moeda) => moeda.sigla == doc.get('sigla'),
        );
        _lista.add(moeda);
      } catch (e) {
        debugPrint("Moeda não encontrada: ${doc.get('sigla')}");
      }
    }
    notifyListeners();
  }

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista);

  saveAll(List<Moeda> moedas) {
    moedas.forEach((moeda) async {
      if (!_lista.any((atual) => atual.sigla == moeda.sigla)) {
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
  }

  remove(Moeda moeda) async {
    await db
        .collection('usuarios/${auth.usuario!.uid}/favoritas')
        .doc(moeda.sigla)
        .delete();
  }
}
