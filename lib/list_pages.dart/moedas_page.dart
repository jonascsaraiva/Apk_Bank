import 'package:flutter/material.dart';
import 'package:teste_1/list_pages.dart/moedasDetalhes_page.dart';
import 'package:teste_1/models/moeda.dart';
import 'package:teste_1/repositories/favoritas_repository.dart';
import 'package:teste_1/repositories/moeda_repository.dart';
import 'package:provider/provider.dart';
import 'package:teste_1/configs/app_settings.dart';
import 'package:intl/intl.dart';

class MoedasPage extends StatefulWidget {
  MoedasPage({Key? key}) : super(key: key);

  @override
  _MoedasPageState createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  late List<Moeda> tabela;
  late NumberFormat real;
  late Map<String, String> loc;
  List<Moeda> selecionadas = [];
  late FavoritasRepository favoritas;
  late MoedaRepository moedas;
  late AppSettings settings;

  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  appBarDinamica() {
    if (selecionadas.isEmpty) {
      return const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: SizedBox.shrink(),
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selecionadas = [];
            });
          },
        ),
        title: Text('${selecionadas.length} selecionadas'),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  mostrarDetalhes(Moeda moeda) async {
    final atualizou = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MoedasDetalhesPage(moeda: moeda)),
    );

    if (atualizou == true) {
      setState(() {
        tabela = moedas.tabela; // força atualizar histórico e valores
      });
    }
  }

  limparSelecionadas() {
    setState(() {
      selecionadas = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    favoritas = context.watch<FavoritasRepository>();
    moedas = context.watch<MoedaRepository>();
    tabela = moedas.tabela;
    readNumberFormat();
    settings = context.watch<AppSettings>();

    return Scaffold(
      appBar: appBarDinamica(),
      body: RefreshIndicator(
        onRefresh: () => moedas.checkPrecos(),
        child: ListView.separated(
          itemBuilder: (BuildContext context, int moeda) {
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              leading: (selecionadas.contains(tabela[moeda]))
                  ? CircleAvatar(child: Icon(Icons.check))
                  : SizedBox(
                      child: Image.network(tabela[moeda].icone),
                      width: 40,
                    ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      tabela[moeda].nome,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (favoritas.lista.any(
                    (fav) => fav.sigla == tabela[moeda].sigla,
                  ))
                    Icon(
                      Icons.circle,
                      color: const Color.fromARGB(255, 28, 255, 7),
                      size: 7,
                    ),
                ],
              ),
              trailing: Text(
                real.format(tabela[moeda].preco),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              selected: selecionadas.contains(tabela[moeda]),
              selectedTileColor: const Color.fromARGB(127, 102, 102, 102),
              onLongPress: () {
                setState(() {
                  (selecionadas.contains(tabela[moeda]))
                      ? selecionadas.remove(tabela[moeda])
                      : selecionadas.add(tabela[moeda]);
                });
              },
              onTap: () => mostrarDetalhes(tabela[moeda]),
            );
          },
          padding: EdgeInsets.all(16),
          separatorBuilder: (_, ___) => Divider(),
          itemCount: tabela.length,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selecionadas.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                favoritas.saveAll(selecionadas);
                limparSelecionadas();
              },
              icon: Icon(Icons.star),
              label: Text(
                'Favoritar',
                style: TextStyle(letterSpacing: 0, fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
}
