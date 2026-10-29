import '../models/usuario.dart';
import 'banco.dart';

class UsuarioService {
  Future<bool> emailExiste(String email) async {
    final db = await BancoEstoque.abrir();
    final linhas = await db.query(
      'usuarios',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
    );
    return linhas.isNotEmpty;
  }

  Future<void> inserir({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final db = await BancoEstoque.abrir();
    await db.rawInsert(
      'INSERT INTO usuarios (nome, email, senha) VALUES (?, ?, ?)',
      [nome, email, senha],
    );
    // A senha não entra no print.
    print('INSERT → Usuário cadastrado: $nome');
  }

  Future<Usuario?> buscarPorEmailESenha(String email, String senha) async {
    print('SELECT → Procurando usuário: $email');

    final db = await BancoEstoque.abrir();
    final linhas = await db.query(
      'usuarios',
      columns: ['id', 'nome', 'email'],
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (linhas.isEmpty) {
      print('SELECT → Usuário não encontrado');
      return null;
    }

    final usuario = Usuario.fromMap(linhas.first);
    print('SELECT → Usuário encontrado: ${usuario.nome}');
    return usuario;
  }
}
