import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/missao.dart';

class MissaoService {
  // Só acessa o Firebase quando um método é chamado.
  CollectionReference<Map<String, dynamic>> get _colecao =>
      FirebaseFirestore.instance.collection('missoes');

  Future<void> adicionar(Missao missao) async {
    await _colecao.add(missao.toMap());
  }

  Future<List<Missao>> buscarTodas() async {
    final consulta = await _colecao.get();
    return consulta.docs
        .map((documento) => Missao.fromMap(documento.id, documento.data()))
        .toList();
  }

  Future<void> atualizar(String id) async {
    await _colecao.doc(id).update({'concluida': true});
  }

  Future<void> excluir(String id) async {
    await _colecao.doc(id).delete();
  }
}
