create table  if not exists prod_audit (
	usuario varchar NOT NULL,
	data timestamp NOT NULL,
	id varchar NOT NULL,
	mudanca text NOT NULL,
	valor_antigo text NOT NULL,
	valor_novo text NOT NULL
);

CREATE OR REPLACE FUNCTION processo_prod_audit() RETURNS TRIGGER AS
$prod_audit$
	BEGIN
	-- Inserir linhas na tabela prod_audit para refletir as alterações realizada na tabela emp.
	IF (NEW.num_prod <> OLD.num_prod) THEN
		INSERT INTO prod_audit 
			SELECT current_user, current_timestamp, NEW.num_prod, 'Núm. do Produto', OLD.num_prod, NEW.num_prod;
	END IF;
	IF (NEW.nome <> OLD.nome) THEN
		INSERT INTO prod_audit 
			SELECT current_user, current_timestamp, NEW.num_prod, 'Nome', OLD.nome, NEW.nome;
	END IF;
	IF (NEW.descricao <> OLD.descricao) THEN
		INSERT INTO prod_audit
			SELECT current_user, current_timestamp, NEW.num_prod, 'Descrição', OLD.descricao, NEW.descricao;
	END IF;
	IF (NEW.valor <> OLD.valor) THEN
		INSERT INTO serv_audit 
			SELECT current_user, current_timestamp, NEW.num_prod, 'Valor', OLD.valor, NEW.valor;
	END IF;
	IF (NEW.desconto <> OLD.desconto) THEN
		INSERT INTO prod_audit
			SELECT current_user, current_timestamp, NEW.num_prod, 'Desconto', OLD.desconto, NEW.desconto;
	END IF;
	IF (NEW.qtd <> OLD.qtd) THEN
		INSERT INTO prod_audit
			SELECT current_user, current_timestamp, NEW.num_prod, 'Quantidade', OLD.qtd, NEW.qtd;
	END IF;
	RETURN NULL; -- o resultado é ignorado uma vez que este é um gatilho AFTER
	END;
	$prod_audit$ language plpgsql;
	
CREATE TRIGGER prod_audit
	AFTER UPDATE ON produtos
	FOR EACH ROW EXECUTE PROCEDURE processo_prod_audit();
		
		--select * from produtos;
		--select * from prod_audit;
		--insert into produtos(num_prod, nome, descricao, qtd, valor, desconto)
			--values ('123', 'Coleira', 'Amarra o pescoço', 3, 5, 0);
		--update produtos set descricao = 'Identificação do animasl' where num_prod = '123';
		


