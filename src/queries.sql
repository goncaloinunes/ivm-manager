
-- Qual o nome do retalhista (ou retalhistas)  responsáveis pela reposição do maior número de categorias
SELECT nome
FROM retalhista
	JOIN responsavel_por ON retalhista.tin = responsavel_por.tin
GROUP BY nome
HAVING COUNT(DISTINCT nome_cat) > ALL(
	SELECT COUNT(*)
	FROM retalhista);


-- Qual o nome do ou dos retalhistas que são responsáveis por todas as categorias simples? 
SELECT nome
FROM retalhista
WHERE tin = (
	SELECT tin
	FROM responsavel_por
    WHERE nome_cat IN (
    	SELECT nome FROM categoria_simples
    )
	GROUP BY tin
	HAVING COUNT(DISTINCT nome_cat) = (
		SELECT COUNT(*)
		FROM categoria_simples
	)
);


-- Quais os produtos (ean) que nunca foram repostos? 
SELECT DISTINCT ean
FROM produto
WHERE ean NOT IN (
	SELECT DISTINCT ean
	FROM evento_reposicao
);


-- Quais os produtos (ean) que foram repostos sempre pelo mesmo retalhista? 
SELECT ean
FROM evento_reposicao
GROUP BY ean
HAVING COUNT(DISTINCT tin) = 1;