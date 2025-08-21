import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teste_1/configs/app_settings.dart';
import 'package:teste_1/models/moeda.dart';
import 'package:teste_1/repositories/conta_repository.dart';
import 'package:teste_1/repositories/moeda_repository.dart';

class VenderMoedaPage extends StatefulWidget {
  final Moeda moeda;
  final double quantidadeDisponivel;

  const VenderMoedaPage({
    super.key,
    required this.moeda,
    required this.quantidadeDisponivel,
  });

  @override
  State<VenderMoedaPage> createState() => _VenderMoedaPageState();
}

class _VenderMoedaPageState extends State<VenderMoedaPage> {
  final _valorCtrl = TextEditingController();
  late NumberFormat real;
  double valor = 0; // em BRL
  Moeda? moedaAtualizada; // <- variável global para usar em toda a classe

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  @override
  void dispose() {
    _valorCtrl.dispose();
    super.dispose();
  }

  void _setValor(double v) {
    final preco = (moedaAtualizada?.preco ?? widget.moeda.preco);
    final valorMax = widget.quantidadeDisponivel * preco;
    valor = v.clamp(0, valorMax);
    _valorCtrl.text = valor.toStringAsFixed(2);
    setState(() {});
  }

  Future<void> _vender() async {
    final conta = context.read<ContaRepository>();
    if (valor <= 0) {
      _msg('Informe um valor maior que zero.');
      return;
    }

    try {
      await conta.Vender(moedaAtualizada ?? widget.moeda, valor);
      if (!mounted) return;
      _msg('Venda realizada!');
      Navigator.pop(context); // fecha a tela de venda
    } catch (e) {
      _msg('Falha ao vender: $e');
    }
  }

  void _msg(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }

  @override
  Widget build(BuildContext context) {
    // Atualiza a moeda com o preço mais recente da API
    final moedasRepo = context.watch<MoedaRepository>();
    moedaAtualizada = moedasRepo.tabela.firstWhere(
      (m) => m.sigla == widget.moeda.sigla,
      orElse: () => widget.moeda,
    );

    final qtd = widget.quantidadeDisponivel;
    final preco = moedaAtualizada!.preco > 0 ? moedaAtualizada!.preco : 1;
    final valorMax = qtd * preco;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 46, 95),
        title: Text(
          'Vender ${moedaAtualizada!.sigla}',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(moedaAtualizada!.icone),
              ),
              title: Text(
                moedaAtualizada!.nome,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              subtitle: Text(
                'Preço atual: ${real.format(preco)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              trailing: Text(
                'Disponível: ${qtd.toStringAsFixed(6)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 19),
            Text(
              'Valor a vender (BRL) — máx: ${real.format(valorMax)}',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _valorCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.sell),
              ),
              onChanged: (s) {
                final v = double.tryParse(s.replaceAll(',', '.')) ?? 0;
                final preco = moedaAtualizada!.preco > 0
                    ? moedaAtualizada!.preco
                    : 1;
                final valorMax = widget.quantidadeDisponivel * preco;
                setState(() {
                  valor = v.clamp(0, valorMax);
                });
              },
            ),
            const SizedBox(height: 12),
            Center(
              child: Wrap(
                spacing: 19,
                children: [
                  OutlinedButton(
                    onPressed: () => _setValor(valorMax * .25),
                    child: const Text(
                      '25%',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => _setValor(valorMax * .50),
                    child: const Text(
                      '50%',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => _setValor(valorMax * .75),
                    child: const Text(
                      '75%',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => _setValor(valorMax * 1.00),
                    child: const Text(
                      '100%',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                child: ElevatedButton.icon(
                  onPressed: valor > 0 ? _vender : null,
                  icon: const Icon(Icons.check),
                  label: Text(
                    'Vender • ${real.format(valor)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
