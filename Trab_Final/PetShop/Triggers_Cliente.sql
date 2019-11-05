create table  if not exists cli_audit (
	usuario varchar NOT NULL,
	data timestamp NOT NULL,
	id varchar NOT NULL,
	mudanca text NOT NULL,
	valor_antigo text NOT NULL,
	valor_novo text NOT NULL
);

CREATE OR REPLACE FUNCTION processo_cli_audit() RETURNS TRIGGER AS
$cli_audit$
	BEGIN
	-- Não permitir atualizar a chave primária
	IF (NEW.cpf <> OLD.cpf) THEN
		RAISE EXCEPTION 'Não é permitido atualizar o campo CPF do Cliente';
	END IF;
	-- Inserir linhas na tabela emp_audit para refletir as alterações realizada na tabela emp.
	IF (NEW.nome <> OLD.nome) THEN
		INSERT INTO cli_audit
			SELECT current_user, current_timestamp, NEW.cpf, 'Nome', OLD.nome, NEW.nome;
	END IF;
	IF (NEW.email <> OLD.email) THEN
		INSERT INTO cli_audit
			SELECT current_user, current_timestamp, NEW.cpf, 'Email', OLD.email, NEW.email;
	END IF;
	IF (NEW.endereco <> OLD.endereco) THEN
		INSERT INTO cli_audit
			SELECT current_user, current_timestamp, NEW.cpf, 'Endereco', OLD.endereco, NEW.endereco;
	END IF;
	IF (NEW.telefone <> OLD.telefone) THEN
		INSERT INTO cli_audit
			SELECT current_user, current_timestamp, NEW.cpf, 'Telefone', OLD.telefone, NEW.telefone;
	END IF;
	RETURN NULL; -- o resultado é ignorado uma vez que este é um gatilho AFTER
END;
$cli_audit$ language plpgsql;
	
	CREATE TRIGGER cli_audit
		AFTER UPDATE ON cliente
		FOR EACH ROW EXECUTE PROCEDURE processo_cli_audit();
		