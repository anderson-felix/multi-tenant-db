#!/bin/bash

# Localiza o arquivo .env no mesmo diretório do script
ENV_FILE="$(dirname "$0")/.env"

if [ -f "$ENV_FILE" ]; then
    echo "📂 Carregando variáveis do arquivo .env..."
    # Exporta as variáveis ignorando comentários
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "❌ Erro: Arquivo .env não encontrado em $(dirname "$0")"
    exit 1
fi

if [ -z "$MASTER_DB_URL" ] || [ -z "$DB_BASE_URL" ] || [ -z "$TENANT_TABLE_NAME" ] || [ -z "$TENANT_COLUMN_NAME" ]; then
    echo "❌ Erro: MASTER_DB_URL, DB_BASE_URL, TENANT_TABLE_NAME ou TENANT_COLUMN_NAME não definidas no .env"
    exit 1
fi

echo "🚀 Iniciando processo de atualização"

tenants=$(psql "$MASTER_DB_URL" -t -c "SELECT \"$TENANT_COLUMN_NAME\" FROM \"$TENANT_TABLE_NAME\";")

if [ -z "$tenants" ]; then
    echo "❌ Nenhum tenant encontrado."
    exit 1
fi

echo "----------------------------------------------------"
echo "Bancos de dados encontrados para atualização:"
echo "----------------------------------------------------"
echo "$tenants"
echo "----------------------------------------------------"

echo "Deseja aplicar as migrações (deploy) nestes bancos?"
echo " [1] Sim, iniciar agora"
echo " [0] Não, cancelar processo"
echo -n "Opção: "
read opcao

if [ "$opcao" != "1" ]; then
    echo "🚫 Operação cancelada pelo usuário."
    exit 0
fi

echo "🚀 Iniciando migrações em massa..."

# Itera sobre cada banco de dados
for dbname in $tenants; do
    dbname=$(echo $dbname | xargs) # Trim
    
    echo "----------------------------------------------------"
    echo "🛠️  Atualizando banco: $dbname"
    
    # Sobrescreve a URL de conexão para o tenant atual
    export DATABASE_URL="$DB_BASE_URL/$dbname"
    
    echo "👉 Aplicando migrações (deploy)..."
    npx prisma migrate dev --schema=./prisma/schema.prisma --name auto
    
    if [ $? -eq 0 ]; then
        echo "✅ Banco $dbname atualizado com sucesso!"
    else
        echo "⚠️  FALHA ao atualizar $dbname. Verifique os logs imediatamente."
        # Interromper o script em caso de erro:
        exit 1 
    fi
done

echo "----------------------------------------------------"
echo "🏁 Processo de atualização finalizado!"