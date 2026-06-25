CREATE TRIGGER trg_check_stock
    BEFORE INSERT
    ON store.order_products
    FOR EACH ROW
EXECUTE FUNCTION store.fn_validate_stock();

CREATE TRIGGER trg_decrement_stock
    AFTER INSERT
    ON store.order_products
    FOR EACH ROW
EXECUTE FUNCTION catalog.fn_decrement_stock();