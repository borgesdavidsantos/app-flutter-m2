import 'package:flutter/foundation.dart';

import '../data/receita.dart';
import '../data/receitas_repository.dart';
import '../data/receitas_service.dart';

sealed class BuscaEstado {
  const BuscaEstado();
}

class BuscaInicial extends BuscaEstado {
  const BuscaInicial();
}

class BuscaCarregando extends BuscaEstado {
  const BuscaCarregando();
}

class BuscaSucesso extends BuscaEstado {
  const BuscaSucesso(this.receitas);
  final List<Receita> receitas;
}

class BuscaVazia extends BuscaEstado {
  const BuscaVazia(this.termo);
  final String termo;
}

class BuscaErro extends BuscaEstado {
  const BuscaErro(this.mensagem);
  final String mensagem;
}

class BuscaViewModel extends ChangeNotifier {
  BuscaViewModel(this._repository);
  final ReceitasRepository _repository;
  BuscaEstado _estado = const BuscaInicial();
  BuscaEstado get estado => _estado;
  String _ultimoTermo = '';
  int _requisicao = 0;

  Future<void> buscar(String termo) async {
    final t = termo.trim();
    if (t.isEmpty) return;
    _ultimoTermo = t;
    final id = ++_requisicao;
    _emitir(const BuscaCarregando());
    try {
      final receitas = await _repository.buscar(t);
      if (id != _requisicao) return;
      _emitir(receitas.isEmpty ? BuscaVazia(t) : BuscaSucesso(receitas));
    } on ReceitasFalha catch (falha) {
      if (id != _requisicao) return;
      _emitir(BuscaErro(falha.mensagem));
    }
  }

  Future<void> tentarNovamente() => buscar(_ultimoTermo);
  void _emitir(BuscaEstado novo) {
    _estado = novo;
    notifyListeners();
  }
}
