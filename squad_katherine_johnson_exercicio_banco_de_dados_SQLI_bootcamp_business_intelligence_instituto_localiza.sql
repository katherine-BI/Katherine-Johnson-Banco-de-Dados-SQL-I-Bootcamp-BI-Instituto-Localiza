-- Apagar tabelas antigas se existirem 
DROP TABLE IF EXISTS MATRICULAS; 
DROP TABLE IF EXISTS ALUNOS; 
DROP TABLE IF EXISTS CURSOS; 

-- Criar as novas tabelas 
CREATE TABLE ALUNOS ( 
ID_ALUNO INT PRIMARY KEY, 
NOME_ALUNO VARCHAR(150), 
EMAIL VARCHAR(100), 
DATA_INGRESSO DATE 
); 
CREATE TABLE CURSOS ( 
ID_CURSO INT PRIMARY KEY, 
NOME_CURSO VARCHAR(100), 
DEPARTAMENTO VARCHAR(100), 
CREDITOS INT 
);
CREATE TABLE MATRICULAS ( 
ID_MATRICULA INT PRIMARY KEY, 
ID_ALUNO INT, 
ID_CURSO INT, 
NOTA_FINAL DECIMAL(4, 2), 
FOREIGN KEY (ID_ALUNO) REFERENCES ALUNOS(ID_ALUNO), 
FOREIGN KEY (ID_CURSO) REFERENCES CURSOS(ID_CURSO) 
); 

-- Inserir dados de exemplo 
INSERT INTO ALUNOS (ID_ALUNO, NOME_ALUNO, EMAIL, DATA_INGRESSO) 
VALUES 
(1, 'Lucas Martins', 'lucas.m@email.com', '2023-02-01'), 
(2, 'Sofia Pereira', 'sofia.p@email.com', '2023-02-01'), 
(3, 'Mariana Costa', 'mariana.c@email.com', '2022-08-01'), 
(4, 'Rafael Santos', 'rafael.s@email.com', '2024-02-01');  

-- Aluno novo, sem matrícula 
INSERT INTO CURSOS (ID_CURSO, NOME_CURSO, DEPARTAMENTO, CREDITOS) 
VALUES 
(101, 'Algoritmos e Programação', 'Ciência da Computação', 4), 
(102, 'Cálculo I', 'Matemática', 6), 
(103, 'Administração de Empresas', 'Gestão', 4), 
(104, 'Estrutura de Dados', 'Ciência da Computação', 6);

INSERT INTO MATRICULAS (ID_MATRICULA, ID_ALUNO, ID_CURSO, NOTA_FINAL) 
VALUES 
(1, 1, 101, 8.5), 
(2, 1, 102, 7.0), 
(3, 2, 101, 9.0), 
(4, 2, 104, 8.8), 
(5, 3, 103, 6.5); 

----------------------------------------------------------------------------------------
-- 1. Consulta Geral: Selecione todas as informações da tabela ALUNOS
SELECT * FROM ALUNOS

/* 2. Consulta Específica: Crie um relatório que mostre apenas o nome e o departamento de todos os cursos, com os títulos das colunas sendo 
 "Curso" e "Departamento Responsável". */

SELECT 
	NOME_CURSO AS "Curso",
	DEPARTAMENTO AS "Departamento Responsável"
FROM CURSOS;

/* 3. Filtro Numérico: Liste o nome e os créditos de todos os cursos que valem mais de 4 créditos. */

SELECT 
    NOME_CURSO AS "Curso",
    CREDITOS AS "Créditos"
FROM CURSOS
WHERE CREDITOS > 4;

/* 4. Filtro de Data: Mostre o nome e o email dos alunos que ingressaram a partir do início de 2023 (ou seja, DATA_INGRESSO maior ou igual a '2023-01-01').*/

SELECT 
    NOME_ALUNO AS "Aluno",
    EMAIL AS "Email"
FROM ALUNOS
WHERE DATA_INGRESSO >= '2023-01-01';

/*5. Filtro com AND e Ordenação: Liste o nome e a nota final de todas as matrículas do aluno de ID_ALUNO = 1 
E cuja NOTA_FINAL foi maior ou igual a 7.0. Ordene o resultado pela nota, da maior para a menor.*/

-- busca de acordo com o nome do curso
SELECT 
    NOME_CURSO,
    NOTA_FINAL
FROM MATRICULAS M
JOIN CURSOS C ON M.ID_CURSO = C.ID_CURSO
WHERE ID_ALUNO = 1 
    AND NOTA_FINAL >= 7.0
ORDER BY NOTA_FINAL DESC;

-- busca de acordo com o nome do aluno
SELECT 
    A.NOME_ALUNO AS "Aluno",
    M.NOTA_FINAL AS "Nota Final"
FROM MATRICULAS M
JOIN ALUNOS A ON A.ID_ALUNO = M.ID_ALUNO
WHERE M.ID_ALUNO = 1 
  AND M.NOTA_FINAL >= 7.0
ORDER BY M.NOTA_FINAL DESC;
-------------------------------------------------------------------------------------------
/*Parte 2: DQL (Transformação e Organização) 
1. Valores Únicos: Qual é a lista de departamentos únicos que oferecem cursos na universidade?*/

SELECT DISTINCT 
    DEPARTAMENTO AS "Departamento"
FROM CURSOS;

/* 2. Lógica Condicional: Crie um relatório de matrículas que mostre o 
ID_MATRICULA e uma nova coluna chamada STATUS . 
O status deve ser 'Aprovado' se a NOTA_FINAL for maior ou igual a 7.0, e 'Reprovado' caso 
contrário. */

SELECT 
    ID_MATRICULA,
    CASE 
        WHEN NOTA_FINAL >= 7.0 THEN 'Aprovado'
        ELSE 'Reprovado'
    END AS STATUS
FROM MATRICULAS;

/*3. Ordenação e Limite: Qual é o curso com o maior número de créditos? O 
resultado deve mostrar apenas o nome do curso e seus créditos.*/

SELECT nome_curso, creditos
FROM CURSOS
ORDER BY creditos DESC
LIMIT 1;
-------------------------------------------------------------------------------------------
/*Parte 3: DQL (Agregações e Agrupamentos) 
1. Contagem e Média: Calcule o número total de matrículas e a média geral 
de todas as notas finais. */

SELECT 
    COUNT(*) AS "Total de Matrículas",
    AVG(NOTA_FINAL) AS "Média Geral das Notas"
FROM MATRICULAS;

/*2. Agrupamento: Crie um relatório que mostre quantos cursos são oferecidos 
por departamento. */

SELECT 
    DEPARTAMENTO AS "Departamento",
    COUNT(*) AS "Qtd de Cursos"
FROM CURSOS
GROUP BY DEPARTAMENTO;

/*3. Filtro de Grupo: Com base na consulta anterior, mostre apenas os 
departamentos que oferecem mais de um curso. */

SELECT 
    DEPARTAMENTO AS "Departamento",
    COUNT(*) AS "Qtd de Cursos"
FROM CURSOS
GROUP BY DEPARTAMENTO
HAVING COUNT(*) > 1;
-------------------------------------------------------------------------------------------
/*Parte 4: DQL (Junção de Tabelas - JOINs) 
1. Relatório de Desempenho: Crie uma consulta que mostre o nome do 
aluno, o nome do curso em que ele está matriculado e a sua nota final. 
(Dica: Você precisará de dois JOIN s). */

SELECT 
    A.NOME_ALUNO AS "Aluno",
    C.NOME_CURSO AS "Curso",
    M.NOTA_FINAL AS "Nota Final"
FROM MATRICULAS M
JOIN ALUNOS A ON A.ID_ALUNO = M.ID_ALUNO
JOIN CURSOS C ON C.ID_CURSO = M.ID_CURSO;


/*2. Busca por Alunos sem Matrícula: Qual aluno está cadastrado na 
universidade mas ainda não se matriculou em nenhum curso? A consulta 
deve retornar apenas o nome deste aluno. (Dica: LEFT JOIN com um filtro 
WHERE ... IS NULL ). */

SELECT 
    A.NOME_ALUNO AS "Aluno"
FROM ALUNOS A
LEFT JOIN MATRICULAS M ON A.ID_ALUNO = M.ID_ALUNO
WHERE M.ID_ALUNO IS NULL;
-------------------------------------------------------------------------------------------
/*Crie um único relatório para encontrar o "Aluno Destaque". Este aluno é aquele 
com a maior média de notas finais. A consulta deve mostrar o nome do aluno 
e a sua média de notas, arredondada para duas casas decimais.*/

SELECT ALUNOS.NOME_ALUNO AS 'Aluno Destaque',
        ROUND(AVG(MATRICULAS.NOTA_FINAL), 2) AS 'Média Final'
FROM ALUNOS 
JOIN MATRICULAS ON ALUNOS.ID_ALUNO = MATRICULAS.ID_ALUNO 
GROUP BY ALUNOS.ID_ALUNO, ALUNOS.NOME_ALUNO 
ORDER BY AVG (MATRICULAS.NOTA_FINAL) DESC 
LIMIT 1;
-------------------------------------------------------------------------------------------