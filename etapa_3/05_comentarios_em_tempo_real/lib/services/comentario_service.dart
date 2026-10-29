import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComentarioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _comentarios(String publicacaoId) {
    return _db
        .collection('publicacoes')
        .doc(publicacaoId)
        .collection('comentarios');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> acompanhar(String publicacaoId) {
    return _comentarios(publicacaoId).orderBy('data').snapshots();
  }

  Future<void> comentar(String publicacaoId, String texto) async {
    final usuario = _auth.currentUser!;
    final perfil = await _db.collection('usuarios').doc(usuario.uid).get();
    final nome = (perfil.data()?['nome'] as String?) ?? 'Usuário';

    await _comentarios(publicacaoId).add({
      'texto': texto.trim(),
      'autorNome': nome,
      'autorId': usuario.uid,
      'publicacaoId': publicacaoId,
      'data': FieldValue.serverTimestamp(),
    });
  }

  Future<void> excluir(String publicacaoId, String comentarioId) {
    return _comentarios(publicacaoId).doc(comentarioId).delete();
  }
}
