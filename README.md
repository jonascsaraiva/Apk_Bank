💙 Apk_Bank

App em Flutter para monitoramento de criptomoedas: compra, venda, histórico e carteira com gráfico.

Funcionalidades principais

- Autenticação Firebase:
permite login e registro de usuários.
- Carteira de criptomoedas:
lista de posições atuais com saldo em tempo real e gráfico de composição.
- Compra de moedas:
registra transações, atualiza saldo e histórico.
- Venda de moedas:
interface para venda segundo o preço corrente da API e quantidade disponível.
- Histórico de transações:
detalha operações com etiquetas claras ("Compra:" ou "Venda:").
- Preferências do usuário:
modo escuro, configurações salvas via Hive.
- Sincronização contínua com API Coinbase:
para atualizar preços.

Tela de vendas

- Lista de moedas disponíveis para venda (da carteira).
- Ao tocar em uma moeda, abre uma tela com:
  - Preço atualizado da moeda (via API CoinBase).
  - Campo para informar valor em BRL a vender (com validação e limites).
  - Botões rápidos 25/50/75/100% para facilitar a escolha.
  - Botão de “Vender • R$ xxx” que executa a venda de forma dinâmica.

Como executar

1. Clone o repositório:
     git clone https://github.com/jonascsaraiva/Apk_Bank.git
     cd Apk_Bank
2. Instale as dependências:
		flutter pub outdated
		flutter pub upgrade
3. Inicie o app:
    flutter run


Arquitetura

State Management com Provider, usando ChangeNotifier.

Repositórios principais:

MoedaRepository: busca e atualiza os preços da API (Coinbase).

ContaRepository: gerencia saldo, carteira, histórico, compras e vendas.

UI dividida em páginas:

carteira_page.dart: exibe resumo, gráfico, botão "Vender", e histórico.

vendas_lista_page.dart: lista de moedas disponíveis.

vendas_page.dart: tela de venda com valor baseado no preço atual.

Customizações e melhorias possíveis

Melhor digitação do valor (ex.: máscaras regionais).

Animações para compra/venda.

Adicionar gráficos por moeda detalhada.

Cache offline do histórico.

Suporte a múltiplas exchanges.

Internacionalização (i18n).



Contribuições são bem-vindas!

Faça fork.

Crie uma branch específica para sua feature.

Realize commits claros e testáveis.

Abra o Pull Request para avaliação.

Licença: MIT






⚠️ Pontos sensíveis do projeto

Firebase

Cada pessoa precisa gerar o seu próprio projeto no Firebase.

É necessário baixar o google-services.json (Android) e/ou GoogleService-Info.plist (iOS).

Esse arquivo não deve ser commitado junto no repositório público (segurança).

Ajustes podem ser necessários em:

android/app/build.gradle

android/build.gradle

ios/Runner/Info.plist

API de preços (Coinbase ou outra)

Hoje o app consulta valores direto de um endpoint público.

Esse endpoint pode mudar, ficar fora do ar ou alterar formatação.


Dependências Flutter

O pubspec.yaml pode ter versões que mudam rápido (ex.: firebase_auth, provider).

Configurações locais

Banco local (Hive) pode ter conflitos se o usuário rodar em mais de um dispositivo com o mesmo login.


Ambiente

flutter --version
Tools • Dart 3.9.0 • DevTools 2.48.0
