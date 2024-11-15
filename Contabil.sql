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

DELIMITER //

CREATE FUNCTION calcular_imposto_simples_nacional(faturamento DECIMAL(15, 2), categoria VARCHAR(20))
RETURNS DECIMAL(15, 2)
DETERMINISTIC
BEGIN
    DECLARE aliquota DECIMAL(5, 2);
    DECLARE valor_a_deduzir DECIMAL(15, 2);

    IF categoria = 'Comércio' THEN
        CASE
            WHEN faturamento <= 180000 THEN
                SET aliquota = 0.04;
                SET valor_a_deduzir = 0;
            WHEN faturamento <= 360000 THEN
                SET aliquota = 0.073;
                SET valor_a_deduzir = 5940;
            WHEN faturamento <= 720000 THEN
                SET aliquota = 0.095;
                SET valor_a_deduzir = 13860;
            WHEN faturamento <= 1800000 THEN
                SET aliquota = 0.107;
                SET valor_a_deduzir = 22500;
            WHEN faturamento <= 3600000 THEN
                SET aliquota = 0.143;
                SET valor_a_deduzir = 87300;
            ELSE
                SET aliquota = 0.19;
                SET valor_a_deduzir = 378000;
        END CASE;

    ELSEIF categoria = 'Serviço' THEN
        CASE
            WHEN faturamento <= 180000 THEN
                SET aliquota = 0.06;
                SET valor_a_deduzir = 0;
            WHEN faturamento <= 360000 THEN
                SET aliquota = 0.112;
                SET valor_a_deduzir = 9360;
            WHEN faturamento <= 720000 THEN
                SET aliquota = 0.135;
                SET valor_a_deduzir = 17640;
            WHEN faturamento <= 1800000 THEN
                SET aliquota = 0.16;
                SET valor_a_deduzir = 35640;
            WHEN faturamento <= 3600000 THEN
                SET aliquota = 0.21;
                SET valor_a_deduzir = 125640;
            ELSE
                SET aliquota = 0.33;
                SET valor_a_deduzir = 648000;
        END CASE;
    END IF;

    RETURN (faturamento * aliquota) - valor_a_deduzir;
END //

DELIMITER ;

