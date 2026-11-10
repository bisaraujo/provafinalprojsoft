# Projeto-base da prova final

Este projeto foi preparado para que o back-end continue funcionando mesmo que o front-end, o Auth0, o PostgreSQL ou o Docker nao sejam concluidos durante a prova.

## Modos de execucao

| Perfil ativo | Banco | Seguranca | Dependencias externas |
|---|---|---|---|
| nenhum (padrao) | H2 em arquivo | rotas abertas | nenhuma |
| `postgres` | PostgreSQL | rotas abertas | PostgreSQL |
| `auth0` | H2 em arquivo | JWT do Auth0 | Auth0 |
| `auth0,postgres` | PostgreSQL | JWT do Auth0 | Auth0 e PostgreSQL |

O front-end e sempre independente: a API inicia sem ele.

## Caminho seguro para a prova

1. Rode `./mvnw.cmd verify` para executar os testes e gerar o JaCoCo.
2. Rode `./scripts/run-local.ps1` para iniciar no modo minimo.
3. Confirme `http://localhost:8080/actuator/health` com resposta `UP`.
4. Implemente entidade, repository, service e controller do tema sorteado.
5. So ative PostgreSQL, Auth0 ou deploy depois que o CRUD estiver funcionando.

Antes de comecar, `./scripts/check-ports.ps1` mostra se as portas mais comuns estao livres.

O H2 persiste os dados em `./data/provafinal`. O console fica em `http://localhost:8080/h2-console`, com JDBC URL `jdbc:h2:file:./data/provafinal`, usuario `sa` e senha vazia.

## PostgreSQL opcional

Com Docker Desktop iniciado:

```powershell
./scripts/start-postgres.ps1
```

O script cria apenas o container `provafinal-postgres` e inicia a API com o perfil `postgres`. Sem Docker, volte ao modo H2; nenhuma alteracao no codigo e necessaria.

## Auth0 opcional

Crie uma API no Auth0 e informe o Identifier como audience. Depois execute:

```powershell
./scripts/run-auth0.ps1 `
  -IssuerUri "https://dev-kcwjkqlrx2lj73ae.us.auth0.com/" `
  -Audience "https://provafinal-api"
```

Configuracao publica preparada para o futuro front-end:

```text
Domain: dev-kcwjkqlrx2lj73ae.us.auth0.com
Client ID: 7HTiixp3WpbYvQeIVveF4fw99Te93Uay
Audience: https://provafinal-api
```

A Action de Post Login esta em `auth0/post-login-action.js`. Ela adiciona email e roles ao access token. O claim de roles usado pelo back-end e `https://projsoft.com/roles` e pode ser trocado pela variavel `AUTH0_ROLES_CLAIM`.

No perfil `auth0`, todas as rotas exigem JWT, exceto `/actuator/health`. Anotacoes como `@PreAuthorize("hasRole('ADMIN')")` passam a ser aplicadas. Sem esse perfil, a configuracao aberta permite testar o CRUD normalmente.

## Testes e JaCoCo

```powershell
./mvnw.cmd verify
```

Abra `target/site/jacoco/index.html`. O JaCoCo esta focado no pacote `service`, que e onde normalmente a prova exige 100% de cobertura. Quando as classes de servico forem criadas, os testes unitarios devem cobrir todos os caminhos delas.

## Docker da API

Primeiro gere o JAR e depois a imagem:

```powershell
./mvnw.cmd verify
docker build -t provafinal:local .
docker run --name provafinal-app -p 8080:8080 -v provafinal-h2-data:/app/data provafinal:local
```

Essa imagem usa H2 por padrao e nao precisa do PostgreSQL para subir.

## GitHub Actions

- `ci.yml`: executa Maven, testes e JaCoCo em push e pull request.
- `deploy.yml`: por acionamento manual, publica a imagem no Docker Hub. A EC2 so e atualizada quando a opcao `deploy_to_aws` for marcada explicitamente.

O deploy deve permanecer manual ate a VM estar preparada. Para o modo mais resiliente, deixe a variavel `SPRING_PROFILES_ACTIVE` vazia: a EC2 usara H2 persistido em volume. Para o modo completo, use `auth0,postgres` e cadastre os secrets documentados no workflow.

