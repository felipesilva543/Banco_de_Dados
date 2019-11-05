create table  if not exists serv_audit (
	usuario varchar NOT NULL,
	data timestamp NOT NULL,
	id integer NOT NULL,
	mudanca text NOT NULL,
	valor_antigo text NOT NULL,
	valor_novo text NOT NULL
);

CREATE OR REPLACE FUNCTION processo_serv_audit() RETURNS TRIGGER AS
$emp_audit$
	BEGIN
	-- Não permitir atualizar a chave primária
	IF (NEW.id_serv <> OLD.id_serv) THEN
		RAISE EXCEPTION 'Não é permitido atualizar o campo id do funcionário';
	END IF;
	-- Inserir linhas na tabela emp_audit para refletir as alterações realizada na tabela emp.
	IF (NEW.nome <> OLD.nome) THEN
		INSERT INTO serv_audit 
			SELECT current_user, current_timestamp, NEW.id_serv, 'Nome', OLD.nome, NEW.nome;
	END IF;
	IF (NEW.descricao <> OLD.descricao) THEN
		INSERT INTO serv_audit 
			SELECT current_user, current_timestamp, NEW.id_serv, 'Descrição', OLD.descricao, NEW.descricao;
	END IF;
	IF (NEW.valor <> OLD.valor) THEN
		INSERT INTO serv_audit 
			SELECT current_user, current_timestamp, NEW.id_serv, 'Valor', OLD.valor, NEW.valor;
	END IF;
	IF (NEW.desconto <> OLD.desconto) THEN
		INSERT INTO serv_audit 
			SELECT current_user, current_timestamp, NEW.id_serv, 'Desconto', OLD.desconto, NEW.desconto;
	END IF;
	RETURN NULL; -- o resultado é ignorado uma vez que este é um gatilho AFTER
	END;
	$emp_audit$ language plpgsql;
	
CREATE TRIGGER serv_audit
	AFTER UPDATE ON servicos
	FOR EACH ROW EXECUTE PROCEDURE processo_serv_audit();
		
		--select * from servicos;
		--select * from serv_audit;
		--update servicos set descricao = 'Cortar pelos' where id_serv = 1;
		


