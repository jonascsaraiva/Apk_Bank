import 'package:flutter/material.dart';
import 'package:teste_1/repositories/favoritas_repository.dart';
import 'package:provider/provider.dart';
import 'package:teste_1/widgets/moeda_card.dart';

class FavoritasPage extends StatefulWidget {
  FavoritasPage({Key? key}) : super(key: key);
  @override
  _FavoritasPageState createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FavoritasRepository>(
        builder: (context, favoritas, child) {
          return RefreshIndicator(
            onRefresh: () => favoritas.refresh(),
            child: favoritas.lista.isEmpty
                ? ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Ainda não há moedas favoritas'),
                  )
                : ListView.builder(
                    itemCount: favoritas.lista.length,
                    itemBuilder: (_, index) {
                      return MoedaCard(moeda: favoritas.lista[index]);
                    },
                  ),
          );
        },
      ),
    );
  }
}
