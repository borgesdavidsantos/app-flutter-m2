import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'features/receitas/data/receitas_repository.dart';
import 'features/receitas/data/receitas_service.dart';
import 'features/receitas/ui/busca_page.dart';
import 'features/receitas/ui/busca_view_model.dart';

void main() {
  final viewModel = BuscaViewModel(
    ReceitasRepository(ReceitasService(http.Client())),
  );
  runApp(ReceitasApp(viewModel: viewModel));
}

class ReceitasApp extends StatelessWidget {
  const ReceitasApp({super.key, required this.viewModel});
  final BuscaViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receitas favoritas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: BuscaPage(viewModel: viewModel),
    );
  }
}
