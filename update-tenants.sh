#!/bin/bash

MASTER_DB_URL="postgresql://postgres:postgres@localhost:7000/master1"
DB_BASE_URL="postgresql://postgres:postgres@localhost:7000"

echo "🚀 Iniciando processo de atualização multi-tenant..."

# 1. Busca os nomes dos bancos na tabela 'tenants' (coluna 'dbref')
tenants=$(psql $MASTER_DB_URL -t -c "SELECT dbref FROM tenants;")

if [ -z "$tenants" ]; then
    echo "❌ Nenhum tenant encontrado ou erro na conexão com master1."
    exit 1
fi

echo "Bancos de dados encontrados:"
echo "$tenants"

# 2. Itera sobre cada banco de dados
for dbname in $tenants; do
    # Remove espaços em branco extras (trim)
    dbname=$(echo $dbname | xargs)
    
    echo "----------------------------------------------------"
    echo "🛠️  Atualizando banco: $dbname"
    
    # Define a variável de ambiente DATABASE_URL temporariamente para o Prisma
    export DATABASE_URL="$DB_BASE_URL/$dbname"
    
    echo "👉 Aplicando migrações..."
    npx prisma migrate dev --schema=./prisma/schema.prisma --name auto
    
    if [ $? -eq 0 ]; then
        echo "✅ Banco $dbname atualizado com sucesso!"
    else
        echo "⚠️ Erro ao atualizar $dbname. Verifique os logs."
    fi
done

echo "----------------------------------------------------"
echo "🏁 Processo finalizado!"