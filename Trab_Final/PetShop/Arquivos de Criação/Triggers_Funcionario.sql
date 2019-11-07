create table  if not exists emp_audit (
	usuario varchar NOT NULL,
	data timestamp NOT NULL,
	id integer NOT NULL,
	mudanca text NOT NULL,
	valor_antigo text NOT NULL,
	valor_novo text NOT NULL
);

CREATE OR REPLACE FUNCTION processo_emp_audit() RETURNS TRIGGER AS
$emp_audit$
	BEGIN
	-- Não permitir atualizar a chave primária
	IF (NEW.cpf_func <> OLD.cpf_func) THEN
		RAISE EXCEPTION 'Não é permitido atualizar o campo CPF do funcionário';
	END IF;
	-- Inserir linhas na tabela emp_audit para refletir as alterações realizada na tabela emp.
	IF (NEW.nome <> OLD.nome) THEN
		INSERT INTO emp_audit 
			SELECT current_user, current_timestamp, NEW.cpf_func, 'Nome', OLD.nome, NEW.nome;
	END IF;
	IF (NEW.salario <> OLD.salario) THEN
		INSERT INTO emp_audit
			SELECT current_user, current_timestamp, NEW.cpf_func, 'Salario', OLD.salario, NEW.salario;
	END IF;
	IF (NEW.endereco <> OLD.endereco) THEN
		INSERT INTO emp_audit
			SELECT current_user, current_timestamp, NEW.cpf_func, 'Endereco', OLD.endereco, NEW.endereco;
	END IF;
	IF (NEW.telefone <> OLD.telefone) THEN
		INSERT INTO emp_audit
			SELECT current_user, current_timestamp, NEW.cpf_func, 'Telefone', OLD.telefone, NEW.telefone;
	END IF;
	IF (NEW.funcao <> OLD.funcao) THEN
		INSERT INTO emp_audit
			SELECT current_user, current_timestamp, NEW.cpf_func, 'Funcao', OLD.funcao, NEW.funcao;
	END IF;	
	RETURN NULL; -- o resultado é ignorado uma vez que este é um gatilho AFTER
	END;
	$emp_audit$ language plpgsql;
	
	CREATE TRIGGER emp_audit
		AFTER UPDATE ON funcionario
		FOR EACH ROW EXECUTE PROCEDURE processo_emp_audit();
		