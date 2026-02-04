# 🗄️ Multi-Tenant Database Manager

Este repositório é dedicado à gestão e sincronização automatizada de esquemas de banco de dados em uma arquitetura **Multi-tenant (Database-per-tenant)** utilizando **Prisma ORM** .

## 🎯 Objetivo

Garantir que todas as bases de dados dos clientes (tenants) estejam sempre em conformidade com o `schema.prisma` definido no projeto, automatizando o processo de migração que, de outra forma, exigiria intervenção manual banco a banco.

## 🏗️ Como Funciona

O fluxo de atualização segue a lógica:

1. **Consulta Master:** O script conecta-se à base principal (`master1`).
2. **Descoberta:** Recupera a lista de nomes de bancos ativos através da tabela `tenants` (coluna `dbref`).
3. **Iteração:** Para cada banco encontrado, o script injeta dinamicamente a string de conexão na variável `DATABASE_URL`.
4. **Deploy:** Executa o `prisma migrate deploy` para aplicar as novas migrações.

## 🚀 Pré-requisitos

Antes de executar o script, certifique-se de ter:

- **PostgreSQL Client (`psql`)** instalado no sistema.
- **Node.js** e dependências do projeto instaladas (`npm install`).
- Acesso de rede à instância PostgreSQL em `localhost:7000`.
- Arquivo `.env` configurado (embora o script sobrescreva a URL de conexão em runtime).

## 🛠️ Uso

### 1. Preparação

Sempre que houver mudanças no `schema.prisma`, gere a nova migração localmente:

**Bash**

```
npx prisma migrate dev --name sua_alteracao
```

### 2. Execução em Lote

Para aplicar as migrações em todos os tenants da lista:

**Bash**

```
# Permissão de execução (apenas na primeira vez)
chmod +x migrate-tenants.sh

# Rodar a automação
./migrate-tenants.sh
```

## ⚠️ Comandos Prisma: Importante

Neste projeto, diferenciamos dois comandos críticos:

- **`npx prisma migrate deploy`** : Utilizado pelo script. Ele aplica migrações pendentes sem resetar o banco de dados. **Nunca** use `migrate dev` em produção ou scripts de automação.
- **`npx prisma generate`** : Atualiza o artefato do Prisma Client no seu `node_modules`. Deve ser executado após o deploy para que a aplicação reconheça os novos tipos.

## 🛡️ Segurança e Boas Práticas

- **Logs:** O script exibe o status de cada banco. Caso um banco falhe, o script continuará para o próximo, mas marcará o erro no terminal com ⚠️.
