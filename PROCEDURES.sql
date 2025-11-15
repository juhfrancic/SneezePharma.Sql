USE SneezePharma;

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


CREATE PROCEDURE sp_CriarVenda
    @idCliente INT,
    @idMedicamento1 INT,
    @Quantidade1 INT,
    @idMedicamento2 INT = NULL,
    @Quantidade2 INT = NULL,
    @idMedicamento3 INT = NULL,
    @Quantidade3 INT = NULL
AS
BEGIN
    DECLARE @idVenda INT;
    DECLARE @ContadorItens INT = 0;

    BEGIN TRANSACTION;
    BEGIN TRY

        INSERT INTO VendasMedicamentos (idCliente)
        VALUES (@idCliente);
        SET @idVenda = SCOPE_IDENTITY();

        IF @idMedicamento1 IS NOT NULL AND @Quantidade1 > 0
        BEGIN
            INSERT INTO ItensVendas (idMedicamento, idVenda, Quantidade)
            VALUES (@idMedicamento1, @idVenda, @Quantidade1);
            SET @ContadorItens = @ContadorItens + 1;
        END

        IF @idMedicamento2 IS NOT NULL AND @Quantidade2 > 0 AND @ContadorItens < 3
        BEGIN
            INSERT INTO ItensVendas (idMedicamento, idVenda, Quantidade)
            VALUES (@idMedicamento2, @idVenda, @Quantidade2);
            SET @ContadorItens = @ContadorItens + 1;
        END

        IF @idMedicamento3 IS NOT NULL AND @Quantidade3 > 0 AND @ContadorItens < 3
        BEGIN
            INSERT INTO ItensVendas (idMedicamento, idVenda, Quantidade)
            VALUES (@idMedicamento3, @idVenda, @Quantidade3);
            SET @ContadorItens = @ContadorItens + 1;
        END

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
        RETURN;
    END CATCH
END;
GO

/*
EXEC sp_CriarVenda
    @idCliente = 2,             
    @idMedicamento1 = 1,         
    @Quantidade1 = 2,
     @idMedicamento2 = 1,         
    @Quantidade2 = 2,
     @idMedicamento3 = 1,         
    @Quantidade3 = 2
    
    */

CREATE PROCEDURE sp_CriarProducao
@idMedicamento INT,
@Quantidade INT,
@idPrincipioAtivo1 INT,
@QuantidadePrincipios1 INT,
@idPrincipioAtivo2 INT = NULL,
@QuantidadePrincipios2 INT = NULL,
@idPrincipioAtivo3 INT = NULL,
@QuantidadePrincipios3 INT = NULL

AS
BEGIN
    DECLARE @idProducao INT;
    DECLARE @ContadorItens INT = 0;

    BEGIN TRANSACTION;
    BEGIN TRY

        INSERT INTO Producoes (idMedicamento, Quantidade)
        VALUES (@idMedicamento, @Quantidade);
        SET @idProducao = SCOPE_IDENTITY();

        IF @idPrincipioAtivo1 IS NOT NULL AND @QuantidadePrincipios1 > 0
        BEGIN
            INSERT INTO ItensProducoes (idPrincipioAtivo, idProducao, QuantidadePrincipios)
            VALUES (@idPrincipioAtivo1, @idProducao, @QuantidadePrincipios1);
            SET @ContadorItens = @ContadorItens + 1;
        END

        IF @idPrincipioAtivo2 IS NOT NULL AND @QuantidadePrincipios2 > 0 AND @ContadorItens < 3
        BEGIN
            INSERT INTO ItensProducoes (idPrincipioAtivo, idProducao, QuantidadePrincipios)
            VALUES (@idPrincipioAtivo2, @idProducao, @QuantidadePrincipios2);
            SET @ContadorItens = @ContadorItens + 1;
        END

        IF @idPrincipioAtivo3 IS NOT NULL AND @QuantidadePrincipios3 > 0 AND @ContadorItens < 3
        BEGIN
            INSERT INTO ItensProducoes (idPrincipioAtivo, idProducao, QuantidadePrincipios)
            VALUES (@idPrincipioAtivo3, @idProducao, @QuantidadePrincipios3);
            SET @ContadorItens = @ContadorItens + 1;
        END

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
        RETURN;
    END CATCH
END;
GO

/*
EXEC sp_CriarProducao
    @idMedicamento = 2,         
    @Quantidade = 50,                   
    @idPrincipioAtivo1 = 2,             
    @QuantidadePrincipios1 = 75;        
*/

CREATE PROCEDURE sp_AlterarSituacaoCliente
@idCliente INT
AS
BEGIN
    IF(SELECT Situacao FROM Clientes WHERE idCliente = @idCliente) = 'I'
    UPDATE Clientes
    SET Situacao = 'A'
    WHERE idCliente = @idCliente;

    ELSE 
    UPDATE Clientes
    SET Situacao = 'I'
    WHERE idCliente = @idCliente;

END;


--EXEC sp_AlterarSituacaoCliente 1

CREATE PROCEDURE sp_AlterarSituacaoMedicamento
@idMedicamento INT
AS
BEGIN
    IF(SELECT Situacao FROM Medicamentos WHERE idMedicamento = @idMedicamento) = 'I'
    UPDATE Medicamentos
    SET Situacao = 'A'
    WHERE idMedicamento = @idMedicamento;

    ELSE 
    UPDATE Medicamentos
    SET Situacao = 'I'
    WHERE idMedicamento = @idMedicamento;

END;


--EXEC sp_AlterarSituacaoMedicamento 2


CREATE PROCEDURE sp_AlterarSituacaoPrincipioAtivo
@idPrincipioAtivo INT
AS
BEGIN
    IF(SELECT Situacao FROM PrincipiosAtivos WHERE idPrincipioAtivo = @idPrincipioAtivo) = 'I'
    UPDATE PrincipiosAtivos
    SET Situacao = 'A'
    WHERE idPrincipioAtivo = @idPrincipioAtivo;

    ELSE 
    UPDATE PrincipiosAtivos
    SET Situacao = 'I'
    WHERE idPrincipioAtivo = @idPrincipioAtivo;

END;

--EXEC sp_AlterarSituacaoPrincipioAtivo 1


CREATE PROCEDURE sp_AlterarSituacaoFornecedor
@idFornecedor INT
AS
BEGIN
    IF(SELECT Situacao FROM Fornecedores WHERE idFornecedor = @idFornecedor) = 'I'
    UPDATE Fornecedores
    SET Situacao = 'A'
    WHERE idFornecedor = @idFornecedor;

    ELSE 
    UPDATE Fornecedores
    SET Situacao = 'I'
    WHERE idFornecedor = @idFornecedor;

END;

--EXEC sp_AlterarSituacaoFornecedor 1



CREATE PROCEDURE sp_AdicionarClienteRestrito
@idCliente INT
AS
BEGIN
    INSERT INTO ClientesRestritos(idCliente)
    VALUES (@idCliente);
END;



CREATE PROCEDURE sp_AdicionarFornecedorBloqueado
@idFornecedor INT
AS
BEGIN
    INSERT INTO FornecedoresBloqueados(idFornecedor)
    VALUES (@idFornecedor);
END;



CREATE PROCEDURE sp_DeletarClienteRestrito
@idCliente INT
AS
BEGIN
    DELETE ClientesRestritos
    WHERE idCliente = @idCliente;
END;



CREATE PROCEDURE sp_DeletarFornecedorBloqueado
@idFornecedor INT
AS
BEGIN
    DELETE FornecedoresBloqueados
    WHERE idFornecedor = @idFornecedor;
END;



CREATE PROCEDURE sp_AlterarItensVenda
@idItemVenda INT,
@idMedicamento INT,
@Quantidade INT
AS
BEGIN
    UPDATE ItensVendas
    SET idMedicamento = @idMedicamento,
        Quantidade = @Quantidade
    WHERE idItemVenda = @idItemVenda;
END;



CREATE PROCEDURE sp_AlterarItensCompra
@idItemCompra INT,
@idPrincipioAtivo INT,
@Quantidade INT,
@ValorUnitario DECIMAL(6,2)
AS
BEGIN
    UPDATE ItensCompras
    SET idPrincipioAtivo = @idPrincipioAtivo,
        Quantidade = @Quantidade,
        ValorUnitario = @ValorUnitario
    WHERE idItemCompra = @idItemCompra;
END;



CREATE PROCEDURE sp_AlterarItensProducoes
@idItemProducao INT,
@idPrincipioAtivo INT,
@QuantidadePrincipios INT
AS
BEGIN
    UPDATE ItensProducoes
    SET idPrincipioAtivo = @idPrincipioAtivo,
        QuantidadePrincipios = @QuantidadePrincipios
    WHERE idItemProducao = @idItemProducao;
END;






    
