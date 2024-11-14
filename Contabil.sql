CREATE DATABASE CONTABIL;
USE CONTABIL;

CREATE TABLE Empresa_Cliente (
    cnpj VARCHAR(18) PRIMARY KEY,
    razao_social VARCHAR(255),
    endereco VARCHAR(255),
    telefone VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE Guia_de_Pagamento (
    numero_da_guia VARCHAR(50) PRIMARY KEY,
    data_de_emissao DATE,
    data_de_vencimento DATE,
    valor DOUBLE,
    status_de_pagamento BOOLEAN,
    fk_Empresa_Cliente_cnpj VARCHAR(18),
    CONSTRAINT FK_Guia_de_Pagamento_Empresa_Cliente FOREIGN KEY (fk_Empresa_Cliente_cnpj)
    REFERENCES Empresa_Cliente (cnpj)
    ON DELETE CASCADE
);

CREATE TABLE Declaracao_Fiscal (
    cod_Declaracao_Fiscal VARCHAR(50) PRIMARY KEY,
    tipo VARCHAR(50),
    periodo_de_referencia VARCHAR(50),
    data_de_envio DATE,
    situacao VARCHAR(50),
    fk_Empresa_Cliente_cnpj VARCHAR(18),
    CONSTRAINT FK_Declaracao_Fiscal_Empresa_Cliente FOREIGN KEY (fk_Empresa_Cliente_cnpj)
    REFERENCES Empresa_Cliente (cnpj)
    ON DELETE CASCADE
);

CREATE TABLE Consultoria (
    cod_Consultoria VARCHAR(50) PRIMARY KEY,
    tipo VARCHAR(50),
    data DATE,
    descricao VARCHAR(255),
    fk_Empresa_Cliente_cnpj VARCHAR(18),
    CONSTRAINT FK_Consultoria_Empresa_Cliente FOREIGN KEY (fk_Empresa_Cliente_cnpj)
    REFERENCES Empresa_Cliente (cnpj)
    ON DELETE CASCADE
);

CREATE TABLE Nota_Fiscal (
    cod_Nota VARCHAR(50),
    data_de_emissao DATE,
    valor_total DOUBLE,
    descricao VARCHAR(255),
    fk_Empresa_Cliente_cnpj VARCHAR(18),
    PRIMARY KEY (cod_Nota, fk_Empresa_Cliente_cnpj),
    CONSTRAINT FK_Nota_Fiscal_Empresa_Cliente FOREIGN KEY (fk_Empresa_Cliente_cnpj)
    REFERENCES Empresa_Cliente (cnpj)
);

CREATE TABLE Funcionario (
    cpf VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(100),
    departamento VARCHAR(50),
    telefone VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE Simples_Nacional (
    tipo_de_calculo VARCHAR(50),
    fk_Empresa_Cliente_cnpj VARCHAR(18) PRIMARY KEY,
    CONSTRAINT FK_Simples_Nacional_Empresa_Cliente FOREIGN KEY (fk_Empresa_Cliente_cnpj)
    REFERENCES Empresa_Cliente (cnpj)
);

CREATE TABLE Lucro_Presumido (
    tipo_de_calculo VARCHAR(50),
    fk_Empresa_Cliente_cnpj VARCHAR(18) PRIMARY KEY,
    CONSTRAINT FK_Lucro_Presumido_Empresa_Cliente FOREIGN KEY (fk_Empresa_Cliente_cnpj)
    REFERENCES Empresa_Cliente (cnpj)
);

CREATE TABLE Lucro_real (
    tipo_de_calculo VARCHAR(50),
    fk_Empresa_Cliente_cnpj VARCHAR(18) PRIMARY KEY,
    CONSTRAINT FK_Lucro_real_Empresa_Cliente FOREIGN KEY (fk_Empresa_Cliente_cnpj)
    REFERENCES Empresa_Cliente (cnpj)
);

CREATE TABLE Imposto (
    cod_imposto VARCHAR(50) PRIMARY KEY,
    tipo VARCHAR(50),
    aliquota FLOAT,
    base_de_calculo DOUBLE
);

CREATE TABLE formalizam (
    fk_Imposto VARCHAR(50),
    fk_Guia_de_Pagamento VARCHAR(50),
    PRIMARY KEY (fk_Imposto, fk_Guia_de_Pagamento),
    CONSTRAINT FK_formalizam_Imposto FOREIGN KEY (fk_Imposto)
    REFERENCES Imposto (cod_imposto),
    CONSTRAINT FK_formalizam_Guia_de_Pagamento FOREIGN KEY (fk_Guia_de_Pagamento)
    REFERENCES Guia_de_Pagamento (numero_da_guia)
);

CREATE TABLE apura (
    fk_Nota_Fiscal_cod VARCHAR(50),
    fk_Nota_Fiscal_cnpj VARCHAR(18),
    fk_Funcionario VARCHAR(11),
    fk_Imposto VARCHAR(50),
    PRIMARY KEY (fk_Nota_Fiscal_cod, fk_Nota_Fiscal_cnpj, fk_Funcionario, fk_Imposto),
    CONSTRAINT FK_apura_Nota_Fiscal FOREIGN KEY (fk_Nota_Fiscal_cod, fk_Nota_Fiscal_cnpj)
    REFERENCES Nota_Fiscal (cod_Nota, fk_Empresa_Cliente_cnpj),
    CONSTRAINT FK_apura_Funcionario FOREIGN KEY (fk_Funcionario)
    REFERENCES Funcionario (cpf),
    CONSTRAINT FK_apura_Imposto FOREIGN KEY (fk_Imposto)
    REFERENCES Imposto (cod_imposto)
);
