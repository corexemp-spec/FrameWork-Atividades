import 'package:flutter/material.dart';

import '../models/filme.dart';
import '../services/filme_service.dart';

class FilmeViewModel extends ChangeNotifier {
  FilmeViewModel() {
    carregar();
  }

  final FilmeService _service = FilmeService();

  // Estado da tela. A persistência fica no FilmeService / SQLite.
  List<Filme> filmes = [];

  bool carregando = true;
  bool salvando = false;
  String? erro;

  Future<void> carregar() async {
    try {
      filmes = await _service.listar();
      erro = null;
    } catch (e) {
      erro = 'Não foi possível carregar os filmes.';
    }

    carregando = false;
    notifyListeners();
  }

  Future<String?> adicionar(String titulo) async {
    final nome = titulo.trim();
    if (nome.isEmpty) {
      return 'Informe o nome do filme.';
    }
    if (salvando) {
      return null;
    }

    salvando = true;
    notifyListeners();

    try {
      await _service.inserir(nome);
      await carregar();
      return null;
    } catch (e) {
      erro = 'Não foi possível cadastrar o filme.';
      notifyListeners();
      return erro;
    } finally {
      salvando = false;
      notifyListeners();
    }
  }

  Future<void> definirAssistido(Filme filme, bool assistido) async {
    final id = filme.id;
    if (id == null || salvando) {
      return;
    }

    salvando = true;
    notifyListeners();

    try {
      await _service.atualizarAssistido(id, assistido);
      await carregar();
    } catch (e) {
      erro = 'Não foi possível atualizar o filme.';
      notifyListeners();
    } finally {
      salvando = false;
      notifyListeners();
    }
  }
}
