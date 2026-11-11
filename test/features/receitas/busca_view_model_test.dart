import 'dart:convert';

import 'package:app_flutter_m2/features/receitas/data/receitas_repository.dart';
import 'package:app_flutter_m2/features/receitas/data/receitas_service.dart';
import 'package:app_flutter_m2/features/receitas/ui/busca_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

BuscaViewModel criar(http.Client client) =>
    BuscaViewModel(ReceitasRepository(ReceitasService(client)));
String corpoComUmaReceita() => jsonEncode({
  'meals': [
    {'idMeal': '1', 'strMeal': 'Arrabiata'},
  ],
});

void main() {
  test(
    'busca com resultado passa por carregando e termina em sucesso',
    () async {
      final vm = criar(
        MockClient((_) async => http.Response(corpoComUmaReceita(), 200)),
      );
      final estados = <BuscaEstado>[];
      vm.addListener(() => estados.add(vm.estado));
      await vm.buscar('arrabiata');
      expect(estados.first, isA<BuscaCarregando>());
      expect(vm.estado, isA<BuscaSucesso>());
    },
  );

  test('meals null vira estado vazio', () async {
    final vm = criar(
      MockClient((_) async => http.Response('{"meals":null}', 200)),
    );
    await vm.buscar('xyzzy');
    expect(vm.estado, isA<BuscaVazia>());
  });

  test('erro 503 vira BuscaErro e tentar novamente leva a sucesso', () async {
    var chamadas = 0;
    final vm = criar(
      MockClient((_) async {
        chamadas++;
        return chamadas == 1
            ? http.Response('indisponivel', 503)
            : http.Response(corpoComUmaReceita(), 200);
      }),
    );
    await vm.buscar('arrabiata');
    expect(vm.estado, isA<BuscaErro>());
    await vm.tentarNovamente();
    expect(vm.estado, isA<BuscaSucesso>());
  });

  test('resposta inválida vira BuscaErro', () async {
    final vm = criar(
      MockClient((_) async => http.Response('isso nao e json', 200)),
    );
    await vm.buscar('arrabiata');
    expect(vm.estado, isA<BuscaErro>());
  });
}
