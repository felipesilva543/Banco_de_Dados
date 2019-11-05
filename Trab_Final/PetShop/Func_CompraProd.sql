drop function compraProd;
CREATE OR REPLACE FUNCTION compraProd(cpf_cliente varchar, num_produto varchar, qtdF int)
RETURNS void AS $$
begin
	perform * from cliente where cpf = cpf_cliente;
		if found then
			perform * from produtos where qtd >= qtdF and num_prod = num_produto;
			if found then
				insert into compra_prod(cpf_cli, num_prod, qtd, data_compra, status)
								values (cpf_cliente, num_produto, qtdF, current_date, 'NP');
				RAISE NOTICE 'Pedido cadastrado!';
			else
				RAISE EXCEPTION 'Quantidade de produto indisponivel!';
			end if;
		else
			RAISE EXCEPTION 'Cliente não consta no cadastro!';
		end if;
end;
$$
LANGUAGE plpgsql SECURITY DEFINER;

select * from produtos P, cliente C;
select * from compra_prod;
update produtos set qtd = 5 where num_prod = '123';
select compraProd('111', '123', 2, 0);