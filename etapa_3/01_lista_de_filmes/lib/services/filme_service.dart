import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/filme.dart';

class FilmeService {
  FilmeService({String? caminhoArquivo}) : _caminhoArquivo = caminhoArquivo;

  final String? _caminhoArquivo;
  Database? _banco;

  Future<Database> _abrir() async {
    if (_banco != null) {
      return _banco!;
    }

    final caminho =
        _caminhoArquivo ?? join(await getDatabasesPath(), 'filmes.db');

    _banco = await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, versao) async {
        await db.execute(
          'CREATE TABLE filmes ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'titulo TEXT NOT NULL, '
          'assistido INTEGER NOT NULL'
          ')',
        );
      },
    );

    return _banco!;
  }

  Future<void> fechar() async {
    await _banco?.close();
    _banco = null;
  }

  Future<void> inserir(String titulo) async {
    final db = await _abrir();
    await db.rawInsert(
      'INSERT INTO filmes (titulo, assistido) VALUES (?, ?)',
      [titulo, 0],
    );
  }

  Future<List<Filme>> listar() async {
    final db = await _abrir();
    final linhas = await db.rawQuery(
      'SELECT id, titulo, assistido FROM filmes ORDER BY id ASC',
    );

    return linhas.map(Filme.fromMap).toList();
  }

  Future<void> atualizarAssistido(int id, bool assistido) async {
    final db = await _abrir();
    await db.rawUpdate(
      'UPDATE filmes SET assistido = ? WHERE id = ?',
      [assistido ? 1 : 0, id],
    );
  }
}
