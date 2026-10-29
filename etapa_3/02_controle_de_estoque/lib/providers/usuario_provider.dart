import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../services/usuario_service.dart';

class UsuarioProvider extends ChangeNotifier {
  final UsuarioService _service = UsuarioService();

  Usuario? usuarioLogado;
  String? erroLogin;
  String? erroCadastro;

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final nomeLimpo = nome.trim();
    final emailLimpo = email.trim();

    if (nomeLimpo.isEmpty || emailLimpo.isEmpty || senha.isEmpty) {
      erroCadastro = 'Preencha nome, e-mail e senha.';
      notifyListeners();
      return false;
    }

    final existe = await _service.emailExiste(emailLimpo);
    if (existe) {
      erroCadastro = 'E-mail já cadastrado.';
      notifyListeners();
      return false;
    }

    try {
      await _service.inserir(
        nome: nomeLimpo,
        email: emailLimpo,
        senha: senha,
      );
    } catch (e) {
      erroCadastro = 'Não foi possível cadastrar o usuário.';
      notifyListeners();
      return false;
    }

    erroCadastro = null;
    notifyListeners();
    return true;
  }

  Future<bool> entrar(String email, String senha) async {
    if (email.trim().isEmpty || senha.isEmpty) {
      erroLogin = 'E-mail ou senha incorretos.';
      notifyListeners();
      return false;
    }

    final usuario = await _service.buscarPorEmailESenha(email.trim(), senha);
    if (usuario == null) {
      usuarioLogado = null;
      erroLogin = 'E-mail ou senha incorretos.';
      notifyListeners();
      return false;
    }

    usuarioLogado = usuario;
    erroLogin = null;
    notifyListeners();
    return true;
  }

  void sair() {
    usuarioLogado = null;
    erroLogin = null;
    notifyListeners();
  }
}
