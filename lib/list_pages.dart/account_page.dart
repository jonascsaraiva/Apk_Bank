import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
  XFile? comprovante;

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
                style: TextStyle(
                  fontSize: 25,
                  color: const Color.fromARGB(255, 10, 42, 221),
                ),
              ),
              trailing: IconButton(
                onPressed: updateSaldo,
                icon: Icon(Icons.edit),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.attach_file),
              title: Text('Enviar Comprovante de Depósito'),
              onTap: selecionarComprovante,
              trailing: comprovante != null
                  ? Image.file(File(comprovante!.path))
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  selecionarComprovante() async {
    final ImagePicker picker = ImagePicker();

    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) setState(() => comprovante = file);
    } catch (e) {
      print(e);
    }
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
