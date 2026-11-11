import 'package:flutter/material.dart';

import 'busca_view_model.dart';

class BuscaPage extends StatefulWidget {
  const BuscaPage({super.key, required this.viewModel});
  final BuscaViewModel viewModel;
  @override
  State<BuscaPage> createState() => _BuscaPageState();
}

class _BuscaPageState extends State<BuscaPage> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _corpo(BuscaEstado estado) => switch (estado) {
    BuscaInicial() => const Center(
      child: Text('Digite o nome de uma receita (em inglês).'),
    ),
    BuscaCarregando() => const Center(child: CircularProgressIndicator()),
    BuscaVazia(:final termo) => Center(
      child: Text('Nenhuma receita encontrada para "$termo".'),
    ),
    BuscaErro(:final mensagem) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(mensagem),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: widget.viewModel.tentarNovamente,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    ),
    BuscaSucesso(:final receitas) => ListView.builder(
      itemCount: receitas.length,
      itemBuilder: (context, i) {
        final r = receitas[i];
        return ListTile(
          leading: r.imagemUrl == null
              ? const Icon(Icons.restaurant)
              : Image.network(
                  r.imagemUrl!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, erro, pilha) =>
                      const Icon(Icons.restaurant),
                ),
          title: Text(r.nome),
          subtitle: Text([r.categoria, r.area].whereType<String>().join(' • ')),
        );
      },
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receitas favoritas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Buscar receita (ex.: chicken)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => widget.viewModel.buscar(_controller.text),
                ),
              ),
              onSubmitted: widget.viewModel.buscar,
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, child) => _corpo(widget.viewModel.estado),
            ),
          ),
        ],
      ),
    );
  }
}
