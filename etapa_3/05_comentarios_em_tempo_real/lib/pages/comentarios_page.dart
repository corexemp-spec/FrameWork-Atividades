import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/comentario_service.dart';

class ComentariosPage extends StatefulWidget {
  final String publicacaoId;
  final String textoPublicacao;
  final String autorPublicacao;

  const ComentariosPage({
    super.key,
    required this.publicacaoId,
    required this.textoPublicacao,
    required this.autorPublicacao,
  });

  @override
  State<ComentariosPage> createState() => _ComentariosPageState();
}

class _ComentariosPageState extends State<ComentariosPage> {
  final _texto = TextEditingController();
  final _service = ComentarioService();
  bool _enviando = false;

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (_texto.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva um comentário.')),
      );
      return;
    }

    setState(() => _enviando = true);
    try {
      await _service.comentar(widget.publicacaoId, _texto.text);
      _texto.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível enviar o comentário: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  Future<void> _excluir(String comentarioId) async {
    try {
      await _service.excluir(widget.publicacaoId, comentarioId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível excluir: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final meuUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Comentários')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: ListTile(
              title: Text(widget.autorPublicacao),
              subtitle: Text(widget.textoPublicacao),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _service.acompanhar(widget.publicacaoId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar comentários: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final comentarios = snapshot.data!.docs;
                if (comentarios.isEmpty) {
                  return const Center(child: Text('Nenhum comentário ainda.'));
                }
                return ListView.builder(
                  itemCount: comentarios.length,
                  itemBuilder: (context, index) {
                    final doc = comentarios[index];
                    final dados = doc.data();
                    final autorId = dados['autorId'] as String? ?? '';
                    final meu = autorId == meuUid;
                    return ListTile(
                      title: Text(dados['autorNome'] as String? ?? 'Usuário'),
                      subtitle: Text(dados['texto'] as String? ?? ''),
                      trailing: meu
                          ? IconButton(
                              tooltip: 'Excluir comentário',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _excluir(doc.id),
                            )
                          : null,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _texto,
                    decoration: const InputDecoration(
                      hintText: 'Escreva um comentário',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Enviar',
                  onPressed: _enviando ? null : _enviar,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
