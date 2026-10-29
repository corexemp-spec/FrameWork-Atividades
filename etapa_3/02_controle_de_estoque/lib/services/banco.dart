import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoEstoque {
  static Database? _banco;

  // O teste aponta este campo para um arquivo temporário.
  // O aplicativo deixa o valor nulo e usa estoque.db.
  static String? caminhoParaTeste;

  static Future<Database> abrir() async {
    if (_banco != null) {
      return _banco!;
    }

    final caminho =
        caminhoParaTeste ?? join(await getDatabasesPath(), 'estoque.db');

    _banco = await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, versao) async {
        await db.execute(
          'CREATE TABLE usuarios ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'nome TEXT NOT NULL, '
          'email TEXT NOT NULL UNIQUE, '
          'senha TEXT NOT NULL'
          ')',
        );
        await db.execute(
          'CREATE TABLE produtos ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'nome TEXT NOT NULL, '
          'categoria TEXT NOT NULL, '
          'quantidade INTEGER NOT NULL, '
          'preco REAL NOT NULL'
          ')',
        );
      },
    );

    return _banco!;
  }

  static Future<void> fechar() async {
    await _banco?.close();
    _banco = null;
  }
}
