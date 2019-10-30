-- 1. Atualize o endereço do paciente João para ‘Rua do Bonde’;
	-- update Paciente set endereco = 'Rua do Bonde' where nome = 'João';
	
-- 2. Atualize os dados do medico Elias para ‘Rua Z’ e telefone ‘9838-7867’;
	--update Medico set endereco = 'Rua Z' where nome = 'Elias';
	--update Medico set telefone = '9838-7867' where nome = 'Elias';
	
-- 3. Atualize todos os tipos dos convênios que os pacientes possuem para ‘S’;
	-- update possui set tipo = 'S';	
	
-- 4. Exclua a informação que o paciente José tem o convenio 232;
	-- delete from possui where cod_conv = 232 and cod_pac = 2;
	
-- 5. Exclua a consulta realizada do dia 14/05/2013 as 14:00.
	-- delete from consulta where dt_cons = '14/05/2013' and horario = '14:00';
	
-- 6. Altere o nome da coluna especialidade, da tabela médico, para especialização.
		--alter table medico rename column especialidade to especializacao;
		

-- 7. Altere o tipo de dado da coluna nome, da tabela convenio, para varchar(200).
	-- alter table convenio alter column nome type VARCHAR (200);
	

-- 8. Acrescente a coluna Valor na tabela consulta e atualize todas as consultas para o valor de R$100,00.
	alter table consulta add valor real;
	update consulta set valor = 100;