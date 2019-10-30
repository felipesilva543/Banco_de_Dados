-- Paciente

insert into paciente (nome, endereco, telefone) values ('João', 'Rua 1','9809-9756');
insert into paciente (nome, endereco, telefone) values ('José Rua', 'B', '3621-8978');
insert into paciente (nome, endereco, telefone) values ('Maria', 'Rua 10', '4567-9872');
insert into paciente (nome, endereco, telefone) values ('Joana', 'Rua J', '3343-9889');

-- Médico

insert into Medico (crm, Nome, Endereco, telefone, Especialidade)
			values (18739, 'Elias','Rua X', '8738-1221', 'Pediatria');
insert into Medico (crm, Nome, Endereco, telefone, Especialidade)
			values (7646, 'Ana', 'Av Z', '7829-1233', 'Obstetricia');
insert into Medico (crm, Nome, Endereco, telefone, Especialidade)
			values (39872, 'Pedro', 'Tv H', '9888-2333', 'Oftalmologia');

-- Convenio

insert into Convenio (cod_conv, Nome) values (189, 'Cassi');
insert into Convenio (cod_conv, Nome) values (232, 'Unimed');
insert into Convenio (cod_conv, Nome) values (454, 'Santa Clara');
insert into Convenio (cod_conv, Nome) values (908, 'Copassa');
insert into Convenio (cod_conv, Nome) values (435, 'São Lucas');

-- Consulta

insert into Consulta (dt_cons, horario, crm_med, cod_pac, cod_conv, porcent) 
			values ('10/05/2013', '10:00', 18739, 1, 189, 5);
insert into Consulta (dt_cons, horario, crm_med, cod_pac, cod_conv, porcent) 
			values ('12/05/2013', '10:00', 7646, 2, 232, 10);
insert into Consulta (dt_cons, horario, crm_med, cod_pac, cod_conv, porcent) 
			values ('12/05/2013', '11:00', 18739, 3, 908, 15);
insert into Consulta (dt_cons, horario, crm_med, cod_pac, cod_conv, porcent) 
			values ('13/05/2013', '10:00', 7646, 4, 435, 13);
insert into Consulta (dt_cons, horario, crm_med, cod_pac, cod_conv, porcent) 
			values ('14/05/2013', '13:00', 7646, 2, 232, 10);
insert into Consulta (dt_cons, horario, crm_med, cod_pac, cod_conv, porcent) 
			values ('14/05/2013', '14:00', 39872, 1, 189, 5);

-- Atende

insert into Atende (crm_med, cod_conv) values (18739, 189);
insert into Atende (crm_med, cod_conv) values (18739, 908);
insert into Atende (crm_med, cod_conv) values (7646, 232);
insert into Atende (crm_med, cod_conv) values (39872, 189);

-- Possui

insert into Possui (cod_pac, cod_conv, tipo, vencimento)
			values (1, 189, 'E', '31/12/2016');
insert into Possui (cod_pac, cod_conv, tipo, vencimento)
			values (2, 232, 'S', '31/12/2014');
insert into Possui (cod_pac, cod_conv, tipo, vencimento)
			values (3, 908, 'S', '31/12/2017');
insert into Possui (cod_pac, cod_conv, tipo, vencimento)
			values (4, 435, 'E', '31/12/2016');
insert into Possui (cod_pac, cod_conv, tipo, vencimento)
			values (1, 232, 'S', '31/12/2015');


