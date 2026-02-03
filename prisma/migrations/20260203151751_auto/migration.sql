-- CreateTable
CREATE TABLE "BackofficeUser" (
    "id" UUID NOT NULL,
    "fullName" VARCHAR(255),
    "email" VARCHAR(255),
    "externalIdpId" VARCHAR(255),
    "role" SMALLINT,
    "status" SMALLINT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BackofficeUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InsurerTenant" (
    "id" UUID NOT NULL,
    "name" VARCHAR(255),
    "tradeName" VARCHAR(255),
    "federalDocument" VARCHAR(20),
    "dbRef" VARCHAR(50),
    "status" SMALLINT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "InsurerTenant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Product" (
    "id" UUID NOT NULL,
    "insurerTenantId" UUID NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "productTypeId" SMALLINT,
    "pricingRuleId" UUID,
    "status" SMALLINT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InsurerTenantProduct" (
    "id" UUID NOT NULL,
    "insurerTenantId" UUID NOT NULL,
    "productId" UUID,
    "metadata" JSONB,

    CONSTRAINT "InsurerTenantProduct_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Coverage" (
    "id" UUID NOT NULL,
    "code" VARCHAR(20),
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "baseTax" DECIMAL(10,6),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Coverage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductCoverage" (
    "id" UUID NOT NULL,
    "productId" UUID,
    "coverageId" UUID,
    "metadata" JSONB,

    CONSTRAINT "ProductCoverage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PricingRule" (
    "id" UUID NOT NULL,
    "ruleJson" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PricingRule_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "BackofficeUser_email_key" ON "BackofficeUser"("email");

-- CreateIndex
CREATE UNIQUE INDEX "BackofficeUser_externalIdpId_key" ON "BackofficeUser"("externalIdpId");

-- CreateIndex
CREATE UNIQUE INDEX "InsurerTenant_dbRef_key" ON "InsurerTenant"("dbRef");

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_insurerTenantId_fkey" FOREIGN KEY ("insurerTenantId") REFERENCES "InsurerTenant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_pricingRuleId_fkey" FOREIGN KEY ("pricingRuleId") REFERENCES "PricingRule"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InsurerTenantProduct" ADD CONSTRAINT "InsurerTenantProduct_insurerTenantId_fkey" FOREIGN KEY ("insurerTenantId") REFERENCES "InsurerTenant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InsurerTenantProduct" ADD CONSTRAINT "InsurerTenantProduct_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductCoverage" ADD CONSTRAINT "ProductCoverage_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductCoverage" ADD CONSTRAINT "ProductCoverage_coverageId_fkey" FOREIGN KEY ("coverageId") REFERENCES "Coverage"("id") ON DELETE SET NULL ON UPDATE CASCADE;
