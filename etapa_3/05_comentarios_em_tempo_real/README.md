# Comentários em Tempo Real

Continuação do mural da aula de 19/10 (`referencias/mural_19_10/`). Cadastro, login por e-mail e senha, perfil e publicações foram mantidos. Não há login Google.

O comentário fica em `publicacoes/{id}/comentarios` e também guarda `publicacaoId`, `autorId`, `autorNome` e `texto`. A lista usa `StreamBuilder` com `.snapshots()`.

O pacote `provider` continua no `pubspec.yaml` porque já estava na base. As telas não passaram a usar Provider.

## Configuração

`lib/firebase_options.dart` não tem credenciais. A referência da aula também não tinha. Gere o arquivo no seu projeto:

```sh
flutter create . --platforms=web --project-name muralapp
flutter pub get
dart pub global activate flutterfire_cli
dart pub global run flutterfire_cli:flutterfire configure
```

Publique `firestore.rules` no seu Firestore. O arquivo não foi enviado a nenhum projeto. Usuário autenticado lê o mural. Cada pessoa só altera o próprio perfil, as próprias publicações e os próprios comentários. Visitante sem login não lê nem escreve.

As versões de Firebase do `pubspec.yaml` são as da base (`firebase_core ^5.0.0`, `firebase_auth ^7.0.0`, `cloud_firestore ^7.0.0`). `flutter pub get` não foi executado, então essa combinação não foi confirmada.

```sh
flutter run -d chrome
```

## Estado desta implementação

- Código, regras e `RESPOSTAS.md` escritos.
- Nenhuma conta entrou no aplicativo. Comentário entre duas pessoas, isolamento e exclusão não foram vistos na tela.
- `flutter analyze` não rodou: o Flutter SDK não está instalado.

O roteiro das duas contas está em `RESPOSTAS.md`.
