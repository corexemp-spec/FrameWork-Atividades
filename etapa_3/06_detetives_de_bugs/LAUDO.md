# Laudo técnico

Base investigada: `referencias/bugs_original/`. O projeto corrigido está nesta pasta. A ordenação `orderBy('criadoEm', descending: false)` foi mantida: o enunciado não define a ordem.

`referencias/bugs_original/` não contém `firestore.rules`. O arquivo desta pasta é uma proposta para o seu projeto e não foi publicado.

Nenhum bug abaixo foi confirmado executando o aplicativo. O Flutter SDK não está instalado nesta máquina, não há `firebase_options.dart` com o seu projeto e não há captura de duas contas. A causa de cada item foi lida no código original.

## Bug 1

**Arquivo:** `lib/pages/central_page.dart`  
**Sintoma:** o projeto não compila. O subtítulo da lista quebra no meio da string.  
**Causa:** a string de aspas simples continua na linha seguinte. Em Dart isso é erro de sintaxe.  
**Correção:** as duas linhas ficaram em uma string só, com `\n` antes de `Por`.  
**Teste:** leitura do original. `flutter analyze` não foi executado.

## Bug 2

**Arquivo:** `lib/pages/central_page.dart`  
**Sintoma:** o projeto não compila ao abrir os detalhes.  
**Causa:** `DetalhePage()` era chamado sem o parâmetro obrigatório `ocorrencia`.  
**Correção:** a navegação envia a ocorrência da linha: `DetalhePage(ocorrencia: o)`.  
**Teste:** leitura do construtor em `detalhe_page.dart` e da chamada original. Execução pendente.

## Bug 3

**Arquivo:** `lib/pages/central_page.dart`  
**Sintoma:** dá para registrar um objeto sem título ou sem local, desde que o outro campo esteja preenchido.  
**Causa:** a validação usava `&&`. Os dois campos precisavam estar vazios ao mesmo tempo para a gravação ser recusada.  
**Correção:** a condição passou a usar `||`. Título vazio ou local vazio interrompe o cadastro.  
**Teste:** leitura da condição original. Cadastro na tela pendente.

## Bug 4

**Arquivo:** `lib/pages/central_page.dart`  
**Sintoma:** o interruptor "Somente não resolvidos" fica invertido em relação ao toque.  
**Causa:** `onChanged` recebia o novo valor e gravava `!value`.  
**Correção:** o estado recebe `value`.  
**Teste:** leitura do `SwitchListTile` original. Toque na tela pendente.

## Bug 5

**Arquivo:** `lib/pages/central_page.dart`  
**Sintoma:** com o filtro ligado, a lista mostra os itens resolvidos.  
**Causa:** o filtro usava `o.resolvido` no modo "somente não resolvidos".  
**Correção:** o filtro passou a usar `!o.resolvido`.  
**Teste:** leitura do `where` original. Filtro na tela pendente.

## Bug 6

**Arquivo:** `lib/models/ocorrencia.dart`  
**Sintoma:** o identificador do autor não é o UID. A comparação de dono falha e o nome pode aparecer no lugar do id.  
**Causa:** `fromDoc` lia `autorId` a partir de `d['autorNome']`.  
**Correção:** `autorId` passa a ler `d['autorId']`.  
**Teste:** leitura do `fromDoc` original. Leitura de documento real pendente.

## Bug 7

**Arquivo:** `lib/models/ocorrencia.dart`  
**Sintoma:** um item gravado como não resolvido aparece como resolvido, e o contrário também.  
**Causa:** `resolvido` era montado com `!(d['resolvido'] ...)`.  
**Correção:** o campo usa o booleano gravado, sem inverter.  
**Teste:** leitura do mapeamento original. Tela pendente.

## Bug 8

**Arquivo:** `lib/services/central_service.dart`  
**Sintoma:** o responsável fica associado ao e-mail. O botão de status, que compara com `currentUser.uid`, não reconhece o dono.  
**Causa:** `registrar` gravava `'autorId': u.email`.  
**Correção:** `autorId` recebe `u.uid`. O nome continua em `autorNome`.  
**Teste:** leitura do `add` original. Conferência no Firestore pendente.

## Bug 9

**Arquivo:** `lib/services/central_service.dart`  
**Sintoma:** "Marcar como resolvido" não muda o status.  
**Causa:** `update` gravava `item.resolvido`, o mesmo valor que já estava no objeto.  
**Correção:** o `update` grava `!item.resolvido`.  
**Teste:** leitura do `update` original. Alternância na tela pendente.

## Bug 10

**Arquivo:** `lib/pages/detalhe_page.dart`  
**Sintoma:** uma pista com texto não é enviada. O campo preenchido é ignorado.  
**Causa:** `enviar` retornava quando `pista.text.trim().isNotEmpty`.  
**Correção:** o retorno acontece quando o texto está vazio.  
**Teste:** leitura do `if` original. Envio na tela pendente.

## Bug 11

**Arquivo:** `lib/pages/detalhe_page.dart`  
**Sintoma:** a pista gravada não contém o texto digitado.  
**Causa:** mesmo depois da validação, `enviarPista` era chamado com `''`.  
**Correção:** a chamada envia `pista.text`.  
**Teste:** leitura da chamada original. Texto no Firestore pendente.

## Bug 12

**Arquivo:** `lib/services/central_service.dart`  
**Sintoma:** a pista não aparece na ocorrência aberta. Ela ia para um documento fixo.  
**Causa:** `enviarPista` usava `.doc('pistas')` em vez do id recebido. A leitura em `pistas(id)` usava o id da ocorrência.  
**Correção:** a gravação usa `.doc(ocorrenciaId).collection('pistas')`.  
**Teste:** leitura dos dois métodos originais. Duas contas vendo a mesma pista: pendente.

## O que não entrou no laudo

Não contei a direção da ordenação como bug. Não há décimo terceiro defeito confirmado no código lido. Autenticação Google e o fluxo de pistas compartilhadas foram mantidos.
