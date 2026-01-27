-- CreateTable
CREATE TABLE "log_sistema" (
    "id" TEXT NOT NULL,
    "mensagem" VARCHAR(150) NOT NULL,
    "aplicacao" VARCHAR(100) NOT NULL,
    "detalhes" TEXT,
    "loglevel" INTEGER NOT NULL,
    "ref_tabela" VARCHAR(100),
    "ref_registro" VARCHAR(100),
    "metadata" JSONB,
    "data_criacao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "log_sistema_pkey" PRIMARY KEY ("id")
);
