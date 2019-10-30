-- 5. Quais os nomes das disciplinas do curso de Ciência da Computação.
	--select D.nome from Disciplina D, Contem C, Curso C2
		--where D.num_disc = C.num_disc and C.num_curso = C2.num_curso and C2.nome = 'Ciência da Computação';

-- 6. Quais os nomes dos cursos que possuem no curriculum a disciplina Cálculo Numérico
	--select C.Nome from Curso C, Disciplina D, Contem C2
		--where C.num_curso = C2.num_curso and C2.num_disc = D.num_disc and D.nome = 'Cálculo Numérico';

-- 7. Quais os nomes das disciplinas que o aluno Marcos João Casanova cursou no 1º semestre de 1998.
	--select D.nome from Disciplina D, Aluno A1, Aula A2
		--where A2.semestre = 1 and A2.num_disc = D.num_disc and A1.num_alu = A2.num_alu and A1.nome = 'Marcos João Casanova';

--8. Quais os nomes de disciplinas que o aluno Ailton Castro foi reprovado.
	--select D.nome from Disciplina D, Aluno A1, Aula A2
		--where D.num_disc = A2.num_disc and A1.num_alu = A2.num_alu and A1.nome = 'Feipe' and A2.nota < 7;
		
--9. Quais os nomes de alunos reprovados na disciplina de Cálculo Numérico no 1º semestre de 1998.
	--select A1.nome from Aluno A1, Disciplina D, Aula A2
		--where A1.num_alu = A2.num_alu and D.num_disc = A2.num_disc and D.nome = 'Cálculo Numérico' and A2.semestre = 1 and A2.nota < 7;

--10. Quais os nomes das disciplinas ministradas pelo prof. Ramon Travanti.
	--select D.nome from Disciplina D, Professor P, Aula A
		--where A.num_prof = P.num_prof and D.num_disc = A.num_disc and P.nome = 'Ramon Travanti';
		
--11. Quais os nomes professores que já ministraram aula de Banco de Dados.
	--select distinct P.nome from Professor P, Aula A, Disciplina D
		--where P.num_prof = A.num_prof and A.num_disc = D.num_disc and D.nome = 'Banco de Dados';

--12. Qual a maior e a menor nota na disciplina de Cálculo Numérico no 1º semestre de 1998.
	--select Max(A.nota) AS Maior, Min(A.nota) AS Menor from Aula A, Disciplina D
		--where A.num_disc = D.num_disc and A.semestre = 1 and D.nome = 'Cálculo Numérico';

--13. Qual o nome do aluno e nota que obteve maior nota na disciplina de Engenharia de Software no 1º semestre de 1998.
	--select A.nome, A2.nota from Aluno A, Aula A2, Disciplina D
		--where A.num_alu = A2.num_alu and A2.num_disc = D.num_disc and A2.semestre = 1 and D.nome = 'Informatica'
		--and A2.nota = (select MAX(nota) from Aula A3, Disciplina D2 where D2.nome = 'Informatica' and D2.num_disc = A3.num_disc);

--14. Quais nomes de alunos, nome de disciplina e nome de professores que cursaram o 1º semestre de 1998 em ordem de aluno.
	--select A.nome AS Aluno, D.nome AS Disciplinas, P.nome AS Professor from Aluno A, Disciplina D, Professor P, Aula A2
		--where A2.semestre = 1 and A2.num_alu = A.num_alu and D.num_disc = A2.num_disc and P.num_prof = A2.num_prof
		--order by A.nome;

--15. Quais nomes de alunos, nome de disciplina e notas do 1º semestre de 1998 no curso de Ciência da Computação.
	--select A.nome AS Alu, D.nome AS Disc, A2.nota AS Nota from Aluno A, Disciplina D, Aula A2, Curso C, Contem C2
		--where A2.semestre = 1 and A2.num_alu = A.num_alu and A2.num_disc = D.num_disc
		--and C.nome = 'CC' and C2.num_disc = D.num_disc and C2.num_curso = C.num_curso;

--16. Qual a média de notas do professor Marcos Salvador.
	--select AVG(A.nota) AS media from Aula A, Professor P
		--where A.num_prof = P.num_prof and P.nome = 'Marcos Salvador';

--17. Quais nomes de alunos, nomes de disciplinas e notas que tiveram nota entre 5.0 e 7.0 em ordem de disciplina.
	--select A.nome AS Alu, D.nome AS Disc, A2.nota AS Nota from Aluno A, Disciplina D, Aula A2
		--where A2.num_alu = A.num_alu and D.num_disc = A2.num_disc and A2.nota between 5 and 7 order by D.nome asc;

--18. Qual a média de notas da disciplina Cálculo Numérico no 1º semestre de 1998.
	--select AVG(A.nota) AS media from Aula A, Disciplina D
		--where A.num_disc = D.num_disc and D.nome = 'Cálculo Numérico' and A.semestre = 1;

--19. Quantos alunos o professor Abgair teve no 1º semestre de 1998.
	--select count(A.num_alu) from Aula A, Professor P
		--where A.num_prof = P.num_prof and A.semestre = 1 and p.nome = 'Abgair';

--20. Qual a média de notas do aluno Edvaldo Carlos Silva.
	--select AVG(A2.nota) from Aluno A, Aula A2
		--where A.num_alu = A2.num_alu and A.nome = 'Edvaldo Carlos Silva';

--21. Quais as médias por nome de disciplina de todos os cursos do 1º semestre de 1998 em ordem de disciplina.
	--select D.nome, AVG(A2.nota) from Aula A2, Disciplina D
		--where A2.num_disc = D.num_disc and A2.semestre = 1 group by D.nome order by D.nome;

--22. Quais as médias das notas por nome de professor no 1º semestre de 1998.
	--select P.nome, AVG(A2.nota) from Aula A2, Professor P
		--where A2.num_prof = P.num_prof and A2.semestre = 1 group by P.nome;
		
--23. Qual a média por disciplina no 1º semestre de 1998 do curso do Ciência da Computação
	--select D.nome, AVG(A2.nota) from Disciplina D, Aula A2, Curso C, Contem C2
		--where A2.semestre = 1 and A2.num_disc = D.num_disc and C.nome = 'Ciência da Computação'
		--and C2.num_curso = C.num_curso and C2.num_disc = A2.num_disc group by D.nome;
		
--24. Qual foi quantidade de créditos concluídos (somente as disciplinas aprovadas) do aluno Edvaldo Carlos Silva.
	--select SUM(D.qtd_cred) from Disciplina D, Aluno A, Aula A2
		--where A.nome = 'Edvaldo Carlos Silva' and A.num_alu = A2.num_alu and A2.num_disc = D.num_disc and A2.nota between 7 and 10;

--25. Quais nomes de alunos e quantidade de créditos que já completaram 70 créditos (somente os aprovados na disciplina).
	--select A.nome, SUM(D.qtd_cred) AS Creditos from Aluno A, Aula A2, Disciplina D
		--where A.num_alu = A2.num_alu and D.num_disc = A2.num_disc and A2.nota >= 7
		--group by A.nome having SUM(D.qtd_cred) > 70;

--26. Quais nomes de alunos, nome de disciplina e nome de professores que cursaram o 1º semestre de 1998
-- e pertencem ao curso de ciência da Computação que possuem nota superior à 8.0.
	--select A.nome AS Aluno, D.nome AS Disciplina, P.nome AS Professor
		--from Aluno A, Disciplina D, Professor P, Aula A2, Curso C
			--where A2.semestre = 1 and A2.nota > 8 and A.num_alu = A2.num_alu and C.num_curso = A.num_curso and
				--P.num_prof = A2.num_prof and D.num_disc = A2.num_disc and C.nome = 'Ciência da Computação';
				
--27. Qual a disciplina com nota mais baixa em qualquer época
	--select D.nome from Disciplina D, Aula A2
		--where D.num_disc = A2.num_disc and A2.nota = (select min(nota) from aula);

--28. Qual a disciplina com média de nota mais alta em qualquer época
	--select D.nome from Disciplina D, Aula A2
		--where D.num_disc = A2.num_disc group by D.nome
		--having AVG(nota) >= all (select AVG(nota) from aula group by num_disc);

--29. Quais alunos já concluiram o curso de Ciência da Computação?
--create view CreditosT AS
	--(select A.num_alu, A.nome, sum(D.qtd_cred) AS TCreditos from Disciplina D, Aula A, Aluno A
		--where A.num_disc = D.num_disc and A.num_alu = A.num_alu and A.nota >= 7 group by A.num_alu);
		
--	select A.nome from Aluno A, Curso C, CreditosT CT
	--	where A.num_curso = C.num_curso and C.nome = 'EC' and A.num_alu = CT.num_alu and C.total_cred <= CT.tcreditos;
	
--30. Ordene as disciplinas por quantidade de reprovações.
--create view ReprovacaoT AS
--	select num_disc, count(num_disc) AS T_rep from aula where nota < 7 group by num_disc;

--select D.nome, RT.t_rep from Disciplina D, ReprovacaoT RT
	--where D.num_disc = RT.num_disc order by RT.t_rep;
