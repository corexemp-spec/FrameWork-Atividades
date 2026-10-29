import 'package:flutter/material.dart';

import '../models/produto.dart';
import '../services/produto_service.dart';

class ProdutoProvider extends ChangeNotifier {
  final ProdutoService _service = ProdutoService();

  List<Produto> produtos = [];
  bool carregando = false;
  String? erro;

  Future<void> carregar() async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      produtos = await _service.listar();
    } catch (e) {
      erro = 'Não foi possível carregar o estoque.';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<String?> cadastrar({
    required String nome,
    required String categoria,
    required String quantidadeTexto,
    required String precoTexto,
  }) async {
    final nomeLimpo = nome.trim();
    final categoriaLimpa = categoria.trim();
    final quantidade = int.tryParse(quantidadeTexto.trim());
    // Aceita 250.00 e também 250,00.
    final preco = double.tryParse(precoTexto.trim().replaceAll(',', '.'));

    if (nomeLimpo.isEmpty || categoriaLimpa.isEmpty) {
      return 'Preencha nome e categoria.';
    }
    if (quantidade == null || quantidade < 0) {
      return 'Informe uma quantidade válida, zero ou maior.';
    }
    if (preco == null || preco < 0) {
      return 'Informe um preço válido.';
    }

    await _service.inserir(
      nome: nomeLimpo,
      categoria: categoriaLimpa,
      quantidade: quantidade,
      preco: preco,
    );
    return null;
  }

  Future<String?> alterarQuantidade(Produto produto, int delta) async {
    final id = produto.id;
    if (id == null) {
      return 'Produto sem identificador.';
    }

    final nova = produto.quantidade + delta;
    if (nova < 0) {
      return 'A quantidade não pode ser negativa.';
    }

    await _service.atualizarQuantidade(
      id: id,
      nome: produto.nome,
      quantidadeAnterior: produto.quantidade,
      novaQuantidade: nova,
    );
    await carregar();
    return null;
  }

  Future<void> excluir(Produto produto) async {
    final id = produto.id;
    if (id == null) {
      return;
    }

    await _service.excluir(id, produto.nome);
    await carregar();
  }
}
