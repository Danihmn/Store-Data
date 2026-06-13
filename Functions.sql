CREATE OR REPLACE FUNCTION loja.fn_alterar_loja_ativo(loja_id UUID)
    RETURNS VOID AS
$$
BEGIN
    UPDATE loja.lojas
    SET ativo = NOT ativo
    WHERE id = loja_id;
END
$$ LANGUAGE plpgsql;