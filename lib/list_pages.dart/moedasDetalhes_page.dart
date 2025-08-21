import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teste_1/configs/app_settings.dart';
import 'package:teste_1/models/moeda.dart';
import 'package:teste_1/repositories/conta_repository.dart';
import 'package:teste_1/widgets/grafico_historico.dart';
import 'package:share_plus/share_plus.dart';

class MoedasDetalhesPage extends StatefulWidget {
  final Moeda moeda;

  MoedasDetalhesPage({Key? key, required this.moeda}) : super(key: key);

  @override
  _MoedasDetalhesPageState createState() => _MoedasDetalhesPageState();
}

class _MoedasDetalhesPageState extends State<MoedasDetalhesPage> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final _form = GlobalKey<FormState>();
  final _valor = TextEditingController();
  double quantidade = 0;
  late ContaRepository conta;
  Widget grafico = Container();
  bool graficoLoaded = false;

  getGrafico() {
    if (!graficoLoaded) {
      grafico = GraficoHistorico(moeda: widget.moeda);
      graficoLoaded = true;
    }
    return grafico;
  }

  comprar() async {
    if (_form.currentState!.validate()) {
      // Salvar a compra
      await conta.Comprar(widget.moeda, double.parse(_valor.text));

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Compra realizada com sucesso!')));
    }
  }

  void compartilharPreco() {
    final moeda = widget.moeda;

    SharePlus.instance.share(
      ShareParams(
        text:
            'Confira o Preço do ${moeda.nome} agora: ${real.format(moeda.preco)}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    readNumberFormat();
    conta = Provider.of<ContaRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moeda.nome),
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: compartilharPreco),
        ],
        titleTextStyle: TextStyle(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 15, 68, 124),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(widget.moeda.icone, scale: 2.5),
                  Container(width: 10),
                  Text(
                    real.format(widget.moeda.preco),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),
            getGrafico(),
            (quantidade > 0)
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      child: Text(
                        '$quantidade ${widget.moeda.sigla}',
                        style: TextStyle(fontSize: 20),
                      ),
                      margin: EdgeInsets.only(bottom: 24),
                      alignment: Alignment.center,
                    ),
                  )
                : Container(margin: EdgeInsets.only(bottom: 24)),
            Form(
              key: _form,
              child: TextFormField(
                controller: _valor,
                style: TextStyle(fontSize: 22),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Valor',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  suffix: Text('reais', style: TextStyle(fontSize: 14)),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o valor da compra';
                  } else if (double.parse(value) < 10) {
                    return 'Compra mínima é R\$ 10,00';
                  } else if (double.parse(value) > conta.saldo) {
                    return 'Você não tem saldo suficiente';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    quantidade = (value.isEmpty)
                        ? 0
                        : double.parse(value) / widget.moeda.preco;
                  });
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(top: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 15, 68, 124),
                ),
                onPressed: comprar,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Comprar',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  readNumberFormat() {
    final loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }
}
