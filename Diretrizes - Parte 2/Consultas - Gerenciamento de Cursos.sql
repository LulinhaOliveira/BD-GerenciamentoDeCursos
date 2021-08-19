USE gerenciamentodecurso;
#CONSULTAS

#Dado um funcionario selecione todos os pedidos feitos por um funcionario entre 01/08/2019 até 01/12/2019

SELECT * FROM pedido JOIN funcionario ON funcionario.cpf = pedido.cpf
AND data_pedido BETWEEN '01/09/2019' AND '01/12/2019';

#Selecione todas as disciplinas de saúde em 2019.2

	SELECT * FROM disciplina 
WHERE codigo = (SELECT adc.codigo FROM area_conhecimento as adc WHERE adc.descricao = 'Saude');

#Retorna todas as sala que estão hospedando turmas do 5º semestre

SELECT * FROM sala JOIN turma on sala.id = turma.id_sala AND turma.semestre = 5;