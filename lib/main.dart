import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

import 'firebase_options.dart';

import 'features/auth/auth_service.dart';
import 'features/auth/login_page.dart';
import 'features/receitas/data/receitas_repository.dart';
import 'features/receitas/data/receitas_service.dart';
import 'features/receitas/ui/busca_page.dart';
import 'features/receitas/ui/busca_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authService = AuthService();
  final viewModel = BuscaViewModel(
    ReceitasRepository(ReceitasService(http.Client())),
  );

  runApp(ReceitasApp(authService: authService, buscaViewModel: viewModel));
}

class ReceitasApp extends StatelessWidget {
  const ReceitasApp({
    super.key,
    required this.authService,
    required this.buscaViewModel,
  });
  final AuthService authService;
  final BuscaViewModel buscaViewModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receitas favoritas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return BuscaPage(
              viewModel: buscaViewModel,
              authService: authService,
            );
          }
          return LoginPage(authService: authService);
        },
      ),
    );
  }
}
