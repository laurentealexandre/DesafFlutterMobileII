import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/clientes_screen.dart';
import 'screens/cliente_form_screen.dart';
import 'screens/produtos_screen.dart';
import 'screens/produto_form_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const HomeScreen(),
        '/clientes': (context) => const ClientesScreen(),
        '/cliente-form': (context) => const ClienteFormScreen(),
        '/produtos': (context) => const ProdutosScreen(),
        '/produto-form': (context) => const ProdutoFormScreen(),
      },
    );
  }
}