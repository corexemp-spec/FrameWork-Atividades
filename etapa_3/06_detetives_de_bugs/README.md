# Operação Resgate: Detetives de Bugs

Cópia corrigida de `referencias/bugs_original/`. A referência continua intacta. Os 12 defeitos confirmados estão em `LAUDO.md`.

Login Google, listagem compartilhada e pistas foram mantidos. Só o dono altera `resolvido`, no código e na regra proposta.

## Regras

O ZIP original não tinha `firestore.rules`. O arquivo desta pasta não foi publicado. Ele deixa ocorrências e pistas visíveis para usuário autenticado, restringe a criação ao UID logado e só permite ao dono atualizar o campo `resolvido`.

## Configuração

`lib/firebase_options.dart` não tem IDs. Gere o seu, sem usar o projeto do professor:

```sh
flutter create . --platforms=web --project-name central_achados
flutter pub get
dart pub global activate flutterfire_cli
dart pub global run flutterfire_cli:flutterfire configure
```

Ative o provedor Google e autorize `localhost`. Publique `firestore.rules` no seu Firestore.

```sh
flutter run -d chrome
```

Se já existirem documentos antigos com `autorId` igual ao e-mail, o dono não será reconhecido. Cadastre ocorrências novas. Não apague a coleção do professor: este app deve apontar para o seu projeto.

## Roteiro ainda não executado

1. Abrir o app e registrar dois objetos, com título e local.
2. Conferir o nome de quem registrou.
3. Ligar "Somente não resolvidos".
4. Abrir o detalhe do item certo.
5. Marcar como encontrado e ver o status mudar.
6. Conta A registra. Conta B vê sem recarregar.
7. Conta B envia uma pista. Conta A vê a pista naquela ocorrência.
8. Repetir em outra ocorrência e conferir que a pista não muda de item.
9. Conta B não altera o status da ocorrência de A.
10. Guardar a captura real em `evidencias/`.

## Estado desta implementação

- Correções pontuais aplicadas e laudo escrito.
- `flutter analyze` e o aplicativo não foram executados: o Flutter SDK não está instalado.
- Nenhuma conta viu a mesma ocorrência. Não há captura.
