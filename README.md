#  Recriando o Modulo Inventory do Data Warehouse AdventureWorks 2022. 

📌 **1. Objetivo do projeto**

Construir um Data Warehouse para o módulo Inventory do AdventureWorks 2022, replicando o fluxo OLTP → DW para permitir análises históricas e métricas de inventário de modo simplificado.

Este projeto foi desenvolvido com foco em:
- Criar e carregar tabelas de staging (stg_)
- Criar e carregar tabelas de Dimensão e Fato
- Aplicar transformações simples para padronização
- Utilizar MERGE para cargas
- Implementação de chaves surrogate (SK)
- Padronização de datas via DimDate

---

📌 **2. Ferramentas Utilizadas**

- SQL Server
- SQL Server Management Studio (SSMS)
- AdventureWorks 2022 OLTP (disponivel em :https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2022.bak)


---

📌 **3. Arquitetura do Projeto**

O DW foi construído seguindo um modelo dimensional no formato Star Schema, porém com características de Snowflake também, por conta da hierarquia de produtos.

Tabelas de Dimensão:
- DimProduct
- DimProductSubcategory
- DimProductCategory
- DimDate

Tabela de Fato:
- FactProductInventory

![Resultado final do Modelo Dimensional](./docs/Modelo_Dimensional.png)



---


📌 **4. Etapas**

**4.1 Localização e seleção dos dados no OLTP para compor o DW. **

- A estrutura do Data Warehouse original do AdventureWorks foi analisada usando como referencia: https://dataedo.com/samples/html/Data_warehouse/
- As tabelas do OLTP com dados relevantes para a construção do módulo Inventory foram mapeadas.
- Chaves primárias e os relacionamentos do modelo transacional foram identificados.

**4.2 Criação da tabela DimDate**

A primeira estrutura criada foi a DimDate, responsável por padronizar todas as datas usadas no DW.

Exemplo resumido da estrutura:

```sql

CREATE TABLE dbo.DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    DayNumberOfWeek TINYINT,
    DayNumberOfMonth TINYINT,
    MonthNumberOfYear TINYINT,
    CalendarYear SMALLINT
);

```


**4.3 Criação das tabelas de Staging (STG)**

Foram criadas tabelas intermediárias (staging) para as Dimensões para receber os dados brutos vindos do OLTP.
Essas tabelas serviram como camada temporária para armazenar, padronizar e validar os dados antes de carregá-los no DW.

Exemplo resumido da estrutura da STG de DimProduct:

```sql

CREATE TABLE stg.DimProduct (
    ProductAlternateKey NVARCHAR(25) NOT NULL,
    ProductSubcategoryKey INT NULL,
    EnglishProductName NVARCHAR(50) NULL,
    Color NVARCHAR(15) NULL,
    StandardCost MONEY NULL,
    SellStartDate DATETIME NULL,
    SellEndDate DATETIME NULL,
    Status NVARCHAR(20) NULL
);

```

**4.4 Criação das tabelas finais do Data Warehouse**

Após a camada STG, foram criadas as tabelas dimensionais finais.
Essas tabelas foram preparadas com suas surrogate keys, tipos de dados definitivos e a estrutura final do Schema.

Exemplo resumido da estrutura da DimProduct:

```sql

CREATE TABLE dbo.DimProduct (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductAlternateKey NVARCHAR(25) NOT NULL,
    ProductSubcategoryKey INT NULL,
    EnglishProductName NVARCHAR(50) NULL,
    Color NVARCHAR(15) NULL,
    StandardCost MONEY NULL,
    SellStartDate DATETIME NULL,
    SellEndDate DATETIME NULL,
    Status NVARCHAR(20) NULL
);

```

**4.5 Transformação e carga das tabelas STG**

Os dados foram carregados na camada STG utilizando processos de transform/load, incluindo:

- Ajuste de tipos
- Seleção das colunas relevantes
- Padronização de dados
- Preparação para integridade referencial

Exemplo resumido do Load da DimProduct:

```sql

DECLARE @LoadDate DATETIME = GETDATE();
INSERT INTO dbo.stg_DimProduct (
    ProductAlternateKey,
    ProductSubcategoryKey,
    StandardCost,
    FinishedGoodsFlag,
    Color,
    ListPrice,
    SellStartDate,
    SellEndDate
)
SELECT
    p.ProductNumber,
    p.ProductSubcategoryID,
    p.StandardCost,
    p.FinishedGoodsFlag,
    p.Color,
    p.ListPrice,
    p.SellStartDate,
    p.SellEndDate,
    CASE 
        WHEN p.SellEndDate < @LoadDate THEN 'Discontinued'
        ELSE 'Current'
    END
FROM Production.Product p
LEFT JOIN Production.ProductModel pm 
       ON p.ProductModelID = pm.ProductModelID
LEFT JOIN (
    SELECT pp.ProductID, pph.LargePhoto
    FROM Production.ProductProductPhoto pp
    JOIN Production.ProductPhoto pph 
         ON pp.ProductPhotoID = pph.ProductPhotoID
) ph ON p.ProductID = ph.ProductID;

```

**4.6 Carga das Dimensões usando MERGE**

Com as tabelas STG prontas, para realmente simular um DW sendo atualizado com novos dados, as dimensões finais foram alimentadas usando comandos MERGE, que permite:

- Inserir registros novos
- Evitar duplicidades
- Sincronizar as dimensões com as tabelas de origem

Exemplo resumido do MERGE da DimProduct:

```sql

MERGE DimProduct AS tgt
USING stg.DimProduct AS src
    ON tgt.ProductAlternateKey = src.ProductAlternateKey

WHEN MATCHED THEN
    UPDATE SET
        tgt.ProductSubcategoryKey = src.ProductSubcategoryKey,
        tgt.EnglishProductName    = src.EnglishProductName,
        tgt.Color                 = src.Color,
        tgt.StandardCost          = src.StandardCost,
        tgt.Status                = src.Status

WHEN NOT MATCHED THEN
    INSERT (
        ProductAlternateKey,
        ProductSubcategoryKey,
        EnglishProductName,
        Color,
        StandardCost,
        StartDate,
        EndDate,
        Status
    )
    VALUES (
        src.ProductAlternateKey,
        src.ProductSubcategoryKey,
        src.EnglishProductName,
        src.Color,
        src.StandardCost,
        GETDATE(),
        '9999-12-31',
        'Current'
    );

```

**4.7 Criação e carga da tabela de fato (FactProductInventory)**

Diferente das dimensões, a Fact foi criada sem passar pela camada STG, para simplificar o processo.
Ela foi carregada diretamente com um INSERT + JOIN entre:

- DimProduct
- DimDate

Exemplo resumido da Carga da Fact:

```sql

INSERT INTO dbo.FactProductInventory
(
    ProductKey,
    DateKey,
    MovementDate
)
SELECT 
    dp.ProductKey,
    dd.DateKey,
    dd.FullDateAlternateKey AS MovementDate
FROM dbo.DimProduct dp
CROSS JOIN dbo.DimDate dd
WHERE dd.FullDateAlternateKey BETWEEN '2010-01-01' AND '2014-12-31'
ORDER BY dp.ProductKey, dd.DateKey;

```

**4.8 Criação dos relacionamentos**

Por fim, foram criados os relacionamentos entre:

- FactProductInventory -> DimProduct
- FactProductInventory -> DimDate
- DimProduct -> DimProductSubcategory
- DimProductSubcategory -> DimProductCategory

Exemplo do relacionamento - DimDate <- FactProductInventory -> DimProduct:

```sql

ALTER TABLE dbo.FactProductInventory
ADD CONSTRAINT FK_FactProductInventory_Product
    FOREIGN KEY (ProductKey) REFERENCES dbo.DimProduct(ProductKey);

ALTER TABLE dbo.FactProductInventory
ADD CONSTRAINT FK_FactProductInventory_Date
    FOREIGN KEY (DateKey) REFERENCES dbo.DimDate(DateKey);

```

---


📌 **5. Regras de Negócio**

- Cada movimento pertence a um produto (ProductKey)
- Cada movimento pertence a um dia específico (DateKey)
- Integridade garantida via FK (ProductKey, DateKey)

---


📌 **6. Decisões de Modelagem**

- Colunas de tradução (Spanish, French, etc) como NULL nas dimensões: para reduzir volume e manter o foco apenas nos atributos necessários ao entendimento do fluxo ETL.
- Colunas NULL na Fact: refletindo ausência de dados completos no OLTP e para simplificar a modelagem, mas mantendo consistência do projeto.


📌 **7. Validações Realizadas**

- Conferência de granularidade da Fact
- Verificação de schema via `sp_help`
- Testes de integridade referencial (FKs)
- Conferência de duplicidades
- Confirmação de SKs funcionando

---

📌 **8. Estrutura do Repositório**

<pre> 
sql/
│
├── create_tables/
│   ├── create_tables.sql
│   └── create_tables_stg.sql
│
├── load/
│   ├── load_stg_dim_product.sql
│   ├── load_stg_dim_product_category.sql
│   ├── load_stg_dim_product_sub_category.sql
│   ├── load_dim_date.sql
│   └── load_fact_product_inventory.sql
│
├── merge/
│   ├── merge_dim_product.sql
│   ├── merge_dim_product_category.sql
│   └── merge_dim_product_sub_category.sql
│
└── constraints/
    ├── fk_dim_product_product_sub_category.sql
    ├── fk_dim_product_sub_category_category.sql
    └── fk_fact_product_inventory.sql
    
 </pre>

---

📌 **9. Aprendizados**

Durante o desenvolvimento deste DW, aprendi e pratiquei:

- Modelagem dimensional com linguagem SQL no SQL Server.
- Identificar e mapear dados no OLTP para modelar as tabelas do DW (OLAP).
- Criação de dimensões e fato, além do uso de chaves surrogate (IDENTITY).
- Construção e padronização de DimDate.
- Processo ETL completo: extração, transformação e carga.
- Como criar tabelas STG e usá-las como camada intermediária.
- Uso do comando MERGE para atualizar/insert na camada DW.
- Boas práticas de documentação para projetos de dados.


---

📌 **10. Próximos Passos**

- Expandir o DW para incluir novos módulos do AdventureWorks
- Criar dashboards analíticos (Power BI / Tableau) consumindo este DW

---

📌 **11. Referências**

 https://dataedo.com/samples/html/Data_warehouse/


---

📌 **12. Autor**

Leonardo Bonani<br>
Contato: www.linkedin.com/in/leonardo-bonani

---

