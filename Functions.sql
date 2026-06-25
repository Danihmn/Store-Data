CREATE OR REPLACE FUNCTION store.fn_validate_stock()
    RETURNS TRIGGER AS
$$
DECLARE
    current_stock INT;
BEGIN
    SELECT stock
    INTO current_stock
    FROM catalog.products
    WHERE id = NEW.product_id;

    IF current_stock < NEW.quantity THEN
        RAISE EXCEPTION 'INSUFFICIENT STOCK: Available %, requested %', current_stock, NEW.quantity;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION catalog.fn_decrement_stock()
    RETURNS TRIGGER AS
$$
BEGIN
    UPDATE catalog.products
    SET stock      = stock - NEW.quantity,
        updated_at = NOW()
    WHERE id = NEW.product_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;