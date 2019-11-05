------------------------------
---------- Clientes ----------
------------------------------

--insert into cliente values('111', 'Felipe', 'f@gmail.com', '1234', 'rua 1');
--insert into cliente values('222', 'Iury', 'i@gmail.com', '4321', 'rua 2');
--update Cliente set endereco = 'Rua Z' where cpf = '111';

select * from cliente;

insert into Cliente values('333', 'Camila', 'c@gmail.com', '9876', 'rua 3');
insert into Cliente values('444', 'Rafaela', 'r@gmail.com', '6789', 'rua 4');
update Cliente set endereco = 'Rua X' where cpf = '222';
update Cliente set email = 'r@hotmail.com' where cpf = '444';


select * from cliente;
select * from cli_audit; -- Empregados - Animais - Produtos - Serviços
-- select * from emp_audit; | select * from prod_audit; | select * from serv_audit; | select * from ani_audit;
select * from funcionarios_log;

-----------------------------
---------- Animais ----------
-----------------------------
/*insert into Animais(nome, tipo, raca, tamanho, peso, idade, cpf_cli) 
			values('Rex', 'Cachorro', 'Pug', 0.4, 15, 6, '111');
insert into Animais(nome, tipo, raca, tamanho, peso, idade, cpf_cli) 
			values('Tobi', 'Cachorro', 'Pastor Alemão', 1.5, 45, 12, '222');*/

select * from animais;			
update Animais set tamanho = 0.5 where cod_ani = 4;
select * from ani_audit;

----------------------------------
---------- Funcionarios ----------
----------------------------------
--insert into funcionario values ('456', 'Raul', 'Rua R', '8525', 'Secretário', 1004);
--insert into funcionario values ('984', 'Lais', 'Rua T', '8452', 'Tosa & Banho', 2008);
select * from funcionario;

------------------------------
---------- Produtos ----------
------------------------------

--insert into Produtos values('111', 'Coleira', 'Acessórios para animais', 10, 2, 0);
--insert into Produtos values('222', 'Bola', 'Acessórios para animais', 10, 2, 0.1);

select * from produtos;

------------------------------
---------- Servicos ----------
------------------------------
/*insert into Servicos values(default, 'Tosa', 'Cortar pelo do animal', 50, 0);
insert into servicos values(default, 'Banho 1', 'Banho com shampoo', 40, 0);
insert into servicos values(default, 'Banho 2', 'Banho com shampoo e anti pugas', 60, 0.1);*/
--update Servicos set desconto = 0.1 where id_serv = 4;

select * from serv_audit;
select * from servicos;

---------------------------------------
---------- Comprar Prod/Serv ----------
---------------------------------------
/*
select compraProd('111', '111', 2);
select compraServ('111', '984', 5, 4);*/

select * from compra_prod;
select * from compra_serv;

-- compraProd(cpf_cliente, num_produto, qtdF)
select compraProd('222', '111', 3);
select compraProd('222', '222', 3);
--compraServ(cpf_cliente, cpf_funcF, id_servF, id_aniF)
select compraServ('111', '984', 2, 4);

select * from compra_prod;
select * from compra_serv;

--finalizarCompraServ(cpf_cliente, descontoF)
select * from finalizarCompraProd('222', 0);
select * from finalizarCompraServ('111', 0);

select * from produtos;
select * from servicos;

