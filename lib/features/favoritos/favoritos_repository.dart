import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../receitas/data/receita.dart';

class FavoritosRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  Future<void> adicionar(Receita receita) async {
    await _firestore.collection('favoritos').doc('${_uid}_${receita.id}').set({
      'ownerId': _uid,
      'idMeal': receita.id,
      'strMeal': receita.nome,
      'strMealThumb': receita.imagemUrl,
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  Future<void> remover(String idReceita) async {
    await _firestore.collection('favoritos').doc('${_uid}_$idReceita').delete();
  }

  Stream<QuerySnapshot> listar() {
    return _firestore
        .collection('favoritos')
        .where('ownerId', isEqualTo: _uid)
        .snapshots();
  }
}
