CREATE OR REPLACE VIEW vw_clientes_status_pendente AS
SELECT loja.clientes.nome, loja.pedidos.total
FROM loja.pedidos
         JOIN loja.clientes ON loja.pedidos.cliente_id = loja.clientes.id
WHERE loja.pedidos.status = 'pendente';

CREATE OR REPLACE VIEW vw_pedidos_cliente AS
SELECT loja.clientes.nome AS nome_cliente, COUNT(loja.pedidos.id) AS total_pedidos
FROM loja.clientes
         LEFT JOIN loja.pedidos ON loja.clientes.id = loja.pedidos.cliente_id
GROUP BY nome_cliente
ORDER BY total_pedidos DESC;

CREATE OR REPLACE VIEW vw_clientes_enderecos AS
SELECT loja.clientes.nome AS nome_cliente, COUNT(loja.clientes_enderecos.endereco_id) AS total_enderecos
FROM loja.clientes
         JOIN loja.clientes_enderecos ON loja.clientes_enderecos.cliente_id = loja.clientes.id
GROUP BY nome_cliente
HAVING COUNT(loja.clientes_enderecos.endereco_id) > 1;