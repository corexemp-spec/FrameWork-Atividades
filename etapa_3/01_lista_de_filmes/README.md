# Minha Lista de Filmes

Aplicativo Flutter com Model, View, ViewModel, Provider e SQLite.

A `List<Filme>` da ViewModel só guarda o que a tela está mostrando. O arquivo `filmes.db` guarda os dados.

## Fluxo

```
PaginaInicial
  → FilmeViewModel
    → FilmeService
      → SQLite (filmes.db)
```

`false` é gravado como `0` e `true` como `1`.

## Executar

Na primeira vez, nesta pasta, gere as pastas de plataforma sem substituir `lib/`:

```sh
flutter create . --platforms=windows,android --project-name lista_de_filmes
flutter pub get
flutter run -d windows
```

No Android, o `sqflite` usa o banco do aparelho. No Windows, `main.dart` inicializa `sqflite_common_ffi`.

Não execute no Chrome: esta atividade não inclui `sqlite3.wasm`. Sem esse arquivo o navegador não mantém o SQLite.

## Roteiro de teste

1. Cadastre Interestelar, Homem-Aranha e Shrek.
2. Marque Interestelar.
3. Feche o aplicativo e abra de novo.
4. Confira os três títulos e a marcação.
5. Desmarque Interestelar, reinicie e confira que continua desmarcado.

## Estado desta implementação

- Código do aplicativo escrito.
- Teste de serviço em `test/filme_service_test.dart`, cobrindo gravação, releitura e desmarcação no mesmo arquivo `filmes.db`.
- `flutter analyze`, `flutter test` e a execução do aplicativo não foram feitos nesta máquina: o Flutter SDK não está instalado nem está no PATH.
- Teste manual da tela (cadastro, checkbox e reinício do app) pendente.
