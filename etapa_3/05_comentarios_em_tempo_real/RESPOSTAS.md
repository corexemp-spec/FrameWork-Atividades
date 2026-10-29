# Respostas

## 1. Como o Firebase identifica quem escreveu determinado comentário?

`ComentarioService.comentar` grava o campo `autorId` com `FirebaseAuth.instance.currentUser.uid`. O nome exibido vem do documento `usuarios/{uid}`, porque o login por e-mail não garante `displayName`.

A regra em `firestore.rules` só aceita criar o comentário se `request.resource.data.autorId == request.auth.uid`. Esconder o botão de excluir não substitui essa regra: apagar também exige `resource.data.autorId == request.auth.uid`.

## 2. Como relacionar um comentário a uma publicação específica?

O botão da `HomePage` abre `ComentariosPage` com `posts[index].id`, que é o id do documento da publicação.

O comentário é salvo em `publicacoes/{publicacaoId}/comentarios` e o campo `publicacaoId` repete esse id. A tela escuta só essa subcollection. Um comentário de outra publicação não entra nessa consulta.

## 3. Por que utilizamos `StreamBuilder` para mostrar os comentários?

`ComentarioService.acompanhar` devolve `.snapshots()`, não um `.get()` isolado. O `StreamBuilder` em `ComentariosPage` reconstrói a lista sempre que o Firestore envia um snapshot novo. Não há botão de atualizar nem consulta repetida por temporizador.

## 4. Como garantir que os comentários apareçam automaticamente em contas diferentes?

As duas contas precisam estar com a discussão da mesma publicação aberta. Cada uma assina a mesma subcollection. Quando uma grava um comentário, o Firestore entrega o snapshot para todos os ouvintes daquele caminho, sem recarregar a página.

## Checklist de teste manual

Ainda não executado. Depende do seu Firebase e de duas contas.

- [ ] Conta A cria uma publicação e deixa a tela de comentários aberta.
- [ ] Conta B abre a mesma publicação e comenta.
- [ ] O comentário aparece na conta A sem atualizar a página.
- [ ] Um comentário feito em outra publicação não aparece nesta.
- [ ] A conta dona do comentário vê o botão de excluir e consegue apagar.
- [ ] A outra conta não vê o botão. A regra do Firestore também recusa o delete.
