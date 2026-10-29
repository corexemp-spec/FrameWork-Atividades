import 'package:firebase_core/firebase_core.dart';

/// Este arquivo não contém credenciais.
/// A base da aula também não trazia firebase_options.dart.
/// Substitua pela saída do FlutterFire no seu projeto:
/// dart pub global run flutterfire_cli:flutterfire configure
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'firebase_options.dart ainda não foi gerado para o seu projeto Firebase.',
    );
  }
}
