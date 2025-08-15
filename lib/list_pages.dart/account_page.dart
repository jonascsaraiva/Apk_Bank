import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:teste_1/configs/app_settings.dart';
import 'package:teste_1/repositories/conta_repository.dart';
import 'package:intl/intl.dart';

class accountPage extends StatefulWidget {
  const accountPage({super.key});

  @override
  State<accountPage> createState() => _accountPageState();
}

class _accountPageState extends State<accountPage> {
  @override
  Widget build(BuildContext context) {
    final conta = context.watch<ContaRepository>();
    final loc = context.read<AppSettings>().locale;

    NumberFormat real = NumberFormat.currency(
      locale: loc['locale'],
      name: loc['name'],
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              title: Text('Saldo'),
              subtitle: Text(
                real.format(conta.saldo),
                style: TextStyle(fontSize: 25, color: Colors.indigo),
              ),
              trailing: IconButton(
                onPressed: updateSaldo,
                icon: Icon(Icons.edit),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  updateSaldo() async {
    final form = GlobalKey<FormState>();
    final valor = TextEditingController();
    final conta = context.read<ContaRepository>();

    valor.text = conta.saldo.toString();

    AlertDialog dialog = AlertDialog(
      title: Text('Atualizar Saldo'),
      content: Form(
        key: form,
        child: TextFormField(
          controller: valor,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          validator: (value) {
            if (value!.isEmpty) return 'informe o valor do saldo';
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (form.currentState!.validate()) {
              conta.setSaldo(double.parse(valor.text));
              Navigator.pop(context);
            }
          },
          child: Text('Salvar'),
        ),
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}
