class Produto {
  final int? id;
  final String nome;
  final String categoria;
  final int quantidade;
  final double preco;

  Produto({
    this.id,
    required this.nome,
    required this.categoria,
    required this.quantidade,
    required this.preco,
  });

  bool get estoqueBaixo => quantidade <= 3;

  factory Produto.fromMap(Map<String, dynamic> dados) {
    return Produto(
      id: (dados['id'] as num?)?.toInt(),
      nome: dados['nome'] as String? ?? '',
      categoria: dados['categoria'] as String? ?? '',
      quantidade: (dados['quantidade'] as num?)?.toInt() ?? 0,
      preco: (dados['preco'] as num?)?.toDouble() ?? 0,
    );
  }
}
