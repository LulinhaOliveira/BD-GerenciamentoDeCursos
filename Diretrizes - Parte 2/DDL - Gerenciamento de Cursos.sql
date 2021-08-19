CREATE DATABASE gerenciamentodecurso;
USE gerenciamentodecurso;

CREATE TABLE endereco (
    cep varchar(9),
    rua varchar(55) NOT NULL,
    bairro varchar(55) NOT NULL,
    cidade varchar(55) NOT NULL,
    estado varchar(55) NOT NULL,
    pais varchar(55) NOT NULL,
    
    PRIMARY KEY (cep)
);

CREATE TABLE usuario (
	cpf varchar(11),
    nome varchar(255) NOT NULL,
    sexo char NOT NULL check( sexo = 'M' or sexo = 'F'),
    telefone varchar(16) NOT NULL,
    telefone_secundario varchar(16) DEFAULT null,
    cep varchar(9) NOT NULL,
    numero int(11) NOT NULL,
    email varchar(55) NOT NULL UNIQUE,
    senha varchar(55) NOT NULL,
    ativo int(1) DEFAULT 1,
    idade int(2) DEFAULT NULL,
    data_nasc date NOT NULL,
    
    PRIMARY KEY (cpf),
	FOREIGN KEY (cep) REFERENCES endereco(cep) ON UPDATE CASCADE 
);

CREATE TABLE bonificacao (
	id int(11) AUTO_INCREMENT,
    valor float(20) NOT NULL,
	data_boni date NOT NULL,
    descricao varchar(255) DEFAULT null,
    
    PRIMARY KEY (id)
);

CREATE TABLE empresa(
	cnpj_empresa varchar(14),
    razao_social varchar(255) NOT NULL,
    
    PRIMARY KEY (cnpj_empresa)
);

CREATE TABLE filial (
	cnpj varchar(14),
    razao_social varchar(255) DEFAULT null,
    nome_fantasia varchar(255) NOT NULL,
    cnpj_empresa varchar(14) NOT NULL,
    
    PRIMARY KEY (cnpj),
    FOREIGN KEY (cnpj_empresa) REFERENCES empresa(cnpj_empresa) ON UPDATE CASCADE
);

CREATE TABLE unidade (
	id int(11) AUTO_INCREMENT,
    tipo varchar(55) NOT NULL,
    nome varchar(255) NOT NULL,
    cnpj varchar (14) NOT NULL,
    
    PRIMARY KEY (id),
    FOREIGN KEY (cnpj) REFERENCES filial (cnpj) ON UPDATE CASCADE
);

CREATE TABLE funcionario (
	cpf varchar(11),
    salario float(20) NOT NULL,
    dt_contratacao date NOT NULL,
    dt_fim_contratacao date DEFAULT null,
    id_boni int(11) DEFAULT null,
    id_unidade int(11) NOT NULL, 

    PRIMARY KEY (cpf),
    FOREIGN KEY (cpf) REFERENCES usuario (cpf) ON UPDATE CASCADE,
    FOREIGN KEY (id_boni) REFERENCES bonificacao(id),
    FOREIGN KEY (id_unidade) REFERENCES unidade(id) ON UPDATE CASCADE
);

CREATE TABLE aluno (
	cpf varchar(11),
    
    PRIMARY KEY (cpf),
    FOREIGN KEY (cpf) REFERENCES usuario(cpf) ON UPDATE CASCADE
);

CREATE TABLE periodo_letivo (
	id_periodo int(11) AUTO_INCREMENT,
	ano int(4) NOT NULL,
    data_inicio date NOT NULL,
    data_final date NOT NULL,
    ativo int(1) DEFAULT 1,
    semestre varchar(10) NOT NULL,
    calendario varchar(55) NOT NULL,
    obs varchar(255) DEFAULT null,
    
    PRIMARY KEY (id_periodo)
);

CREATE TABLE assunto (
	cod int(11) AUTO_INCREMENT,
    descricao varchar(255) DEFAULT null,
    nivel varchar(55) DEFAULT null,
    
    PRIMARY KEY (cod)
);

CREATE TABLE area_conhecimento (
	codigo int(11) AUTO_INCREMENT,
    descricao varchar(255) DEFAULT null,
    cod int(11) NOT NULL,
    
    PRIMARY KEY (codigo),
    FOREIGN KEY (cod) REFERENCES assunto(cod)  ON UPDATE CASCADE
);

CREATE TABLE administrador (
	cpf varchar(11),
    
    PRIMARY KEY (cpf),
    FOREIGN KEY (cpf) REFERENCES funcionario(cpf) ON UPDATE CASCADE
);

CREATE TABLE curso (
	codigo int(11) AUTO_INCREMENT,
    nome varchar(255) NOT NULL,
    data_criacao date DEFAULT null,
    horario_funcionamento varchar(255) NOT NULL,
    cpf varchar(11) NOT NULL UNIQUE,
    id_unidade int(11) DEFAULT null, 
    
    PRIMARY KEY (codigo),
    FOREIGN KEY (cpf) REFERENCES administrador(cpf)  ON UPDATE CASCADE,
    FOREIGN KEY (id_unidade) REFERENCES unidade(id) ON UPDATE CASCADE
    
);

CREATE TABLE disciplina (
	id int(11) AUTO_INCREMENT,
    nome varchar(55) NOT NULL,
    ementa text DEFAULT null,
    num_creditos int(11) DEFAULT null,
    codigo int(11) NOT NULL,
    id_disci_requisito int(11) DEFAULT NULL,
    curso int(11) NOT NULL,
    
    PRIMARY KEY (id),
    FOREIGN KEY (codigo) REFERENCES area_conhecimento (codigo)  ON UPDATE CASCADE,
    FOREIGN KEY (id_disci_requisito) REFERENCES disciplina (id), 
    FOREIGN KEY (curso) REFERENCES curso (codigo)
    
);

CREATE TABLE professor (
	cpf varchar(11),
    
    PRIMARY KEY (cpf),
    FOREIGN KEY (cpf) REFERENCES funcionario(cpf) ON UPDATE CASCADE
);

CREATE TABLE oferta_disciplina (
	id_disciplina int(11) NOT NULL,
	id_periodo int(11) NOT NULL,
    ativo int(1) DEFAULT 1,
    dia_1 varchar(20) NOT NULL,
    dia_2 varchar (20) NOT NULL,
    hora_1 time NOT NULL,
    hora_2 time NOT NULL,
    cpf varchar (11) NOT NULL,
    
    PRIMARY KEY(id_disciplina, id_periodo),
    FOREIGN KEY(id_disciplina) REFERENCES disciplina (id),
    FOREIGN KEY (id_periodo) REFERENCES periodo_letivo (id_periodo),
    FOREIGN KEY (cpf) REFERENCES professor(cpf)  ON UPDATE CASCADE
);

CREATE TABLE sala (
	id int (11) AUTO_INCREMENT,
    numero int(3) NOT NULL,
    capacidade int(3) NOT NULL,
    
    PRIMARY KEY (id)
);

CREATE TABLE turma (
	codigo int(11) AUTO_INCREMENT,
    nome varchar(255) NOT NULL,
    sigla varchar(20) DEFAULT null,
    semestre int(2) NOT NULL,
    ano date NOT NULL,
    quantidade_alunos int(3) NOT NULL DEFAULT 0,
    turno varchar(20) NOT NULL check( turno = 'manha' or turno = 'tarde'),
    ativo int(1) DEFAULT 1,
    id_sala int(11),
    
    PRIMARY KEY(codigo),
    FOREIGN KEY(id_sala) REFERENCES sala(id) ON UPDATE CASCADE
);

CREATE TABLE responsavel_financeiro (
	nome varchar(255) NOT NULL,
    parentesco varchar(55) NOT NULL,
    telefone varchar(16) NOT NULL,
    email varchar(55) NOT NULL UNIQUE,
    cpf_aluno varchar(11) NOT NULL,
    
    PRIMARY KEY (nome, cpf_aluno),
    FOREIGN KEY (cpf_aluno) REFERENCES aluno(cpf) ON UPDATE CASCADE
);

CREATE TABLE aviso (
	numero_aviso int(11) AUTO_INCREMENT,
    assunto varchar(255) NOT NULL,
    texto text DEFAULT null,
    data_aviso date NOT NULL,
    validade_dias int(3) DEFAULT null,
    cpf varchar(11),
    
    PRIMARY KEY (numero_aviso),
    FOREIGN KEY (cpf) REFERENCES funcionario(cpf)  ON UPDATE CASCADE
);

CREATE TABLE pacote_matricula (
	id int(11) AUTO_INCREMENT,
    descricao varchar(255) NOT NULL,
    dt_inicio date NOT NULL,
    taxas_juros_dia float(20) DEFAULT null, 
    tipo varchar(255) NOT NULL,
    validade_meses int(2) NOT NULL,
    codigo int(11),
    
    PRIMARY KEY (id),
    FOREIGN KEY (codigo) REFERENCES curso(codigo)
);

CREATE TABLE aluno_matricula_curso (
	codigo int(11) AUTO_INCREMENT,
    dt_inicio date NOT NULL,
    data_fim date NOT NULL,
    ativo int(1) DEFAULT 1,
    obs varchar(255) DEFAULT null,
    doc_contrato text NOT NULL,
    cpf varchar(11) NOT NULL UNIQUE,
    codigo_curso int(11),
    
    PRIMARY KEY (codigo),
    FOREIGN KEY (cpf) REFERENCES aluno(cpf)  ON UPDATE CASCADE,
    FOREIGN KEY (codigo_curso) REFERENCES curso(codigo)
);

CREATE TABLE boleto (
	codigo int(11) AUTO_INCREMENT,
    carteira varchar(255) NOT NULL,
    data_venc date NOT NULL,
    ativo int(1) DEFAULT 1,
    num varchar(55) NOT NULL,
    valor float(20) NOT NULL,
    data_emissao date NOT NULL,
    codigo_do_banco varchar(55) NOT NULL,
    codigo_matricula int(11) NOT NULL,
    
    PRIMARY KEY (codigo),
    FOREIGN KEY (codigo_matricula) REFERENCES aluno_matricula_curso(codigo)  ON UPDATE CASCADE
);

CREATE TABLE avaliacao (
	codigo int(11) AUTO_INCREMENT,
    numero_questoes int(3) NOT NULL,
    obs varchar(255) DEFAULT null,
    ativo int(1) DEFAULT null,
    tipo varchar(255) NOT NULL check (tipo = 'simulado' or tipo = 'prova' or tipo = 'vestibular'),
    
    PRIMARY KEY (codigo)
);

CREATE TABLE questao (
	id int(11) AUTO_INCREMENT,
    pergunta text NOT NULL,
    tipo varchar(255) DEFAULT null,
    cpf varchar(11),
    
    PRIMARY KEY(id),
    FOREIGN KEY (cpf) REFERENCES professor(cpf)  ON UPDATE CASCADE
);

CREATE TABLE alternativa (
	id int(11),
    letra char NOT NULL,
    descricao varchar(255) DEFAULT null,
    eh_altern_correta char NOT NULL,
    
    PRIMARY KEY (id, letra),
    FOREIGN KEY (id) REFERENCES questao (id)  ON UPDATE CASCADE
);

CREATE TABLE material (
	id int(11) AUTO_INCREMENT,
    descricao varchar(255) DEFAULT null,
    url varchar(255) DEFAULT null UNIQUE,
    assunto varchar(255) DEFAULT null,
    tipo varchar(255) DEFAULT null,
    
    PRIMARY KEY (id)
);

CREATE TABLE monitor (
	cpf varchar(11),
    
    PRIMARY KEY (cpf),
    FOREIGN KEY (cpf) REFERENCES funcionario(cpf)  ON UPDATE CASCADE
);

CREATE TABLE redes_sociais (
	codigo int(11) AUTO_INCREMENT,
    url varchar(255) NOT NULL,
    descricao varchar(255) DEFAULT null,
    id_curso int(11) ,
    cpf varchar(11),
    
    PRIMARY KEY (codigo),
    FOREIGN KEY (id_curso) REFERENCES curso(codigo),
    FOREIGN KEY (cpf) REFERENCES funcionario(cpf)  ON UPDATE CASCADE
);

CREATE TABLE secretaria (
	cpf varchar(11),
    
    PRIMARY KEY (cpf),
    FOREIGN KEY (cpf) REFERENCES funcionario(cpf)  ON UPDATE CASCADE
);

CREATE TABLE almoxarifado (
	id int(11) AUTO_INCREMENT,
    local_almoxarifado varchar(55) NOT NULL,
    numero_de_itens int(4) DEFAULT null,
    descricao varchar(255) DEFAULT null,
    tipo varchar(255) NOT NULL,
    cpf varchar(11) NOT NULL UNIQUE,
    
    PRIMARY KEY(id),
    FOREIGN KEY (cpf) REFERENCES secretaria(cpf)  ON UPDATE CASCADE
);

CREATE TABLE estante (
	corredor int(2),
    prateleira int(2),
    
    PRIMARY KEY(corredor, prateleira)
);

CREATE TABLE produto_ref (
	cod int(11) AUTO_INCREMENT,
    descricao varchar(255) DEFAULT null,
    unidade int (3) NOT NULL,
    cod_barra varchar(55) NOT NULL UNIQUE,
    preco_unit float(20) NOT NULL,
    marca varchar(255) DEFAULT null,
	tipo varchar(255) NOT NULL,

    PRIMARY KEY (cod)
);

CREATE TABLE item_almoxarifado (
	id_almo int(11),
    cod int(11) UNIQUE,
    corredor int(2),
    prateleira int(2),
    qtd_min int(3) NOT NULL,
    qtd_atual int(3) NOT NULL,
    
    PRIMARY KEY (id_almo, cod),
    FOREIGN KEY (corredor, prateleira) REFERENCES estante(corredor, prateleira)  ON UPDATE CASCADE,
    FOREIGN KEY (id_almo) REFERENCES almoxarifado(id)  ON UPDATE CASCADE,
    FOREIGN KEY (cod) REFERENCES produto_ref(cod)  ON UPDATE CASCADE
);

CREATE TABLE pedido (
	cod int(11) AUTO_INCREMENT,
    data_pedido date NOT NULL,
    dt_atend date NOT NULL,
    ativo varchar(255) DEFAULT '',
    cpf varchar(11),
    
    PRIMARY KEY (cod),
    FOREIGN KEY (cpf) REFERENCES funcionario(cpf)  ON UPDATE CASCADE
);

CREATE TABLE item_pedido (
	cod_prod int(11),
    cod_ped int(11),
    qtd_solicitada int(2),
    
    PRIMARY KEY (cod_prod, cod_ped),
    FOREIGN KEY (cod_prod) REFERENCES produto_ref(cod)  ON UPDATE CASCADE,
    FOREIGN KEY (cod_ped) REFERENCES pedido(cod)  ON UPDATE CASCADE
);

CREATE TABLE candidato (
	cpf varchar(11),
    nome varchar(255) NOT NULL,
    telefone varchar(16) NOT NULL,
    email varchar(255) NOT NULL UNIQUE,
    data_candidato date NOT NULL,
    
    PRIMARY KEY (cpf)
);

CREATE TABLE candidato_vestibular(
	cpf varchar(11),
    codigo int(11),
    data_can_vest date NOT NULL,
    nota float(20) NOT NULL,
    situacao varchar(255) NOT NULL,
    
    PRIMARY KEY(cpf, codigo),
    FOREIGN KEY(cpf) REFERENCES candidato(cpf)  ON UPDATE CASCADE,
    FOREIGN KEY(codigo) REFERENCES avaliacao(codigo)
);

CREATE TABLE candidato_curso(
	cpf varchar(11),
    codigo int(11),
    data_can_curso date NOT NULL,
    
    PRIMARY KEY(cpf, codigo),
    FOREIGN KEY(cpf) REFERENCES candidato(cpf)  ON UPDATE CASCADE,
    FOREIGN KEY(codigo) REFERENCES curso(codigo)

);

CREATE TABLE aluno_turma(
	cpf varchar(11),
    codigo int(11),
    
    PRIMARY KEY(cpf, codigo),
    FOREIGN KEY(cpf) REFERENCES aluno(cpf)  ON UPDATE CASCADE,
    FOREIGN KEY(codigo) REFERENCES turma(codigo)  ON UPDATE CASCADE
);

CREATE TABLE professor_material(
	cpf varchar(11),
    id int(11),
    data_p_m date NOT NULL,
     
	PRIMARY KEY(cpf, id),
    FOREIGN KEY(cpf) REFERENCES professor(cpf)  ON UPDATE CASCADE,
    FOREIGN KEY(id) REFERENCES material(id)  ON UPDATE CASCADE
   
);

CREATE TABLE monitor_material(
	cpf varchar(11),
    id int(11),
    data_p_m date NOT NULL,
     
	PRIMARY KEY(cpf, id),
    FOREIGN KEY(cpf) REFERENCES monitor(cpf)  ON UPDATE CASCADE,
    FOREIGN KEY(id) REFERENCES material(id)  ON UPDATE CASCADE
   
);

CREATE TABLE professor_area(
	cpf varchar(11),
    codigo int(11),
    
	PRIMARY KEY(cpf, codigo),
    FOREIGN KEY(cpf) REFERENCES professor(cpf)  ON UPDATE CASCADE,
    FOREIGN KEY(codigo) REFERENCES area_conhecimento(codigo)  ON UPDATE CASCADE
   
);

CREATE TABLE assunto_avalia(
	cod_assunto int(11),
    cod_aval int(11),

	PRIMARY KEY(cod_assunto, cod_aval),
    FOREIGN KEY(cod_assunto) REFERENCES assunto(cod)  ON UPDATE CASCADE,
    FOREIGN KEY(cod_aval) REFERENCES avaliacao(codigo)  ON UPDATE CASCADE
);

CREATE TABLE avaliacao_questao(
	codigo int(11),
    id int(11),
    
    PRIMARY KEY(codigo, id),
    FOREIGN KEY(codigo) REFERENCES avaliacao(codigo)  ON UPDATE CASCADE,
    FOREIGN KEY(id) REFERENCES questao(id)  ON UPDATE CASCADE

);

CREATE TABLE aviso_turma(
	numero_aviso int(11),
    codigo int(11),
    
    PRIMARY KEY(numero_aviso, codigo),
    FOREIGN KEY(numero_aviso) REFERENCES aviso(numero_aviso),
    FOREIGN KEY(codigo) REFERENCES turma(codigo)  ON UPDATE CASCADE

);


CREATE TABLE aviso_curso(
	numero_aviso int(11),
    codigo int(11),
    
    PRIMARY KEY(numero_aviso, codigo),
    FOREIGN KEY(numero_aviso) REFERENCES aviso(numero_aviso),
    FOREIGN KEY(codigo) REFERENCES curso(codigo)  ON UPDATE CASCADE

);


CREATE TABLE aluno_oferta_disciplina(
	id_disciplina int(11),
    id_periodo int(11),
    cpf varchar(11),
    data_matricula date NOT NULL,
    media_final float,
    
    PRIMARY KEY(id_disciplina, id_periodo, cpf),
    FOREIGN KEY(id_disciplina, id_periodo) REFERENCES oferta_disciplina(id_disciplina, id_periodo)  ON UPDATE CASCADE,
    FOREIGN KEY(cpf) REFERENCES aluno(cpf)  ON UPDATE CASCADE
);

CREATE TABLE aluno_avaliacao_oferta_disciplina(
	id_disciplina int(11),
    id_periodo int(11),
    cpf varchar (11),
    codigo int(11),
    nota float,
    
    PRIMARY KEY(id_disciplina, id_periodo, cpf, codigo),
    FOREIGN KEY(id_disciplina, id_periodo) REFERENCES oferta_disciplina(id_disciplina, id_periodo)  ON UPDATE CASCADE,
    FOREIGN KEY(cpf) REFERENCES aluno(cpf)  ON UPDATE CASCADE,
    FOREIGN KEY(codigo) REFERENCES avaliacao(codigo)  ON UPDATE CASCADE
);



