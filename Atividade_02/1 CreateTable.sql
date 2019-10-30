CREATE TABLE IF NOT EXISTS Curso (
	num_curso serial NOT null,
	nome varchar (30),
	total_Cred integer,
	CONSTRAINT Curso_Pkey PRIMARY KEY (num_curso)
);

CREATE TABLE IF NOT EXISTS Disciplina (
	num_disc serial NOT null,
	nome varchar (30),
	qtd_Cred integer,
	CONSTRAINT Disciplina_Pkey PRIMARY KEY (num_disc)
);

CREATE TABLE IF NOT EXISTS Contem (
	num_curso integer,
	num_disc integer,
	CONSTRAINT Contem_Pkey PRIMARY KEY (num_curso, num_Disc),
	CONSTRAINT Contem_Fkey FOREIGN KEY (num_curso) REFERENCES Curso (num_curso),
	CONSTRAINT Contem_Fkey2 FOREIGN KEY (num_disc) REFERENCES Disciplina (num_disc)
);

CREATE TABLE IF NOT EXISTS Aluno (
	num_alu serial NOT null,
	nome varchar (70),
	endereco varchar (200),
	cidade varchar (20),
	telefone varchar (20),
	num_curso integer,
	CONSTRAINT Aluno_Pkey PRIMARY KEY (num_alu),
	CONSTRAINT Aluno_Fkey FOREIGN KEY (num_curso) REFERENCES Curso (num_curso)
);

CREATE TABLE IF NOT EXISTS Professor (
	num_prof serial NOT null,
	nome varchar (70),
	area_pes varchar (200),
	CONSTRAINT Professor_Pkey PRIMARY KEY (num_prof)
);

CREATE TABLE IF NOT EXISTS Aula (
	semestre integer,
	nota real,
	num_alu integer,
	num_prof integer,
	num_disc integer,
	CONSTRAINT Aula_Fkey FOREIGN KEY (num_alu) REFERENCES Aluno (num_alu),
	CONSTRAINT Aula_Fkey2 FOREIGN KEY (num_prof) REFERENCES Professor (num_prof),
	CONSTRAINT Aula_Fkey3 FOREIGN KEY (num_disc) REFERENCES Disciplina (num_disc)
);



