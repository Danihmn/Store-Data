CREATE OR REPLACE FUNCTION loja.fn_valida_estoque()
    RETURNS TRIGGER AS
$$
DECLARE
    estoque_atual INT;
BEGIN
    SELECT estoque
    INTO estoque_atual
    FROM catalogo.produtos
    WHERE id = NEW.produdo_id;

    IF estoque_atual < NEW.quantidade THEN
        RAISE EXCEPTION 'ESTOQUE INSUFICIENTE: Disponível %, solicitado %', estoque_atual, NEW.quantidade;
    END IF;

    RETURN NEW;
END ;
$$ LANGUAGE plpgsql