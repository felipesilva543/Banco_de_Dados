-- Autor(idautor, nome)

CREATE TABLE IF NOT EXISTS Autor (
	id_autor serial not null,
	nome varchar (80),
	CONSTRAINT Autor_Pkey PRIMARY KEY (id_autor)
);

-- Cliente(idcliente, nome, telefone)
CREATE TABLE IF NOT EXISTS Cliente (
	id_cli serial not null,
	nome varchar (80),
	telefone varchar(11),
	CONSTRAINT Cliente_Pkey PRIMARY KEY (id_cli)
);

-- Editora (ideditora, nome)
CREATE TABLE IF NOT EXISTS Editora (
	id_edit serial not null,
	nome varchar (80),
	CONSTRAINT Editora_Pkey PRIMARY KEY (id_edit)
);

-- Genero (idgenero, descricao)
CREATE TABLE IF NOT EXISTS Genero (
	id_gen serial not null,
	descricao varchar (200),
	CONSTRAINT Genero_Pkey PRIMARY KEY (id_gen)
);

-- Livro (idlivro, titulo, preco, estoque, idgenero, ideditora) (Obs.: idgenero e ideditora são chaves estrangeiras para as tabelas gênero e editora respectivamente)
CREATE TABLE IF NOT EXISTS Livro (
	id_liv serial not null,
	titulo varchar (80),
	preco real,
	estoque integer,
	id_gen integer,
	id_edit integer,
	CONSTRAINT Livro_Pkey PRIMARY KEY (id_liv),
	CONSTRAINT Livro_Fkey FOREIGN KEY (id_gen) REFERENCES Genero (id_gen),
	CONSTRAINT Livro_Fkey2 FOREIGN KEY (id_edit) REFERENCES Editora (id_edit)
);

-- Venda (idvenda, data, total, idcliente) (Obs.: idcliente é chave estrangeira para a tabela cliente)
CREATE TABLE IF NOT EXISTS Venda (
	id_venda serial not null,
	dt_venda date,
	total integer,
	id_cli integer,
	CONSTRAINT Venda_Pkey PRIMARY KEY (id_venda),
	CONSTRAINT Venda_Fkey FOREIGN KEY (id_cli) REFERENCES Cliente (id_cli)
);

-- Itens_da_venda(idvenda, idlivro, qtd, subtotal)
CREATE TABLE IF NOT EXISTS Itens_da_venda (
	id_venda serial not null,
	id_liv integer,
	qtd integer,
	subtotal real,
	CONSTRAINT Itens_da_venda_Fkey FOREIGN KEY (id_venda) REFERENCES Venda (id_venda),
	CONSTRAINT Itens_da_venda_Fkey2 FOREIGN KEY (id_liv) REFERENCES Livro (id_liv)
);

-- Escreve (idlivro, idautor) (Obs.: idlivro e idautor são chaves estrangeiras para as tabelas livro e autor respectivamente)
CREATE TABLE IF NOT EXISTS Escreve (
	id_escreve integer,
	id_autor integer,
	CONSTRAINT Escreve_Pkey PRIMARY KEY (id_escreve, id_autor),
	CONSTRAINT Escreve_Fkey FOREIGN KEY (id_escreve) REFERENCES Livro (id_liv),
	CONSTRAINT Escreve_Fkey2 FOREIGN KEY (id_autor) REFERENCES Autor (id_autor)
);


