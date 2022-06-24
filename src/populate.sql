----------------------------------------
-- Create Schema
----------------------------------------


drop table if exists categoria cascade;
drop table if exists categoria_simples cascade;
drop table if exists super_categoria cascade;
drop table if exists tem_outra cascade;
drop table if exists produto cascade;
drop table if exists tem_categoria cascade;
drop table if exists ivm cascade;
drop table if exists ponto_de_retalho cascade;
drop table if exists instalada_em cascade;
drop table if exists prateleira cascade;
drop table if exists planograma cascade;
drop table if exists retalhista cascade;
drop table if exists responsavel_por cascade;
drop table if exists evento_reposicao cascade;


create table categoria (
	nome varchar(80) not null unique,
	constraint pk_categoria primary key(nome)
);

create table categoria_simples (
	nome varchar(80) not null unique,
    constraint pk_categoria_simples primary key(nome),
	constraint fk_categoria_nome foreign key(nome) references categoria(nome) on delete cascade
);

create table super_categoria (
	nome varchar(80) not null unique,
    constraint pk_super_categoria primary key(nome),
	constraint fk_categoria_nome foreign key(nome) references categoria(nome) on delete cascade
);

create table tem_outra (
	super_categoria varchar(80) not null,
	categoria varchar(80) not null,
	constraint fk_tem_outra_sup_cat_nome foreign key(super_categoria) references super_categoria(nome) on delete cascade,
	constraint fk_tem_outra_cat_nome foreign key(categoria) references categoria(nome) on delete cascade,
	constraint pk_tem_outra primary key(categoria)
);

create table produto (
	ean numeric(13) not null unique,
    descr varchar(80) not null,
    constraint pk_produto primary key(ean)
);

create table tem_categoria (
	ean numeric(13) not null,
	nome varchar(80) not null,
  	constraint fk_tem_categoria_ean foreign key(ean) references produto(ean) on delete cascade,
	constraint fk_tem_categoria_nome foreign key(nome) references categoria(nome) on delete cascade
);

create table ivm (
	num_serie numeric(12) not null,
	fabricante varchar(80) not null,
    constraint pk_ivm primary key(num_serie, fabricante)
);

create table ponto_de_retalho (
  	nome varchar(80) not null unique,
	distrito varchar(80) not null,
	concelho varchar(80) not null,
	constraint pk_ponto_de_retalho primary key(nome)
);

create table instalada_em (
	num_serie numeric(12) not null,
	fabricante varchar(80) not null,
	local varchar(80) not null,
    constraint pk_instalada_em primary key(num_serie, fabricante),
	constraint fk_instalada_em_num_serie_e_fabricante foreign key(num_serie, fabricante) references ivm(num_serie, fabricante) on delete cascade,
	constraint fk_instalada_em_local foreign key(local) references ponto_de_retalho(nome) on delete cascade
);

create table prateleira (
  	nro numeric(10) not null,
    num_serie numeric(12) not null,
    fabricante varchar(80) not null,
    altura real not null,
    nome varchar(80) not null,
    constraint pk_prateleira primary key(nro, num_serie, fabricante),
    constraint fk_prateleira_num_serie_e_fabricante foreign key(num_serie, fabricante) references ivm(num_serie, fabricante) on delete cascade,
    constraint fk_prateleira_local foreign key(nome) references categoria(nome) on delete cascade
);

create table planograma (
  	ean numeric(13) not null,
    nro numeric(10) not null,
    num_serie numeric(12) not null,
    fabricante varchar(80) not null,
    faces smallint not null,
    unidades numeric(10) not null,
    loc varchar(80) not null,
    constraint pk_planograma primary key(ean, nro, num_serie, fabricante),
    constraint fk_planograma_ean foreign key(ean) references produto(ean) on delete cascade,
    constraint fk_planograma_nro_e_num_serie_e_fabricante foreign key(nro, num_serie, fabricante) references prateleira(nro, num_serie, fabricante) on delete cascade
);

create table retalhista (
	tin numeric(9) not null,
    nome varchar(80) not null unique,
    constraint pk_retalhista primary key(tin)
);

create table responsavel_por (
  	nome_cat varchar(80) not null,
    tin numeric(9) not null,
    num_serie numeric(12) not null,
    fabricante varchar(80) not null,
    constraint pk_responsavel_por primary key(num_serie, fabricante), 
    constraint fk_responsavel_por_num_serie_e_fabricante foreign key(num_serie, fabricante) references ivm(num_serie, fabricante) on delete cascade,
    constraint fk_responsavel_por_tin foreign key(tin) references retalhista(tin) on delete cascade,
    constraint fk_responsavel_por_nome_cat foreign key(nome_cat) references categoria(nome) on delete cascade
);

create table evento_reposicao (
  	ean numeric(13) not null,
    nro numeric(10) not null,
    num_serie numeric(12) not null,
    fabricante varchar(80) not null,
    instante timestamp not null,
    unidades numeric(8) not null,
    tin numeric(9) not null,
    constraint pk_evento_reposicao primary key(ean, nro, num_serie, fabricante, instante),
    constraint fk_evento_reposicao_ean_e_nro_e_num_serie_e_fabricante foreign key(ean, nro, num_serie, fabricante) references planograma(ean, nro, num_serie, fabricante) on delete cascade,
    constraint fk_evento_reposicao_tin foreign key(tin) references retalhista(tin) on delete cascade
);





----------------------------------------
-- Populate Relations 
----------------------------------------


/* categoria */
insert into categoria values ('Galliano');
insert into categoria values ('Tomato');
insert into categoria values ('Cookie');
insert into categoria values ('Coke');
insert into categoria values ('French Rack');
insert into categoria values ('Canned');
insert into categoria values ('Flour');
insert into categoria values ('Decafenated');
insert into categoria values ('Black');
insert into categoria values ('Americano');
insert into categoria values ('Cappuccino');
insert into categoria values ('Cortado');
insert into categoria values ('Espresso');
insert into categoria values ('Latte');
insert into categoria values ('Mocha Latte Macchiato');
insert into categoria values ('Mocha Macchiato');
insert into categoria values ('Grana Padano');
insert into categoria values ('Serra da Estrela');
insert into categoria values ('Halves');
insert into categoria values ('Alface');
insert into categoria values ('Frutos');

insert into categoria values ('Muskox');
insert into categoria values ('Lotus Rootlets');
insert into categoria values ('Tortillas');
insert into categoria values ('Coffee');
insert into categoria values ('Mocha');
insert into categoria values ('Mocha Latte');
insert into categoria values ('Cheese');
insert into categoria values ('Apricots');
--added
insert into categoria values ('Vegetable');


/* categoria_simples */
insert into categoria_simples values ('Galliano');
insert into categoria_simples values ('Tomato');
insert into categoria_simples values ('Cookie');
insert into categoria_simples values ('Coke');
insert into categoria_simples values ('French Rack');
insert into categoria_simples values ('Canned');
insert into categoria_simples values ('Flour');
insert into categoria_simples values ('Decafenated');
insert into categoria_simples values ('Black');
insert into categoria_simples values ('Americano');
insert into categoria_simples values ('Cappuccino');
insert into categoria_simples values ('Cortado');
insert into categoria_simples values ('Espresso');
insert into categoria_simples values ('Latte');
insert into categoria_simples values ('Mocha Latte Macchiato');
insert into categoria_simples values ('Mocha Macchiato');
insert into categoria_simples values ('Grana Padano');
insert into categoria_simples values ('Serra da Estrela');
insert into categoria_simples values ('Halves');
insert into categoria_simples values ('Alface');
insert into categoria_simples values ('Frutos');


/* super_categoria */
insert into super_categoria values ('Muskox');
insert into super_categoria values ('Lotus Rootlets');
insert into super_categoria values ('Tortillas');
insert into super_categoria values ('Coffee');
insert into super_categoria values ('Mocha');
insert into super_categoria values ('Mocha Latte');
insert into super_categoria values ('Cheese');
insert into super_categoria values ('Apricots');
--added
insert into super_categoria values ('Vegetable');


/* tem_outra */
insert into tem_outra (super_categoria, categoria) values ('Muskox', 'French Rack');
insert into tem_outra (super_categoria, categoria) values ('Lotus Rootlets', 'Canned');
insert into tem_outra (super_categoria, categoria) values ('Tortillas', 'Flour');
insert into tem_outra (super_categoria, categoria) values ('Coffee', 'Decafenated');
insert into tem_outra (super_categoria, categoria) values ('Coffee', 'Black');
insert into tem_outra (super_categoria, categoria) values ('Coffee', 'Americano');
insert into tem_outra (super_categoria, categoria) values ('Coffee', 'Cappuccino');
insert into tem_outra (super_categoria, categoria) values ('Coffee', 'Cortado');
insert into tem_outra (super_categoria, categoria) values ('Coffee', 'Espresso');
insert into tem_outra (super_categoria, categoria) values ('Coffee', 'Latte');
insert into tem_outra (super_categoria, categoria) values ('Coffee', 'Mocha');
insert into tem_outra (super_categoria, categoria) values ('Mocha', 'Mocha Macchiato');
insert into tem_outra (super_categoria, categoria) values ('Mocha', 'Mocha Latte');
insert into tem_outra (super_categoria, categoria) values ('Mocha Latte', 'Mocha Latte Macchiato');
insert into tem_outra (super_categoria, categoria) values ('Cheese', 'Grana Padano');
insert into tem_outra (super_categoria, categoria) values ('Cheese', 'Serra da Estrela');
insert into tem_outra (super_categoria, categoria) values ('Apricots', 'Halves');
--added
insert into tem_outra (super_categoria, categoria) values ('Vegetable', 'Alface');




/* produto */
insert into produto (ean, descr) values (1234567890123, 'Galliano');
insert into produto (ean, descr) values (1234567890124, 'Tomato Cherry');
insert into produto (ean, descr) values (1234567890125, 'Maria');
insert into produto (ean, descr) values (1234567890126, 'Belga');
insert into produto (ean, descr) values (1234567890127, 'Coca Cola');
insert into produto (ean, descr) values (1234567890128, 'Pepsi');
insert into produto (ean, descr) values (1234567890129, 'Decafenated Coffee');
insert into produto (ean, descr) values (1234567890130, 'Alface');

/* tem_categoria */
insert into tem_categoria (ean, nome) values (1234567890123, 'Galliano');
insert into tem_categoria (ean, nome) values (1234567890124, 'Tomato');
insert into tem_categoria (ean, nome) values (1234567890125, 'Cookie');
insert into tem_categoria (ean, nome) values (1234567890126, 'Cookie');
insert into tem_categoria (ean, nome) values (1234567890127, 'Coke');
insert into tem_categoria (ean, nome) values (1234567890128, 'Coke');
insert into tem_categoria (ean, nome) values (1234567890129, 'Decafenated');
insert into tem_categoria (ean, nome) values (1234567890130, 'Alface');
--added
insert into tem_categoria (ean, nome) values (1234567890124, 'Vegetable');
insert into tem_categoria (ean, nome) values (1234567890130, 'Vegetable');


/* ivm */
insert into ivm (num_serie, fabricante) values (0001, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0002, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0003, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0004, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0005, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0006, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0007, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0008, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0009, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0010, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0011, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0012, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0013, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0014, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0015, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0016, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0017, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0018, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0019, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0020, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (0021, 'Evil Corp');
insert into ivm (num_serie, fabricante) values (1093, 'LG');
insert into ivm (num_serie, fabricante) values (1094, 'LG');
insert into ivm (num_serie, fabricante) values (3392, 'Samsung');
insert into ivm (num_serie, fabricante) values (3441, 'Samsung');


/* retalhista */
insert into retalhista (tin, nome) values (123456780, 'Retalhista 1');
insert into retalhista (tin, nome) values (123456781, 'Retalhista 2');
insert into retalhista (tin, nome) values (123456782, 'Retalhista 3');

/* ponto_de_retalho */
insert into ponto_de_retalho (nome, distrito, concelho) values ('Ponto de Retalho 1', 'Lisboa', 'Lisboa');
insert into ponto_de_retalho (nome, distrito, concelho) values ('Ponto de Retalho 2', 'Lisboa', 'Torres Vedras');
insert into ponto_de_retalho (nome, distrito, concelho) values ('Ponto de Retalho 3', 'Coimbra', 'Coimbra');
insert into ponto_de_retalho (nome, distrito, concelho) values ('Ponto de Retalho 4', 'Porto', 'Gaia');


/* instalada_em */
insert into instalada_em (num_serie, fabricante, local) values (0001, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0002, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0003, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0004, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0005, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0006, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0007, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0008, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0009, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0010, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0011, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0012, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0013, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0014, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0015, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0016, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0017, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0018, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0019, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0020, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (0021, 'Evil Corp', 'Ponto de Retalho 1');
insert into instalada_em (num_serie, fabricante, local) values (1093, 'LG', 'Ponto de Retalho 2');
insert into instalada_em (num_serie, fabricante, local) values (1094, 'LG', 'Ponto de Retalho 2');
insert into instalada_em (num_serie, fabricante, local) values (3392, 'Samsung', 'Ponto de Retalho 3');
insert into instalada_em (num_serie, fabricante, local) values (3441, 'Samsung', 'Ponto de Retalho 4');


/* prateliera */
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (1, 0001, 'Evil Corp', 0.5, 'Galliano');
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (2, 0001, 'Evil Corp', 1.0, 'Tomato');
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (3, 0001, 'Evil Corp', 1.5, 'Cookie');
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (4, 0001, 'Evil Corp', 2.0, 'Coke');
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (1, 1093, 'LG', 0.5, 'Galliano');
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (2, 1093, 'LG', 1.0, 'Decafenated');
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (3, 1093, 'LG', 1.5, 'Coke');
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (1, 1094, 'LG', 0.5, 'Galliano');
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (2, 1094, 'LG', 1.0, 'Coffee');
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (3, 1094, 'LG', 1.5, 'Mocha');
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (1, 3392, 'Samsung', 0.5, 'Galliano');
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (2, 3392, 'Samsung', 1.0, 'Coke');
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (3, 3392, 'Samsung', 1.5, 'Cookie');
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (1, 3441, 'Samsung', 0.5, 'Muskox');
insert into prateleira (nro, num_serie, fabricante, altura, nome) values (2, 3441, 'Samsung', 1.0, 'Tortillas');


/* planograma */
insert into planograma (ean, nro, num_serie, fabricante, faces, unidades, loc) values (1234567890123, 1, 0001, 'Evil Corp', 1, 5, 'Ponto de Retalho 1');
insert into planograma (ean, nro, num_serie, fabricante, faces, unidades, loc) values (1234567890124, 2, 0001, 'Evil Corp', 1, 5, 'Ponto de Retalho 1');
insert into planograma (ean, nro, num_serie, fabricante, faces, unidades, loc) values (1234567890125, 3, 0001, 'Evil Corp', 1, 5, 'Ponto de Retalho 1');
insert into planograma (ean, nro, num_serie, fabricante, faces, unidades, loc) values (1234567890127, 4, 0001, 'Evil Corp', 1, 5, 'Ponto de Retalho 1');
insert into planograma (ean, nro, num_serie, fabricante, faces, unidades, loc) values (1234567890123, 1, 1093, 'LG', 1, 5, 'Ponto de Retalho 2');
insert into planograma (ean, nro, num_serie, fabricante, faces, unidades, loc) values (1234567890129, 2, 1093, 'LG', 1, 5, 'Ponto de Retalho 2');
insert into planograma (ean, nro, num_serie, fabricante, faces, unidades, loc) values (1234567890127, 3, 1093, 'LG', 1, 5, 'Ponto de Retalho 2');
--added
--insert into planograma (ean, nro, num_serie, fabricante, faces, unidades, loc) values (1234567890130, 4, 1093, 'LG', 1, 3, 'Ponto de Retalho 2');


/* responsavel_por */
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Galliano', 123456780, 0001, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Tomato', 123456780, 0002, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Cookie', 123456780, 0003, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Coke', 123456780, 0004, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Mocha Macchiato', 123456780, 0005, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('French Rack', 123456780, 0006, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Canned', 123456780, 0007, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Flour', 123456780, 0008, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Decafenated', 123456780, 0009, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Black', 123456780, 0010, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Americano', 123456780, 0011, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Cappuccino', 123456780, 0012, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Cortado', 123456780, 0013, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Espresso', 123456780, 0014, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Latte', 123456780, 0015, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Mocha Latte Macchiato', 123456780, 0016, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Grana Padano', 123456780, 0017, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Serra da Estrela', 123456780, 0018, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Halves', 123456780, 0019, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Alface', 123456780, 0020, 'Evil Corp');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Frutos', 123456780, 0021, 'Evil Corp');

insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Cheese', 123456781, 1093, 'LG');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Galliano', 123456782, 1094, 'LG');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Coke', 123456782, 3392, 'Samsung');
insert into responsavel_por (nome_cat, tin, num_serie, fabricante) values ('Muskox', 123456782, 3441, 'Samsung');




/* evento_reposicao */
insert into evento_reposicao (ean, nro, num_serie, fabricante, instante, unidades, tin) values (1234567890123, 1, 0001, 'Evil Corp', '2016-01-01 00:00:00', 5, 123456780);
insert into evento_reposicao (ean, nro, num_serie, fabricante, instante, unidades, tin) values (1234567890124, 2, 0001, 'Evil Corp', '2016-01-02 00:00:00', 4, 123456780);
insert into evento_reposicao (ean, nro, num_serie, fabricante, instante, unidades, tin) values (1234567890125, 3, 0001, 'Evil Corp', '2016-01-03 00:00:00', 3, 123456780);
--insert into evento_reposicao (ean, nro, num_serie, fabricante, instante, unidades, tin) values (1234567890127, 4, 0001, 'Evil Corp', '2016-01-04 00:00:00', 2, 123456780);
insert into evento_reposicao (ean, nro, num_serie, fabricante, instante, unidades, tin) values (1234567890129, 2, 1093, 'LG', '2016-01-01 00:00:00', 1, 123456782);
insert into evento_reposicao (ean, nro, num_serie, fabricante, instante, unidades, tin) values (1234567890127, 3, 1093, 'LG', '2016-01-01 00:00:00', 1, 123456782);
