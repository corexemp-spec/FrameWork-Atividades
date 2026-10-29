class Missao {
  final String? id;
  final String titulo;
  final String grau;
  final bool concluida;
  final String usuarioId;

  Missao({
    this.id,
    required this.titulo,
    required this.grau,
    required this.usuarioId,
    this.concluida = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'grau': grau,
      'concluida': concluida,
      'usuarioId': usuarioId,
    };
  }

  factory Missao.fromMap(String id, Map<String, dynamic> dados) {
    return Missao(
      id: id,
      titulo: dados['titulo'] as String? ?? '',
      grau: dados['grau'] as String? ?? '',
      concluida: dados['concluida'] as bool? ?? false,
      usuarioId: dados['usuarioId'] as String? ?? '',
    );
  }
}
