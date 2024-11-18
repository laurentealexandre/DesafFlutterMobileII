class Produto {
  final int? id;
  final String nome;
  final String descricao;
  final double preco;
  final DateTime dataAtualizado;

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.dataAtualizado,
  });

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      preco: map['preco'],
      dataAtualizado: map['data_atualizado'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'data_atualizado': dataAtualizado.toIso8601String(),
    };
  }
}