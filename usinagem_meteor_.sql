CREATE DATABASE usinagem_meteor_;
use usinagem_meteor_;

-- Entidades Fortes
CREATE TABLE maquina(
	pk_id_maquina INT NOT NULL UNIQUE AUTO_INCREMENT,
	nome_maquina VARCHAR(40) NOT NULL,
	descricao__maquina VARCHAR(600) NOT NULL,
	capacidade_max INT NOT NULL,
	ultima_manutencao DATE NOT NULL,
    
    PRIMARY KEY (pk_id_maquina)
);
CREATE TABLE operador(
	pk_id_operador INT NOT NULL UNIQUE AUTO_INCREMENT,
	nome_operador VARCHAR(40) NOT NULL,
	especializacao VARCHAR(50) NOT NULL,
	disponibilidade TIME,
    
    PRIMARY KEY (pk_id_operador)
);
/* GERENCIAMENTO DE ESTOQUE DE MATÉRIAS-PRIMAS */
CREATE TABLE fornecedor(
	pk_id_operador INT NOT NULL UNIQUE AUTO_INCREMENT,
	nome_operador VARCHAR(40) NOT NULL,
	especializacao VARCHAR(50) NOT NULL,
	disponibilidade VARCHAR(25) NOT NULL,
    
    PRIMARY KEY (pk_id_operador)
);

-- ENTIDADES FRACAS
CREATE TABLE Peca(
	pk_id_peca INT NOT NULL UNIQUE AUTO_INCREMENT,
    descricao_peca VARCHAR(600) NOT NULL,
    fk_material INT NOT NULL,
	peso DECIMAL(10,2) NOT NULL,
	dimensoes VARCHAR(80) NOT NULL,
    
    PRIMARY KEY (pk_id_peca),
    FOREIGN KEY (fk_material) references materia_prima(pk_id_materia_prima)
);

/* CONTROLE DE QUALIDADE DE PEÇAS */

CREATE TABLE inspecao(
	pk_id_inspecao INT NOT NULL UNIQUE AUTO_INCREMENT ,
	fk_id_peca INT NOT NULL,
	data_inspecao DATE NOT NULL,
	resultado_inspecao VARCHAR(50) NOT NULL,
	observacoes VARCHAR(200),
    
    PRIMARY KEY (pk_id_inspecao),
    FOREIGN KEY (fk_id_peca) references Pecas(pk_id_peca)
);

CREATE TABLE rejeicao(
	pk_id_rejeicao INT NOT NULL UNIQUE AUTO_INCREMENT ,
	fk_id_peca INT NOT NULL,
	motivo_rejeicao VARCHAR(80) NOT NULL,
	data_rejeicao DATE NOT NULL,
	acoes_corretivas VARCHAR(200) NOT NULL,

	PRIMARY KEY (pk_id_rejeicao),
	FOREIGN KEY (fk_id_peca) references Pecas(pk_id_peca)
);

CREATE TABLE aceitacao(
	pk_id_aceitacao INT NOT NULL UNIQUE AUTO_INCREMENT,
	fk_id_peca INT NOT NULL,
	data_aceitacao DATE NOT NULL,
	destino_peca VARCHAR(200) NOT NULL,
	observacoes VARCHAR(200),
    
	PRIMARY KEY (pk_id_aceitacao),
	FOREIGN KEY (fk_id_peca) references Peca(pk_id_peca)
);

/* CONTROLE DE PRODUÇÃO DE PEÇAS */

CREATE TABLE ordens_de_producao(
	pk_id_ordem INT NOT NULL UNIQUE AUTO_INCREMENT,
	fk_id_peca INT NOT NULL,
	quant_ordem INT NOT NULL,
	data_inicio DATE NOT NULL,
    data_conclusao DATE NOT NULL,
	status_ordem VARCHAR(50) NOT NULL,

	PRIMARY KEY (pk_id_ordem),
	FOREIGN KEY (fk_id_peca) references Peca(pk_id_peca)
);

-- ---------------------------------------------------------------
/* MANUTENÇÃO DE EQUIPAMENTOS */

CREATE TABLE equipamento(
	pk_id_equipamento INT NOT NULL UNIQUE AUTO_INCREMENT,
	nome_equipamento VARCHAR(50) NOT NULL,
	descrição_equipamento VARCHAR(600) NOT NULL,
	data_aquisicao DATE NOT NULL,
	vida_util_restante VARCHAR(20) NOT NULL,
    fk_id_maquina INT NOT NULL,
    
    PRIMARY KEY (pk_id_equipamento),
	FOREIGN KEY (fk_id_maquina) references Maquina(pk_id_maquina)
);

CREATE TABLE manutencao_programada(
	pk_id_manutencao INT NOT NULL UNIQUE AUTO_INCREMENT ,
	fk_id_equipamento INT NOT NULL UNIQUE,
	tipo_manutencao VARCHAR(30) NOT NULL,
	data_programada DATE NOT NULL,
	responsavel_manutencao VARCHAR(40) NOT NULL,
    
	PRIMARY KEY (pk_id_manutencao),
	FOREIGN KEY (fk_id_equipamento) references equipamento(pk_id_equipamento)
);
CREATE TABLE historico_de_manutencao(
	pk_id_manutencao INT AUTO_INCREMENT NOT NULL UNIQUE,
	fk_id_equipamento  INT NOT NULL UNIQUE,
	tipo_manutencao  VARCHAR(30) NOT NULL,
	data_manutenção DATE NOT NULL,
	custos_manutenção DECIMAL(8,2),
	
    PRIMARY KEY (pk_id_manutencao),
	FOREIGN KEY (pk_id_manutencao) references manutencao_programada(pk_id_manutencao),
    FOREIGN KEY (fk_id_equipamento) references equipamento(pk_id_equipamento)
);

-- ---------------------------------------------------------------
/* GERENCIAMENTO DE ESTOQUE DE MATÉRIAS-PRIMAS */

CREATE TABLE materia_prima(
	pk_id_materia_prima INT NOT NULL UNIQUE  AUTO_INCREMENT,
	descricao VARCHAR(60) NOT NULL,
	fk_fornecedor INT NOT NULL,
	quant_estoque INT,
	data_ultima_compra DATE NOT NULL,
    
	PRIMARY KEY (pk_id_materia_prima),
	FOREIGN KEY (fk_fornecedor) references fornecedor(pk_id_fornecedor)
);



-- ---------------------------------------------------------------
/* HISTÓRICO DE PRODUÇÃO */
CREATE TABLE historico_producao(
	pk_id_his_prod INT NOT NULL UNIQUE  AUTO_INCREMENT ,
    fk_id_peca INT NOT NULL,
    fk_id_operador INT NOT NULL,
    fk_id_ordem INT NOT NULL,
    fk_id_maquina INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_conclusao DATE NOT NULL,
    lote INT NOT NULL UNIQUE,
    
    PRIMARY KEY (pk_id_his_prod),
	FOREIGN KEY (fk_id_peca) references Peca(pk_id_peca),
    FOREIGN KEY (fk_id_operador) references Operador(pk_id_operador),
    FOREIGN KEY (fk_id_ordem) references ordens_de_producao(pk_id_ordem),
    FOREIGN KEY (fk_id_maquina) references Maquina(pk_id_maquina)
);

