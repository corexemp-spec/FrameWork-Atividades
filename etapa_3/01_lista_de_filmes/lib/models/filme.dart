class Filme {
  final int? id;
  final String titulo;
  final bool assistido;

  Filme({
    this.id,
    required this.titulo,
    this.assistido = false,
  });

  // O SQLite guarda assistido como 0 ou 1.
  factory Filme.fromMap(Map<String, dynamic> dados) {
    return Filme(
      id: dados['id'] as int,
      titulo: dados['titulo'] as String,
      assistido: (dados['assistido'] as int) == 1,
    );
  }
}
