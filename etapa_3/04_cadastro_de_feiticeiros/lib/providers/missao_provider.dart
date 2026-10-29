import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/missao.dart';
import '../services/missao_service.dart';

class MissaoProvider extends ChangeNotifier {
  final MissaoService _service = MissaoService();

  StreamSubscription<User?>? _auth;
  StreamSubscription<List<Missao>>? _consulta;

  List<Missao> missoes = [];
  bool carregando = false;
  String? erro;
  String? uidAtual;

  MissaoProvider() {
    _auth = FirebaseAuth.instance.authStateChanges().listen(_trocarUsuario);
  }

  void _trocarUsuario(User? usuario) {
    final uid = usuario?.uid;
    if (uid == uidAtual && _consulta != null) {
      return;
    }

    _consulta?.cancel();
    _consulta = null;
    uidAtual = uid;
    missoes = [];
    erro = null;

    if (uid == null) {
      carregando = false;
      notifyListeners();
      return;
    }

    carregando = true;
    notifyListeners();

    _consulta = _service.listarDoUsuario(uid).listen(
      (lista) {
        if (uidAtual != uid) {
          return;
        }
        missoes = lista;
        carregando = false;
        erro = null;
        notifyListeners();
      },
      onError: (Object e) {
        if (uidAtual != uid) {
          return;
        }
        erro = 'Não foi possível carregar as missões.';
        carregando = false;
        notifyListeners();
      },
    );
  }

  Future<String?> adicionar(String titulo, String grau) async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null || usuario.uid != uidAtual) {
      return 'Faça login novamente.';
    }

    final tituloLimpo = titulo.trim();
    final grauLimpo = grau.trim();
    if (tituloLimpo.isEmpty || grauLimpo.isEmpty) {
      return 'Informe título e grau.';
    }

    await _service.adicionar(
      Missao(
        titulo: tituloLimpo,
        grau: grauLimpo,
        usuarioId: usuario.uid,
      ),
    );
    return null;
  }

  Future<void> concluir(Missao missao) async {
    if (missao.concluida || missao.id == null) {
      return;
    }
    if (missao.usuarioId != uidAtual) {
      return;
    }
    await _service.concluir(missao.id!);
  }

  Future<void> excluir(Missao missao) async {
    if (missao.id == null || missao.usuarioId != uidAtual) {
      return;
    }
    await _service.excluir(missao.id!);
  }

  @override
  void dispose() {
    _consulta?.cancel();
    _auth?.cancel();
    super.dispose();
  }
}
