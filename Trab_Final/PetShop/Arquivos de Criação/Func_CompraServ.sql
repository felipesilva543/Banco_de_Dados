drop function compraServ;
CREATE OR REPLACE FUNCTION compraServ(cpf_cliente varchar, cpf_funcF varchar,
									  id_servF integer, id_aniF integer)
RETURNS void AS $$
begin
	perform * from cliente where cpf = cpf_cliente;
		if found then
			perform * from funcionario where cpf_func = cpf_funcF;
				if found then
					perform * from servicos where id_serv = id_servF;
						if found then
							perform * from animais where cod_ani = id_aniF;
								if found then
									insert into compra_serv(cpf_cli, cpf_fun, id_serv, id_ani, data_compra, status)
													values (cpf_cliente, cpf_funcF, id_servF, id_aniF, current_date, 'NP');
									RAISE NOTICE 'Pedido cadastrado!';
								else
									raise exception 'Animal não consta no cadastro!';
								end if;
						else
							raise exception 'Serviço não conta no sistema!';
						end if;
				else
					raise exception 'Funcionário não consta no cadastro!';
				end if;
		else
			RAISE EXCEPTION 'Cliente não consta no cadastro!';
		end if;
end;
$$
LANGUAGE plpgsql SECURITY DEFINER;



select * from compra_serv;