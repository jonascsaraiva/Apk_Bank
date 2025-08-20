import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_1/list_pages.dart/account_page.dart';
import 'package:teste_1/list_pages.dart/carteira_page.dart';
import 'package:teste_1/list_pages.dart/conversor_page.dart';
import 'package:teste_1/list_pages.dart/counter_page.dart';
import 'package:teste_1/list_pages.dart/documentos_page.dart';
import 'package:teste_1/list_pages.dart/favoritas_page.dart';
import 'package:teste_1/list_pages.dart/moedas_page.dart';
import 'package:teste_1/configs/configuracoa_page.dart';
import 'package:intl/intl.dart';
import 'package:teste_1/configs/app_settings.dart';
import 'package:teste_1/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late NumberFormat real;
  late Map<String, String> loc;

  // Telas que serão exibidas
  final List<Widget> _pages = [
    accountPage(),
    MoedasPage(),
    carteiraPage(),
    FavoritasPage(),
  ];

  // Títulos correspondentes
  final List<String> _titles = ['Conta', 'Moedas', 'Carteira', 'Favoritos'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  changeLanguageButton() {
    final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc['locale'] == 'pt_BR' ? '\$' : 'R\$';

    return PopupMenuButton(
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.swap_vert),
            title: Text(
              'Usar $locale',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            onTap: () {
              context.read<AppSettings>().setLocale(locale, name);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    readNumberFormat();

    return Scaffold(
      //Header do app,nome dinanmico
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
        ),
        actions: [changeLanguageButton()],

        backgroundColor: const Color.fromARGB(255, 1, 46, 95),
      ),
      // Menu a parte do app
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 1, 46, 95)),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.plus_one_rounded, size: 24),
              title: const Text(
                'Contador',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContadorPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.monetization_on_sharp, size: 24),
              title: const Text(
                'Conversor',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConversorPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, size: 24),
              title: const Text(
                'Escaner',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocumentosPage(),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, size: 24),
              title: const Text(
                'Configurações',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),

            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () => context.read<AuthService>().logout(),
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text(
                  "Sair do app",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 1, 46, 95),
                  minimumSize: Size(double.infinity, 50), // largura total
                ),
              ),
            ),
          ],
        ),
      ),
      // IndexedStack mantém todas as páginas montadas(Evitar microtravamentos)Faz a chama na função de cima.
      body: IndexedStack(index: _selectedIndex, children: _pages),
      // Barra de navegação do rodapé do app
      bottomNavigationBar: Container(
        height: 60,
        color: const Color.fromARGB(255, 1, 46, 95),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_pages.length, (i) {
            final icons = [
              Icons.account_circle_outlined,
              Icons.attach_money_outlined,
              Icons.account_balance_wallet,
              Icons.favorite_border,
            ];
            final labels = ['Conta', 'Moedas', 'Carteira', 'Favoritos'];
            final selected = _selectedIndex == i;

            return GestureDetector(
              onTap: () => _onItemTapped(i),
              child: SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      bottom: 11,
                      child: Text(
                        labels[i],
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : const Color.fromARGB(255, 189, 189, 189),
                          fontSize: selected ? 17 : 14,
                          fontWeight: selected
                              ? FontWeight.w900
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 1, end: selected ? 1.4 : 1),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, scale, child) {
                        return Transform.translate(
                          offset: Offset(0, selected ? -20 : 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: selected
                                  ? Colors.white
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              boxShadow: selected
                                  ? [
                                      const BoxShadow(
                                        color: Colors.white,
                                        spreadRadius: 6,
                                        blurRadius: 2,
                                        offset: Offset(0, 0),
                                      ),
                                    ]
                                  : null,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Transform.scale(
                              scale: scale,
                              child: Icon(
                                icons[i],
                                color: selected
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : Colors.white,
                                size: 27,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
