/* Vista que resuma as informações mais importantes sobre as vendas */
CREATE VIEW Vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades)	
AS
SELECT e.ean, c.nome, 
    EXTRACT(YEAR FROM instante),
    EXTRACT(QUARTER FROM instante),
    EXTRACT(MONTH FROM instante),
    EXTRACT(DAY FROM instante),
    EXTRACT(DOW FROM instante),
    r.distrito, r.concelho, e.unidades
FROM evento_reposicao e 
    JOIN tem_categoria c ON e.ean = c.ean
    JOIN instalada_em i ON e.num_serie = i.num_serie AND e.fabricante = i.fabricante
    JOIN ponto_de_retalho r ON i.local = r.nome;


--SELECT * FROM Vendas;
