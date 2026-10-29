import 'package:central_de_missoes/models/missao.dart';
import 'package:central_de_missoes/providers/missao_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pontos e conversão não dependem da tela', () {
    expect(Missao.pontosDa('Fácil'), 10);
    expect(Missao.pontosDa('Médio'), 20);
    expect(Missao.pontosDa('Difícil'), 30);

    final mapa = Missao(
      titulo: 'Estudar Firebase',
      dificuldade: 'Difícil',
      pontos: 30,
    ).toMap();
    expect(mapa['concluida'], isFalse);
    expect(mapa.containsKey('id'), isFalse);

    final lida = Missao.fromMap('abc', {
      'titulo': 'Caminhar',
      'dificuldade': 'Fácil',
      'pontos': 10,
      'concluida': true,
    });
    expect(lida.id, 'abc');
    expect(lida.concluida, isTrue);

    final provider = MissaoProvider();
    provider.missoes = [
      Missao(
        titulo: 'Caminhar',
        dificuldade: 'Fácil',
        pontos: 10,
        concluida: true,
      ),
      Missao(
        titulo: 'Ler',
        dificuldade: 'Médio',
        pontos: 20,
        concluida: true,
      ),
      Missao(
        titulo: 'Estudar',
        dificuldade: 'Difícil',
        pontos: 30,
        concluida: false,
      ),
    ];
    expect(provider.pontosConquistados, 30);

    provider.missoes = [provider.missoes[1], provider.missoes[2]];
    expect(provider.pontosConquistados, 20);
  });
}
