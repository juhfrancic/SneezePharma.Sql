USE SneezePharma;

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

