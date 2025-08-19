import 'package:teste_1/configs/app_settings.dart';
import 'package:teste_1/models/posicao.dart';
import 'package:teste_1/repositories/conta_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class carteiraPage extends StatefulWidget {
  const carteiraPage({super.key});

  @override
  State<carteiraPage> createState() => _carteiraPageState();
}

class _carteiraPageState extends State<carteiraPage> {
  //Controle de cada seção do grafico em pizza
  int index = 0;
  double totalCarteira = 0;
  late double saldo;
  late NumberFormat real;
  late ContaRepository conta;

  double graficoValor = 0;
  String graficoLabel = '';
  List<Posicao> carteira = [];

  @override
  Widget build(BuildContext context) {
    conta = context.watch<ContaRepository>();
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
    saldo = conta.saldo;
    carteira = conta.carteira;

    setTotalCarteira();

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 8),
              child: Text(
                'Valor da carteira',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
              ),
            ),
            Text(
              real.format(totalCarteira),
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w100,
                letterSpacing: -1.5,
              ),
            ),
            loadGrafico(),
            LoadHistorico(),
          ],
        ),
      ),
    );
  }

  setTotalCarteira() {
    final carteiraList = conta.carteira;
    setState(() {
      totalCarteira = conta.saldo;
      for (var posicao in carteiraList) {
        totalCarteira += posicao.moeda.preco * posicao.quantidade;
      }
    });
  }

  setGraficoDados(int index) {
    if (index < 0) return;

    if (index == carteira.length) {
      graficoLabel = 'Saldo';
      graficoValor = conta.saldo;
    } else {
      graficoLabel = carteira[index].moeda.nome;
      graficoValor = carteira[index].moeda.preco * carteira[index].quantidade;
    }
    ;
  }

  loadCarteira() {
    setGraficoDados(index);

    final tamanhoLista = carteira.length + 1;

    return List.generate(tamanhoLista, (i) {
      final isTouched = i == index;
      final isSaldo = i == tamanhoLista - 1;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = (!isSaldo) ? carteira[i].moeda.cor : Colors.grey[300];

      double porcentagem = 0;
      if (!isSaldo) {
        porcentagem =
            carteira[i].moeda.preco * carteira[i].quantidade / totalCarteira;
      } else {
        porcentagem = (conta.saldo > 0) ? conta.saldo / totalCarteira : 0;
      }
      porcentagem *= 100;

      return PieChartSectionData(
        color: color,
        value: porcentagem,
        title: '${porcentagem.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
      );
    });
  }

  loadGrafico() {
    return (conta.saldo < 0)
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 110,
                    sections: loadCarteira(),
                    pieTouchData: PieTouchData(
                      touchCallback: (event, touch) => setState(() {
                        index =
                            touch?.touchedSection?.touchedSectionIndex ?? -1;
                        setGraficoDados(index);
                      }),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  FittedBox(
                    child: Text(graficoLabel, style: TextStyle(fontSize: 25)),
                  ),
                  FittedBox(
                    child: Text(
                      real.format(graficoValor),
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  LoadHistorico() {
    final historico = conta.historico.reversed.toList();
    ;
    final date = DateFormat('dd/MM/yyyy - hh:mm');
    List<Widget> widgets = [];

    for (var operacao in historico) {
      widgets.add(
        ListTile(
          title: Text(
            operacao.moeda.nome,
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
          ),
          subtitle: Text(
            date.format(operacao.dataOperacao),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          trailing: Text(
            real.format(operacao.moeda.preco * operacao.quantidade),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
      );
      widgets.add(Divider());
    }
    print('Historico length: ${conta.historico.length}');
    return Column(children: widgets);
  }
}
