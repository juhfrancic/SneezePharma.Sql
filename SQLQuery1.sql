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
SELECT * FROM Producoes
SELECT * FROM ItensProducoes
SELECT * FROM VendasMedicamentos
SELECT * FROM ItensVendas
SELECT * FROM ClientesRestritos
SELECT * FROM Telefones

SELECT c.idCompra, ic.idItemCompra, ic.Quantidade, ic.ValorUnitario, (ic.Quantidade * ic.ValorUnitario) AS Total
FROM ItensCompras ic
JOIN Compras c ON c.idCompra = ic.idCompra;

SELECT p.idProducao, pa.Nome, ip.QuantidadePrincipios
FROM ItensProducoes ip
JOIN Producoes p ON p.idProducao = ip.idProducao
JOIN PrincipiosAtivos pa ON pa.idPrincipioAtivo = ip.idPrincipioAtivo;

SELECT vm.idVenda, c.Nome, c.CPF, c.Situacao, vm.DataVenda
FROM VendasMedicamentos vm
JOIN Clientes c ON c.idCliente = vm.idCliente;

SELECT c.Nome, t.DDD, t.Numero
FROM Clientes c 
RIGHT JOIN Telefones t ON t.idCliente = c.idCliente;

SELECT vm.idVenda, m.Nome, iv.Quantidade, m.ValorVenda,(iv.Quantidade * m.ValorVenda) AS Total
FROM ItensVendas iv
JOIN VendasMedicamentos vm ON vm.idVenda = iv.idVenda
JOIN Medicamentos m ON m.idMedicamento = iv.idMedicamento;

SELECT c.CPF
FROM Clientes c
JOIN ClientesRestritos cr ON cr.idCliente = c.idCliente;

SELECT f.CNPJ
FROM Fornecedores f
JOIN FornecedoresBloqueados fb ON fb.idFornecedor = f.idFornecedor;

--Relatório de vendas por período
SELECT *
FROM VendasMedicamentos
WHERE DataVenda BETWEEN '2025-11-01' AND '2025-11-10';


--Relatório de medicamentos mais vendidos
SELECT m.Nome, SUM(iv.Quantidade) AS Quantidade
FROM ItensVendas iv
JOIN Medicamentos m ON iv.idMedicamento = m.idMedicamento
GROUP BY m.Nome
ORDER BY SUM(iv.Quantidade) DESC;

--Relatório de compras por fornecedor
SELECT c.idCompra, c.DataCompra,f.RazaoSocial
FROM Compras c
JOIN Fornecedores f ON f.idFornecedor = c.idFornecedor;
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
   IF EXISTS(
       SELECT 1
       FROM inserted c
       JOIN Fornecedores f ON f.idFornecedor = c.idFornecedor
       WHERE f.Situacao = 'I'
   )
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
    IF EXISTS(
        SELECT 1
        FROM inserted c
        JOIN FornecedoresBloqueados fb ON fb.idFornecedor = c.idFornecedor
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
        JOIN ItensProducoes ip ON ip.idProducao = p.idProducao
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
ON ItensVendas
FOR INSERT 
AS 
BEGIN
    IF EXISTS(
        SELECT 1
        FROM inserted iv
        JOIN Medicamentos m ON m.idMedicamento = iv.idMedicamento
        WHERE m.Situacao = 'I'
    )
    BEGIN 
        RAISERROR('Não é possível adicionar o medicamento a tabela de itens de vendas, pois está inativo!', 16, 1)
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

CREATE TRIGGER TRG_QuantidadeItensCompras
ON ItensCompras
FOR INSERT 
AS
BEGIN
    IF EXISTS(
        SELECT 1 
        FROM ItensCompras ic
        JOIN inserted i ON i.idCompra = ic.idCompra
        GROUP BY ic.idCompra
        HAVING COUNT (ic.idItemCompra) > 3
    )
    BEGIN 
        RAISERROR ('Não é possível adicionar mais de 3 itens à sua compra!', 16, 1)
        ROLLBACK TRANSACTION;
    END 
END;
GO

CREATE TRIGGER TRG_QuantidadeItensVenda
ON ItensVendas
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT iv.idVenda
        FROM ItensVendas iv
        WHERE iv.idVenda IN (SELECT idVenda FROM inserted)
        GROUP BY iv.idVenda
        HAVING COUNT(iv.idItemVenda) > 3
    )
    BEGIN 
        RAISERROR ('Não é possível adicionar mais de 3 itens à sua venda!', 16, 1)
        ROLLBACK TRANSACTION;
    END 
END;
GO


CREATE TRIGGER TRG_VerificarItemProducao
ON ItensVendas
FOR INSERT 
AS 
BEGIN
    IF EXISTS(
        SELECT 1
        FROM inserted iv
        WHERE NOT EXISTS(
            SELECT 1 
            FROM Producoes p
            WHERE p.idMedicamento = iv.idMedicamento
        )
    )
    BEGIN
        RAISERROR('Não é possível vender medicamento não produzido ainda!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TRG_VerificarClienteMaiorDeIdade
ON VendasMedicamentos
FOR INSERT
AS
BEGIN
    IF EXISTS(
        SELECT 1 
        FROM inserted vm
        JOIN Clientes c ON c.idCliente = vm.idCliente
        WHERE c.DataNascimento > DATEADD(year, -18, vm.DataVenda)
    )
    BEGIN 
        RAISERROR('Clientes menores de 18 anos não podem realizar compras de medicamentos!', 16, 1)
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TRG_VerificarFornecedorDoisAnos
ON Compras
FOR INSERT
AS
BEGIN
    IF EXISTS(
        SELECT 1 
        FROM inserted c
        JOIN Fornecedores f ON f.idFornecedor = c.idFornecedor
        WHERE f.DataAbertura >= DATEADD(year, -2, c.DataCompra)
    )
    BEGIN 
        RAISERROR('Fornecedores que estão abertos a menos de 2 anos não podem realizar vendas!', 16, 1)
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TYPE TYPEItensCompra AS TABLE(
    idPrincipioAtivo INT,
    Quantidade INT, 
    ValorUnitario DECIMAL
);
GO

CREATE OR ALTER PROCEDURE sp_Compra
@idFornecedor INT,
@Itens TYPEItensCompra READONLY
AS
BEGIN
    DECLARE @idCompra INT

    INSERT INTO Compras(idFornecedor, DataCompra)
    VALUES(@idFornecedor, GETDATE());

    SET @idCompra = SCOPE_IDENTITY();

    INSERT INTO ItensCompras(idCompra, Quantidade, ValorUnitario, idPrincipioAtivo)
    SELECT @idCompra, Quantidade, ValorUnitario, idPrincipioAtivo
    FROM @Itens;

    END;
    GO
