CREATE TABLE funcionarios_log(
	usuario varchar NOT NULL,
	data timestamp NOT NULL,
	operacao_realizada CHARACTER VARYING
);

CREATE OR REPLACE FUNCTION funcionarios_log_function()
RETURNS trigger AS $$
	BEGIN
		-- Aqui temos um bloco IF que confirmará o tipo de operação.
		IF (TG_OP = 'INSERT') THEN
			INSERT INTO funcionarios_log (usuario, data, operacao_realizada) 
				VALUES (current_user, current_timestamp, 'Operação de INSERT na tabela ' || TG_RELNAME || '. Dados adicionados: '
					   || NEW.*);
		RETURN NEW;
		-- Aqui temos um bloco IF que confirmará o tipo de operação UPDATE.
		ELSIF (TG_OP = 'UPDATE') THEN
			INSERT INTO funcionarios_log (usuario, data, operacao_realizada) 
				VALUES (current_user, current_timestamp, 'Operação de UPDATE na tabela ' || TG_RELNAME || '. Dados atualizados: '
					   || NEW.*);
		RETURN NEW;
		-- Aqui temos um bloco IF que confirmará o tipo de operação DELETE
		ELSIF (TG_OP = 'DELETE') THEN
			INSERT INTO funcionarios_log (usuario, data, operacao_realizada) 
				VALUES (current_user, current_timestamp, 'Operação de DELETE na tabela ' || TG_RELNAME || '. Dados excluidos: ' || OLD.*);
		RETURN OLD;
		END IF;
RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER trigger_log_operacoes
AFTER INSERT OR UPDATE OR DELETE ON funcionario
FOR EACH ROW EXECUTE PROCEDURE funcionarios_log_function();

CREATE TRIGGER trigger_log_operacoes
AFTER INSERT OR UPDATE OR DELETE ON animais
FOR EACH ROW EXECUTE PROCEDURE funcionarios_log_function();

CREATE TRIGGER trigger_log_operacoes
AFTER INSERT OR UPDATE OR DELETE ON cliente
FOR EACH ROW EXECUTE PROCEDURE funcionarios_log_function();

CREATE TRIGGER trigger_log_operacoes
AFTER INSERT OR UPDATE OR DELETE ON produtos
FOR EACH ROW EXECUTE PROCEDURE funcionarios_log_function();

CREATE TRIGGER trigger_log_operacoes
AFTER INSERT OR UPDATE OR DELETE ON servicos
FOR EACH ROW EXECUTE PROCEDURE funcionarios_log_function();
