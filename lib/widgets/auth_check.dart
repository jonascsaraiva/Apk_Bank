import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_1/home_page.dart';
import 'package:teste_1/list_pages.dart/login_page.dart';
import 'package:teste_1/services/auth_service.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheck();
}

class _AuthCheck extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading)
      return loading();
    else if (auth.usuario == null)
      return LoginPage();
    else
      return HomePage();
  }

  loading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Color.fromARGB(255, 255, 0, 0),
        ),
      ),
    );
  }
}
