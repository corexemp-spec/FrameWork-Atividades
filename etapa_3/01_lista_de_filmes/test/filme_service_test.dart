import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lista_de_filmes/services/filme_service.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('cadastra, marca, desmarca e recupera depois de reabrir o banco', () async {
    final pasta = await Directory.systemTemp.createTemp('filmes_teste');
    final caminho = join(pasta.path, 'filmes.db');

    final primeiro = FilmeService(caminhoArquivo: caminho);
    await primeiro.inserir('Interestelar');
    await primeiro.inserir('Homem-Aranha');
    await primeiro.inserir('Shrek');

    final cadastrados = await primeiro.listar();
    expect(cadastrados, hasLength(3));
    await primeiro.atualizarAssistido(cadastrados[0].id!, true);
    await primeiro.fechar();

    final segundo = FilmeService(caminhoArquivo: caminho);
    final recuperados = await segundo.listar();
    expect(recuperados.map((filme) => filme.titulo).toList(), [
      'Interestelar',
      'Homem-Aranha',
      'Shrek',
    ]);
    expect(recuperados[0].assistido, isTrue);
    expect(recuperados[1].assistido, isFalse);
    expect(recuperados[2].assistido, isFalse);

    await segundo.atualizarAssistido(recuperados[0].id!, false);
    await segundo.fechar();

    final terceiro = FilmeService(caminhoArquivo: caminho);
    final depois = await terceiro.listar();
    expect(depois[0].assistido, isFalse);
    await terceiro.fechar();

    await pasta.delete(recursive: true);
  });
}
