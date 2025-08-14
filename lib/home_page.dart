import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_1/list_pages.dart/conversor_page.dart';
import 'package:teste_1/list_pages.dart/counter_page.dart';
import 'package:teste_1/list_pages.dart/favoritas_page.dart';
import 'package:teste_1/list_pages.dart/moedas_page.dart';
import 'package:teste_1/configs/settings.dart';
import 'package:intl/intl.dart';
import 'package:teste_1/configs/app_settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; //Indice onde é escolhida a pagina
  int counter = 0;
  late PageController _pageController;
  late NumberFormat real;
  late Map<String, String> loc;

  // Telas que serão exibidas pelo Navegador do fundo
  List<Widget> get _pages => [MoedasPage(), FavoritasPage()];

  // Títulos correspondentes que serão exibidas no titulo
  final List<String> _titles = ['Moedas', 'Favoritos'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 600),
      curve: Curves.linear, //Troca o tipo de slider
    );
  }

  void _onPageChanged(int index) {
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
      icon: Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.swap_vert),
            title: Text('Usar $locale'),
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
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [changeLanguageButton()],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 1, 46, 95),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 1, 46, 95),
              ),
              child: const Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.plus_one_rounded),
              title: const Text('Contador'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContadorPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.monetization_on_sharp),
              title: const Text('Contador'),
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
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
          ],
        ),
      ),
      // Pageview do body com paginas dinamicas
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: _onPageChanged,
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_outlined),
            label: 'Moedas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoritos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 1, 46, 95),
        unselectedItemColor: const Color.fromARGB(255, 126, 126, 126),

        onTap: _onItemTapped, // Onde faz a animação da pagina lá no controller
      ),
    );
  }
}
