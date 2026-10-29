# Central Jujutsu

O enunciado se chama Cadastro de Feiticeiros, mas o aplicativo é o cadastro de missões com login Google. Não há CRUD de pessoas.

Cada missão tem `titulo`, `grau`, `concluida` e `usuarioId`. O `usuarioId` é o UID do Firebase Authentication, não o e-mail.

A collection é `missoes_jujutsu`, para não misturar com a collection `missoes` da atividade 03. O enunciado não definiu o nome.

O grau é um texto obrigatório, como o exemplo `2`. O enunciado não definiu uma lista fechada de graus.

## Login

No Chrome o código usa `GoogleAuthProvider` e `signInWithPopup`, no mesmo formato de `referencias/auth_aula/`.

Ao sair ou trocar de conta, o provider cancela a consulta anterior, esvazia a lista e só então escuta o UID novo. A tela não reaproveita as missões da conta anterior.

## Regras

`firestore.rules` ainda não foi publicado. Leitura, atualização e exclusão exigem `resource.data.usuarioId == request.auth.uid`. A criação exige `request.resource.data.usuarioId == request.auth.uid`. A atualização não deixa mudar o dono.

Publique esse arquivo no seu projeto, no console do Firestore ou com a CLI, depois de revisar. Eu não alterei permissões.

## Configuração

`lib/firebase_options.dart` não tem IDs. Gere o seu:

```sh
flutter create . --platforms=web --project-name cadastro_de_feiticeiros
flutter pub get
dart pub global activate flutterfire_cli
dart pub global run flutterfire_cli:flutterfire configure
```

No console do Firebase, ative o provedor Google e autorize o domínio `localhost`.

```sh
flutter run -d chrome
```

## Roteiro pendente

Com duas contas Google, A e B:

1. A cadastra uma missão. B não vê essa missão.
2. B cadastra outra. A não vê a de B.
3. B não conclui nem apaga a missão de A. A regra do Firestore também recusa.
4. Sair ou trocar de conta não deixa a lista antiga na tela.

## Estado desta implementação

- Código e regras escritos, seguindo o padrão Model / Provider / Service da aula.
- Login Google, isolamento e regras não foram executados: não há Flutter SDK nem projeto Firebase configurado nesta máquina.
- Nenhuma conta de teste foi usada.
