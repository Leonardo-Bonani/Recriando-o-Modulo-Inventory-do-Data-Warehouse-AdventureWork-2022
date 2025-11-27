#  Recriando o Modulo Inventory do Data Warehouse AdventureWork 2022. 

📌 1. Objetivo do projeto

Construir um Data Warehouse para o módulo Inventory do AdventureWorks 2022, replicando o fluxo OLTP → DW para permitir análises históricas e métricas de inventário de modo simplificado.

Este projeto foi desenvolvido com foco em:
- Criar e carregar tabelas de staging (stg_)
- Criar e carregar tabelas de Dimensão e Fato
- Aplicar transformações simples para padronização
- Utilizar MERGE para cargas
- Implementação de chaves surrogate (SK)
- Padronização de datas via DimDate

---

📌 2. Ferramentas Utilizadas

- **SQL Server**
- **SQL Server Management Studio (SSMS)**
- **AdventureWorks 2022 OLTP**

---

📌 3. Arquitetura do Projeto

O DW foi construído seguindo um modelo dimensional no formato Star Schema, porém com características de Snowflake também, por conta da hierarquia de produtos.

Tabelas de Dimensão:
DimProduct
DimProductSubcategory
DimProductCategory
DimDate

Tabela de Fato:
FactProductInventory

flowchart LR
    FactProductInventory --> DimProduct
    FactProductInventory --> DimDate
    DimProduct --> DimProductSubcategory
    DimProductSubcategory --> DimProductCategory

📌 4. Arquitetura do Projeto



##  Métricas e Regras de Negócio
A tabela FactProductInventory permite medir:
- Entradas de estoque (UnitIn)
- Saídas de estoque (UnitOut)
- Custo unitário
- Valor movimentado  
- Saldos por período  

Regras principais:
- Cada movimento pertence a um produto (ProductKey)
- Cada movimento pertence a um dia específico (DateKey)
- Mais de um movimento no mesmo dia é permitido
- Integridade garantida via FK (ProductKey, DateKey)

---

##  Validações Realizadas
- Verificação de schema via `sp_help`
- Conferência de granularidade da Fact
- Testes de integridade referencial (FKs)
- Conferência de duplicidades
- Confirmação de SKs funcionando
- Conferência de CHECK e DEFAULT (quando aplicável)

---

##   Estrutura do Repositório
 AdventureWorksDW_Project
┣ sql
┃ ┣ create_tables.sql
┃ ┣ load_dim_product.sql
┃ ┣ load_dim_date.sql
┃ ┣ load_fact_product_inventory.sql
┃ ┗ views.sql
┣ docs
┃ ┗ arquitetura_dw.png
┗ README.md



---

##   Resultados
O projeto demonstra:
- Conhecimento completo em modelagem dimensional  
- Criação de uma solução DW funcional  
- Domínio de processos de carga com MERGE  
- Capacidade de validar regras e integridade  
- Entendimento da arquitetura AdventureWorks  

---

##   Autor
**Seu Nome** – Desenvolvedor de Dados  
 Contato: *seu email ou LinkedIn*  

---

