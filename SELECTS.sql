Use SneezePharma;

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

SELECT c.idCompra, ic.idItemCompra, pa.Nome, ic.Quantidade, ic.ValorUnitario, (ic.Quantidade * ic.ValorUnitario) AS Total
FROM ItensCompras ic
JOIN Compras c ON c.idCompra = ic.idCompra
JOIN PrincipiosAtivos pa ON pa.idPrincipioAtivo = ic.idPrincipioAtivo;

SELECT p.idProducao, pa.Nome, ip.QuantidadePrincipios
FROM ItensProducoes ip
JOIN Producoes p ON p.idProducao = ip.idProducao
JOIN PrincipiosAtivos pa ON pa.idPrincipioAtivo = ip.idPrincipioAtivo;

SELECT vm.idVenda, c.Nome AS NomeCliente, c.CPF, c.Situacao, vm.DataVenda
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