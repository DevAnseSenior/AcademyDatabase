select * from crosstab(
    $$
    select pg.nome,
    ano.mes,
    coalesce (sum(si.quant) filter (where to_char(s.data, 'mm')::integer = ano.mes), 0) as total from produto_grupo pg
        inner join produto p on p.id_produto_grupo=pg.id
        inner join venda_item vi on p.id=vi.id_produto
        inner join venda v on vi.id_venda =v.id 
        cross join (select * from gen_series(1,12) mes) ano
    where date_part('year', s.date)= 2019
    group by 1, 2
    order by 1, 2
    $$,
    $$
        select * from gen_series(1,12) order by 1
    $$) as (name varchar, JAN numeric, FEV numeric, MAR numeric, ABR numeric, MAI numeric, JUN numeric, JUL numeric, AGO numeric, SET_ numeric, OUT_ numeric, NOV numeric, DEZ numeric)