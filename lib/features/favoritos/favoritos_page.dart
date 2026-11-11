import 'package:flutter/material.dart';

import 'favoritos_repository.dart';

class FavoritosPage extends StatelessWidget {
  const FavoritosPage({super.key, required this.repository});
  final FavoritosRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Favoritos')),
      body: StreamBuilder(
        stream: repository.listar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Você ainda não tem favoritos.'));
          }

          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              return ListTile(
                leading: data['strMealThumb'] != null
                    ? Image.network(
                        data['strMealThumb'],
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.restaurant),
                title: Text(data['strMeal'] ?? 'Sem nome'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => repository.remover(data['idMeal']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
