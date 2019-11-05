drop function finalizarCompraProd;
CREATE OR REPLACE FUNCTION finalizarCompraProd(cpf_cliente varchar, descontoF double precision)
RETURNS TABLE(id_compra integer, num_prod character varying (70), qtd integer, valorC double precision, valorCompra double precision ) AS $$
declare
	valorTCompra double precision;
	prod_rec	RECORD;
begin	
	DROP TABLE IF EXISTS _tmpComprasProd;
	create temporary table _tmpComprasProd as select CP.id_compra, CP.num_prod, CP.qtd, ((CP.qtd * (Pr.valor - (Pr.valor * Pr.desconto))) ) AS ValorC
		from compra_prod CP, produtos Pr where
			cpf_cli = '111' and 
			CP.num_prod = Pr.num_prod and
			CP.status = 'NP' and
			CP.data_compra = current_date;

	EXECUTE 'select sum(ValorC) from _tmpComprasProd' into valorTCompra;
	raise notice 'Valor total: %', (valorTCompra - (valorTCompra * descontoF));
	
		for prod_rec in select * from _tmpComprasProd tmp loop
			raise notice 'Qtd: %', prod_rec.qtd;
			update "produtos" AS P
				set 
					"qtd" = (P.qtd - prod_rec.qtd)
				where P.num_prod = prod_rec.num_prod;
		end loop;
		
		for prod_rec in select * from _tmpComprasProd tmp loop
			raise notice 'Id Compra: %', prod_rec.id_compra;
			update "compra_prod" AS CP
				set 
					"status" = 'PG'
					where CP.id_compra = prod_rec.id_compra;
		end loop;
	
		return QUERY SELECT
						CP.id_compra,
						CP.num_prod,
						CP.qtd,
						cp.ValorC,
						(valorTCompra - (valorTCompra * descontoF))
						FROM _tmpComprasProd CP;
end;
$$
LANGUAGE plpgsql SECURITY DEFINER;

select * from compra_prod; where status = 'NP';
select * from finalizarCompraProd('111', 0);

------------------------------------------------------------------------
drop function finalizarCompraServ;
CREATE OR REPLACE FUNCTION finalizarCompraServ(cpf_cliente varchar, descontoF double precision)
RETURNS TABLE(id_compra integer, id_serv integer, valorC real, valorCompra double precision ) AS $$
declare
	valorTCompra double precision;
	serv_rec	RECORD;
begin	
	DROP TABLE IF EXISTS _tmpComprasServ;
	create temporary table _tmpComprasServ as select CS.id_compra, CS.id_serv, ((S.valor - (S.valor * S.desconto))) AS ValorC
		from compra_serv CS, Servicos S where
			CS.cpf_cli = '111' and
			CS.id_serv = S.id_serv and
			status = 'NP' and
			CS.data_compra = '2019-11-01'; --current_date;
						
	EXECUTE 'select sum(ValorC) from _tmpComprasServ' into valorTCompra;
	raise notice 'Valor total: %', (valorTCompra - (valorTCompra * descontoF));
		
		for serv_rec in select * from _tmpComprasServ loop
			raise notice 'Id Serv: %', serv_rec.id_serv;
			update "compra_serv" AS CP
				set 
					"status" = 'PG'
					where CP.id_compra = serv_rec.id_compra;
		end loop;
		
		return QUERY SELECT
						CS.id_compra,
						CS.id_serv,
						CS.ValorC,
						(valorTCompra - (valorTCompra * descontoF))
						FROM _tmpComprasServ CS;
end;
$$
LANGUAGE plpgsql SECURITY DEFINER;

select * from finalizarCompraServ('111', 0);
