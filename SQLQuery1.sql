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

CREATE TABLE CompraItens(
    idCompraItem INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idCompra INT NOT NULL,
    idItemCompra INT NOT NULL
);

CREATE TABLE ItensCompras(
    idItemCompra INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idPrincipioAtivo INT NOT NULL,
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

CREATE TABLE ProducoesItens(
    idProducaoItem INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idProducao INT NOT NULL,
    idItemProducao INT NOT NULL
);

CREATE TABLE ItensProducoes(
    idItemProducao INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idPrincipioAtivo INT NOT NULL,
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

CREATE TABLE VendaItens(
    idVendaItem INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idVenda INT NOT NULL,
    idItemVenda INT NOT NULL
);

CREATE TABLE ItensVendas(
    idItemVenda INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    idMedicamento INT NOT NULL,
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

ALTER TABLE FornecedoresBloqueados
ADD FOREIGN KEY (idFornecedor) REFERENCES Fornecedores(idFornecedor);

ALTER TABLE Compras
ADD FOREIGN KEY (idFornecedor) REFERENCES Fornecedores(idFornecedor);

ALTER TABLE CompraItens
ADD FOREIGN KEY (idCompra) REFERENCES Compras(idCompra);

ALTER TABLE CompraItens
ADD FOREIGN KEY (idItemCompra) REFERENCES ItensCompras(idItemCompra);

ALTER TABLE Producoes
ADD FOREIGN KEY (idMedicamento) REFERENCES Medicamentos(idMedicamento);

ALTER TABLE ProducoesItens
ADD FOREIGN KEY (idItemProducao) REFERENCES ItensProducoes(idItemProducao);

ALTER TABLE ProducoesItens
ADD FOREIGN KEY (idProducao) REFERENCES Producoes(idProducao);

ALTER TABLE ItensProducoes
ADD FOREIGN KEY(idPrincipioAtivo) REFERENCES PrincipiosAtivos(idPrincipioAtivo);

ALTER TABLE VendasMedicamentos
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente);

ALTER TABLE VendaItens
ADD FOREIGN KEY (idVenda) REFERENCES VendasMedicamentos(idVenda);

ALTER TABLE VendaItens
ADD FOREIGN KEY (idItemVenda) REFERENCES ItensVendas(idItemVenda);

ALTER TABLE ItensVendas
ADD FOREIGN KEY (idMedicamento) REFERENCES Medicamentos(idMedicamento);

ALTER TABLE ClientesRestritos
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente);

ALTER TABLE Telefones
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente);
---------------------------------------------------------------------------------------------
----------------------------------INSERT INTO------------------------------------------------
INSERT INTO Fornecedores (Cnpj, RazaoSocial, Pais, DataAbertura) VALUES
('12345678998765', 'Empresa A', 'Brasil', '2010-07-09'),
('98765432112345', 'Empresa B', 'Estados Unidos', '2002-08-22'),
('45678976543120', 'Empresa C', 'México', '2006-02-04');

INSERT INTO PrincipiosAtivos(Principio, Nome) VALUES
('123456', 'Paracetamol'),
('654321', 'Dipirona'),
('456321', 'Ibuprofeno');

INSERT INTO Medicamentos(Categoria, CDB, Nome, ValorVenda) VALUES
('A','1234567890987', 'Paracetamol', 45.00),
('A','0987654321234', 'Dipirona', 20.50),
('I','8765433456789', 'Ibuprofeno', 36.99);

INSERT INTO Clientes(CPF, Nome, DataNascimento) VALUES
('12345678912', 'Julia Tostes', '2004-08-27'),
('12435678998', 'Fulana de Tal', '1950-06-30'),
('23456787656', 'Krys com sono','2005-01-01'),
('21345678543', 'Nath', '2000-05-05');

INSERT INTO FornecedoresBloqueados(idFornecedor)
VALUES (3);

INSERT INTO Compras(idFornecedor) VALUES
(1),
(2);

INSERT INTO ItensCompras(Quantidade, ValorUnitario, idPrincipioAtivo) VALUES
(2, 10.90, 1),
(3, 22.00, 2);

INSERT INTO CompraItens(idCompra, idItemCompra) VALUES 
(1, 1),
(2, 2);

INSERT INTO Producoes(idMedicamento, Quantidade) VALUES 
(1, 5),
(2, 6);

INSERT INTO ItensProducoes(idPrincipioAtivo, QuantidadePrincipios) VALUES
(1, 5),
(2, 6);

INSERT INTO ProducoesItens(idProducao, idItemProducao) VALUES
(1,1),
(2,2);

INSERT INTO VendasMedicamentos(idCliente) VALUES
(1),
(2);

INSERT INTO ItensVendas(idMedicamento, Quantidade) VALUES
(1, 3),
(2, 4);

INSERT INTO VendaItens(idVenda, idItemVenda) VALUES
(1,1),
(2,2);

INSERT INTO ClientesRestritos(idCliente) 
VALUES (3);

INSERT INTO Telefones (idCliente, DDD, Numero) VALUES
(1, 12, 987656543),
(1, 12, 980765432),
(2, 14, 987065437);

-----------------------------------------UPDATES------------------------------------------------
UPDATE Clientes
SET Situacao = 'I'
WHERE IdCliente = 2;
GO 
------------------------------------------------------------------------------------------------
------------------------------------------SELECTS-----------------------------------------------
------------------------------------------------------------------------------------------------
SELECT * FROM Fornecedores
SELECT * FROM PrincipiosAtivos
SELECT * FROM Medicamentos
SELECT * FROM Clientes
SELECT * FROM FornecedoresBloqueados
SELECT * FROM Compras
SELECT * FROM ItensCompras
SELECT * FROM CompraItens
SELECT * FROM Producoes
SELECT * FROM ItensProducoes
SELECT * FROM ProducoesItens
SELECT * FROM VendasMedicamentos
SELECT * FROM ItensVendas
SELECT * FROM VendaItens
SELECT * FROM ClientesRestritos
SELECT * FROM Telefones
GO
------------------------------------------------------------------------------------------------
------------------------------------------TRIGGERS----------------------------------------------
------------------------------------------------------------------------------------------------


CREATE TRIGGER TRG_VerificarClienteVenda
ON VendasMedicamentos
FOR INSERT
AS
BEGIN
    DECLARE
        @IDCLIENTE INT,
        @SITUACAO CHAR(1)

    SELECT @IDCLIENTE = idCliente FROM inserted;

    SELECT @SITUACAO = Situacao
    FROM Clientes 
    WHERE idCliente = @IDCLIENTE

    IF(@SITUACAO = 'I')
    BEGIN 
        RAISERROR('Cliente inativo não pode realizar venda!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TGR_VerificarClienteRestritoVenda
ON VendasMedicamentos
FOR INSERT
AS 
BEGIN
    DECLARE @idCliente INT;
    SELECT @idCliente = idCliente FROM inserted;

    IF EXISTS(
        SELECT 1
        FROM ClientesRestritos
        WHERE idCliente = @idCliente
        )
        BEGIN
           RAISERROR('Cliente restrito não pode realizar venda!', 16, 1);
           ROLLBACK TRANSACTION;
        END
END;
GO

CREATE TRIGGER TRG_VerificarSituacaoFornecedorCompra
ON Compras
FOR INSERT
AS
BEGIN
    DECLARE
        @idFornecedor INT,
        @Situacao CHAR(1)

    SELECT @idFornecedor = idFornecedor FROM inserted;

    SELECT @Situacao = Situacao
    FROM Fornecedores
    WHERE idFornecedor = @idFornecedor

    IF(@Situacao = 'I')
    BEGIN 
        RAISERROR('Fornecedor inativo não pode vender!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TGR_VerificarFornecedorBloqueadoCompra
ON Compras
FOR INSERT
AS 
BEGIN
    DECLARE @idFornecedor INT;
    SELECT @idFornecedor = idFornecedor FROM inserted;

    IF EXISTS(
        SELECT 1
        FROM FornecedoresBloqueados
        WHERE idFornecedor = @idFornecedor
        )
        BEGIN
           RAISERROR('Fornecedor bloqueado não pode vender!', 16, 1);
           ROLLBACK TRANSACTION;
        END
END;
GO

CREATE TRIGGER TRG_ValidarPrincipioAtivoProducao
ON Producoes
FOR INSERT
AS
BEGIN
    IF EXISTS(
        SELECT 1
        FROM inserted p
        JOIN ProducoesItens pi ON pi.idProducao = p.idProducao
        JOIN ItensProducoes ip ON ip.idItemProducao = pi.idItemProducao
        JOIN PrincipiosAtivos pa ON pa.idPrincipioAtivo = ip.idPrincipioAtivo
        WHERE pa.Situacao = 'I'
    )
    BEGIN 
        RAISERROR('Não é possível produzir remédio, o ingrediente está inativo!', 16, 1)
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TRG_VerificarMedicamentoAtivoVenda
ON VendasMedicamentos
FOR INSERT 
AS 
BEGIN
    IF EXISTS(
        SELECT 1
        FROM inserted v
        JOIN VendaItens vi ON vi.idVenda = v.idVenda
        JOIN ItensVendas iv ON iv.idItemVenda = vi.idItemVenda
        JOIN Medicamentos m ON m.idMedicamento = iv.idMedicamento
        WHERE m.Situacao = 'I'
    )
    BEGIN 
        RAISERROR('Não é possível realizar a compra desse medicamento, está inativo!', 16, 1)
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TRG_BloquearDeleteForenecedores
ON Fornecedores 
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Não é permititido excluir registros dessa tabela!', 16, 1);
END;
GO

CREATE TRIGGER TRG_BloquearDeleteCompras
ON Compras 
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Não é permititido excluir registros dessa tabela!', 16, 1);
END;
GO

CREATE TRIGGER TRG_BloquearDeleteCompraItens
ON  CompraItens
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Não é permititido excluir registros dessa tabela!', 16, 1);
END;
GO

CREATE TRIGGER TRG_BloquearDeleteItensCompras
ON ItensCompras
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Não é permititido excluir registros dessa tabela!', 16, 1);
END;
GO

CREATE TRIGGER TRG_BloquearDeletePrincipiosAtivos
ON PrincipiosAtivos
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Não é permititido excluir registros dessa tabela!', 16, 1);
END;
GO

CREATE TRIGGER TRG_BloquearDeleteProducoes
ON Producoes
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Não é permititido excluir registros dessa tabela!', 16, 1);
END;
GO

CREATE TRIGGER TRG_BloquearDeleteProducoesItens
ON ProducoesItens  
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Não é permititido excluir registros dessa tabela!', 16, 1);
END;
GO

CREATE TRIGGER TRG_BloquearDeleteItensProducoes
ON ItensProducoes
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Não é permititido excluir registros dessa tabela!', 16, 1);
END;
GO

CREATE TRIGGER TRG_BloquearDeleteMedicamentos
ON Medicamentos
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Não é permititido excluir registros dessa tabela!', 16, 1);
END;
GO

CREATE TRIGGER TRG_BloquearDeleteVendasMedicamentos
ON VendasMedicamentos
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Não é permititido excluir registros dessa tabela!', 16, 1);
END;
GO

CREATE TRIGGER TRG_BloquearDeleteVendaItens
ON VendaItens 
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Não é permititido excluir registros dessa tabela!', 16, 1);
END;
GO

CREATE TRIGGER TRG_BloquearDeleteItensVendas
ON ItensVendas
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Não é permititido excluir registros dessa tabela!', 16, 1);
END;
GO

CREATE TRIGGER TRG_BloquearDeleteClientes
ON Clientes
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Não é permititido excluir registros dessa tabela!', 16, 1);
END;
GO

CREATE TRIGGER TRG_BloquearDeleteTelefones
ON Telefones
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Não é permititido excluir registros dessa tabela!', 16, 1);
END;
GO

