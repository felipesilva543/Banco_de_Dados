-- Paciente(codpac, nome, endereço, telefone)

CREATE TABLE IF NOT EXISTS Paciente (
	cod_pac SERIAL NOT NULL,
	nome VARCHAR (30),
	endereco varchar (30),
	telefone varchar (11),
	CONSTRAINT Paciente_Pkey PRIMARY KEY (cod_pac)
);
 -- Medico(crm, nome, endereço, telefone, especialidade)
CREATE TABLE IF NOT EXISTS Medico (
	crm integer,
	nome VARCHAR (30),
	endereco varchar (30),
	telefone varchar (11),
	especialidade varchar (30),
	CONSTRAINT Medico_Pkey PRIMARY KEY (crm)
);

CREATE TABLE IF NOT EXISTS Convenio (
	cod_conv integer,
	nome VARCHAR (30),
	CONSTRAINT Convenio_Pkey PRIMARY KEY (cod_conv)
);

 -- Consulta(codconsulta, data, horário, medico, paciente, convenio, porcent)
CREATE TABLE IF NOT EXISTS Consulta (
	cod_cons SERIAL NOT NULL,
	dt_cons varchar (30),
	horario varchar (30),
	crm_med integer,
	cod_pac integer,
	cod_conv integer,
	porcent real,	
	CONSTRAINT Consulta_Pkey PRIMARY KEY (cod_cons),
	CONSTRAINT Consulta_Fkey FOREIGN KEY (crm_med) REFERENCES Medico (crm),
	CONSTRAINT Consulta_Fkey2 FOREIGN KEY (cod_pac) REFERENCES Paciente (cod_pac),
	CONSTRAINT Consulta_Fkey3 FOREIGN KEY (cod_conv) REFERENCES Convenio (cod_conv)
);

 -- Atende
CREATE TABLE IF NOT EXISTS Atende (
	crm_med integer,
	cod_conv integer,
	CONSTRAINT Atende_Pkey PRIMARY KEY (crm_med, cod_conv),
	CONSTRAINT Atende_Fkey FOREIGN KEY (crm_med) REFERENCES Medico (crm),
	CONSTRAINT Atende_Fkey2 FOREIGN KEY (cod_conv) REFERENCES Convenio (cod_conv)
);

 -- Possui(paciente, convenio, tipo, vencimento)
CREATE TABLE IF NOT EXISTS Possui (
	cod_pac integer,
	cod_conv integer,
	tipo varchar(30),
	vencimento varchar(30),
	CONSTRAINT Possui_Pkey PRIMARY KEY (cod_pac, cod_conv),
	CONSTRAINT Possui_Fkey FOREIGN KEY (cod_pac) REFERENCES Paciente (cod_pac),
	CONSTRAINT Possui_Fkey2 FOREIGN KEY (cod_conv) REFERENCES Convenio (cod_conv)
);
