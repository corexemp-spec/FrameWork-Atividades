import 'dart:io';

import 'package:controle_de_estoque/services/banco.dart';
import 'package:controle_de_estoque/services/produto_service.dart';
import 'package:controle_de_estoque/services/usuario_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory pasta;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    pasta = await Directory.systemTemp.createTemp('estoque_teste');
    BancoEstoque.caminhoParaTeste = join(pasta.path, 'estoque.db');
  });

  tearDown(() async {
    await BancoEstoque.fechar();
    BancoEstoque.caminhoParaTeste = null;
    if (await pasta.exists()) {
      await pasta.delete(recursive: true);
    }
  });

  test('login, estoque, update, delete e reabertura do arquivo', () async {
    final usuarios = UsuarioService();
    final produtos = ProdutoService();

    expect(await usuarios.emailExiste('maria@email.com'), isFalse);
    await usuarios.inserir(
      nome: 'Maria',
      email: 'maria@email.com',
      senha: '1234',
    );
    expect(await usuarios.emailExiste('maria@email.com'), isTrue);

    final maria = await usuarios.buscarPorEmailESenha(
      'maria@email.com',
      '1234',
    );
    expect(maria?.nome, 'Maria');

    final senhaErrada = await usuarios.buscarPorEmailESenha(
      'maria@email.com',
      '9999',
    );
    expect(senhaErrada, isNull);

    await produtos.inserir(
      nome: 'Teclado',
      categoria: 'Informática',
      quantidade: 5,
      preco: 250,
    );
    await produtos.inserir(
      nome: 'Mouse',
      categoria: 'Informática',
      quantidade: 2,
      preco: 120,
    );
    await produtos.inserir(
      nome: 'Cabo',
      categoria: 'Informática',
      quantidade: 10,
      preco: 30,
    );

    final lista = await produtos.listar();
    expect(lista.map((produto) => produto.nome), ['Teclado', 'Mouse', 'Cabo']);
    expect(lista[1].estoqueBaixo, isTrue);
    expect(lista[0].estoqueBaixo, isFalse);

    await produtos.atualizarQuantidade(
      id: lista[0].id!,
      nome: lista[0].nome,
      quantidadeAnterior: lista[0].quantidade,
      novaQuantidade: lista[0].quantidade + 1,
    );
    await produtos.excluir(lista[2].id!, lista[2].nome);

    await BancoEstoque.fechar();

    final salvos = await produtos.listar();
    expect(salvos.map((produto) => produto.nome), ['Teclado', 'Mouse']);
    expect(salvos[0].quantidade, 6);

    final deNovo = await usuarios.buscarPorEmailESenha(
      'maria@email.com',
      '1234',
    );
    expect(deNovo?.nome, 'Maria');
  });
}
