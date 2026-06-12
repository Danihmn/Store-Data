CREATE SCHEMA loja;
CREATE SCHEMA catalogo;
CREATE SCHEMA base;

-- TABELA BASE COM COLUNAS PADRAO
CREATE TABLE base.auditoria
(
    criado_em     TIMESTAMP DEFAULT NOW(),
    atualizado_em TIMESTAMP DEFAULT NOW()
);

CREATE TABLE loja.clientes
(
    id       UUID DEFAULT gen_random_uuid(),
    nome     VARCHAR(100) NOT NULL,
    email    VARCHAR(150) NOT NULL,
    telefone VARCHAR(20),

    CONSTRAINT pk_clientes PRIMARY KEY (id),
    CONSTRAINT uq_clientes_email UNIQUE (email),
    CONSTRAINT uq_clientes_telefone UNIQUE (telefone)
) INHERITS (base.auditoria);

CREATE TABLE loja.enderecos
(
    id     UUID DEFAULT gen_random_uuid(),
    rua    VARCHAR(200) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2)      NOT NULL,
    cep    VARCHAR(9)   NOT NULL,

    CONSTRAINT pk_enderecos PRIMARY KEY (id)
) INHERITS (base.auditoria);

CREATE TABLE loja.clientes_enderecos
(
    cliente_id  UUID NOT NULL,
    endereco_id UUID NOT NULL,

    CONSTRAINT pk_clientes_enderecos PRIMARY KEY (cliente_id, endereco_id),
    CONSTRAINT fk_clientes_enderecos_cliente FOREIGN KEY (cliente_id) REFERENCES loja.clientes (id) ON DELETE CASCADE,
    CONSTRAINT fk_clientes_enderecos_endereco FOREIGN KEY (endereco_id) REFERENCES loja.enderecos (id)
);

CREATE TABLE loja.pedidos
(
    id          UUID        DEFAULT gen_random_uuid(),
    cliente_id  UUID           NOT NULL,
    endereco_id UUID           NOT NULL,
    status      VARCHAR(20) DEFAULT 'pendente',
    total       NUMERIC(10, 2) NOT NULL,

    CONSTRAINT pk_pedidos PRIMARY KEY (id),
    CONSTRAINT fk_cliente FOREIGN KEY (cliente_id) REFERENCES loja.clientes (id),
    CONSTRAINT fk_endereco FOREIGN KEY (endereco_id) REFERENCES loja.enderecos (id),
    CONSTRAINT chk_pedidos_status CHECK ( status IN ('pendente', 'pago', 'enviado', 'entregue', 'cancelado') )
) INHERITS (base.auditoria);

CREATE TABLE catalogo.produtos
(
    id             UUID DEFAULT gen_random_uuid(),
    descricao      VARCHAR(200)   NOT NULL,
    preco_unitario NUMERIC(10, 2) NOT NULL,
    estoque        INT  DEFAULT 0,

    CONSTRAINT pk_produtos PRIMARY KEY (id),
    CONSTRAINT chk_produtos_estoque CHECK (estoque >= 0)
) INHERITS (base.auditoria);

CREATE TABLE loja.produtos_pedidos
(
    pedido_id  UUID NOT NULL,
    produto_id UUID NOT NULL,
    quantidade INT  NOT NULL,

    CONSTRAINT pk_produtos_pedidos PRIMARY KEY (pedido_id, produto_id),
    CONSTRAINT fk_produtos_pedidos_pedido FOREIGN KEY (pedido_id) REFERENCES loja.pedidos (id),
    CONSTRAINT fk_produtos_pedidos_produto FOREIGN KEY (produto_id) REFERENCES catalogo.produtos (id),
    CONSTRAINT chk_produtos_pedidos_quantidade CHECK (quantidade > 0)
);

-- CORRIGE CONSTRAINT
ALTER TABLE loja.produtos_pedidos
    DROP CONSTRAINT fk_produtos_pedidos_pedido;

ALTER TABLE loja.produtos_pedidos
    ADD CONSTRAINT fk_produtos_pedidos_pedido FOREIGN KEY (pedido_id) REFERENCES loja.pedidos (id) ON DELETE CASCADE;