CREATE DATABASE SneezePharma;

USE SneezePharma;

CREATE TABLE Fornecedores(
    idFornecedor INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    Cnpj CHAR(14) NOT NULL UNIQUE,
    RazaoSocial VARCHAR(50),
    Pais NVARCHAR(20),
    DataAbertura DATE NOT NULL,
    DataCadastro DATE NOT NULL DEFAULT GETDATE(),
    Situacao CHAR(1) NOT NULL
        CHECK(Situacao IN('A', 'I'))
        DEFAULT 'A'
);

CREATE TABLE FornecedoresBloqueados(
    idFornecedorBloqueado INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idFornecedor INT NOT NULL
);

CREATE TABLE Compras(
    idCompra INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idFornecedor INT NOT NULL,
    DataCompra DATE NOT NULL DEFAULT GETDATE()
);

CREATE TABLE ItensCompras(
    idItemCompra INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idPrincipioAtivo INT NOT NULL,
    idCompra INT NOT NULL,
    Quantidade INT NOT NULL,
    ValorUnitario DECIMAL(6,2)
);

CREATE TABLE PrincipiosAtivos(
    idPrincipioAtivo INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    Principio CHAR(6) NOT NULL UNIQUE,
    Nome NVARCHAR(20) NOT NULL,
    DataCadastro DATE NOT NULL DEFAULT GETDATE(),
    Situacao CHAR(1) NOT NULL
        CHECK(Situacao IN('A', 'I'))
        DEFAULT 'A'
); 

CREATE TABLE Producoes(
    idProducao INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idMedicamento INT NOT NULL,
    DataProducao DATE NOT NULL,
    Quantidade INT NOT NULL
); 


CREATE TABLE ItensProducoes(
    idItemProducao INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idPrincipioAtivo INT NOT NULL,
    idProducao INT NOT NULL,
    QuantidadePrincipios INT NOT NULL 
);

CREATE TABLE Medicamentos(
    idMedicamento INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    Categoria CHAR(1)  -- A = Analgésico, B = Antibiótico, I = Anti-inflamatório, V = Vitamina
        CHECK(Categoria IN('A', 'B', 'I', 'V')),
    CDB CHAR(13) NOT NULL UNIQUE,
    Nome NVARCHAR(40) NOT NULL,
    ValorVenda DECIMAL(6,2) NOT NULL,
    DataCadastro DATE NOT NULL DEFAULT GETDATE(),
    Situacao CHAR(1) NOT NULL
        CHECK(Situacao IN('A', 'I'))
        DEFAULT 'A'
);

CREATE TABLE VendasMedicamentos(
    idVenda INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idCliente INT NOT NULL, 
    DataVenda DATE NOT NULL DEFAULT GETDATE()
);


CREATE TABLE ItensVendas(
    idItemVenda INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idMedicamento INT NOT NULL,
    idVenda INT NOT NULL,
    Quantidade INT NOT NULL
);

CREATE TABLE Clientes(
    idCliente INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    CPF CHAR(11) NOT NULL,
    Nome NVARCHAR(50),
    DataNascimento DATE NOT NULL,
    DataCadastro DATE NOT NULL DEFAULT GETDATE(),
    Situacao CHAR(1) NOT NULL
        CHECK(Situacao IN('A', 'I'))
        DEFAULT 'A'
);

CREATE TABLE ClientesRestritos(
    idClienteRestrito INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idCliente INT NOT NULL
);

CREATE TABLE Telefones(
    idTelefone INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idCliente INT NOT NULL,
    DDD CHAR(3),
    Numero NVARCHAR(9)
);


ALTER TABLE Producoes
ADD CONSTRAINT DF_Producoes
DEFAULT GETDATE() for DataProducao
---------------------------------------FOREIGN KEYS-----------------------------------------------
ALTER TABLE ItensCompras
ADD FOREIGN KEY (idPrincipioAtivo) REFERENCES PrincipiosAtivos(idPrincipioAtivo);

ALTER TABLE ItensCompras
ADD FOREIGN KEY (idCompra) REFERENCES Compras(idCompra);

ALTER TABLE FornecedoresBloqueados
ADD FOREIGN KEY (idFornecedor) REFERENCES Fornecedores(idFornecedor);

ALTER TABLE Compras
ADD FOREIGN KEY (idFornecedor) REFERENCES Fornecedores(idFornecedor);

ALTER TABLE Producoes
ADD FOREIGN KEY (idMedicamento) REFERENCES Medicamentos(idMedicamento);

ALTER TABLE ItensProducoes
ADD FOREIGN KEY(idPrincipioAtivo) REFERENCES PrincipiosAtivos(idPrincipioAtivo);

ALTER TABLE ItensProducoes
ADD FOREIGN KEY(idProducao) REFERENCES Producoes(idProducao);

ALTER TABLE VendasMedicamentos
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente);

ALTER TABLE ItensVendas
ADD FOREIGN KEY (idMedicamento) REFERENCES Medicamentos(idMedicamento);

ALTER TABLE ItensVendas
ADD FOREIGN KEY (idVenda) REFERENCES VendasMedicamentos(idVenda);

ALTER TABLE ClientesRestritos
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente);

ALTER TABLE Telefones
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente);
---------------------------------------------------------------------------------------------
----------------------------------INSERT INTO------------------------------------------------
INSERT INTO Fornecedores (Cnpj, RazaoSocial, Pais, DataAbertura) VALUES
('12345678998765', 'Empresa A', 'Brasil', '2010-07-09'),
('98765432112345', 'Empresa B', 'Estados Unidos', '2002-08-22'),
('45678976543120', 'Empresa C', 'México', '2006-02-04'),
('45678976543122', 'Empresa D', 'Japão', '2016-04-04');

INSERT INTO PrincipiosAtivos(Principio, Nome) VALUES
('123456', 'Paracetamol'),
('654321', 'Dipirona'),
('456321', 'Ibuprofeno');

INSERT INTO Medicamentos(Categoria, CDB, Nome, ValorVenda) VALUES
('A','1234567890987', 'Paracetamol', 45.00),
('A','0987654321234', 'Dipirona', 20.50),
('I','8765433456789', 'Ibuprofeno', 36.99);
INSERT INTO Medicamentos(Categoria, CDB, Nome, ValorVenda) VALUES
('A','1234567890864', 'Nimesulida', '22.50');

INSERT INTO Clientes(CPF, Nome, DataNascimento) VALUES
('12345678912', 'Julia Tostes', '2004-08-27'),
('12435678998', 'Fulana de Tal', '1950-06-30'),
('23456787656', 'Krys com sono','2005-01-01'),
('21345678543', 'Nath', '2000-05-05');

INSERT INTO FornecedoresBloqueados(idFornecedor)
VALUES (3);
DELETE FROM FornecedoresBloqueados;

INSERT INTO Compras(idFornecedor) VALUES
(1),
(2),
(3);

INSERT INTO ItensCompras(Quantidade, ValorUnitario, idPrincipioAtivo, idCompra) VALUES
(2, 10.90, 1, 1),
(3, 22.00, 2, 2),
(3, 26.00, 3, 5);


INSERT INTO Producoes(idMedicamento, Quantidade) VALUES 
(1, 5),
(2, 6),
(3, 6);

INSERT INTO ItensProducoes(idPrincipioAtivo, QuantidadePrincipios, idProducao) VALUES
(1, 5, 1),
(2, 6, 2);

INSERT INTO VendasMedicamentos(idCliente) VALUES
(1),
(2),
(4);

INSERT INTO ItensVendas(idMedicamento, Quantidade, idVenda) VALUES
(1, 3, 1),
(2, 4, 2),
(3, 2, 1004);


INSERT INTO ClientesRestritos(idCliente) 
VALUES (3);

INSERT INTO Telefones (idCliente, DDD, Numero) VALUES
(1, 12, 987656543),
(1, 12, 980765432),
(2, 14, 987065437);

-----------------------------------------UPDATES------------------------------------------------
UPDATE Clientes
SET Situacao = 'A'
WHERE IdCliente = 2;
GO 
