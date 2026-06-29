CREATE SCHEMA store;
CREATE SCHEMA catalog;
CREATE SCHEMA base;

-- BASE TABLE WITH STANDARD COLUMNS
CREATE TABLE base.audit
(
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE store.users
(
    id              UUID                  DEFAULT gen_random_uuid(),
    name            VARCHAR(100) NOT NULL,
    email           VARCHAR(150) NOT NULL,
    hashed_password TEXT         NOT NULL,
    active          BOOLEAN      NOT NULL DEFAULT TRUE,
    role            VARCHAR(20)  NOT NULL,

    CONSTRAINT pk_users PRIMARY KEY (id),
    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT chk_users_role CHECK (role IN ('admin', 'seller', 'purchaser', 'stock_clerk'))
) INHERITS (base.audit);

CREATE TABLE store.addresses
(
    id       UUID DEFAULT gen_random_uuid(),
    street   VARCHAR(200) NOT NULL,
    city     VARCHAR(100) NOT NULL,
    state    CHAR(2)      NOT NULL,
    zip_code VARCHAR(9)   NOT NULL,

    CONSTRAINT pk_addresses PRIMARY KEY (id)
) INHERITS (base.audit);

CREATE TABLE store.stores
(
    id         UUID                  DEFAULT gen_random_uuid(),
    legal_name VARCHAR(200) NOT NULL,
    trade_name VARCHAR(200),
    cnpj       CHAR(14)     NOT NULL,
    active     BOOLEAN      NOT NULL DEFAULT TRUE,
    address_id UUID         NOT NULL,

    CONSTRAINT pk_stores PRIMARY KEY (id),
    CONSTRAINT uq_stores_cnpj UNIQUE (cnpj),
    CONSTRAINT fk_stores_address FOREIGN KEY (address_id) REFERENCES store.addresses (id)
) INHERITS (base.audit);

CREATE TABLE store.customers
(
    id    UUID DEFAULT gen_random_uuid(),
    name  VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone VARCHAR(20)  NOT NULL,

    CONSTRAINT pk_customers PRIMARY KEY (id),
    CONSTRAINT uq_customers_email UNIQUE (email),
    CONSTRAINT uq_customers_phone UNIQUE (phone)
) INHERITS (base.audit);

CREATE TABLE store.customer_addresses
(
    customer_id UUID NOT NULL,
    address_id  UUID NOT NULL,

    CONSTRAINT pk_customer_addresses PRIMARY KEY (customer_id, address_id),
    CONSTRAINT fk_customer_addresses_customer FOREIGN KEY (customer_id) REFERENCES store.customers (id) ON DELETE CASCADE,
    CONSTRAINT fk_customer_addresses_address FOREIGN KEY (address_id) REFERENCES store.addresses (id)
);

CREATE TABLE store.orders
(
    id          UUID        DEFAULT gen_random_uuid(),
    customer_id UUID           NOT NULL,
    address_id  UUID           NOT NULL,
    status      VARCHAR(20) DEFAULT 'pending',
    total       NUMERIC(10, 2) NOT NULL,

    CONSTRAINT pk_orders PRIMARY KEY (id),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES store.customers (id),
    CONSTRAINT fk_orders_address FOREIGN KEY (address_id) REFERENCES store.addresses (id),
    CONSTRAINT chk_orders_status CHECK ( status IN ('pending', 'paid', 'shipped', 'delivered', 'canceled') )
) INHERITS (base.audit);

CREATE TABLE catalog.products
(
    id          UUID DEFAULT gen_random_uuid(),
    description VARCHAR(200)   NOT NULL,
    unit_price  NUMERIC(10, 2) NOT NULL,
    stock       INT  DEFAULT 0,

    CONSTRAINT pk_products PRIMARY KEY (id),
    CONSTRAINT chk_products_stock CHECK (stock >= 0)
) INHERITS (base.audit);

CREATE TABLE store.order_products
(
    order_id   UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity   INT  NOT NULL,

    CONSTRAINT pk_order_products PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order_products_order FOREIGN KEY (order_id) REFERENCES store.orders (id),
    CONSTRAINT fk_order_products_product FOREIGN KEY (product_id) REFERENCES catalog.products (id),
    CONSTRAINT chk_order_products_quantity CHECK (quantity > 0)
);

-- FIX CONSTRAINT
ALTER TABLE store.order_products
    DROP CONSTRAINT fk_order_products_order;

ALTER TABLE store.order_products
    ADD CONSTRAINT fk_order_products_order FOREIGN KEY (order_id) REFERENCES store.orders (id) ON DELETE CASCADE;