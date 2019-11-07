PGDMP     &    ;            
    w            PetShop    11.5    11.5 S    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    17117    PetShop    DATABASE     �   CREATE DATABASE "PetShop" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';
    DROP DATABASE "PetShop";
             postgres    false            �            1255    25880 9   compraprod(character varying, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.compraprod(cpf_cliente character varying, num_produto character varying, qtdf integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
	perform * from cliente where cpf = cpf_cliente;
		if found then
			perform * from produtos where qtd >= qtdF and num_prod = num_produto;
			if found then
				insert into compra_prod(cpf_cli, num_prod, qtd, data_compra, status)
								values (cpf_cliente, num_produto, qtdF, current_date, 'NP');
				RAISE NOTICE 'Pedido cadastrado!';
			else
				RAISE EXCEPTION 'Quantidade de produto indisponivel!';
			end if;
		else
			RAISE EXCEPTION 'Cliente não consta no cadastro!';
		end if;
end;
$$;
 m   DROP FUNCTION public.compraprod(cpf_cliente character varying, num_produto character varying, qtdf integer);
       public       postgres    false            �            1255    25729 ?   compraprod(character varying, character varying, integer, real)    FUNCTION     �  CREATE FUNCTION public.compraprod(cpf_cliente character varying, num_produto character varying, qtdf integer, descontof real) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
	perform * from cliente where cpf = cpf_cliente;
		if found then
			perform * from produtos where qtd >= qtdF and num_prod = num_produto;
			if found then
				insert into compra_prod(cpf_cli, num_prod, qtd, desconto, data_compra)
								values (cpf_cliente, num_produto, qtdF, descontoF, current_date);
				RAISE NOTICE 'Pedido cadastrado!';
			else
				RAISE EXCEPTION 'Quantidade de produto indisponivel!';
			end if;
		else
			RAISE EXCEPTION 'Cliente não consta no cadastro!';
		end if;
end;
$$;
 }   DROP FUNCTION public.compraprod(cpf_cliente character varying, num_produto character varying, qtdf integer, descontof real);
       public       postgres    false            �            1255    25881 B   compraserv(character varying, character varying, integer, integer)    FUNCTION       CREATE FUNCTION public.compraserv(cpf_cliente character varying, cpf_funcf character varying, id_servf integer, id_anif integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
	perform * from cliente where cpf = cpf_cliente;
		if found then
			perform * from funcionario where cpf_func = cpf_funcF;
				if found then
					perform * from servicos where id_serv = id_servF;
						if found then
							perform * from animais where cod_ani = id_aniF;
								if found then
									insert into compra_serv(cpf_cli, cpf_fun, id_serv, id_ani, data_compra, status)
													values (cpf_cliente, cpf_funcF, id_servF, id_aniF, current_date, 'NP');
									RAISE NOTICE 'Pedido cadastrado!';
								else
									raise exception 'Animal não consta no cadastro!';
								end if;
						else
							raise exception 'Serviço não conta no sistema!';
						end if;
				else
					raise exception 'Funcionário não consta no cadastro!';
				end if;
		else
			RAISE EXCEPTION 'Cliente não consta no cadastro!';
		end if;
end;
$$;
 �   DROP FUNCTION public.compraserv(cpf_cliente character varying, cpf_funcf character varying, id_servf integer, id_anif integer);
       public       postgres    false            �            1255    25730 H   compraserv(character varying, character varying, integer, integer, real)    FUNCTION     *  CREATE FUNCTION public.compraserv(cpf_cliente character varying, cpf_funcf character varying, id_servf integer, id_anif integer, descontof real) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
	perform * from cliente where cpf = cpf_cliente;
		if found then
			perform * from funcionario where cpf_func = cpf_funcF;
				if found then
					perform * from servicos where id_serv = id_servF;
						if found then
							perform * from animais where cod_ani = id_aniF;
								if found then
									insert into compra_serv(cpf_cli, cpf_fun, id_serv, id_ani, desconto, data_compra)
													values (cpf_cliente, cpf_funcF, id_servF, id_aniF, descontoF, current_date);
									RAISE NOTICE 'Pedido cadastrado!';
								else
									raise exception 'Animal não consta no cadastro!';
								end if;
						else
							raise exception 'Serviço não conta no sistema!';
						end if;
				else
					raise exception 'Funcionário não consta no cadastro!';
				end if;
		else
			RAISE EXCEPTION 'Cliente não consta no cadastro!';
		end if;
end;
$$;
 �   DROP FUNCTION public.compraserv(cpf_cliente character varying, cpf_funcf character varying, id_servf integer, id_anif integer, descontof real);
       public       postgres    false            �            1255    25870 8   finalizarcompraprod(character varying, double precision)    FUNCTION     �  CREATE FUNCTION public.finalizarcompraprod(cpf_cliente character varying, descontof double precision) RETURNS TABLE(id_compra integer, num_prod character varying, qtd integer, valorc double precision, valorcompra double precision)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
	valorTCompra double precision;
	prod_rec	RECORD;
begin	
	DROP TABLE IF EXISTS _tmpComprasProd;
	create temporary table _tmpComprasProd as select CP.id_compra, CP.num_prod, CP.qtd, ((CP.qtd * (Pr.valor - (Pr.valor * Pr.desconto))) ) AS ValorC
		from compra_prod CP, produtos Pr where
			cpf_cli = cpf_cliente and 
			CP.num_prod = Pr.num_prod and
			CP.status = 'NP' and
			CP.data_compra = current_date;

	EXECUTE 'select sum(ValorC) from _tmpComprasProd' into valorTCompra;
	raise notice 'Valor total: %', (valorTCompra - (valorTCompra * descontoF));
	
		for prod_rec in select * from _tmpComprasProd tmp loop
			raise notice 'Qtd: %', prod_rec.qtd;
			update "produtos" AS P
				set 
					"qtd" = (P.qtd - prod_rec.qtd)
				where P.num_prod = prod_rec.num_prod;
		end loop;
		
		for prod_rec in select * from _tmpComprasProd tmp loop
			raise notice 'Id Compra: %', prod_rec.id_compra;
			update "compra_prod" AS CP
				set 
					"status" = 'PG'
					where CP.id_compra = prod_rec.id_compra;
		end loop;
	
		return QUERY SELECT
						CP.id_compra,
						CP.num_prod,
						CP.qtd,
						cp.ValorC,
						(valorTCompra - (valorTCompra * descontoF))
						FROM _tmpComprasProd CP;
end;
$$;
 e   DROP FUNCTION public.finalizarcompraprod(cpf_cliente character varying, descontof double precision);
       public       postgres    false            �            1255    25901 8   finalizarcompraserv(character varying, double precision)    FUNCTION     �  CREATE FUNCTION public.finalizarcompraserv(cpf_cliente character varying, descontof double precision) RETURNS TABLE(id_compra integer, id_serv integer, valorc real, valorcompra double precision)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
	valorTCompra double precision;
	serv_rec	RECORD;
begin	
	DROP TABLE IF EXISTS _tmpComprasServ;
	create temporary table _tmpComprasServ as select CS.id_compra, CS.id_serv, ((S.valor - (S.valor * S.desconto))) AS ValorC
		from compra_serv CS, Servicos S where
			CS.cpf_cli = cpf_cliente and
			CS.id_serv = S.id_serv and
			status = 'NP' and
			CS.data_compra = current_date;
						
	EXECUTE 'select sum(ValorC) from _tmpComprasServ' into valorTCompra;
	raise notice 'Valor total: %', (valorTCompra - (valorTCompra * descontoF));
		
		for serv_rec in select * from _tmpComprasServ loop
			raise notice 'Id Serv: %', serv_rec.id_serv;
			update "compra_serv" AS CP
				set 
					"status" = 'PG'
					where CP.id_compra = serv_rec.id_compra;
		end loop;
		
		return QUERY SELECT
						CS.id_compra,
						CS.id_serv,
						CS.ValorC,
						(valorTCompra - (valorTCompra * descontoF))
						FROM _tmpComprasServ CS;
end;
$$;
 e   DROP FUNCTION public.finalizarcompraserv(cpf_cliente character varying, descontof double precision);
       public       postgres    false            �            1255    17597    funcionarios_log_function()    FUNCTION     I  CREATE FUNCTION public.funcionarios_log_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 2   DROP FUNCTION public.funcionarios_log_function();
       public       postgres    false            �            1255    17571    processo_ani_audit()    FUNCTION     �  CREATE FUNCTION public.processo_ani_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
	$$;
 +   DROP FUNCTION public.processo_ani_audit();
       public       postgres    false            �            1255    17550    processo_cli_audit()    FUNCTION     '  CREATE FUNCTION public.processo_cli_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
	$$;
 +   DROP FUNCTION public.processo_cli_audit();
       public       postgres    false            �            1255    17530    processo_emp_audit()    FUNCTION     �  CREATE FUNCTION public.processo_emp_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
	$$;
 +   DROP FUNCTION public.processo_emp_audit();
       public       postgres    false            �            1255    17619    processo_prod_audit()    FUNCTION     �  CREATE FUNCTION public.processo_prod_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
	$$;
 ,   DROP FUNCTION public.processo_prod_audit();
       public       postgres    false            �            1255    17611    processo_serv_audit()    FUNCTION     S  CREATE FUNCTION public.processo_serv_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
	$$;
 ,   DROP FUNCTION public.processo_serv_audit();
       public       postgres    false            �            1259    17564 	   ani_audit    TABLE     �   CREATE TABLE public.ani_audit (
    usuario character varying NOT NULL,
    data timestamp without time zone NOT NULL,
    id integer NOT NULL,
    mudanca text NOT NULL,
    valor_antigo text NOT NULL,
    valor_novo text NOT NULL
);
    DROP TABLE public.ani_audit;
       public         postgres    false            �            1259    17304    animais    TABLE     �   CREATE TABLE public.animais (
    cod_ani integer NOT NULL,
    nome character varying(70),
    tipo character varying(30),
    raca character varying(30),
    tamanho real,
    peso real,
    idade integer,
    cpf_cli character varying(30)
);
    DROP TABLE public.animais;
       public         postgres    false            �            1259    17302    animais_cod_ani_seq    SEQUENCE     �   CREATE SEQUENCE public.animais_cod_ani_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.animais_cod_ani_seq;
       public       postgres    false    202            �           0    0    animais_cod_ani_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.animais_cod_ani_seq OWNED BY public.animais.cod_ani;
            public       postgres    false    201            �            1259    17544 	   cli_audit    TABLE     �   CREATE TABLE public.cli_audit (
    usuario character varying NOT NULL,
    data timestamp without time zone NOT NULL,
    id character varying NOT NULL,
    mudanca text NOT NULL,
    valor_antigo text NOT NULL,
    valor_novo text NOT NULL
);
    DROP TABLE public.cli_audit;
       public         postgres    false            �            1259    17134    cliente    TABLE     �   CREATE TABLE public.cliente (
    cpf character varying(15) NOT NULL,
    nome character varying(70),
    email character varying(70),
    telefone character varying(15),
    endereco character varying(70)
);
    DROP TABLE public.cliente;
       public         postgres    false            �            1259    17489    compra_prod    TABLE     �   CREATE TABLE public.compra_prod (
    id_compra integer NOT NULL,
    cpf_cli character varying(15),
    num_prod character varying(70),
    qtd integer,
    data_compra date,
    status character varying(5)
);
    DROP TABLE public.compra_prod;
       public         postgres    false            �            1259    17487    compra_prod_id_compra_seq    SEQUENCE     �   CREATE SEQUENCE public.compra_prod_id_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.compra_prod_id_compra_seq;
       public       postgres    false    210            �           0    0    compra_prod_id_compra_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.compra_prod_id_compra_seq OWNED BY public.compra_prod.id_compra;
            public       postgres    false    209            �            1259    17399    compra_serv    TABLE     �   CREATE TABLE public.compra_serv (
    id_compra integer NOT NULL,
    cpf_cli character varying(15),
    cpf_fun character varying(15),
    id_serv integer,
    id_ani integer,
    data_compra date,
    status character varying(5)
);
    DROP TABLE public.compra_serv;
       public         postgres    false            �            1259    17397    compra_serv_id_compra_seq    SEQUENCE     �   CREATE SEQUENCE public.compra_serv_id_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.compra_serv_id_compra_seq;
       public       postgres    false    208            �           0    0    compra_serv_id_compra_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.compra_serv_id_compra_seq OWNED BY public.compra_serv.id_compra;
            public       postgres    false    207            �            1259    25735    comprascliente    VIEW     �   CREATE VIEW public.comprascliente AS
 SELECT p.id_compra AS produto,
    s.id_compra AS servico
   FROM public.compra_prod p,
    public.compra_serv s
  WHERE ((p.cpf_cli)::text = (s.cpf_cli)::text);
 !   DROP VIEW public.comprascliente;
       public       postgres    false    210    210    208    208            �            1259    17524 	   emp_audit    TABLE     �   CREATE TABLE public.emp_audit (
    usuario character varying NOT NULL,
    data timestamp without time zone NOT NULL,
    id character varying NOT NULL,
    mudanca text NOT NULL,
    valor_antigo text NOT NULL,
    valor_novo text NOT NULL
);
    DROP TABLE public.emp_audit;
       public         postgres    false            �            1259    17315    funcionario    TABLE     A  CREATE TABLE public.funcionario (
    cpf_func character varying(15) NOT NULL,
    nome character varying(70),
    endereco character varying(30),
    telefone character varying(30),
    funcao character varying(30),
    salario real,
    CONSTRAINT funcionario_salario_check CHECK ((salario > (0)::double precision))
);
    DROP TABLE public.funcionario;
       public         postgres    false            �            1259    17573    funcionarios_log    TABLE     �   CREATE TABLE public.funcionarios_log (
    usuario character varying NOT NULL,
    data timestamp without time zone NOT NULL,
    operacao_realizada character varying
);
 $   DROP TABLE public.funcionarios_log;
       public         postgres    false            �            1259    17621 
   prod_audit    TABLE     �   CREATE TABLE public.prod_audit (
    usuario character varying NOT NULL,
    data timestamp without time zone NOT NULL,
    id character varying NOT NULL,
    mudanca text NOT NULL,
    valor_antigo text NOT NULL,
    valor_novo text NOT NULL
);
    DROP TABLE public.prod_audit;
       public         postgres    false            �            1259    17352    produtos    TABLE     �  CREATE TABLE public.produtos (
    num_prod character varying(30) NOT NULL,
    nome character varying(70),
    descricao character varying(300),
    qtd integer,
    valor real,
    desconto real,
    CONSTRAINT produtos_desconto_check CHECK (((desconto >= (0)::double precision) AND (desconto <= (1)::double precision))),
    CONSTRAINT produtos_valor_check CHECK ((valor > (0)::double precision))
);
    DROP TABLE public.produtos;
       public         postgres    false            �            1259    17605 
   serv_audit    TABLE     �   CREATE TABLE public.serv_audit (
    usuario character varying NOT NULL,
    data timestamp without time zone NOT NULL,
    id integer NOT NULL,
    mudanca text NOT NULL,
    valor_antigo text NOT NULL,
    valor_novo text NOT NULL
);
    DROP TABLE public.serv_audit;
       public         postgres    false            �            1259    17344    servicos    TABLE     s  CREATE TABLE public.servicos (
    id_serv integer NOT NULL,
    nome character varying(70),
    descricao character varying(300),
    valor real,
    desconto real,
    CONSTRAINT servicos_desconto_check CHECK (((desconto >= (0)::double precision) AND (desconto <= (1)::double precision))),
    CONSTRAINT servicos_valor_check CHECK ((valor > (0)::double precision))
);
    DROP TABLE public.servicos;
       public         postgres    false            �            1259    17342    servicos_id_serv_seq    SEQUENCE     �   CREATE SEQUENCE public.servicos_id_serv_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.servicos_id_serv_seq;
       public       postgres    false    205            �           0    0    servicos_id_serv_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.servicos_id_serv_seq OWNED BY public.servicos.id_serv;
            public       postgres    false    204            �
           2604    17307    animais cod_ani    DEFAULT     r   ALTER TABLE ONLY public.animais ALTER COLUMN cod_ani SET DEFAULT nextval('public.animais_cod_ani_seq'::regclass);
 >   ALTER TABLE public.animais ALTER COLUMN cod_ani DROP DEFAULT;
       public       postgres    false    201    202    202            �
           2604    17492    compra_prod id_compra    DEFAULT     ~   ALTER TABLE ONLY public.compra_prod ALTER COLUMN id_compra SET DEFAULT nextval('public.compra_prod_id_compra_seq'::regclass);
 D   ALTER TABLE public.compra_prod ALTER COLUMN id_compra DROP DEFAULT;
       public       postgres    false    210    209    210            �
           2604    17402    compra_serv id_compra    DEFAULT     ~   ALTER TABLE ONLY public.compra_serv ALTER COLUMN id_compra SET DEFAULT nextval('public.compra_serv_id_compra_seq'::regclass);
 D   ALTER TABLE public.compra_serv ALTER COLUMN id_compra DROP DEFAULT;
       public       postgres    false    208    207    208            �
           2604    17347    servicos id_serv    DEFAULT     t   ALTER TABLE ONLY public.servicos ALTER COLUMN id_serv SET DEFAULT nextval('public.servicos_id_serv_seq'::regclass);
 ?   ALTER TABLE public.servicos ALTER COLUMN id_serv DROP DEFAULT;
       public       postgres    false    204    205    205            �          0    17564 	   ani_audit 
   TABLE DATA               Y   COPY public.ani_audit (usuario, data, id, mudanca, valor_antigo, valor_novo) FROM stdin;
    public       postgres    false    213   J�       w          0    17304    animais 
   TABLE DATA               [   COPY public.animais (cod_ani, nome, tipo, raca, tamanho, peso, idade, cpf_cli) FROM stdin;
    public       postgres    false    202   ��       �          0    17544 	   cli_audit 
   TABLE DATA               Y   COPY public.cli_audit (usuario, data, id, mudanca, valor_antigo, valor_novo) FROM stdin;
    public       postgres    false    212   ��       u          0    17134    cliente 
   TABLE DATA               G   COPY public.cliente (cpf, nome, email, telefone, endereco) FROM stdin;
    public       postgres    false    200   ��                 0    17489    compra_prod 
   TABLE DATA               ]   COPY public.compra_prod (id_compra, cpf_cli, num_prod, qtd, data_compra, status) FROM stdin;
    public       postgres    false    210   �       }          0    17399    compra_serv 
   TABLE DATA               h   COPY public.compra_serv (id_compra, cpf_cli, cpf_fun, id_serv, id_ani, data_compra, status) FROM stdin;
    public       postgres    false    208   m�       �          0    17524 	   emp_audit 
   TABLE DATA               Y   COPY public.emp_audit (usuario, data, id, mudanca, valor_antigo, valor_novo) FROM stdin;
    public       postgres    false    211   ��       x          0    17315    funcionario 
   TABLE DATA               Z   COPY public.funcionario (cpf_func, nome, endereco, telefone, funcao, salario) FROM stdin;
    public       postgres    false    203   Ù       �          0    17573    funcionarios_log 
   TABLE DATA               M   COPY public.funcionarios_log (usuario, data, operacao_realizada) FROM stdin;
    public       postgres    false    214   (�       �          0    17621 
   prod_audit 
   TABLE DATA               Z   COPY public.prod_audit (usuario, data, id, mudanca, valor_antigo, valor_novo) FROM stdin;
    public       postgres    false    216   �       {          0    17352    produtos 
   TABLE DATA               S   COPY public.produtos (num_prod, nome, descricao, qtd, valor, desconto) FROM stdin;
    public       postgres    false    206   ��       �          0    17605 
   serv_audit 
   TABLE DATA               Z   COPY public.serv_audit (usuario, data, id, mudanca, valor_antigo, valor_novo) FROM stdin;
    public       postgres    false    215   �       z          0    17344    servicos 
   TABLE DATA               M   COPY public.servicos (id_serv, nome, descricao, valor, desconto) FROM stdin;
    public       postgres    false    205   ^�       �           0    0    animais_cod_ani_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.animais_cod_ani_seq', 5, true);
            public       postgres    false    201            �           0    0    compra_prod_id_compra_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.compra_prod_id_compra_seq', 15, true);
            public       postgres    false    209            �           0    0    compra_serv_id_compra_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.compra_serv_id_compra_seq', 8, true);
            public       postgres    false    207            �           0    0    servicos_id_serv_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.servicos_id_serv_seq', 5, true);
            public       postgres    false    204            �
           2606    17309    animais animais_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.animais
    ADD CONSTRAINT animais_pkey PRIMARY KEY (cod_ani);
 >   ALTER TABLE ONLY public.animais DROP CONSTRAINT animais_pkey;
       public         postgres    false    202            �
           2606    17138    cliente cliente_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cpf);
 >   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
       public         postgres    false    200            �
           2606    17495    compra_prod compra_prod_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.compra_prod
    ADD CONSTRAINT compra_prod_pkey PRIMARY KEY (id_compra);
 F   ALTER TABLE ONLY public.compra_prod DROP CONSTRAINT compra_prod_pkey;
       public         postgres    false    210            �
           2606    17405    compra_serv compra_serv_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.compra_serv
    ADD CONSTRAINT compra_serv_pkey PRIMARY KEY (id_compra);
 F   ALTER TABLE ONLY public.compra_serv DROP CONSTRAINT compra_serv_pkey;
       public         postgres    false    208            �
           2606    17320    funcionario funcionario_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf_func);
 F   ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
       public         postgres    false    203            �
           2606    17358    produtos produtos_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (num_prod);
 @   ALTER TABLE ONLY public.produtos DROP CONSTRAINT produtos_pkey;
       public         postgres    false    206            �
           2606    17351    servicos servicos_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.servicos
    ADD CONSTRAINT servicos_pkey PRIMARY KEY (id_serv);
 @   ALTER TABLE ONLY public.servicos DROP CONSTRAINT servicos_pkey;
       public         postgres    false    205            �
           2620    17572    animais ani_audit    TRIGGER     t   CREATE TRIGGER ani_audit AFTER UPDATE ON public.animais FOR EACH ROW EXECUTE PROCEDURE public.processo_ani_audit();
 *   DROP TRIGGER ani_audit ON public.animais;
       public       postgres    false    236    202            �
           2620    17551    cliente cli_audit    TRIGGER     t   CREATE TRIGGER cli_audit AFTER UPDATE ON public.cliente FOR EACH ROW EXECUTE PROCEDURE public.processo_cli_audit();
 *   DROP TRIGGER cli_audit ON public.cliente;
       public       postgres    false    234    200            �
           2620    17531    funcionario emp_audit    TRIGGER     x   CREATE TRIGGER emp_audit AFTER UPDATE ON public.funcionario FOR EACH ROW EXECUTE PROCEDURE public.processo_emp_audit();
 .   DROP TRIGGER emp_audit ON public.funcionario;
       public       postgres    false    233    203            �
           2620    17620    produtos prod_audit    TRIGGER     w   CREATE TRIGGER prod_audit AFTER UPDATE ON public.produtos FOR EACH ROW EXECUTE PROCEDURE public.processo_prod_audit();
 ,   DROP TRIGGER prod_audit ON public.produtos;
       public       postgres    false    206    238            �
           2620    17612    servicos serv_audit    TRIGGER     w   CREATE TRIGGER serv_audit AFTER UPDATE ON public.servicos FOR EACH ROW EXECUTE PROCEDURE public.processo_serv_audit();
 ,   DROP TRIGGER serv_audit ON public.servicos;
       public       postgres    false    237    205            �
           2620    17598 !   funcionario trigger_log_operacoes    TRIGGER     �   CREATE TRIGGER trigger_log_operacoes AFTER INSERT OR DELETE OR UPDATE ON public.funcionario FOR EACH ROW EXECUTE PROCEDURE public.funcionarios_log_function();
 :   DROP TRIGGER trigger_log_operacoes ON public.funcionario;
       public       postgres    false    235    203            �
           2620    17599    animais trigger_log_operacoes    TRIGGER     �   CREATE TRIGGER trigger_log_operacoes AFTER INSERT OR DELETE OR UPDATE ON public.animais FOR EACH ROW EXECUTE PROCEDURE public.funcionarios_log_function();
 6   DROP TRIGGER trigger_log_operacoes ON public.animais;
       public       postgres    false    235    202            �
           2620    17600    cliente trigger_log_operacoes    TRIGGER     �   CREATE TRIGGER trigger_log_operacoes AFTER INSERT OR DELETE OR UPDATE ON public.cliente FOR EACH ROW EXECUTE PROCEDURE public.funcionarios_log_function();
 6   DROP TRIGGER trigger_log_operacoes ON public.cliente;
       public       postgres    false    235    200            �
           2620    17601    produtos trigger_log_operacoes    TRIGGER     �   CREATE TRIGGER trigger_log_operacoes AFTER INSERT OR DELETE OR UPDATE ON public.produtos FOR EACH ROW EXECUTE PROCEDURE public.funcionarios_log_function();
 7   DROP TRIGGER trigger_log_operacoes ON public.produtos;
       public       postgres    false    235    206            �
           2620    17602    servicos trigger_log_operacoes    TRIGGER     �   CREATE TRIGGER trigger_log_operacoes AFTER INSERT OR DELETE OR UPDATE ON public.servicos FOR EACH ROW EXECUTE PROCEDURE public.funcionarios_log_function();
 7   DROP TRIGGER trigger_log_operacoes ON public.servicos;
       public       postgres    false    235    205            �
           2606    17310    animais animais_fkey    FK CONSTRAINT     v   ALTER TABLE ONLY public.animais
    ADD CONSTRAINT animais_fkey FOREIGN KEY (cpf_cli) REFERENCES public.cliente(cpf);
 >   ALTER TABLE ONLY public.animais DROP CONSTRAINT animais_fkey;
       public       postgres    false    200    202    2781            �
           2606    17496    compra_prod compra_prod_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.compra_prod
    ADD CONSTRAINT compra_prod_fkey FOREIGN KEY (cpf_cli) REFERENCES public.cliente(cpf);
 F   ALTER TABLE ONLY public.compra_prod DROP CONSTRAINT compra_prod_fkey;
       public       postgres    false    2781    210    200            �
           2606    17501    compra_prod compra_prod_fkey2    FK CONSTRAINT     �   ALTER TABLE ONLY public.compra_prod
    ADD CONSTRAINT compra_prod_fkey2 FOREIGN KEY (num_prod) REFERENCES public.produtos(num_prod);
 G   ALTER TABLE ONLY public.compra_prod DROP CONSTRAINT compra_prod_fkey2;
       public       postgres    false    210    2789    206            �
           2606    17406    compra_serv compra_serv_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.compra_serv
    ADD CONSTRAINT compra_serv_fkey FOREIGN KEY (cpf_cli) REFERENCES public.cliente(cpf);
 F   ALTER TABLE ONLY public.compra_serv DROP CONSTRAINT compra_serv_fkey;
       public       postgres    false    200    208    2781            �
           2606    17411    compra_serv compra_serv_fkey2    FK CONSTRAINT     �   ALTER TABLE ONLY public.compra_serv
    ADD CONSTRAINT compra_serv_fkey2 FOREIGN KEY (cpf_fun) REFERENCES public.funcionario(cpf_func);
 G   ALTER TABLE ONLY public.compra_serv DROP CONSTRAINT compra_serv_fkey2;
       public       postgres    false    2785    208    203            �
           2606    17416    compra_serv compra_serv_fkey3    FK CONSTRAINT     �   ALTER TABLE ONLY public.compra_serv
    ADD CONSTRAINT compra_serv_fkey3 FOREIGN KEY (id_serv) REFERENCES public.servicos(id_serv);
 G   ALTER TABLE ONLY public.compra_serv DROP CONSTRAINT compra_serv_fkey3;
       public       postgres    false    2787    208    205            �
           2606    17421    compra_serv compra_serv_fkey4    FK CONSTRAINT     �   ALTER TABLE ONLY public.compra_serv
    ADD CONSTRAINT compra_serv_fkey4 FOREIGN KEY (id_ani) REFERENCES public.animais(cod_ani);
 G   ALTER TABLE ONLY public.compra_serv DROP CONSTRAINT compra_serv_fkey4;
       public       postgres    false    208    202    2783            �   A   x�+�/.I/J-�420��54�50S04�25�2��3�0021�4�I�M����4�3bS�=... ���      w   P   x�3��O��tNL��/*��H,.�/Rp�I�=�8��Pϔ�Ĕ�Ј��Ȉ˄3(�Imi:�P��)����!W� �:�      �   �   x���;�0��>E.��6qH2��L�T%*H�Ti�?������ʼ5� ıanH��>�ذ�>l�����s�}����~�#N?�֤�H���� "�X���v�A;v����jۗqݗ�|�,">P�4�      u   t   x�344�tK��,H�LsH�M���K���4426�*MT��266�tN���I�LFRaian�YTa�edd��YZTə�$obld6!���hVbZb*Ј"����"3sK�!&\1z\\\ V�'�         L   x���444c#N#CK]CC]S� w.C����!��!\
C�DH	��1D6MຌRf`)S�.t�=... ��      }   )   x���444䴴0�4�4�420��54�50�p����� Z�F      �      x������ � �      x   U   x�315�J,��*MT�052�NM.J-9��(3���������'1��(����Ԉ3$�8QAM�)1/#������+F��� �J�      �   �  x����n�0ůק�r�@�,���+�i��+B�x��FJ��I�6h< ���Y5ؚ&�ب��\��O�|��+\Yͼ-(&���C, Q	W����X`y�ެ~�n�Zp���l<K*ses�<���"pj��f���[6�	xI�ol�^��-L���- �������ը�!HB8��iL�A)����{�Q�F�=2��XK�6>\�M�z�����]t�O]:�2!a�|�t0�,^nׁñ�
OL:w�;xQ� F%�� ���U,� ��]e	�SV΃��.$H@.�,0x��CD"0��dD�\��[ ��Q��cS�k�T�
xiSo�Տ�3H0��aъ÷A�5�$�pAa4q�/��Y΃FcՍ�Q�́m��M��ux�L��m���R[��_���l�aH!�O�c�� ��'��D�0�Z�x���K�v�0ظ��+�Aa�p�[���GJ�UkN۵�"���T��{�ʹY.�
����s�� K�����`�����&��V嶨t�.��0�P���Xl�n�5����!J�7I�q%c͟��K��@��K��D$5S|s���Uq�Uφ��8�[	��&X �9փ�w��W�"8�F�X�)�u�y^��c�M�"��(d�������ֹ�����?��sW=R
�P�b�)l�͝n�e�,��w�\4"Bs���Yޕ�g��%��.���h4��?�      �   �   x���1
�0��Y>E.�'K��[t�H(]�Ф�o��B��[��v{�+q��@���Y���%��{|l�i�fB��c'i_�jŅ��q��s*?��<W��f=ɚZ!;`�Aw�eP��m���bM�(�k!| 8a�      {   K   x�344�t��I�,J�tLN-.>��(3�X� �(Q!1/371��ӄӈӀ��Ȉ�)?�:c�:=C0����� 4�X      �   B   x�+�/.I/J-�420��54�50U0��22�24ֳ�4�4��4�tI-N��+��4�4�3����� ���      z   e   x�3��/N�t�/*I,R(H��WH�WH���M��45�4�2�tJ���W0�����
�����
�@�%�
��Ŝf@�z�`�eUo����Ui� *�&e     