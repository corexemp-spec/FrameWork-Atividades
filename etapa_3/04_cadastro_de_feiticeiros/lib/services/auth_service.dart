import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> entrarComGoogle() async {
    final provider = GoogleAuthProvider();
    provider.setCustomParameters({'prompt': 'select_account'});
    await _auth.signInWithPopup(provider);
  }

  Future<void> sair() async {
    await _auth.signOut();
  }

  Future<void> trocarConta() async {
    await _auth.signOut();
    final provider = GoogleAuthProvider();
    provider.setCustomParameters({'prompt': 'select_account'});
    await _auth.signInWithPopup(provider);
  }
}
