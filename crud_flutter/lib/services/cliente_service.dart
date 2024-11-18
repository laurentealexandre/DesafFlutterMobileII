import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cliente.dart';

class ClienteService {
  static const baseUrl = 'http://localhost:3000/api';

  Future<List<Cliente>> getClientes() async {
    final response = await http.get(Uri.parse('$baseUrl/clientes'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cliente.fromMap(json)).toList();
    }
    throw Exception('Erro ao carregar clientes');
  }

  Future<void> addCliente(Cliente cliente) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clientes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cliente.toMap()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao adicionar cliente');
    }
  }

  Future<void> updateCliente(Cliente cliente) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clientes/${cliente.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cliente.toMap()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar cliente');
    }
  }

  Future<void> deleteCliente(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/clientes/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar cliente');
    }
  }
}