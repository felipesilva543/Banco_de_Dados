create table  if not exists ani_audit (
	usuario varchar NOT NULL,
	data timestamp NOT NULL,
	id integer NOT NULL,
	mudanca text NOT NULL,
	valor_antigo text NOT NULL,
	valor_novo text NOT NULL
);

CREATE OR REPLACE FUNCTION processo_ani_audit() RETURNS TRIGGER AS
$ani_audit$
	BEGIN
	-- Não permitir atualizar a chave primária
	IF (NEW.cod_ani <> OLD.cod_ani) THEN
		RAISE EXCEPTION 'Não é permitido atualizar o campo Código do Animal';
	END IF;
	-- Inserir linhas na tabela emp_audit para refletir as alterações realizada na tabela emp.
	IF (NEW.tipo <> OLD.tipo) THEN
		INSERT INTO ani_audit
			SELECT current_user, current_timestamp, NEW.cod_ani, 'Tipo', OLD.tipo, NEW.tipo;
	END IF;
	IF (NEW.raca <> OLD.raca) THEN
		INSERT INTO ani_audit
			SELECT current_user, current_timestamp, NEW.cod_ani, 'Raça', OLD.raca, NEW.raca;
	END IF;
	IF (NEW.nome <> OLD.nome) THEN
		INSERT INTO ani_audit
			SELECT current_user, current_timestamp, NEW.cod_ani, 'Nome', OLD.nome, NEW.nome;
	END IF;
	IF (NEW.tamanho <> OLD.tamanho) THEN
		INSERT INTO ani_audit
			SELECT current_user, current_timestamp, NEW.cod_ani, 'Tamanho', OLD.tamanho, NEW.tamanho;
	END IF;
	IF (NEW.peso <> OLD.peso) THEN
		INSERT INTO ani_audit
			SELECT current_user, current_timestamp, NEW.cod_ani, 'Peso', OLD.peso, NEW.peso;
	END IF;
	IF (NEW.idade <> OLD.idade) THEN
		INSERT INTO ani_audit
			SELECT current_user, current_timestamp, NEW.cod_ani, 'Idade', OLD.idade, NEW.idade;
	END IF;
	IF (NEW.cpf_cli <> OLD.cpf_cli) THEN
		INSERT INTO ani_audit
			SELECT current_user, current_timestamp, NEW.cod_ani, 'CPF Cliente', OLD.cpf_cli, NEW.cpf_cli;
	END IF;
	RETURN NULL; -- o resultado é ignorado uma vez que este é um gatilho AFTER
END;
$ani_audit$ language plpgsql;
	
	CREATE TRIGGER ani_audit
		AFTER UPDATE ON animais
		FOR EACH ROW EXECUTE PROCEDURE processo_ani_audit();
		
		
		