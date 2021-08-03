alter table venda_item add column preco_unit numeric;

do
$$
    declare
        produto record;
        cd_update varchar default '';
    begin
$$
    create or replace function fn_insert_preco_unit_venda_item() returns trigger as
$$
    begin
        new.preco_unit := (select preco_venda from produto where id=new.id_produto);
        return new;
    end

-- trigger
create trigger tg_insert_preco_unit_venda_item
	alter insert on venda_item
	for each row
	execute function fn_insert_preco_unit_venda_item();