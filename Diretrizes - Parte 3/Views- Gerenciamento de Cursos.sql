CREATE VIEW vw_ofertas_disciplina
AS 
SELECT DI.nome AS Disciplina, DI.ementa AS Ementa, DI.num_creditos AS Quantidade_Creditos, DIS.nome AS Requisito, PE.semestre AS Semestre, PE.ano AS Ano, PE.obs AS Observação, PE.data_inicio As Inicio, PE.data_final AS Final, OD.dia_1 AS 1°Dia, OD.hora_1 AS 1°Hora, OD.dia_2 AS 2°Dia, OD.hora_2 AS 2°Hora, CU.nome AS Curso, CU.horario_funcionamento AS 'Horario De Funcionamento', UN.nome AS Unidade, UN.cnpj AS 'CNPJ Unidade', UN.tipo AS 'Tipo da Unidade', US.nome AS Professor, US.telefone AS Telefone, US.idade AS Idade, US.email AS 'E-mail'
FROM  periodo_letivo PE INNER JOIN  oferta_disciplina OD ON PE.id_periodo = OD.id_periodo
INNER JOIN disciplina DI ON OD.id_disciplina = DI.id
LEFT JOIN disciplina DIS ON DI.id_disci_requisito = DIS.id
INNER JOIN curso CU ON DI.curso = CU.codigo
INNER JOIN unidade UN ON CU.id_unidade = UN.id
INNER JOIN usuario US ON OD.cpf = US.cpf;

CREATE VIEW vw_posicionamento_almoxarifado
AS
SELECT US.nome AS Funcionario, US.telefone AS Telefone, US.email AS 'E-mail', US.IDADE AS Idade, PE.cod AS Codigo, PE.data_pedido, PE.dt_atend AS 'Data de Atendimento', PE.ativo AS 'Status', IP.qtd_solicitada AS 'Quantidade de Itens Solicitada', PR.descricao AS 'Descrição Do Produto', PR.cod_barra AS 'Codigo de Barras', PR.marca AS Marca, PR.tipo AS 'Tipo do Produto', PR.preco_unit AS Preço, IA.id_almo AS 'Id Almoxarifado', IA.corredor AS Corredor, IA.prateleira AS Prateleira, IA.qtd_min AS 'Quantidade Minima', IA.qtd_atual AS 'Quantidade Atual', A.local_almoxarifado AS 'Local', A.numero_de_itens AS 'Quantidade de Itens do Almoxarifado', A.descricao AS 'Descrição Do Almoxarifado', A.tipo AS 'Tipo do Almoxarifado'
FROM funcionario AS F INNER JOIN usuario US ON F.cpf = US.cpf 
INNER JOIN pedido PE ON US.cpf = PE.cpf
INNER JOIN item_pedido IP ON  PE.cod = IP.cod_ped
INNER JOIN produto_ref PR ON IP.cod_prod = PR.cod
INNER JOIN item_almoxarifado IA ON PR.cod = IA.cod
INNER JOIN almoxarifado A ON IA.id_almo = A.id;
 
CREATE VIEW vw_boletos_a_pagar
AS
SELECT US.nome AS Aluno, US.idade, US.telefone, US.email, T.nome AS Turma, T.sigla, T.semestre, T.quantidade_alunos, T.turno, T.ano, AM.codigo AS 'Matricula', AM.dt_inicio, AM.data_fim, AM.obs, AM.doc_contrato, C.nome AS Curso, C.data_criacao, C.horario_funcionamento, U.nome AS Unidade, U.tipo, U.cnpj, B.codigo, B.carteira, B.data_venc, B.num, B.valor, B.data_emissao, B.codigo_do_banco
FROM aluno AS A INNER JOIN usuario US ON A.cpf = US.cpf
INNER JOIN aluno_turma AS A_T ON US.cpf = A_T.cpf 
INNER JOIN turma AS T ON A_T.codigo = T.codigo
INNER JOIN aluno_matricula_curso AS AM ON AM.cpf = A.cpf  
INNER JOIN curso AS C ON  AM.codigo_curso = C.codigo
INNER JOIN boleto AS B ON AM.codigo = B.codigo_matricula
INNER JOIN unidade AS U ON C.id_unidade =  U.id
WHERE B.ativo = 1;