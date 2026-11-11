import 'receita.dart';
import 'receitas_service.dart';

class ReceitasRepository {
  ReceitasRepository(this._service);
  final ReceitasService _service;
  Future<List<Receita>> buscar(String termo) => _service.buscarPorNome(termo);
}
