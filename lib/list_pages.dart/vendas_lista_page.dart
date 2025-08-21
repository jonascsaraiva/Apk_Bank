import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teste_1/configs/app_settings.dart';
import 'package:teste_1/repositories/conta_repository.dart';
import 'package:teste_1/list_pages.dart/vendas_page.dart';

class VendasListaPage extends StatelessWidget {
  const VendasListaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final conta = context.watch<ContaRepository>();
    final loc = context.read<AppSettings>().locale;
    final real = NumberFormat.currency(
      locale: loc['locale'],
      name: loc['name'],
    );
    final carteira = conta.carteira; // já é única por moeda

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 46, 95),
        title: const Text(
          'Moedas disponiveis para venda',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      body: carteira.isEmpty
          ? const Center(child: Text('Você não possui moedas na carteira.'))
          : ListView.separated(
              itemCount: carteira.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (_, i) {
                final pos = carteira[i];
                final valorAtual = pos.moeda.preco * pos.quantidade;
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(pos.moeda.icone),
                  ),
                  title: Text(
                    pos.moeda.nome,
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    '${pos.quantidade.toStringAsFixed(6)} ${pos.moeda.sigla}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  trailing: Text(
                    real.format(valorAtual),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => VenderMoedaPage(
                          moeda: pos.moeda,
                          quantidadeDisponivel: pos.quantidade,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
