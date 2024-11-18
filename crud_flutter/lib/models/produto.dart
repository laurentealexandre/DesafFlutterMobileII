class Produto {
  final int? id;
  final String nome;
  final String descricao;
  final double preco;
  final String dataAtualizado; 

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
      preco: double.parse(map['preco'].toString()),
      dataAtualizado: map['data_atualizado'], 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'data_atualizado': dataAtualizado,
    };
  }
}