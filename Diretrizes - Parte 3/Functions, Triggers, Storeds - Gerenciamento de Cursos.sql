USE gerenciamentodecurso;

DELIMITER $
CREATE FUNCTION atrasado_boleto(id_boleto int(11))
 RETURNS float(20)
 READS SQL DATA
 DETERMINISTIC
 BEGIN 
  DECLARE taxa float;
  DECLARE dta_ve date;
  DECLARE result float;
  DECLARE valor_boleto float(20);
  DECLARE resultado float;
  IF (select COUNT(*) from boleto where id_boleto = boleto.codigo) = 0 THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Codigo do Boleto Não Existe';
  ELSE
   IF (select ativo from boleto where boleto.codigo = id_boleto) = 1 THEN 
    SET taxa = (select taxas_juros_dia FROM pacote_matricula, curso, aluno_matricula_curso , 
    boleto WHERE id_boleto = boleto.codigo AND boleto.codigo_matricula = aluno_matricula_curso.codigo AND aluno_matricula_curso.codigo_curso = curso.codigo AND pacote_matricula.codigo = curso.codigo);
    SET dta_ve = (select data_venc FROM boleto WHERE id_boleto = boleto.codigo);
    SET valor_boleto = (select valor FROM boleto WHERE id_boleto = boleto.codigo);
    SET result = (select datediff(dta_ve, CURDATE())); 
    IF result  <  0 THEN
	 SET resultado = result * (-taxa);
     RETURN resultado + valor_boleto ;
    ELSE
     RETURN valor_boleto;
	END IF;
   ELSE 
    SIGNAL SQLSTATE '45000' SET message_text = 'Boleto Pago';
   END IF;
  END IF;
 END$

DELIMITER $
CREATE FUNCTION avisos_atrasados()
 RETURNS int
 READS SQL DATA
 DETERMINISTIC
 BEGIN
  DECLARE dias int;
  SET dias = (SELECT COUNT(*) FROM aviso WHERE ADDDATE(data_aviso, validade_dias) < CURDATE()) ;
  return dias;
 END $

DELIMITER $
CREATE FUNCTION mensalidade_quites (cod_aluno int)
 RETURNS boolean
 READS SQL DATA
 DETERMINISTIC
 BEGIN
  DECLARE contador int;
  IF (SELECT COUNT(*) FROM aluno_matricula_curso where cod_aluno = aluno_matricula_curso.codigo) = 0 THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Aluno Não Encontrado';
  ELSE
   SET contador = (SELECT COUNT(*) FROM boleto WHERE boleto.codigo_matricula = cod_aluno AND ativo = 1) ;
     IF contador > 0 THEN 
      return false;
	 ELSE 
	  return true;
	 END IF;
    END IF;
 END $

DELIMITER $
CREATE TRIGGER insert_aluno_turma 
after insert on aluno_turma for each row
BEGIN
 UPDATE turma set quantidade_alunos = quantidade_alunos + 1 where new.codigo = turma.codigo;
END $ 

DELIMITER $
CREATE TRIGGER remove_aluno_turma 
after delete on aluno_turma for each row
BEGIN
 UPDATE turma set quantidade_alunos = quantidade_alunos - 1 where old.codigo = turma.codigo;
 
END $ 

DELIMITER $
CREATE TRIGGER insert_produto_almoxarifado
after insert on item_almoxarifado for each row
BEGIN
 UPDATE almoxarifado set numero_de_itens = numero_de_itens + 1 where new.id_almo = almoxarifado.id;
END $

DELIMITER $
CREATE TRIGGER remove_produto_almoxarifado
after delete on item_almoxarifado for each row
BEGIN
UPDATE almoxarifado set numero_de_itens = numero_de_itens - 1 where old.id_almo = almoxarifado.id; 
END $

DELIMITER $ 
CREATE TRIGGER gera_idade
before insert on usuario for each row
BEGIN 
 DECLARE dt int;
 SET dt = timestampdiff(year, new.data_nasc, curdate());
 set new.idade = dt  ;
END $

DELIMITER $
CREATE PROCEDURE atender_pedido (cod_pedido int) 
 BEGIN
 DECLARE cod_produto int;
 DECLARE status_aux boolean;
 DECLARE qtd_itens int;
 DECLARE qtd_atual2 int;
 DECLARE qtd_min2 int;
 DECLARE fim boolean DEFAULT true;
 DECLARE cur_codPed CURSOR FOR SELECT item_pedido.cod_prod, item_pedido.qtd_solicitada FROM item_pedido WHERE cod_pedido = item_pedido.cod_ped;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = false;
 SET status_aux = true;
 
 IF (SELECT COUNT(*) FROM pedido WHERE cod_pedido = pedido.cod) = 0 THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pedido Não Encontrado';
 ELSE
 OPEN cur_codPed;
 
 FETCH cur_codPed INTO cod_produto, qtd_itens;
 mywhile: WHILE fim DO
  set qtd_atual2 = (select qtd_atual  from item_almoxarifado where cod_produto = item_almoxarifado.cod);
  SET qtd_min2   = (select qtd_min    from item_almoxarifado where cod_produto = item_almoxarifado.cod);
  IF qtd_atual2 - qtd_itens < qtd_min2 THEN
   SET status_aux = false;
   leave mywhile;
  ELSE
    FETCH cur_codPed INTO cod_produto, qtd_itens;
  END IF;
 END WHILE;
 CLOSE cur_codPed;
 SET fim = true;
 IF status_aux = false THEN
  UPDATE pedido set ativo = 'Não-Atendido Por Falta' WHERE cod_pedido = pedido.cod;
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantidade de Itens em Falta';
 ELSE
  OPEN cur_codPed;
  WHILE fim DO
   FETCH cur_codPed INTO cod_produto, qtd_itens;
   UPDATE item_almoxarifado set qtd_atual = item_almoxarifado.qtd_atual - qtd_itens WHERE cod_produto = item_almoxarifado.cod;
  END WHILE;
	UPDATE pedido set ativo = 'Atendido' where cod_pedido = pedido.cod; 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pedido Atentido';
 END IF;
 CLOSE cur_codPed;
 END IF;
 END $
  
 DELIMITER $
 create procedure gerar_media(cpf varchar(11), id_disc int, id_periodo int)
  begin
  DECLARE media_final2 float;
  IF LENGTH(cpf) <> 11 THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tamanho do CPF Incorreto';
  ELSE
   IF (SELECT COUNT(*) FROM aluno_oferta_disciplina WHERE cpf = aluno_oferta_disciplina.cpf) = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Aluno Não Encontrado';
   ELSE
    IF( SELECT COUNT(*) FROM aluno_avaliacao_oferta_disciplina WHERE cpf = aluno_avaliacao_oferta_disciplina.cpf) <> 0 THEN
     SET media_final2 = (SELECT SUM(nota) from aluno_avaliacao_oferta_disciplina as aaof where cpf =  aaof.cpf AND id_disc = aaof.id_disciplina AND id_periodo = aaof.id_periodo)/2;
     UPDATE aluno_oferta_disciplina as od SET media_final = media_final2 WHERE cpf =  od.cpf AND id_disc = od.id_disciplina AND id_periodo = od.id_periodo;
	ELSE
     SET media_final2 = 0;
	 UPDATE aluno_oferta_disciplina as od SET media_final = media_final2 WHERE cpf =  od.cpf AND id_disc = od.id_disciplina AND id_periodo = od.id_periodo;
    END IF;
   END IF;
  END IF;
  END$
 
 CREATE PROCEDURE disciplina_para_aluno(cpf varchar(11))
 BEGIN
  DECLARE id_disc int;
  DECLARE cont int;
  DECLARE fim boolean DEFAULT true;
  DECLARE cur_DisCurso CURSOR FOR SELECT oferta_disciplina.id_disciplina FROM oferta_disciplina join disciplina on oferta_disciplina.id_disciplina = disciplina.id join curso on disciplina.curso = curso.codigo join aluno_matricula_curso on aluno_matricula_curso.codigo_curso WHERE aluno_matricula_curso.cpf = cpf AND oferta_disciplina.id_periodo = 1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = false;
  SET cont = 0; 
  
  IF CHAR_LENGTH(cpf) <> 11 THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tamanho do CPF Incorreto';
  ELSE
  IF (SELECT COUNT(*) FROM aluno WHERE aluno.cpf = cpf) = 0 THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Aluno Não Encontrado';
  ELSE
  OPEN cur_DisCurso;
  mywhile: WHILE fim DO
   FETCH cur_DisCurso INTO id_disc; 
    IF cont < 3 or fim = false THEN 
     INSERT INTO aluno_oferta_disciplina (id_disciplina, id_periodo, cpf, data_matricula) VALUES (id_disc, 1 ,cpf, CURDATE());
     SET cont = cont + 1;
    ELSE
     leave mywhile;
    END IF;
  END WHILE;
 CLOSE cur_DisCurso;
 END IF;
 END IF;
 END $