# Controle de Estoque

Login local e produtos em SQLite. A sessão fica só na memória do `UsuarioProvider`. Usuários e produtos ficam no arquivo `estoque.db`.

## Fluxo

```
Page → Provider → Service → SQLite
```

As consultas usam `?` e `whereArgs`. O terminal recebe os `print` de INSERT, SELECT, UPDATE e DELETE. A senha não é impressa.

## Arquivos que faltam em web/

O workspace não contém os anexos do professor:

- `web/sqlite3.wasm` — https://drive.google.com/file/d/1WxW2mJFhj6lLjzDELsRp6Koyj-bl0tw_/view
- `web/sqflite_sw.js` — https://drive.google.com/file/d/1sjRS7uVPN7EH2igfWY5vlyo_oC7_cwmQ/view

Não foram criados binários no lugar desses arquivos. O `web/index.html` já referencia `sqflite_sw.js`. O worker desse script procura `sqlite3.wasm` na mesma pasta.

Com o Flutter instalado, há dois jeitos de obter os arquivos reais:

1. Baixar os dois anexos do Classroom e colocá-los em `web/`.
2. Se a versão do anexo não combinar com o pacote, rode `dart run sqflite_common_ffi_web:setup`. Esse comando copia o `sqlite3.wasm` e o `sqflite_sw.js` oficiais da dependência `sqflite_common_ffi_web`. Continua sendo SQLite, não `localStorage`.

## Executar

Sempre na porta 8080, para o banco do Chrome continuar na mesma origem:

```sh
flutter create . --platforms=web --project-name controle_de_estoque
flutter pub get
dart run sqflite_common_ffi_web:setup
flutter run -d chrome --web-port 8080
```

`flutter create` não deve apagar `lib/` nem `web/index.html` se esses arquivos já existirem. Se o comando recriar o `index.html`, inclua de novo a linha `<script src="sqflite_sw.js"></script>` antes de `flutter_bootstrap.js`.

## Roteiro

1. Cadastre Maria, `maria@email.com`, senha `1234`. O app volta ao login.
2. Entre com esses dados. A home mostra `Olá, Maria!`.
3. Tente a senha `9999`. A tela mostra `E-mail ou senha incorretos.`
4. Tente cadastrar o mesmo e-mail. A tela mostra `E-mail já cadastrado.`
5. Cadastre três produtos, um com quantidade menor ou igual a 3. Esse item mostra `ESTOQUE BAIXO`.
6. Use `-` e `+`. Recarregue com F5, entre de novo e confira a quantidade.
7. Exclua um produto e confira que sumiu depois de outro F5.
8. Saia. O botão voltar do navegador não deve abrir o estoque sem login.

## Estado desta implementação

- Código, `web/index.html` e teste de serviço escritos.
- O teste em `test/estoque_service_test.dart` abre o mesmo arquivo SQLite duas vezes, pela biblioteca FFI. Ele não substitui o teste no Chrome.
- `flutter pub get`, `flutter analyze`, `flutter test` e `flutter run -d chrome --web-port 8080` não foram executados: o Flutter SDK não está instalado.
- Persistência após F5, login na interface e os `print` no terminal do Chrome estão pendentes.
- `sqlite3.wasm` e `sqflite_sw.js` continuam ausentes.
