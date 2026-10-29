import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/usuario_provider.dart';
import '../providers/produto_provider.dart';
import 'login_page.dart';

class CadastroProdutoPage extends StatefulWidget {
  const CadastroProdutoPage({super.key});

  @override
  State<CadastroProdutoPage> createState() => _CadastroProdutoPageState();
}

class _CadastroProdutoPageState extends State<CadastroProdutoPage> {
  final _nome = TextEditingController();
  final _categoria = TextEditingController();
  final _quantidade = TextEditingController();
  final _preco = TextEditingController();
  String? _mensagem;

  @override
  void dispose() {
    _nome.dispose();
    _categoria.dispose();
    _quantidade.dispose();
    _preco.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    final erro = await context.read<ProdutoProvider>().cadastrar(
          nome: _nome.text,
          categoria: _categoria.text,
          quantidadeTexto: _quantidade.text,
          precoTexto: _preco.text,
        );

    if (!mounted) {
      return;
    }

    if (erro != null) {
      setState(() => _mensagem = erro);
      return;
    }

    _nome.clear();
    _categoria.clear();
    _quantidade.clear();
    _preco.clear();
    setState(() => _mensagem = 'Produto cadastrado.');
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<UsuarioProvider>().usuarioLogado == null) {
      return const LoginPage();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar produto')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nome,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _categoria,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _quantidade,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _preco,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Preço',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _cadastrar,
                  child: const Text('CADASTRAR PRODUTO'),
                ),
                if (_mensagem != null) ...[
                  const SizedBox(height: 12),
                  Text(_mensagem!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
