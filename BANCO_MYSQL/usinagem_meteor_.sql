CREATE DATABASE usinagem_meteor_;
use usinagem_meteor_;

-- Entidades Fortes
CREATE TABLE maquina(
	pk_id_maquina INT NOT NULL UNIQUE AUTO_INCREMENT,
	nome_maquina VARCHAR(40) NOT NULL,
	descricao_maquina VARCHAR(600) NOT NULL,
	capacidade_max INT NOT NULL,
	ultima_manutencao DATE NOT NULL,
    
    PRIMARY KEY (pk_id_maquina)
);
CREATE TABLE operador(
	pk_id_operador INT NOT NULL UNIQUE AUTO_INCREMENT,
	fk_id_historico INT NOT NULL, -- conferir dps este dado
	nome_operador VARCHAR(40) NOT NULL,
	especializacao VARCHAR(50) NOT NULL,
	disponibilidade TIME,
	
    
    PRIMARY KEY (pk_id_operador)
);
/* GERENCIAMENTO DE ESTOQUE DE MATÉRIAS-PRIMAS */

CREATE TABLE fornecedor(
	pk_id_fornecedor INT NOT NULL UNIQUE AUTO_INCREMENT,
	nome_fornecedor VARCHAR(40) NOT NULL,
	endereco VARCHAR(60) NOT NULL,
	contato VARCHAR(14) NOT NULL,  			-- mais??
	avaliacao_fornecedor VARCHAR(100) NOT NULL,
    
    PRIMARY KEY (pk_id_fornecedor)
);
-- ENTIDADES FRACAS
/* GERENCIAMENTO DE ESTOQUE DE MATÉRIAS-PRIMAS */

CREATE TABLE materia_prima(
	pk_id_materia_prima INT NOT NULL UNIQUE  AUTO_INCREMENT,
	descricao_mp VARCHAR(60) NOT NULL,
	fk_id_fornecedor INT NOT NULL,
	quant_estoque INT,
	data_ultima_compra DATE NOT NULL,
    
	PRIMARY KEY (pk_id_materia_prima),
	FOREIGN KEY (fk_id_fornecedor) references fornecedor(pk_id_fornecedor)
);

CREATE TABLE Peca(
	pk_id_peca INT NOT NULL UNIQUE AUTO_INCREMENT,
    descricao_peca VARCHAR(600) NOT NULL,
    fk_id_mp INT NOT NULL,
	peso DECIMAL(10,2) NOT NULL,
	dimensoes VARCHAR(80) NOT NULL,
    
    PRIMARY KEY (pk_id_peca),
    FOREIGN KEY (fk_id_mp) references materia_prima(pk_id_materia_prima)
);

/* CONTROLE DE QUALIDADE DE PEÇAS */

CREATE TABLE inspecao(
	pk_id_inspecao INT NOT NULL UNIQUE AUTO_INCREMENT ,
	fk_id_peca INT NOT NULL,
	data_inspecao DATE NOT NULL,
	resultado_inspecao VARCHAR(50) NOT NULL,
	observacao_inspecao VARCHAR(200),
    
    PRIMARY KEY (pk_id_inspecao),
    FOREIGN KEY (fk_id_peca) references Peca(pk_id_peca)
);

CREATE TABLE rejeicao(
	pk_id_rejeicao INT NOT NULL UNIQUE AUTO_INCREMENT ,
	fk_id_peca INT NOT NULL,
    fk_id_inspecao INT NOT NULL,
	motivo_rej VARCHAR(80) NOT NULL,
	data_rej DATE NOT NULL,
	acao_corretiva VARCHAR(200) NOT NULL,

	PRIMARY KEY (pk_id_rejeicao),
	FOREIGN KEY (fk_id_peca) references Peca(pk_id_peca),
    FOREIGN KEY (fk_id_inspecao) references inspecao(pk_id_inspecao)
);

CREATE TABLE aceitacao(
	pk_id_aceitacao INT NOT NULL UNIQUE AUTO_INCREMENT,
	fk_id_peca INT NOT NULL,
    fk_id_inspecao INT NOT NULL,
	data_ac DATE NOT NULL,
	destino_peca VARCHAR(200) NOT NULL,
	observacao VARCHAR(200),
    
	PRIMARY KEY (pk_id_aceitacao),
	FOREIGN KEY (fk_id_peca) references Peca(pk_id_peca),
    FOREIGN KEY (fk_id_inspecao) references inspecao(pk_id_inspecao)
    
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
	descricao_equipamento VARCHAR(600) NOT NULL,
	data_aquisicao DATE NOT NULL,
	vida_util_restante VARCHAR(20) NOT NULL,
    fk_id_maquina INT NOT NULL,
    
    PRIMARY KEY (pk_id_equipamento),
	FOREIGN KEY (fk_id_maquina) references Maquina(pk_id_maquina)
);

CREATE TABLE manutencao_programada(
	pk_id_manutencao INT NOT NULL UNIQUE AUTO_INCREMENT, 
	fk_id_equipamento INT NOT NULL,
    fk_id_maquina INT NOT NULL,
	tipo_manutencao VARCHAR(30) NOT NULL,
    nome_equipamento VARCHAR(30) NOT NULL,
	data_programada DATE NOT NULL,
	responsavel_manutencao VARCHAR(40) NOT NULL,
    
    
	PRIMARY KEY (pk_id_manutencao),
	FOREIGN KEY (fk_id_equipamento) references equipamento(pk_id_equipamento),
    FOREIGN KEY (fk_id_maquina) references maquina(pk_id_maquina)
);

CREATE TABLE historico_manutencao(
	fk_id_manutencao INT AUTO_INCREMENT NOT NULL,
	fk_id_equipamento  INT NOT NULL,
	tipo_man_realizada  VARCHAR(30) NOT NULL,
	data_manutencao DATE NOT NULL,
	custo_manutencao DECIMAL(8,2),
	
    PRIMARY KEY (fk_id_manutencao),
	FOREIGN KEY (fk_id_manutencao) references manutencao_programada(pk_id_manutencao),
    FOREIGN KEY (fk_id_equipamento) references equipamento(pk_id_equipamento)
);

-- ---------------------------------------------------------------


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
    lote INT NOT NULL,
    
    
    PRIMARY KEY (pk_id_his_prod),
	FOREIGN KEY (fk_id_peca) references Peca(pk_id_peca),
    FOREIGN KEY (fk_id_operador) references Operador(pk_id_operador),
    FOREIGN KEY (fk_id_ordem) references ordens_de_producao(pk_id_ordem),
    FOREIGN KEY (fk_id_maquina) references Maquina(pk_id_maquina)
    
    
);

