CREATE TRIGGER trg_verifica_estoque
    BEFORE INSERT ON loja.produtos_pedidos
    FOR EACH ROW EXECUTE FUNCTION loja.fn_valida_estoque();
