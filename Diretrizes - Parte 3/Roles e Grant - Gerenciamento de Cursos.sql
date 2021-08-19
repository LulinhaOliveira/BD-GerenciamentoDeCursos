use gerenciamentodecurso;
CREATE USER 'administrador'@'localhost' IDENTIFIED BY 'senhaadm';
GRANT ALL PRIVILEGES ON gereciamentodecurso.* TO 'administrador';

CREATE USER 'professor'@'localhost' IDENTIFIED BY 'senhaprof';
GRANT INSERT, DELETE, UPDATE, SELECT ON gerenciamentodecurso.questao TO 'professor';
GRANT SELECT  ON gerenciamentodecurso.disciplina TO 'professor';
GRANT INSERT, DELETE, UPDATE, SELECT ON gerenciamentodecurso.oferta_disciplina TO 'professor';
GRANT INSERT, DELETE, UPDATE, SELECT ON gerenciamentodecurso.assunto TO 'professor';
GRANT INSERT, DELETE, UPDATE, SELECT ON gerenciamentodecurso.avaliacao TO 'professor';
GRANT INSERT, DELETE, UPDATE, SELECT ON gerenciamentodecurso.material TO 'professor';
GRANT INSERT, UPDATE, SELECT  ON gerenciamentodecurso.area_conhecimento TO 'professor';
GRANT INSERT, DELETE, UPDATE, SELECT ON gerenciamentodecurso.aviso TO 'professor';

CREATE USER 'monitor'@'localhost' IDENTIFIED BY 'senhamon';
GRANT INSERT, DELETE, UPDATE, SELECT ON gereciamentodecurso.aviso TO 'monitor';
GRANT INSERT, DELETE, UPDATE, SELECT ON gerenciamentodecurso.material TO 'monitor';

CREATE USER 'secretaria'@'localhost' IDENTIFIED BY 'senhasec';
GRANT UPDATE, SELECT  ON gerenciamentodecurso.almoxarifado TO 'secretaria';
GRANT INSERT, DELETE, UPDATE, SELECT ON gerenciamentodecurso.item_almoxarifado TO 'secretaria';
GRANT INSERT, DELETE, UPDATE, SELECT ON gerenciamentodecurso.produto_ref TO 'secretaria';
GRANT INSERT, DELETE, UPDATE, SELECT ON gerenciamentodecurso.item_pedido TO 'secretaria';
GRANT INSERT, DELETE, UPDATE, SELECT ON gerenciamentodecurso.pedido TO 'secretaria';
GRANT INSERT, DELETE, UPDATE, SELECT ON gerenciamentodecurso.aviso TO 'secretaria';

CREATE USER 'aluno'@'localhost' IDENTIFIED BY 'senhalu';
GRANT SELECT ON gerenciamentodecurso.aluno_oferta_disciplina TO 'aluno';
GRANT SELECT ON gerenciamentodecurso.disciplina TO 'aluno';
GRANT SELECT ON gerenciamentodecurso.oferta_disciplina TO 'aluno';
GRANT SELECT ON gerenciamentodecurso.aluno_turma TO 'aluno';
GRANT SELECT ON gerenciamentodecurso.aluno_matricula_curso TO 'aluno';
GRANT SELECT ON gerenciamentodecurso.boleto TO 'aluno';
GRANT SELECT ON gerenciamentodecurso.aluno_avaliacao_oferta_disciplina TO 'aluno';
GRANT SELECT ON gerenciamentodecurso.responsavel_financeiro TO 'aluno';
GRANT SELECT ON gerenciamentodecurso.aviso TO 'aluno';