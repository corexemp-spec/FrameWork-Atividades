import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/missao.dart';

class MissaoService {
  // Collection separada da Central de Missões (atividade 03).
  static const colecao = 'missoes_jujutsu';

  CollectionReference<Map<String, dynamic>> get _colecao =>
      FirebaseFirestore.instance.collection(colecao);

  Stream<List<Missao>> listarDoUsuario(String uid) {
    return _colecao.where('usuarioId', isEqualTo: uid).snapshots().map(
          (snapshot) => snapshot.docs
              .map((documento) => Missao.fromMap(documento.id, documento.data()))
              .toList(),
        );
  }

  Future<void> adicionar(Missao missao) async {
    await _colecao.add(missao.toMap());
  }

  Future<void> concluir(String id) async {
    await _colecao.doc(id).update({'concluida': true});
  }

  Future<void> excluir(String id) async {
    await _colecao.doc(id).delete();
  }
}
