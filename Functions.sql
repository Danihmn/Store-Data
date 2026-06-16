CREATE OR REPLACE FUNCTION loja.fn_valida_estoque()
    RETURNS TRIGGER AS
$$
DECLARE
    estoque_atual INT;
BEGIN
    SELECT estoque
    INTO estoque_atual
    FROM catalogo.produtos
    WHERE id = NEW.produto_id;

    IF estoque_atual < NEW.quantidade THEN
        RAISE EXCEPTION 'ESTOQUE INSUFICIENTE: Disponível %, solicitado %', estoque_atual, NEW.quantidade;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION catalogo.fn_decrementa_estoque()
    RETURNS TRIGGER AS
$$
BEGIN
    UPDATE catalogo.produtos
    SET estoque       = estoque - NEW.quantidade,
        atualizado_em = NOW()
    WHERE id = NEW.produto_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;