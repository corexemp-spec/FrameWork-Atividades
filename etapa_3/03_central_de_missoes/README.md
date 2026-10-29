# Central de Missões

Flutter, Provider, Service e Cloud Firestore. Não há login. A collection é `missoes`, com `titulo`, `dificuldade`, `pontos` e `concluida`.

Os pontos não são digitados: Fácil = 10, Médio = 20, Difícil = 30. O total soma só missões com `concluida == true`. Concluir de novo não soma outra vez, porque o botão some e o service não é chamado.

Os desafios extras (campo `data` e tela de detalhes) não foram implementados.

## Configuração do seu Firebase

Este aplicativo não usa o projeto do professor. `lib/firebase_options.dart` não tem IDs: ele interrompe a execução até você gerar o arquivo.

```sh
flutter create . --platforms=web,windows --project-name central_de_missoes
flutter pub get
dart pub global activate flutterfire_cli
dart pub global run flutterfire_cli:flutterfire configure
```

O comando acima substitui `lib/firebase_options.dart`.

O arquivo `firestore.rules` está fechado (`allow read, write: if false`) e não foi publicado. Como a atividade não autentica ninguém, qualquer regra que permita ler e gravar `missoes` fica pública para quem tiver a configuração do app. Publique no console do seu projeto somente se aceitar isso, limitada à collection `missoes`. Eu não alterei permissões em nenhum serviço.

Exemplo para colar manualmente, se você decidir:

```
match /missoes/{id} {
  allow read, create, update, delete: if true;
}
```

## Executar

```sh
flutter run -d chrome
```

## Roteiro

1. Cadastre uma missão Fácil, uma Médio e uma Difícil.
2. Conclua a de 10 e a de 20. O total deve ficar 30. A de 30 continua pendente.
3. Exclua a concluída de 10. O total deve ficar 20.
4. Feche e abra. As missões restantes devem voltar do Firestore.
5. Confira no console que `concluida` mudou no documento certo.

## Estado desta implementação

- Código e teste local da soma escritos.
- O teste não fala com o Firestore. Ele só confere pontos, `toMap` e `fromMap`.
- `flutter analyze`, `flutter test` e o aplicativo não foram executados: o Flutter SDK não está instalado.
- Integração com Firebase pendente. Nenhuma missão foi gravada.
