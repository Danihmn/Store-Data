-- =========================================================
-- MIGRAÇÃO PT -> EN
-- Ordem: schemas -> tabelas -> colunas -> constraints
-- Observações:
--   * "base" já está em inglês, mantido sem alteração
--   * "cnpj" mantido como está (identificador fiscal BR, sem tradução direta)
--   * Colunas herdadas (criado_em/atualizado_em) são renomeadas só na tabela base
--     e o rename é propagado automaticamente para as tabelas filhas
-- =========================================================

-- 1) SCHEMAS -------------------------------------------------
ALTER SCHEMA loja RENAME TO store;
ALTER SCHEMA catalogo RENAME TO catalog;

-- 2) TABELAS ---------------------------------------------------
ALTER TABLE base.auditoria
    RENAME TO audit;
ALTER TABLE store.enderecos
    RENAME TO addresses;
ALTER TABLE store.lojas
    RENAME TO stores;
ALTER TABLE store.clientes
    RENAME TO customers;
ALTER TABLE store.clientes_enderecos
    RENAME TO customer_addresses;
ALTER TABLE store.pedidos
    RENAME TO orders;
ALTER TABLE catalog.produtos
    RENAME TO products;
ALTER TABLE store.produtos_pedidos
    RENAME TO order_products;

-- 3) COLUNAS ---------------------------------------------------

-- base.audit (propaga para todas as filhas)
ALTER TABLE base.audit
    RENAME COLUMN criado_em TO created_at;
ALTER TABLE base.audit
    RENAME COLUMN atualizado_em TO updated_at;

-- store.addresses
ALTER TABLE store.addresses
    RENAME COLUMN rua TO street;
ALTER TABLE store.addresses
    RENAME COLUMN cidade TO city;
ALTER TABLE store.addresses
    RENAME COLUMN estado TO state;
ALTER TABLE store.addresses
    RENAME COLUMN cep TO zip_code;

-- store.stores
ALTER TABLE store.stores
    RENAME COLUMN razao_social TO legal_name;
ALTER TABLE store.stores
    RENAME COLUMN nome_fantasia TO trade_name;
ALTER TABLE store.stores
    RENAME COLUMN ativo TO active;
ALTER TABLE store.stores
    RENAME COLUMN id_endereco TO address_id;

-- store.customers
ALTER TABLE store.customers
    RENAME COLUMN nome TO name;
ALTER TABLE store.customers
    RENAME COLUMN telefone TO phone;

-- store.customer_addresses
ALTER TABLE store.customer_addresses
    RENAME COLUMN cliente_id TO customer_id;
ALTER TABLE store.customer_addresses
    RENAME COLUMN endereco_id TO address_id;

-- store.orders
ALTER TABLE store.orders
    RENAME COLUMN cliente_id TO customer_id;
ALTER TABLE store.orders
    RENAME COLUMN endereco_id TO address_id;

-- catalog.products
ALTER TABLE catalog.products
    RENAME COLUMN descricao TO description;
ALTER TABLE catalog.products
    RENAME COLUMN preco_unitario TO unit_price;
ALTER TABLE catalog.products
    RENAME COLUMN estoque TO stock;

-- store.order_products
ALTER TABLE store.order_products
    RENAME COLUMN pedido_id TO order_id;
ALTER TABLE store.order_products
    RENAME COLUMN produto_id TO product_id;
ALTER TABLE store.order_products
    RENAME COLUMN quantidade TO quantity;

-- 4) CONSTRAINTS -------------------------------------------------

-- store.addresses
ALTER TABLE store.addresses
    RENAME CONSTRAINT pk_enderecos TO pk_addresses;

-- store.stores
ALTER TABLE store.stores
    RENAME CONSTRAINT pk_lojas TO pk_stores;
ALTER TABLE store.stores
    RENAME CONSTRAINT uq_lojas_cnpj TO uq_stores_cnpj;
ALTER TABLE store.stores
    RENAME CONSTRAINT fk_lojas_endereco TO fk_stores_address;

-- store.customers
ALTER TABLE store.customers
    RENAME CONSTRAINT pk_clientes TO pk_customers;
ALTER TABLE store.customers
    RENAME CONSTRAINT uq_clientes_email TO uq_customers_email;
ALTER TABLE store.customers
    RENAME CONSTRAINT uq_clientes_telefone TO uq_customers_phone;

-- store.customer_addresses
ALTER TABLE store.customer_addresses
    RENAME CONSTRAINT pk_clientes_enderecos TO pk_customer_addresses;
ALTER TABLE store.customer_addresses
    RENAME CONSTRAINT fk_clientes_enderecos_cliente TO fk_customer_addresses_customer;
ALTER TABLE store.customer_addresses
    RENAME CONSTRAINT fk_clientes_enderecos_endereco TO fk_customer_addresses_address;

-- store.orders
ALTER TABLE store.orders
    RENAME CONSTRAINT pk_pedidos TO pk_orders;
ALTER TABLE store.orders
    RENAME CONSTRAINT fk_cliente TO fk_orders_customer;
ALTER TABLE store.orders
    RENAME CONSTRAINT fk_endereco TO fk_orders_address;
ALTER TABLE store.orders
    RENAME CONSTRAINT chk_pedidos_status TO chk_orders_status;

-- catalog.products
ALTER TABLE catalog.products
    RENAME CONSTRAINT pk_produtos TO pk_products;
ALTER TABLE catalog.products
    RENAME CONSTRAINT chk_produtos_estoque TO chk_products_stock;

-- store.order_products
ALTER TABLE store.order_products
    RENAME CONSTRAINT pk_produtos_pedidos TO pk_order_products;
ALTER TABLE store.order_products
    RENAME CONSTRAINT fk_produtos_pedidos_pedido TO fk_order_products_order;
ALTER TABLE store.order_products
    RENAME CONSTRAINT fk_produtos_pedidos_produto TO fk_order_products_product;
ALTER TABLE store.order_products
    RENAME CONSTRAINT chk_produtos_pedidos_quantidade TO chk_order_products_quantity;