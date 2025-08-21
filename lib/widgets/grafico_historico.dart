import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teste_1/configs/app_settings.dart';
import 'package:teste_1/models/moeda.dart';
import 'package:teste_1/repositories/moeda_repository.dart';

class GraficoHistorico extends StatefulWidget {
  final Moeda moeda;
  GraficoHistorico({Key? key, required this.moeda}) : super(key: key);

  @override
  _GraficoHistoricoState createState() => _GraficoHistoricoState();
}

enum Periodo { hora, dia, semana, mes, ano, total }

class _GraficoHistoricoState extends State<GraficoHistorico> {
  late List<Color> cores;

  Periodo periodo = Periodo.hora;
  List<Map<String, dynamic>> historico = [];
  List dadosCompletos = [];
  List<FlSpot> dadosGrafico = [];
  double maxX = 0;
  double maxY = 0;
  double minY = 0;
  ValueNotifier<bool> loaded = ValueNotifier(false);
  late MoedaRepository repositorio;
  late Map<String, String> loc;
  late NumberFormat real;

  @override
  void initState() {
    super.initState();
    cores = [Color(int.parse(widget.moeda.corHex.replaceFirst('#', '0xFF')))];
    setDados();
  }

  setDados() async {
    loaded.value = false;
    dadosGrafico = [];

    if (historico.isEmpty)
      historico = await repositorio.getHistoricoMoeda(widget.moeda);

    dadosCompletos = historico[periodo.index]['prices'];
    dadosCompletos = dadosCompletos.reversed.map((item) {
      double preco = double.parse(item[0]);
      int time = int.parse(item[1].toString() + '000');
      return [preco, DateTime.fromMillisecondsSinceEpoch(time)];
    }).toList();

    maxX = dadosCompletos.length.toDouble();
    maxY = 0;
    minY = double.infinity;

    for (var item in dadosCompletos) {
      maxY = item[0] > maxY ? item[0] : maxY;
      minY = item[0] < minY ? item[0] : minY;
    }

    for (int i = 0; i < dadosCompletos.length; i++) {
      dadosGrafico.add(FlSpot(i.toDouble(), dadosCompletos[i][0]));
    }
    loaded.value = true;
  }

  LineChartData getChartData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        //Aqui mexe no grafico
        LineChartBarData(
          spots: dadosGrafico,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              cores[0],
              // ignore: deprecated_member_use
              cores[0].withOpacity(0.7),
            ],
          ),
          barWidth: 3,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              // ignore: deprecated_member_use
              colors: [cores[0].withOpacity(0.15), cores[0].withOpacity(0.05)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (data) {
            return data.map((item) {
              final date = getDate(item.spotIndex);
              return LineTooltipItem(
                real.format(item.y),
                const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '\n $date',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(
                        0xFFFFFFFF,
                      ).withAlpha(128), // substitui withOpacity(.5)
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  getDate(int index) {
    DateTime date = dadosCompletos[index][1];
    if (periodo != Periodo.ano && periodo != Periodo.total)
      return DateFormat('dd/MM - hh:mm').format(date);
    else
      return DateFormat('dd/MM/y').format(date);
  }

  chartButton(Periodo p, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: OutlinedButton(
        onPressed: () => setState(() => periodo = p),
        child: Text(label),
        style: (periodo != p)
            ? TextButton.styleFrom(
                backgroundColor: Color.fromARGB(0, 0, 0, 0),
                foregroundColor: const Color.fromARGB(255, 139, 139, 139),
                textStyle: TextStyle(fontSize: 15),
              )
            : TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 15, 68, 124),
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 16),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    repositorio = context.read<MoedaRepository>();
    loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
    setDados();

    return Container(
      child: AspectRatio(
        aspectRatio: 2,
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  chartButton(Periodo.hora, '1H'),
                  chartButton(Periodo.dia, '24H'),
                  chartButton(Periodo.semana, '7D'),
                  chartButton(Periodo.mes, 'Mês'),
                  chartButton(Periodo.ano, 'Ano'),
                  chartButton(Periodo.total, 'Tudo'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: ValueListenableBuilder(
                valueListenable: loaded,
                builder: (context, bool isLoaded, _) {
                  return (isLoaded)
                      ? LineChart(getChartData())
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
