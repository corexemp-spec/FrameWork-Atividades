import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/filme_viewmodel.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _adicionar() async {
    final viewModel = context.read<FilmeViewModel>();
    final mensagem = await viewModel.adicionar(_controller.text);

    if (!mounted) {
      return;
    }

    if (mensagem == null) {
      _controller.clear();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FilmeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Lista de Filmes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Digite o nome do filme',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _adicionar(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: viewModel.salvando ? null : _adicionar,
              child: const Text('Adicionar'),
            ),
            if (viewModel.erro != null) ...[
              const SizedBox(height: 12),
              Text(
                viewModel.erro!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 20),
            Expanded(
              child: _lista(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lista(FilmeViewModel viewModel) {
    if (viewModel.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.filmes.isEmpty) {
      return const Center(child: Text('Nenhum filme cadastrado.'));
    }

    return ListView.builder(
      itemCount: viewModel.filmes.length,
      itemBuilder: (context, index) {
        final filme = viewModel.filmes[index];

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(
              filme.titulo,
              style: TextStyle(
                decoration: filme.assistido
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            trailing: Checkbox(
              value: filme.assistido,
              onChanged: viewModel.salvando
                  ? null
                  : (valor) {
                      if (valor == null) {
                        return;
                      }
                      viewModel.definirAssistido(filme, valor);
                    },
            ),
          ),
        );
      },
    );
  }
}
