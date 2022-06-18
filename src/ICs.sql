--(RI-1) Uma Categoria não pode estar contida em si própria
ALTER TABLE tem_outra ADD constraint nested_categoria CHECK (super_categoria <> categoria);



--(RI-4) O número de unidades repostas num Evento de Reposição
-- não pode exceder o número de unidades especificado no Planograma
CREATE OR REPLACE FUNCTION replenishment_limit_reached_proc()
RETURNS TRIGGER AS
$$
DECLARE	limite_maximo INTEGER;
BEGIN
    SELECT unidades INTO limite_maximo
	FROM planograma
	WHERE   ean = NEW.ean AND 
            nro = NEW.nro AND 
            num_serie = NEW.num_serie AND
            fabricante = NEW.fabricante;

	IF NEW.unidades > limite_maximo THEN
		RAISE EXCEPTION 'O numero de unidades repostas num Evento de Reposico nao pode exceder o numero de unidades especificado no Planograma.';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER replenishment_limit_reached_trigger
BEFORE INSERT OR UPDATE ON evento_reposicao
FOR	EACH ROW EXECUTE PROCEDURE replenishment_limit_reached_proc();



--(RI-5) Um Produto só pode ser reposto numa Prateleira que apresente (pelo menos) uma das 
-- Categorias desse produto
CREATE OR REPLACE FUNCTION replenish_product_on_shelf_proc()
RETURNS TRIGGER AS
$$
DECLARE	ctgs_na_prateleira INTEGER;
BEGIN
    SELECT COUNT(tem_categoria.nome) INTO ctgs_na_prateleira
	FROM tem_categoria
        JOIN prateleira ON tem_categoria.nome = prateleira.nome
    WHERE   ean = NEW.ean AND
            nro = NEW.nro AND
            num_serie = NEW.num_serie AND
            fabricante = NEW.fabricante;
    
	IF ctgs_na_prateleira = 0 THEN
		RAISE EXCEPTION 'Um Produto só pode ser reposto numa Prateleira que apresente (pelo menos) uma das Categorias desse produto.';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER replenish_product_on_shelf_trigger
BEFORE INSERT OR UPDATE ON evento_reposicao
FOR	EACH ROW EXECUTE PROCEDURE replenish_product_on_shelf_proc();
