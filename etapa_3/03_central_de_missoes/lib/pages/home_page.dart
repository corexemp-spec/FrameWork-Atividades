import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/missao.dart';
import '../providers/missao_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _titulo = TextEditingController();
  String _dificuldade = 'Fácil';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MissaoProvider>().carregar();
    });
  }

  @override
  void dispose() {
    _titulo.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    final erro = await context.read<MissaoProvider>().adicionar(
          _titulo.text,
          _dificuldade,
        );
    if (!mounted) {
      return;
    }
    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro)));
      return;
    }
    _titulo.clear();
  }

  Future<void> _concluir(Missao missao) async {
    final pontos = await context.read<MissaoProvider>().concluir(missao);
    if (!mounted || pontos == null) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Missão concluída!\n\nVocê conquistou $pontos pontos.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MissaoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('CENTRAL DE MISSÕES')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'PONTOS CONQUISTADOS: ${provider.pontosConquistados}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _titulo,
                  decoration: const InputDecoration(
                    labelText: 'Título da missão',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _dificuldade,
                  decoration: const InputDecoration(
                    labelText: 'Dificuldade',
                    border: OutlineInputBorder(),
                  ),
                  items: Missao.dificuldades
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            '$item  ${Missao.estrelas(item)}  ${Missao.pontosDa(item)} pontos',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (valor) {
                    if (valor == null) {
                      return;
                    }
                    setState(() => _dificuldade = valor);
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: provider.carregando ? null : _cadastrar,
                  child: const Text('CADASTRAR MISSÃO'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _lista(provider)),
        ],
      ),
    );
  }

  Widget _lista(MissaoProvider provider) {
    if (provider.carregando && provider.missoes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.erro != null && provider.missoes.isEmpty) {
      return Center(child: Text(provider.erro!));
    }
    if (provider.missoes.isEmpty) {
      return const Center(child: Text('Nenhuma missão cadastrada.'));
    }

    return ListView.builder(
      itemCount: provider.missoes.length,
      itemBuilder: (context, index) {
        final missao = provider.missoes[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  missao.titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Dificuldade: ${Missao.estrelas(missao.dificuldade)} ${missao.dificuldade}',
                ),
                Text('Pontos: ${missao.pontos}'),
                Text('Status: ${missao.concluida ? 'Concluída' : 'Pendente'}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (!missao.concluida)
                      ElevatedButton(
                        onPressed: () => _concluir(missao),
                        child: const Text('CONCLUIR'),
                      ),
                    if (!missao.concluida) const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        context.read<MissaoProvider>().excluir(missao);
                      },
                      child: const Text('EXCLUIR'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
