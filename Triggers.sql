CREATE TRIGGER trg_verifica_estoque
    BEFORE INSERT
    ON loja.produtos_pedidos
    FOR EACH ROW
EXECUTE FUNCTION loja.fn_valida_estoque();

CREATE TRIGGER trg_decrementa_estoque
    AFTER INSERT
    ON loja.produtos_pedidos
    FOR EACH ROW
EXECUTE FUNCTION catalogo.fn_decrementa_estoque();