import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'receita.dart';

enum TipoFalha { semConexao, tempoEsgotado, servidor, respostaInvalida }

class ReceitasFalha implements Exception {
  const ReceitasFalha(this.tipo, this.mensagem);
  final TipoFalha tipo;
  final String mensagem;
  @override
  String toString() => 'ReceitasFalha($tipo): $mensagem';
}

class ReceitasService {
  ReceitasService(this._client);
  final http.Client _client;

  Future<List<Receita>> buscarPorNome(String termo) async {
    final uri = Uri.https('www.themealdb.com', '/api/json/v1/1/search.php', {
      's': termo,
    });
    final http.Response resposta;
    try {
      resposta = await _client.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ReceitasFalha(
        TipoFalha.tempoEsgotado,
        'A busca demorou demais. Tente novamente.',
      );
    } on http.ClientException {
      throw const ReceitasFalha(
        TipoFalha.semConexao,
        'Sem conexão com a internet.',
      );
    }

    if (resposta.statusCode != 200) {
      throw const ReceitasFalha(
        TipoFalha.servidor,
        'Serviço de receitas indisponível no momento.',
      );
    }

    try {
      final corpo = jsonDecode(resposta.body) as Map<String, dynamic>;
      final meals = corpo['meals'];
      if (meals == null) return [];
      return (meals as List)
          .map((m) => Receita.fromJson(m as Map<String, dynamic>))
          .toList();
    } on FormatException {
      throw const ReceitasFalha(
        TipoFalha.respostaInvalida,
        'Resposta inválida do serviço de receitas.',
      );
    } on TypeError {
      throw const ReceitasFalha(
        TipoFalha.respostaInvalida,
        'Resposta inválida do serviço de receitas.',
      );
    }
  }
}
