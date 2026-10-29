import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/produto.dart';
import '../providers/produto_provider.dart';
import '../providers/usuario_provider.dart';
import 'login_page.dart';

class EstoquePage extends StatefulWidget {
  const EstoquePage({super.key});

  @override
  State<EstoquePage> createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProdutoProvider>().carregar();
    });
  }

  String _preco(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  Future<void> _alterar(Produto produto, int delta) async {
    final erro = await context.read<ProdutoProvider>().alterarQuantidade(
          produto,
          delta,
        );
    if (!mounted || erro == null) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro)));
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<UsuarioProvider>().usuarioLogado == null) {
      return const LoginPage();
    }

    final provider = context.watch<ProdutoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('ESTOQUE')),
      body: provider.carregando
          ? const Center(child: CircularProgressIndicator())
          : provider.erro != null
              ? Center(child: Text(provider.erro!))
              : provider.produtos.isEmpty
                  ? const Center(child: Text('Nenhum produto cadastrado.'))
                  : ListView.builder(
                      itemCount: provider.produtos.length,
                      itemBuilder: (context, index) {
                        final produto = provider.produtos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  produto.nome,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(produto.categoria),
                                Text('Quantidade: ${produto.quantidade}'),
                                Text(_preco(produto.preco)),
                                if (produto.estoqueBaixo)
                                  const Text(
                                    'ESTOQUE BAIXO',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    OutlinedButton(
                                      onPressed: produto.quantidade == 0
                                          ? null
                                          : () => _alterar(produto, -1),
                                      child: const Text('-'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        'Quantidade: ${produto.quantidade}',
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () => _alterar(produto, 1),
                                      child: const Text('+'),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<ProdutoProvider>()
                                            .excluir(produto);
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
                    ),
    );
  }
}
