-- Criando tabela
CREATE TABLE venda (
	id serial NOT NULL,
	id_cliente int(4) NOT NULL,
	id_rel int(4) NOT NULL,
	id_funcionario int(4) NOT NULL,
	"data" timestamp(6) NOT NULL,
	ativo bool NOT NULL DEFAULT true
	criado_em timestamp NOT NULL DEFAULT now(),
	modificado_em timestamp NOT NULL DEFAULT now()
) partition by range(data);

-- chaves estrangeiras
ALTER TABLE venda ADD CONSTRAINT fk_venda_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id);
ALTER TABLE venda ADD CONSTRAINT fk_venda_rel FOREIGN KEY (id_rel) REFERENCES rel(id);
ALTER TABLE venda ADD CONSTRAINT fk_venda_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario(id);

select min(data) from venda v  
select max(data) from venda v

do
$$
declare
	ano integer;
	cd_create varchar default '';
begin
	for ano in 1970..2021 loop
		cd_create := format('create table venda_%s partition of venda for values from (%s) to (%s);',
			ano,
			quote_literal(concat(ano,'-01-01 00:00:00')),
			quote_literal(concat(ano, '-12-31 23:59:59.999999')));
			execute cd_create;
	end loop;
end	
$$
-- Passando informações
do
$$
declare 
	consulta record;
begin 
	for consulta in select * from venda loop
		INSERT INTO venda
			(id, id_cliente, id_rel, id_funcionario, "data", criado_em, modificado_em, ativo)
			VALUES(consulta.id, consulta.id_cliente, consulta.id_rel, consulta.id_funcionario,
				consulta.data, consulta.criado_em, consulta.modificado_em, consulta.ativo);
	end loop;
end
$$
select * from venda;