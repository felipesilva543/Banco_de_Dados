create table  if not exists Cliente (
	cpf varchar (15),
	nome varchar (70),
	endereco varchar (30),
	telefone varchar (30),
	email varchar (30),
	Constraint Cliente_Pkey Primary Key (cpf)
);

create table  if not exists Animais (
	cod_ani serial not null,
	nome varchar (70),
	tipo varchar (30),
	raca varchar (30),
	tamanho real,
	peso real,
	idade integer,
	cpf_cli varchar(30),
	Constraint Animais_Pkey Primary Key (cod_ani),
	Constraint Animais_Fkey Foreign Key (cpf_cli) References Cliente (cpf)
);

create table  if not exists Funcionario (
	cpf_func varchar (15),
	nome varchar (70),
	endereco varchar (30),
	telefone varchar (30),
	funcao varchar (30),
	salario real check (salario > 0),
	Constraint Funcionario_Pkey Primary Key (cpf_func)
);

create table  if not exists Servicos (
	id_serv serial not null,
	nome varchar (70),
	descricao varchar (300),
	valor real check (valor > 0),
	desconto real check (desconto >= 0 and desconto <= 1),
	Constraint Servicos_Pkey Primary Key (id_serv)
);

create table  if not exists Produtos (
	num_prod varchar (30),
	nome varchar (70),
	descricao varchar (300),
	qtd integer,
	valor real check (valor > 0),
	desconto real check (desconto >= 0 and desconto <= 1),
	Constraint Produtos_Pkey Primary Key (num_prod)
);

create table  if not exists Compra_Serv (
	id_compra serial not null,
	cpf_cli varchar (15),
	cpf_fun varchar (15),
	id_serv integer,
	id_ani integer,
	data_compra date,
	desconto real check (desconto >= 0 and desconto <= 1),
	Constraint Compra_Serv_Pkey Primary Key (id_compra),
	Constraint Compra_Serv_Fkey Foreign Key (cpf_cli) References Cliente (cpf),
	Constraint Compra_Serv_Fkey2 Foreign Key (cpf_fun) References Funcionario (cpf_func),
	Constraint Compra_Serv_Fkey3 Foreign Key (id_serv) References Servicos (id_serv),
	Constraint Compra_Serv_Fkey4 Foreign Key (id_ani) References Animais (cod_ani)
);

create table  if not exists Compra_Prod (
	id_compra serial not null,
	cpf_cli varchar (15),
	num_prod varchar (70),
	qtd integer,
	data_compra date,
	desconto real check (desconto >= 0 and desconto <= 1),
	Constraint Compra_Prod_Pkey Primary Key (id_compra),
	Constraint Compra_Prod_Fkey Foreign Key (cpf_cli) References Cliente (cpf),
	Constraint Compra_Prod_Fkey2 Foreign Key (num_prod) References Produtos (num_prod)
);


