import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.authService});
  final AuthService authService;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool _carregando = false;
  String? _erro;

  Future<void> _entrar({required bool cadastrar}) async {
    setState(() { _carregando = true; _erro = null; });
    try {
      if (cadastrar) {
        await widget.authService.cadastrar(_email.text.trim(), _senha.text.trim());
      } else {
        await widget.authService.login(_email.text.trim(), _senha.text.trim());
      }
    } catch (e) {
      setState(() => _erro = 'Falha na autenticação. Verifique os dados.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar no Receitas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'E-mail'), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            TextField(controller: _senha, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
            const SizedBox(height: 20),
            if (_erro != null) Text(_erro!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            _carregando
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      FilledButton(onPressed: () => _entrar(cadastrar: false), child: const Text('Entrar')),
                      TextButton(onPressed: () => _entrar(cadastrar: true), child: const Text('Criar conta')),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
