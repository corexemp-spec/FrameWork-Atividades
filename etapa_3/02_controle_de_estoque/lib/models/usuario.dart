class Usuario {
  final int? id;
  final String nome;
  final String email;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
  });

  factory Usuario.fromMap(Map<String, dynamic> dados) {
    return Usuario(
      id: dados['id'] as int?,
      nome: dados['nome'] as String? ?? '',
      email: dados['email'] as String? ?? '',
    );
  }
}
