import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/missao_provider.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _titulo = TextEditingController();
  final _grau = TextEditingController();
  final _auth = AuthService();

  @override
  void dispose() {
    _titulo.dispose();
    _grau.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    final erro = await context.read<MissaoProvider>().adicionar(
          _titulo.text,
          _grau.text,
        );
    if (!mounted) {
      return;
    }
    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro)));
      return;
    }
    _titulo.clear();
    _grau.clear();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser;
    final provider = context.watch<MissaoProvider>();
    final contaAtual = usuario != null && provider.uidAtual == usuario.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Central Jujutsu'),
        actions: [
          IconButton(
            tooltip: 'Trocar conta',
            onPressed: () => _auth.trocarConta(),
            icon: const Icon(Icons.switch_account),
          ),
          IconButton(
            tooltip: 'Sair',
            onPressed: () => _auth.sair(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (usuario?.photoURL != null)
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(usuario!.photoURL!),
                  )
                else
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bem-vindo,'),
                      Text(
                        usuario?.displayName ?? 'Feiticeiro',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(usuario?.email ?? ''),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titulo,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _grau,
              decoration: const InputDecoration(
                labelText: 'Grau',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _cadastrar,
              child: const Text('Cadastrar missão'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: !contaAtual || provider.carregando
                  ? const Center(child: CircularProgressIndicator())
                  : provider.erro != null
                      ? Center(child: Text(provider.erro!))
                      : provider.missoes.isEmpty
                          ? const Center(
                              child: Text('Nenhuma missão cadastrada.'),
                            )
                          : ListView.builder(
                              itemCount: provider.missoes.length,
                              itemBuilder: (context, index) {
                                final missao = provider.missoes[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(missao.titulo),
                                    subtitle: Text(
                                      'Grau: ${missao.grau}\n'
                                      '${missao.concluida ? 'Concluída' : 'Pendente'}',
                                    ),
                                    isThreeLine: true,
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (!missao.concluida)
                                          IconButton(
                                            tooltip: 'Concluir',
                                            onPressed: () {
                                              provider.concluir(missao);
                                            },
                                            icon: const Icon(Icons.task_alt),
                                          ),
                                        IconButton(
                                          tooltip: 'Excluir',
                                          onPressed: () {
                                            provider.excluir(missao);
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
