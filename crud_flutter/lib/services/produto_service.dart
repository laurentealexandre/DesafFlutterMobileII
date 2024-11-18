import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/produto.dart';

class ProdutoService {
  static const baseUrl = 'http://localhost:3000/api';

  Future<List<Produto>> getProdutos() async {
    final response = await http.get(Uri.parse('$baseUrl/produtos'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Produto.fromMap(json)).toList();
    }
    throw Exception('Erro ao carregar produtos');
  }

  Future<void> addProduto(Produto produto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/produtos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(produto.toMap()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao adicionar produto');
    }
  }

  Future<void> updateProduto(Produto produto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/produtos/${produto.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(produto.toMap()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar produto');
    }
  }

  Future<void> deleteProduto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/produtos/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar produto');
    }
  }
}