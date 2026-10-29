import 'package:flutter/material.dart';

import '../models/missao.dart';
import '../services/missao_service.dart';

class MissaoProvider extends ChangeNotifier {
  final MissaoService _service = MissaoService();

  List<Missao> missoes = [];
  bool carregando = false;
  String? erro;

  int get pontosConquistados {
    var total = 0;
    for (final missao in missoes) {
      if (missao.concluida) {
        total += missao.pontos;
      }
    }
    return total;
  }

  Future<void> carregar() async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      missoes = await _service.buscarTodas();
    } catch (e) {
      erro = 'Não foi possível carregar as missões.';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<String?> adicionar(String titulo, String dificuldade) async {
    final nome = titulo.trim();
    if (nome.isEmpty) {
      return 'Informe o título da missão.';
    }

    final missao = Missao(
      titulo: nome,
      dificuldade: dificuldade,
      pontos: Missao.pontosDa(dificuldade),
    );

    await _service.adicionar(missao);
    await carregar();
    return null;
  }

  /// Devolve os pontos só na primeira conclusão.
  Future<int?> concluir(Missao missao) async {
    if (missao.concluida || missao.id == null) {
      return null;
    }

    await _service.atualizar(missao.id!);
    await carregar();
    return missao.pontos;
  }

  Future<void> excluir(Missao missao) async {
    if (missao.id == null) {
      return;
    }

    await _service.excluir(missao.id!);
    await carregar();
  }
}
