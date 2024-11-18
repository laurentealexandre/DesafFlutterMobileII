// lib/screens/home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Gerenciamento'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuButton(
              context,
              'Lista de Clientes',
              '/clientes',
              Icons.people,
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              context,
              'Cadastrar Cliente',
              '/cliente-form',
              Icons.person_add,
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              context,
              'Lista de Produtos',
              '/produtos',
              Icons.inventory,
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              context,
              'Cadastrar Produto',
              '/produto-form',
              Icons.add_shopping_cart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    String route,
    IconData icon,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}