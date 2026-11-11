class Receita {
  const Receita({
    required this.id,
    required this.nome,
    this.categoria,
    this.area,
    this.instrucoes,
    this.imagemUrl,
    this.ingredientes = const [],
  });

  final String id;
  final String nome;
  final String? categoria;
  final String? area;
  final String? instrucoes;
  final String? imagemUrl;
  final List<String> ingredientes;

  factory Receita.fromJson(Map<String, dynamic> json) {
    final ingredientes = <String>[];
    for (var i = 1; i <= 20; i++) {
      final ingrediente = (json['strIngredient$i'] as String?)?.trim() ?? '';
      if (ingrediente.isEmpty) continue;
      final medida = (json['strMeasure$i'] as String?)?.trim() ?? '';
      ingredientes.add(medida.isEmpty ? ingrediente : '$medida $ingrediente');
    }
    return Receita(
      id: json['idMeal'] as String,
      nome: json['strMeal'] as String,
      categoria: json['strCategory'] as String?,
      area: json['strArea'] as String?,
      instrucoes: json['strInstructions'] as String?,
      imagemUrl: json['strMealThumb'] as String?,
      ingredientes: ingredientes,
    );
  }
}
