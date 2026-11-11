import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get usuarioAtual => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> login(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> cadastrar(String email, String senha) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
