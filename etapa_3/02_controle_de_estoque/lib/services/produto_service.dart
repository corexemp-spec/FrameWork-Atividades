import '../models/produto.dart';
import 'banco.dart';

class ProdutoService {
  Future<void> inserir({
    required String nome,
    required String categoria,
    required int quantidade,
    required double preco,
  }) async {
    final db = await BancoEstoque.abrir();
    await db.rawInsert(
      'INSERT INTO produtos (nome, categoria, quantidade, preco) VALUES (?, ?, ?, ?)',
      [nome, categoria, quantidade, preco],
    );
    print('INSERT → Produto cadastrado: $nome');
  }

  Future<List<Produto>> listar() async {
    final db = await BancoEstoque.abrir();
    final linhas = await db.query('produtos', orderBy: 'id ASC');

    print('SELECT → Produtos encontrados:');
    for (final linha in linhas) {
      print(
        '{id: ${linha['id']}, nome: ${linha['nome']}, quantidade: ${linha['quantidade']}}',
      );
    }

    await mostrarProdutosNoTerminal();
    return linhas.map(Produto.fromMap).toList();
  }

  Future<void> atualizarQuantidade({
    required int id,
    required String nome,
    required int quantidadeAnterior,
    required int novaQuantidade,
  }) async {
    final db = await BancoEstoque.abrir();
    await db.rawUpdate(
      'UPDATE produtos SET quantidade = ? WHERE id = ?',
      [novaQuantidade, id],
    );
    print('UPDATE → $nome');
    print('Quantidade anterior: $quantidadeAnterior');
    print('Nova quantidade: $novaQuantidade');
  }

  Future<void> excluir(int id, String nome) async {
    final db = await BancoEstoque.abrir();
    await db.rawDelete(
      'DELETE FROM produtos WHERE id = ?',
      [id],
    );
    print('DELETE → Produto excluído: $nome');
  }

  Future<void> mostrarProdutosNoTerminal() async {
    final db = await BancoEstoque.abrir();
    final produtos = await db.query('produtos');

    print('===== PRODUTOS NO BANCO =====');
    for (final produto in produtos) {
      print(produto);
    }
  }
}
