class Missao {
  static const dificuldades = ['Fácil', 'Médio', 'Difícil'];

  final String? id;
  final String titulo;
  final String dificuldade;
  final int pontos;
  final bool concluida;

  Missao({
    this.id,
    required this.titulo,
    required this.dificuldade,
    required this.pontos,
    this.concluida = false,
  });

  static int pontosDa(String dificuldade) {
    switch (dificuldade) {
      case 'Fácil':
        return 10;
      case 'Médio':
        return 20;
      case 'Difícil':
        return 30;
      default:
        throw ArgumentError('Dificuldade inválida: $dificuldade');
    }
  }

  static String estrelas(String dificuldade) {
    switch (dificuldade) {
      case 'Fácil':
        return '⭐';
      case 'Médio':
        return '⭐⭐';
      case 'Difícil':
        return '⭐⭐⭐';
      default:
        return '';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'dificuldade': dificuldade,
      'pontos': pontos,
      'concluida': concluida,
    };
  }

  factory Missao.fromMap(String id, Map<String, dynamic> dados) {
    return Missao(
      id: id,
      titulo: dados['titulo'] as String? ?? '',
      dificuldade: dados['dificuldade'] as String? ?? '',
      pontos: (dados['pontos'] as num?)?.toInt() ?? 0,
      concluida: dados['concluida'] as bool? ?? false,
    );
  }
}
