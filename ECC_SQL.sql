-- Database: ecc

-- DROP DATABASE IF EXISTS ecc;

CREATE DATABASE ecc
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-----------------------ESQUELETO DO BANCO DE DADOS -----------------------
-- Tabela Aluno 
DROP TABLE IF EXISTS Aluno cascade;

create table Aluno(

    RA CHAR(8) NOT NULL PRIMARY KEY,
    Nome_aluno varchar(30) not null,
    End_aluno varchar(50) not null,
    Tel_aluno CHAR(13)  not null,
    CPF_aluno char(14) not null,
    RG_aluno char(12) not null,
    Sexo_aluno CHAR(1) NOT NULL CHECK (Sexo_aluno IN ('M','F')),
    Data_nasc_aluno date not null,
	Etnia_aluno CHAR (15) NOT NULL
		CHECK (Etnia_aluno IN ('Branco','Preto','Amarelo','Pardo','Indígena' )));
	
-- Tabela Professor 

drop table if exists Professor cascade;

create table Professor(

    Cod_prof char(6) not null PRIMARY KEY,
    Nome_prof varchar(30) not null,
	end_prof VARCHAR(50) NOT NULL,
    Tel_prof CHAR(13) not null,
    CPF_aluno char(14) not null,
    RG_prof char(12) not  null,
    Data_nasc_prof date not null,
    Sexo_prof CHAR(1) NOT NULL CHECK (sexo_prof IN ('M','F')),
    Data_admissao_prof date not null,
    Data_desligameto_prof date );
 
-- Tabela responsavel 

drop table if exists Responsavel cascade;

create table Responsavel(

    Id_respon char(6) not null,
	 Parestenco_respon char(15) not null
        check (parestenco_respon in ('Mãe','Pai','Madrasta','Padrasto','Tia', 'Tio', 'Avó', 'Avô')),
    Nome_respon char(30) not null,
    Tel_respon CHAR(14) not null,
    CPF_respon char(14) not null,
    RG_respon char(12) not null,
    Sexo_respon CHAR(1) NOT NULL CHECK (sexo_respon IN ('M','F')),
	RA_dependente CHAR(8) NOT NULL,
    PRIMARY KEY (Id_respon));

-- Tabela Idioma 
DROP TABLE IF EXISTS Idioma cascade;

CREATE TABLE Idioma ( 
	Id_idioma CHAR(4) not null PRIMARY KEY ,
	Descricao_idioma CHAR(20) NOT NULL,
	tipo_nivel CHAR(10) not null 
		CHECK (tipo_nivel IN ('Business','Comum')),
	nivel CHAR(2) not null 
		CHECK (nivel IN ('A1','A2','B1','B2','C1','C2')));
		
-- Tabela Aula		
DROP TABLE IF EXISTS Aula cascade;

CREATE TABLE Aula(
    Data_aula date primary key,
    Material_aula varchar(30) not null,
	Situacao_aula char(15) NOT NULL
		CHECK (Situacao_aula IN ('Presente','Falta')),
    RA CHAR(8) NOT NULL references Aluno,
    Cod_prof char(6) not null references Professor,
	id_idioma CHAR(4) NOT NULL REFERENCES IDIOMA,
	Reposicao date);		

-- Tabela Matricula 
DROP TABLE IF EXISTS Matricula cascade;

Create Table Matricula (
	num_matricula CHAR(7) not null PRIMARY KEY,
	Data_matricula date not null,
	Situacao_matricula CHAR(12) NOT NULL 
		CHECK (situacao_matricula IN ('ATIVA','CANCELADA','TRANSFERIDA')),
	RA CHAR(8) NOT NULL references Aluno, 
	Id_idioma CHAR(4) references Idioma);
	
-- Tabela Pagamento 
DROP TABLE IF EXISTS Pagamento cascade;

CREATE TABLE Pagamento(
	id_pagamento char(4) not null PRIMARY KEY, 
	Situação_pagamento CHAR(10) NOT NULL 
		CHECK (situação_pagamento IN ('QUITADO','RECUSADO','CANCELADO') ), 
	Data_venc_pagamento date not null,
	Valor_pagamento NUMERIC(10,2) NOT NULL,
	forma_pagamento CHAR(20)
		CHECK(forma_pagamento IN ('Débito','Crédito','Boleto','PIX')),
	num_matricula CHAR(7) not null references Matricula);

-- Tabela Frequencia
DROP TABLE IF EXISTS Frequencia cascade;

CREATE TABLE Frequencia (
	id_frequencia CHAR(6) NOT NULL PRIMARY KEY,
	Frequencia float not null,
	RA CHAR(8) NOT NULL references Aluno);
	
-- Tabela Atividade 
DROP TABLE IF EXISTS Atividade cascade;

CREATE TABLE Atividade ( cod_atividade char(4) not null PRIMARY KEY ,
	nota_atv float not null,
	data_atv date not null,									
	RA CHAR(8) NOT NULL references Aluno);
	
-- Tabela Boletim 
DROP TABLE IF EXISTS Boletim cascade;

Create table Boletim (
	
	id_boletim CHAR(7) not null PRIMARY KEY,
	Nota_P1 float not null, 
	Nota_P2 float not null,
	frequencia CHAR(6) NOT NULL references Frequencia,
	RA CHAR(8) NOT NULL references Aluno,
	cod_atividade char(4) not null references atividade,
	Id_idioma CHAR(4) not null references idioma);
	
	
	
-- Tabela TIPO AVALIA 
DROP TABLE IF EXISTS tipo_avalia cascade;

CREATE TABLE tipo_avalia ( id_feedback CHAR(9) NOT null PRIMArY KEY,
							Tipo_avalia CHAR(1)
						  		CHECK(tipo_avalia IN('1','2')),
						  	Pontualidade CHAR(1)
						  		CHECK(Pontualidade IN('1','2','3','4','5')),
						  	Dominio_da_Materia CHAR(1)
						  		CHECK(Dominio_da_Materia IN('1','2','3','4','5')),
						  	Desempenho CHAR(1)
						  		CHECK(Desempenho IN('1','2','3','4','5')),
					 		cod_professor char(6) not null references Professor,
						  	RA CHAR(8) NOT NULL references Aluno,
							Id_idioma CHAR(4) not null references idioma);
						
------------------- POPULANDO AS TABELAS ------------------------------

-- Tabela Aluno 
Select * from aluno 


Insert into Aluno values ( '12345678',    'João da Silva Santos',    'Rua da Consolação, 100 - Centro',    
                          '(11)1234-5678' ,    '123.456.789-01',    '48.291.763-5',    'M', '03/02/1995','Branco');

Insert into Aluno values   ('98755432',    'Maria Oliveira Costa',    'Avenida Paulista, 1500 - Bela Vista',    
                           '(11)9876-5432',    '987.654.321-20',    '75.362.981-0',    'F', '11/09/2010','Amarelo'),
                            ('55551234',    'Pedro Almeida Souza',    'Rua Augusta, 2500 - Jardim Paulista',    
                             '(11)5555-1234',    '555.123.456-21',    '91.658.043-2',    'M',     '07/06/1998','Preto'),
                            ('99998888',    'Ana Santos Lima',    'Rua Oscar Freire, 800 - Cerqueira César',    
                             '(11)9999-8888',    '999.888.737-00',    '24.680.975-3',    'F', '15/03/2002','Pardo');

Insert into Aluno values    ('24681357','Lucas Pereira Ribeiro',    'Rua Pamplona, 800 - Jardim Paulista',    
                             '(11)4567-8901',    '246.813.579-05',    '30.571.896-4',    'M',     '24/12/2007','Indígena'),
                            ( '75319864','Juliana Fernandes Rodrigues' ,    'Avenida Brigadeiro Faria Lima, 5000 - Itaim Bibi',    
                            '(11)2345-6789',    '753.198.642-09',    '67.489.201-3',    'F',    '19/08/2015','Branco'),
                            ('87654321','Gabriel Cardoso Gomes',    'Rua João Cachoeira, 800 - Itaim Bibi',
                             '(11)7777-1111',    '876.543.210-55',    '13.946.827-5',    'M',     '30/01/2003','Indígena'),
                            ('11223344','Isabella Martins Barbosa',    'Rua Henrique Schaumann, 800 - Pinheiros',    
                             '(11)3210-9876' ,    '112.233.445-80' ,    '82.054.391-6' ,    'F',    '12/11/2008','Preto');

Insert into Aluno values    ('56789012',    'Rafael Oliveira Silva','Avenida Rebouças, 1000 - Jardim Paulista',
                             '(11)8888-9999'    ,'567.890.123-98'    ,'59.730.186-4',    'M'     ,'28/07/2001','Amarelo'),
                            ('65432109','Larissa Santos Pereira',    'Rua Peixoto Gomide, 500 - Bela Vista',    
                            '(11)5432-1098'    ,'654.321.098-54'    ,'36.472.598-1'    ,'F'    ,'06/04/2012','Pardo'),
                            ('78901234',    'Bruno Alves Carvalho',    'Avenida Ibirapuera, 2000 - Moema',
                             '(11)8765-4321',    '789.012.345-91',    '91.804.762-3'    ,'M' ,    '22/09/2006','Branco'),
                            ('98565432',    'Luana Costa Ferreira',    'Rua Domingos de Morais, 1000 - Vila Mariana'    ,
                             '(11)2468-1357', '987.654.321-87',    '53.029.748-6',    'F',    '02/07/1999','Preto'),
                            ('54321987','Matheus Rodrigues Almeida',    'Avenida Carlos Berrini, 1500 - Brooklin',
                             '(11)7531-8642'    ,'543.219.876-99',    '68.514.307-9',    'M',     '09/05/2004','Indígena'),
                            ('13572468',    'Mariana Lima Gonçalves',    'Rua Clélia, 1000 - Perdizes',
                             '(11)9876-5432',    '135.724.680-34',    '47.239.615-8',    'F'    ,'14/10/2011','Pardo');


Insert into Aluno values     ('86421357',    'Tiago Sousa Oliveira',    'Rua Mourato Coelho, 800 - Vila Madalena',    
                             '(11)5432-1987'    ,'864.213.579-55',    '15.689.432-7',    'M',     '26/12/2009','Amarelo'),
                            ('19875432',    'Fernanda Martins Costa',    'Avenida Juscelino Kubitschek, 1500 - Itaim Bibi',
                             '(11)7890-1234',    '198.754.321-19',    '82.763.951-0',    'F',    '05/03/2007','Indígena'),
                            ('90123456',    'Daniel Silva Rodrigues',    'Rua Paim, 500 - Bela Vista',    
                             '(11)6543-2109',    '901.234.567-8',    '39.461.852-0',    'M',     '18/11/2002','Preto'),
                            ('33333333',    'Carolina Santos Almeida',    'Rua dos Pinheiros, 1000 - Pinheiros',
                             '(11)1111-2222',    '333.333.333-65',    '64.120.893-5',    'F','20/08/2014','Amarelo'),
                             ('44444444',    'Gustavo Pereira Barbosa',    'Rua Barão de Itapetininga, 500 - República',
                              '(11)8888-8888',    '444.444.444-83',    '20.975.348-6',    'M',     '01/02/2000','Branco'),
                            ('77777777',    'Vanessa Oliveira Ribeiro',    'Rua Antônio Carlos, 800 - Consolação',
                             '(11)3333-4444',    '777.777.777-21',    '87.493.610-5',    'F',    '10/07/2005','Pardo'),
                            ('22222222',    'Alexandre Fernandes Gomes',    'Avenida Nove de Julho, 5000 - Jardim Paulista',    
                             '(11)2222-3333',    '222.222.222-46',    '51.340.298-7',    'M',     '29/04/2013','Amarelo'),
                            ('66666666',    'Letícia Barbosa Carvalho',    'Rua da Mooca, 1000 - Mooca',
                             '(11)5555-6666',    '666.666.666-84',    '73.649.582-1',    'F',    '23/12/2016','Pardo'),
                            ('88888888',    'Vinícius Ribeiro Lima',    'Avenida Morumbi, 5000 - Morumbi',
                             '(11)6666-7777',    '888.888.888-93',    '98.521.046-7',    'M',    '08/09/2001','Preto'),
                            ('99999999',    'Camila Oliveira Souza',    'Rua Pamplona, 2000 - Jardim Paulista',    
                             '(11)7777-8888',    '999.999.999-32',    '36.218.475-0',    'F',    '16/06/2010','Indígena'),
                            ('12121212',    'Rafaela Ferreira Alves',    'Avenida Professor Alfonso Bovero, 1000 - Sumaré',    
                             '(11)9999-0000',    '121.212.121-46',    '12.967.354-8',    'F',    '03/11/2008','Branco');
							 
Insert into Aluno values ('34343434',    'André Costa Rodrigues',    'Rua Bela Cintra, 1500 - Consolação',
                          '(11)0000-9999',    '343.434.343-76',    '58.940.723-6',    'M',     '09/05/2002','Preto'),                                                                        
                        ('56565656'    ,'Natália Santos Gonçalves',    'Rua São Caetano, 500 - Brás',    
                         '(11)2345-6789',    '565.656.565-21',    '72.451.986-3',    'F', '25/01/2015','Indígena'),                                                                        
                        ('78787878'    ,'Guilherme Almeida Sousa',    'Avenida Sumaré, 5000 - Perdizes',    
                         '(11)8765-4321',    '787.878.787-98',    '36.187.792-4',    'M',     '17/08/2007','Amarelo'),                                                                        
                        ('23232323'    ,'Beatriz Lima Martins',    'Rua Vergueiro, 1000 - Liberdade',    
                         '(11)4321-8765' ,    '232.323.232-56',    '94.562.801-3',    'F','07/04/2012','Branco'),                                                                        
                        ('45454545',    'Henrique Carvalho Oliveira',    'Rua Clélia, 1500 - Água Branca',    
                         '(11)1357-2468',    '454.545.454-87',    '80.243.615-9',    'M',     '13/10/2006','Pardo'),                                                                        
                        ('67676767'  , 'Isabela Sousa Ferreira',    'Rua da Glória, 800 - Liberdade',    
						 '(11)8642-7531',    '676.767.676-33',    '17.359.264-8',    'F',    '21/07/1999','Preto'),                                                                        
                        ('89898989',    'Lucas Martins Silva',   ' Avenida Pacaembu, 5000 - Pacaembu',
						 '(11)1987-5432',    '898.989.898-11',    '64.891.730-5',    'M',     '31/03/2004','Indígena'),                                                                        
                        ('45678901' ,   'Bruna Gonçalves Costa',    'Rua Santa Cruz, 1000 - Vila Mariana',  
						 '(11)7890-1234',    '456.789.012-87',    '29.764.358-1',    'F',    '06/09/2011','Amarelo'),                                                                        
                        ('97123456',    'Diego Oliveira Barbosa',    'Rua dos Pinheiros, 1500 - Pinheiros',
						 '(11)2109-6543',    '901.234.567-67',    '51.623.094-7',    'M',     '12/05/2009','Branco'),                                                                        
                        ('23456789' ,   'Ana Clara Ribeiro Gomes',    'Avenida Angélica, 2000 - Higienópolis',
						 '(11)2222-1111',    '234.567.890-57',    '87.319.542-6',    'F',    '25/12/2002','Pardo'),                                                                        
                        ('56789712' ,  'Gabriel Fernandes Carvalho',    'Rua Voluntários da Pátria, 1000 - Santana',   
						 '(11)8888-8888',    '567.890.123-98',    '43.276.951-8',    'M',     '04/03/2014','Preto'),                                                                        
                        ('89012345' ,   'Júlia Costa Alves',    'Rua João Moura, 800 - Pinheiros',   
						 '(11)4444-3333',    '890.123.456-63',    '65.938.124-7',    'F',    '19/02/2000','Amarelo');                                                                       
						 
Insert into Aluno values ('12345688',    'Rafael Rodrigues Lima',    'Avenida Professor Vicente Rao, 1000 - Santo Amaro',
						  '(11)3333-2222',    '123.456.789-97',    '21.896.450-3',    'M',     '08/07/2005','Indígena'),
						('78921234',    'Amanda Santos Pereira',    'Rua Augusta, 2000 - Cerqueira César',
						 '(11)6666-5555',    '789.012.345-88',    '39.742.861-5',    'F',    '27/04/2013','Branco'),
						 ('43210987',    'Thiago Almeida Barbosa',    'Rua Barra Funda, 1500 - Barra Funda',   
						 '(11)7777-6666',    '432.109.876-31',    '50.437.189-2',    'M',   '15/12/2016','Pardo'),
						('87654331',    'Manuela Oliveira Ribeiro',    'Avenida Indianópolis, 2000 - Indianópolis',
						 '(11)8888-7777',    '876.543.210-89',    '92.678.031-4',    'F',    '02/09/2001','Preto'),
                        ('10987654',    'Vitor Costa Souza',    'Rua Teodoro Sampaio, 1500 - Pinheiros',
						 '(11)0000-9999' ,   '109.876.543-82',    '18.534.672-9',    'M',  '10/06/2010','Amarelo'),
                        ('54321887',    'Letícia Alves Martins',    'Rua Domingos de Moraes, 1500 - Vila Mar',
						 '(11)6789-2345',    '543.219.876-19',    '76.029.418-3',    'F',    '28/11/2008','Indígena'),
                        ('98765442',    'Renato Lima Gonçalves',    'Praça da Sé, 890 - Sé',
						 '(11)4321-8765',    '987.654.321-15',    '35.187.049-2',    'M',     '14/05/2002','Pardo');
						 
Insert into Aluno values ('32109876',    'Melissa Sousa Oliveira',    'Rua Augusta, 987 - Consolação',    
						'(11)8765-4321',    '321.098.765-84',    '47.815.390-6',    'F',    '30/01/2015','Branco'),
                        ('76543210',    'Pedro Fernandes Gomes',    'Avenida Brasil, 5678 - Jardim América',   
						'(11)2468-1357',    '765.432.109-00',    '63.809.524-1',    'M',     '16/08/2007','Amarelo'),
                        ('23756789',    'Carolina Barbosa Carvalho',    'Rua Vinte e Cinco de Março, 321 - Centro',   
						'(11)7531-8642',    '234.567.890-00',    '91.342.507-6',    'F',    '06/04/2012','Indígena'),
                        ('67890123',    'Igor Ribeiro Lima',    'Avenida Rebouças, 654 - Pinheiros',   
						'(11)5432-1987',    '678.901.234-00',    '57.206.938-4',    'M',     '22/10/2006','Preto'),
                        ('34567890',    'Laura Oliveira Souza',    'Rua José Paulino, 876 - Bom Retiro',    
						'(11)1234-5678',    '345.678.901-00',    '84.093.165-7',    'F',    '01/08/1999','Branco'),
                        ('78001234',    'Lucas Ferreira Alves',    'Avenida Ibirapuera, 9876 - Moema',    
						'(11)9876-5432',    '789.012.345-00',    '19.574.326-8',    'M',     '11/03/2004','Pardo');
						
INSERT INTO Aluno Values (36528790,	'João Lucas Mendes',	'Av. Paulista, 1234, Bela Vista, São Paulo - SP',	
						  '(11)1111-1111',	'123.456.789-00',	'12.345.678-9',	'M',	'19/03/2000',	'Branco'),
						(56782351,	'Isabela Ana  Santos',	'Rua Augusta, 567, Consolação, São Paulo - SP',
						 '(11)2222-2222',	'987.654.321-11',	'98.765.432-1',	'F',	'20/02/1988',	'Pardo'),
						(4567123,	'André Moura Costa',	'Av. Faria Lima, 789, Pinheiros, São Paulo - SP',
						 '(11)3333-3333',	'555.666.777-22',	'55.566.677-7',	'M',	'01/02/1998',	'Preto'),
						(11109787,	'Camila Oliveira Andrade', 	'Rua Oscar Freire, 4321, Jardins, São Paulo - SP',	
						 '(11)4444-4444',	'999.888.777-33',	'99.988.877-7',	'F','03/02/2001',	'Amarelo' );
						
-- Tabela Professor 

SELECT * FROM professor;

INSERT INTO professor VALUES('837490', 'Lucas Mendes', 'Rua das Flores, 123 - Vila Nova', '(11)5550-1234', '538.190.624-73', '38.462.790-5' , '12/03/1979', 'M', '17/07/2012');
INSERT INTO professor VALUES('562831', 'Sofia Silva', 'Avenida dos Bandeirantes, 456 - Moema', '(11)5551-5678', '427.183.950-67', '19.725.638-4', '25/07/1977', 'F', '29/03/2014');
INSERT INTO professor VALUES('194257', 'Gabriel Santos', 'Rua do Sol, 789 - Pinheiros', '(11)5552-8901', '283.691.045-72', '04.631.982-7', '05/12/1995', 'M', '08/11/2017');
INSERT INTO professor VALUES('675408', 'Isabella Oliveira', 'Alameda dos Anjos, 321 - Jardins', '(11)5553-2345', '951.370.628-49', '52.784.069-3', '17/08/1988', 'F', '05/01/2011');
INSERT INTO professor VALUES('320976', 'Pedro Costa', 'Praça da Liberdade, 987 - Liberdade', '(11)5554-6789', '072.384.591-63', '13.984.607-4', '09/09/2000', 'M', '12/09/2013');
INSERT INTO professor VALUES('901543' ,	'Laura Pereira', 'Rua das Palmeiras, 654 - Higienópolis',	'(11)5555-0123' ,'629.417.305-82' ,	'70.963.285-1' , '28/04/1992' ,	'F',	'20/05/2019');	
INSERT INTO professor VALUES('486209' ,	'Matheus Rodrigues' ,	'Avenida Paulista, 321 - Bela Vista' ,	'(11)5556-3456' ,	'692.481.370-52' ,	'45.179.306-2' ,'12/11/1974' , 'M' , 	'03/04/2018');	
INSERT INTO professor VALUES('725164' ,	'Maria Fernandes' ,	'Rua das Violetas, 852 - Morumbi' ,	'(11)5557-7890' ,	'135.792.468-01' ,	'81.510.687-9' ,	'21/08/1998' ,	'F' ,	'06/10/2020' );	
INSERT INTO professor VALUES('368502' ,	'Rafael Almeida' ,	'Alameda dos Ipês, 147 - Itaim Bibi' ,	'(11)5558-1234' ,	'381.529.740-63' ,	'67.049.218-3' ,	'03/02/1985' ,	'M' , 	'21/12/2015');
INSERT INTO professor VALUES('587401' ,	'Ana Castro' ,	'Praça do Patriarca, 369 - Centro',	'(11)5559-5678', '927.418.630-59' ,	'94.236.175-8' ,	'14/10/1979' ,	'F' ,	'11/02/2016');
INSERT INTO professor VALUES('213679', 	'João Cardoso' ,	'Rua dos Lírios, 741 - Perdizes',	'(11)5560-8901' ,	'274.917.680-57' ,	'36.870.254-1' ,	'06/06/1991' ,	'M' ,	'27/08/2010');
INSERT INTO professor VALUES('894316' ,	'Carolina Sousa' ,	'Avenida Faria Lima, 2580 - Vila Olímpia' ,	'(11)5561-2345' ,	'153.962.804-71' ,	'10.598.367-4' ,	'19/12/1983' ,	'F' ,	'14/06/2022' , '01/10/2023');
INSERT INTO professor VALUES('156207' ,	'Gustavo Martins' ,	'Rua dos Pinheiros, 963 - Pinheiros' ,	'(11)5562-6789' , 	'842.759.310-68' ,	'29.486.503-7' ,	'01/03/1997' ,	'M' ,	'09/06/2014');	
INSERT INTO professor VALUES('439682' ,	'Giovanna Ferreira' ,	'Alameda Santos, 1743 - Cerqueira César' ,	'(11)5563-0123' ,	'037.286.495-10' ,	'75.103.429-6' ,	'23/09/1986' ,	'F' ,	'18/04/2017');	
INSERT INTO professor VALUES('706921' ,	'Guilherme Ribeiro' ,	'Rua Augusta, 654 - Consolação' ,	'(11)5564-3456' ,	'371.942.580-63' ,	'43.275.981-6' ,	'08/07/1993' ,	'M' ,	'23/10/2011');	
INSERT INTO professor VALUES('928463' ,	'Beatriz Carvalho' ,	'Avenida Brasil, 987 - Jardim Paulista',	'(11)5565-7890' ,	'628.419.053-73' ,	'57.926.841-0' ,	'27/01/1980' ,	'F' ,	'01/03/2020');	
INSERT INTO professor VALUES('315790' ,	'Leonardo Santos' ,	'Rua Oscar Freire, 123 - Jardim América' ,	'(11)5566-1234' ,	'153.709.246-83' ,	'01.653.978-2' ,	'11/05/1973' ,	'M' ,	'07/01/2013');
INSERT INTO professor VALUES('640187' ,	'Manuela Nunes' ,	'Alameda Campinas, 456 - Paraíso' ,	'(11)5567-5678' ,	'286174.390-53' ,	'82.317.640-9' , 	'2/11/1999' ,	'F' ,	'30/09/2018');	
INSERT INTO professor VALUES('187543' ,	'Felipe Lima' ,	'Rua Haddock Lobo, 852 - Cerqueira César' ,	'(11)5568-8901' ,	'429.716.305-83' ,	'64.089.315-2' ,	'15/09/1976' ,	'M' ,	'13/12/2016' ,	'30/10/2022');
INSERT INTO professor VALUES('572819' ,	'Mariana Gonçalves' ,	'Avenida Rebouças, 369 - Pinheiros' ,	'(11)5569-2345' ,	'704.269.531-93' ,	'93.502.746-1' ,	'07/04/1989' ,	'F' ,	'02/11/2023');	
INSERT INTO professor VALUES('349706' ,	'Daniel Barbosa' ,	'Rua Bela Cintra, 741 - Jardim Paulista' ,	'(11)5570-6789' ,	'139.470.208-53' ,	'26.741.059-3' ,	'20/02/1994' ,	'M' ,	'19/01/2012');	
INSERT INTO professor VALUES('891654' ,	'Letícia Vieira' ,	'Alameda Lorena, 2580 - Jardins' ,	'(11)5571-0123' ,	'825.174.903-63' ,	'18.937.624-0' ,	'30/07/1981' ,	'F' ,	'10/08/2019' ,	'08/06/2019');
INSERT INTO professor VALUES('206845' ,	'Thiago Oliveira' ,	'Praça Benedito Calixto, 963 - Pinheiros' ,	'(11)5572-3456' ,	'318.564.062-73' ,	'79.165.803-4' ,	'13/06/1996' ,	'M' ,	'24/03/2015' ,	'23/03/2021');
INSERT INTO professor VALUES('473190' ,	'Amanda Torres' ,	'Rua João Cachoeira, 1743 - Itaim Bibi' ,	'(11)5573-7890' ,	'692.518.304-73' ,	'40.278.196-3' ,'26/10/1987' ,	'F' ,	'15/09/2022');	
INSERT INTO professor VALUES('819327' ,	'Vinicius Costa' ,	'Avenida Juscelino Kubitschek, 654 - Nova Conceição' ,	'(11)5574-1234' ,	'173.960.428-53' ,	'35.694.072-8' ,	'04/12/1978' ,	'M' ,	'04/11/2020');

-- Tabela Reponsaveis

SELECT * FROM responsavel 

INSERT INTO responsavel VALUES ('492178',	'Mãe',	'Ana Silva Santos',	'(11) 5550-1234',	'689.453.712-58',	'87.120.569-2',	'F',	'98765432'),
								('617493',	'Padrasto',	'João Souza Oliveira',	'(11) 6661-9876',	'924.678.132-45',	'56.381.947-0',	'M', 	'75319864'),
								('856027',	'Avó',	'Maria Rodrigues Costa',	'(11) 7772-3456',	'376.512.908-74',	'92.640.318-5',	'F',	'11223344'),
								('324901',	'Pai',	'Pedro Almeida Pereira',	'(11) 8883-6789',	'102.938.475-60',	'31.857.924-6',	'M',	'65432109'),
								('738512',	'Mãe',	'Juliana Fernandes Lima',	'(11) 9994-5678',	'548.216.739-01',	'75.420.613-8',	'F',	'13572468'),
								('590436',	'Tio',	'Lucas Gomes Carvalho',	'(11) 1115-4321',	'765.432.109-87',	'64.092.758-1',	'M',	'86421357'),
								('283749',	'Mãe',	'Camila Santos Silva',	'(11) 2226-7890',	'325.467.890-12',	'21.589.346-7',	'F',	'33333333'),
								('675091',	'Pai',	'Matheus Costa Oliveira',	'(11) 3337-6543',	'987.654.321-09',	'48.975.236-1',	'M',	'22222222'),
								('145238',	'Mãe',	'Fernanda Pereira Almeida',	'(11) 4448-9012',	'654.378.912-34',	'17.643.098-5',	'F',	'66666666'),
								('976504',	'Pai',	'Gabriel Lima Rodrigues',	'(11) 5559-8765',	'213.456.789-01',	'36.259.871-4',	'M',	'12121212'),
								('410385',	'Avó',	'Letícia Carvalho Gomes',	'(11) 6662-3456',	'876.543.210-98',	'89.714.325-6',	'F',	'23232323'),
								('629407',	'Padrasto',	'Rafael Oliveira Souza',	'(11) 7773-6789',	'439.215.678-90',	'54.360.789-1',	'M',	'45678901'),
								('852146',	'Mãe',	'Larissa Santos Almeida',	'(11) 8884-5678',	'567.809.123-45',	'32.981.465-7',	'F',	'90123456'),
								('317695',	'Avô',	'André Costa Fernandes',	'(11) 9995-4321',	'321.098.765-43',	'71.856.329-4',	'M',	'56789012'),
								('568023',	'Mãe',	'Carolina Pereira Gomes',	'(11) 1116-7890',	'890.123.456-78',	'98.512.470-3',	'F',	'78901234');

INSERT INTO responsavel VALUES ('974126',	'Padrasto' ,	'Gustavo Almeida Rodrigues',	'(11) 2227-6543',	'456.789.012-34',	'65.794.018-2',	'M',	'43210987'),
								('263094',	'Tia',	'Mariana Lima Fernandes',	'(11) 3338-9012',	'765.432.198-76',	'10.487.659-3',	'F',	'10987654'),
								('540617',	'Pai',	'Thiago Souza Santos',	'(11) 4449-8765',	'901.234.567-89',	'78.236.091-5',	'M',	'54321987'),
								('891362',	'Mãe',	'Isabela Fernandes Carvalho',	'(11) 5551-3456',	'654.321.098-76',	'49.027.518-3',	'F',	'32109876'),
								('426709',	'Tio',	'Felipe Santos Almeida',	'(11) 6663-6789',	'789.012.345-67',	'23.185.946-7',	'M',	'23456789');

-- Tabela Idioma 
SELECT * FROM Idioma


INSERT INTO Idioma Values ('4117',	'Ingles', 	'Comum',	'A1'),
							(4127,	'Ingles', 	'Comum',	'A2'),
							(4217,	'Ingles', 	'Comum',	'B1'),
							(4227,	'Ingles', 'Comum',	'B2'),
							(4317,	'Ingles', 	'Comum',	'C1'),
							(4327,	'Ingles', 	'Comum',	'C2'),
							(4118,	'Ingles', 	'Business',	'A1'),
							(4128,	'Ingles', 	'Business',	'A2'),
							('4218',	'Ingles',	'Business',	'B1'),
							('4228',	'Ingles', 	'Business',	'B2'),
							('4318',	'Ingles', 	'Business',	'C1'),
							('4328',	'Ingles', 	'Business',	'C2');

INSERT INTO Idioma VALUES (5117,	'Espanhol',	'Comum',	'A1'),
							(5127,	'Espanhol',	'Comum',	'A2'),
							('5217',	'Espanhol',	'Comum','B1'),
							(5227,	'Espanhol',	'Comum',	'B2'),
							(5317,	'Espanhol',	'Comum',	'C1'),
							(5327,	'Espanhol',	'Comum',	'C2'),
							(5118,	'Espanhol',	'Business',	'A1'),
							(5128,	'Espanhol',	'Business',	'A2'),
							(5218,	'Espanhol',	'Business',	'B1'),
							(5228,	'Espanhol',	'Business',	'B2'),
							(5318,	'Espanhol',	'Business',	'C1'),
							(5328,	'Espanhol',	'Business',	'C2');

INSERT INTO Idioma Values (6117,	'Francês',	'Comum',	'A1'),
							(6127,	'Francês',	'Comum',	'A2'),
							(6217,	'Francês',	'Comum',	'B1'),
							(6227,	'Francês',	'Comum',	'B2'),
							(6317,	'Francês',	'Comum',	'C1'),
							(6327,	'Francês',	'Comum',	'C2'),
							(6118,	'Francês',	'Business',	'A1'),
							(6128,	'Francês',	'Business',	'A2'),
							(6218,	'Francês',	'Business',	'B1'),
							(6228,	'Francês',	'Business',	'B2'),
							(6318,	'Francês',	'Business',	'C1'),
							(6328,	'Francês',	'Business',	'C2');
							
-- Tabela Aula 

SELECT * FROM aula 

INSERT INTO aula VALUES ('01/02/2023',	'M-A1',	'Presente',	12345678,	837490,	4117);

INSERT INTO aula VALUES ('03/02/2023', 'M-C2', 'Presente', 98765432, 562831, 5327),
						('04/02/2023', 'M-A2', 'Presente', 55551234, 194257, 4128),
						('06/02/2023', 'M-B1', 'Presente', 99998888, 675408, 5217),
						('10/02/2023', 'M-B1', 'Presente', 24681357, 320976, 6218);					
INSERT INTO aula VALUES	('11/02/2023', 'M-C3', 'Falta', 75319864, 901543, 4328,'25/02/2023');
INSERT INTO aula VALUES	('13/02/2023', 'M-B2', 'Presente', 87654321, 486209, 6227),
						('15/02/2023', 'M-B2', 'Presente', 11223344, 725164, 4227),
						('17/02/2023', 'M-C1', 'Presente', 56789012, 368502, 5317),
						('20/02/2023', 'M-B2', 'Presente', 65432109, 587401, 6227),
						('22/02/2023', 'M-C2', 'Presente', 78901234, 213679, 4328),
						('24/02/2023', 'M-B1', 'Presente', 98765432, 894316, 4218),
						('27/02/2023', 'M-B1', 'Presente', 54321987, 156207, 4218),
						('01/03/2023', 'M-A2', 'Presente', 13572468, 439682, 6127);						
INSERT INTO aula VALUES	('03/03/2023', 'M-A2', 'Falta', 86421357, 706921, 5128,'18/03/2023');						
INSERT INTO aula VALUES ('06/03/2023', 'M-A2', 'Presente', 19875432, 928463, 4127),
						('08/03/2023', 'M-A1', 'Presente', 90123456, 315790, 5117),
						('10/03/2023', 'M-C2', 'Presente', 33333333, 640187, 5328),
						('13/03/2023', 'M-C1', 'Presente', 44444444, 187543, 4318),
						('15/03/2023', 'M-A2', 'Presente', 77777777, 572819, 6127),
						('17/03/2023', 'M-A1', 'Presente', 22222222, 349706, 6118),
						('20/03/2023', 'M-C2', 'Presente', 66666666, 891654, 6328),
						('22/03/2023', 'M-A2', 'Presente', 88888888, 206845, 4127),
						('24/03/2023', 'M-A2', 'Presente', 99999999, 473190, 4127),
						('27/03/2023', 'M-C2', 'Presente', 12121212, 819327, 4328),
						('29/03/2023', 'M-A1', 'Presente', 34343434, 901543, 6117),
						('31/03/2023', 'M-C2', 'Presente', 56565656, 439682, 4328),
						('03/04/2023', 'M-A2', 'Presente', 78787878, 587401, 6128),
						('05/04/2023', 'M-B1', 'Presente', 23232323, 894316, 5218),
						('07/04/2023', 'M-B1', 'Presente', 45454545, 640187, 5217),
						('10/04/2023', 'M-C3', 'Presente', 67676767, 439682, 6328),
						('04/12/2023', 'M-B2', 'Presente', 89898989, 206845, 4227),
						('14/04/2023', 'M-B2', 'Presente', 45678901, 213679, 4227);						
INSERT INTO aula VALUES	('17/04/2023', 'M-C1', 'Falta', 90123456, 837490, 6318,'02/05/2023');
INSERT INTO aula VALUES	('19/04/2023', 'M-B2', 'Presente', 23456789, 562831, 4227),
						('21/04/2023', 'M-C2', 'Presente', 56789012, 194257, 6327),
						('24/04/2023', 'M-B1', 'Presente', 89012345, 675408, 4218),
						('26/04/2023', 'M-B1', 'Presente', 12345678, 320976, 4218),
						('28/04/2023', 'M-A2', 'Presente', 78901234, 706921, 4127);						
INSERT INTO aula VALUES	('01/05/2023', 'M-A2', 'Falta', 43210987, 928463, 6128,'16/05/2023');
INSERT INTO aula VALUES	('03/05/2023', 'M-A2', 'Presente', 87654321, 315790, 4127),
						('05/05/2023', 'M-A1', 'Presente', 10987654, 706921, 4117),
						('08/05/2023', 'M-C2', 'Presente', 54321987, 928463, 6328),
						('10/05/2023', 'M-C1', 'Presente', 98765432, 901543, 5317),
						('12/05/2023', 'M-A2', 'Presente', 32109876, 725164, 4128);						
INSERT INTO aula VALUES	('15/05/2023', 'M-A1', 'Falta', 76543210, 368502, 6118,'30/05/2023');
INSERT INTO aula VALUES	('17/05/2023', 'M-C2', 'Presente', 23456789, 587401, 5327),
						('19/05/2023', 'M-A2', 'Presente', 67890123, 320976, 4128),
						('22/05/2023', 'M-A2', 'Presente', 34567890, 640187, 4128);
INSERT INTO aula VALUES ('26/05/2023', 'M-C2', 'Falta', 78901234, 206845, 4327,'10/06/2023');
INSERT INTO aula VALUES	('01/06/2023', 'M-A1', 'Presente', 12345678, 837490, 4117),
						('03/06/2023', 'M-C2', 'Presente', 98765432, 562831, 5327),
						('05/06/2023', 'M-A2', 'Presente', 55551234, 194257, 4128),
						('08/06/2023', 'M-B1', 'Presente', 99998888, 675408, 5217),
						('09/06/2023', 'M-B1', 'Presente', 24681357, 320976, 6218);						
INSERT INTO aula VALUES	('12/06/2023', 'M-C3', 'Falta', 75319864, 901543, 4328,'27/06/2023');
INSERT INTO aula VALUES	('16/06/2023', 'M-B2', 'Presente', 87654321, 486209, 6227),
						('19/06/2023', 'M-B2', 'Presente', 11223344, 725164, 4227),
						('21/06/2023', 'M-C1', 'Presente', 56789012, 368502, 5317),
						('23/06/2023', 'M-B2', 'Presente', 65432109, 587401, 6227),
						('26/06/2023', 'M-C2', 'Presente', 78901234, 213679, 4328),
						('29/06/2023', 'M-B1', 'Presente', 98765432, 894316, 4218),
						('01/07/2023', 'M-B1', 'Presente', 54321987, 156207, 4218),
						('03/07/2023', 'M-A2', 'Presente', 13572468, 439682, 6127);						
INSERT INTO aula VALUES ('06/07/2023', 'M-A2', 'Falta', 86421357, 706921, 5128,'21/07/2023');
INSERT INTO aula VALUES	('10/07/2023', 'M-A2', 'Presente', 19875432, 928463, 4127),
						('13/07/2023', 'M-A1', 'Presente', 90123456, 315790, 5117),
						('17/07/2023', 'M-C2', 'Presente', 33333333, 640187, 5328),
						('19/07/2023', 'M-C1', 'Presente', 44444444, 187543, 4318);					
INSERT INTO aula VALUES	('21/07/2023', 'M-A2', 'Falta', 77777777, 572819, 6127,'05/08/2023');
INSERT INTO aula VALUES	('24/07/2023', 'M-A1', 'Presente', 22222222, 349706, 6118),
						('26/07/2023', 'M-C2', 'Presente', 66666666, 891654, 6328);
INSERT INTO aula VALUES	('31/07/2023', 'M-A2', 'Falta', 88888888, 206845, 4127,'16/08/2023');
					

--Tabela matricuLa 

SELECT * FROM Matricula 

INSERT INTO Matricula VALUES ( 9832174,	'25/01/2017',	'ATIVA',	12345678,	5327);
INSERT INTO Matricula VALUES (5428769, '12/10/2020', 'ATIVA', 98765432, 5218),
							(7258391, '6/3/2018', 'ATIVA', 55551234, 6227),
							(6104785, '19/06/2021', 'ATIVA', 99998888, 6218),
							(3972168, '02/09/2019', 'ATIVA', 24681357, 4127),
							(8547320, '28/06/2016', 'ATIVA', 75319864, 5328),
							(1692534, '14/2/2015', 'ATIVA', 87654321, 5217),
							(4268937, '07/02/2022', 'ATIVA', 11223344, 5227),
							(7315462, '31/01/2023', 'ATIVA', 56789012, 6218),
							(5483791, '18/8/2022', 'ATIVA', 65432109, 4317),
							(1269045, '09/04/2016', 'ATIVA', 78901234, 4318),
							(3972854, '23/08/2020', 'ATIVA', 98765432, 6327),
							(6187504, '10/02/2018', 'ATIVA', 54321987, 4128),
							(4726938, '26/9/2022', 'ATIVA', 13572468, 5117),
							(8659143, '03/07/2023', 'ATIVA', 86421357, 5127),
							(3450192, '15/01/2017', 'ATIVA', 19875432, 4318),
							(5201348, '11/03/2023', 'ATIVA', 90123456, 5217),
							(9146825, '04/12/2021', 'ATIVA', 33333333, 4327),
							(2639054, '21/10/2018', 'ATIVA', 44444444, 5227),
							(8743506, '08/05/2016', 'ATIVA', 77777777, 5228),
							(6394218, '24/02/2023', 'ATIVA', 22222222, 6227),
							(3059286, '13/9/2017', 'ATIVA', 66666666, 6318),
							(7532184, '05/06/2020', 'ATIVA', 88888888, 4327),
							(4823069, '29/01/2018', 'ATIVA', 99999999, 4318),
							(1974635, '16/08/2022', 'ATIVA', 12121212, 4327),
							(5389721, '01/08/2021', 'ATIVA', 34343434, 5128),
							(4208563, '19/04/2015', 'ATIVA', 56565656, 5227),
							(7384195, '12/12/2020', 'ATIVA', 78787878, 4318),
							(5146209, '7/3/2019', 'ATIVA', 23232323, 5218),
							(8465702, '21/11/2022', 'ATIVA', 45454545, 4317),
							(3592178, '09/09/2021', 'ATIVA', 67676767, 6228),
							(7029315, '27/6/2018', 'ATIVA', 89898989, 5218),
							(1627390, '13/01/2020', 'ATIVA', 45678901, 6327),
							(4958012, '03/08/2017', 'ATIVA', 90123456, 6118),
							(8247691, '24/04/2016', 'ATIVA', 23456789, 6117),
							(2963148, '18/12/2021', 'ATIVA', 56789012, 4117),
							(6750983, '06/02/2023', 'ATIVA', 89012345, 5227),
							(8440986, '04/01/2023', 'ATIVA', 12345678, 6227),
							(9306417, '28/09/2016', 'ATIVA', 78901234, 6118),
							(4079652, '11/06/2022', 'ATIVA', 43210987, 5117),
							(2384917, '31/03/2023', 'ATIVA', 87654321, 5327),
							(7946820, '15/01/2019', 'ATIVA', 10987654, 6118),
							(5230764, '02/10/2020', 'ATIVA', 54321987, 6117),
							(1862957, '14/07/2017', 'ATIVA', 98765432, 6227),
							(6592471, '08/04/2022', 'ATIVA', 32109876, 6118),
							(4703285, '23/11/2019', 'ATIVA', 76543210, 6318),
							(5234076, '11/11/2021', 'ATIVA', 23456789, 4318),
							(2869751, '23/04/2017', 'ATIVA', 67890123, 5218),
							(6542791, '10/05/2016', 'ATIVA', 34567890, 4317),
							(4370825, '03/08/2018', 'ATIVA', 78901234, 6228);
							
INSERT INTO matricula VALUES (2654134, '03/02/2020', 'CANCELADA', 36528790, 005127),
							(3409123, '18/04/2020', 'CANCELADA', 56782351, 005118),
							(2873564, '09/05/2022', 'CANCELADA', 4567123, 004317),
							(3227865, '02/03/2022', 'TRANSFERIDA', 11109787, 06118);

-- Tabela Pagamento 

SELECT * FROM PAGAMENTO 

-- 3° Mês do trimestrre 
INSERT INTO PAGAMENTO VALUES (1278,	'QUITADO',	'15/04/2023',	440.00,	'Débito',	'9832174'),
							(5489,	'QUITADO',	'15/04/2023',	660.00,	'Crédito',	'5428769'),
							(9031,	'QUITADO',	'15/04/2023',	420.00,	'Boleto',	'7258391'),
							(6524,	'QUITADO',	'15/04/2023',	220.00,	'PIX',	'6104785'),
							(4167,	'RECUSADO',	'15/04/2023',	260.00,	'Crédito',	'3972168'),
							(8390,	'QUITADO',	'15/04/2023',	460.00,	'PIX',	'8547320'),
							(2753,	'QUITADO',	'15/04/2023',	240.00,	'Débito',	'1692534'),
							(7312,	'QUITADO',	'15/04/2023',	640.00,	'Boleto',	'4268937'),
							(5893,	'RECUSADO',	'15/04/2023',	620.00,	'PIX',	'7315462'),
							(3426,	'QUITADO',	'15/04/2023',	240.00,	'Débito',	5483791),
							(6904,	'QUITADO',	'15/04/2023',	620.00,	'Boleto',	1269045),
							(1759,	'QUITADO',	'15/04/2023',	440.00,	'Crédito',	3972854),
							(4382,	'QUITADO',	'15/04/2023',	460.00,	'PIX',	6187504),
							(8210,	'QUITADO',	'15/04/2023',	660.00,	'Débito',	4726938),
							(3647,	'QUITADO',	'15/04/2023',	220.00,	'Boleto',	8659143),
							(9078,	'QUITADO',	'15/04/2023',	260.00,	'Crédito',	3450192),
							(5261,	'QUITADO',	'15/04/2023',	640.00,	'PIX',	5201348),
							(6943,	'QUITADO',	'15/04/2023',	420.00,	'Boleto',	9146825),
							(2570,	'QUITADO',	'15/04/2023',	240.00,	'Débito',	2639054),
							(8102,	'QUITADO',	'15/04/2023',	620.00,	'PIX',	8743506),
							(6437,	'QUITADO',	'15/04/2023',	440.00,	'Crédito',	6394218),
							(9826,	'QUITADO',	'15/04/2023',	660.00,	'Débito',	3059286),
							(3169,	'QUITADO',	'15/04/2023',	460.00,	'Boleto',	7532184),
							(7542,	'QUITADO',	'15/04/2023',	220.00,	'Crédito',	4823069),
							(4085,	'QUITADO',	'15/04/2023',	640.00,	'PIX',	1974635),
							(5934,	'QUITADO',	'15/04/2023',	420.00,	'Boleto',	5389721),
							(2716,	'QUITADO',	'15/04/2023',	260.00,	'Crédito',	4208563),
							(8604,	'QUITADO',	'15/04/2023',	240.00,	'Débito',	7384195),
							(5247,	'QUITADO',	'15/04/2023',	440.00,	'PIX',	5146209),
							(3891,	'RECUSADO',	'15/04/2023',	660.00,	'Boleto',	8465702),
							(7364,	'QUITADO',	'15/04/2023',	620.00,	'Débito',	3592178),
							(1682,	'QUITADO',	'15/04/2023',	460.00,	'Crédito',	7029315),
							(9407,	'QUITADO',	'15/04/2023',	220.00,	'PIX',	1627390),
							(6251,	'QUITADO',	'15/04/2023',	420.00,	'Boleto',	4958012),
							(4837,	'QUITADO',	'15/04/2023',	640.00,	'Débito',	8247691),
							(2794,	'QUITADO',	'15/04/2023',	660.00,	'PIX',	2963148),
							(6153,	'QUITADO',	'15/04/2023',	240.00,	'Crédito',	6750983),
							(9720,	'QUITADO',	'15/04/2023',	260.00,	'Boleto',	8440986),
							(3405,	'QUITADO',	'15/04/2023',	440.00,	'Débito',	9306417),
							(7928,	'QUITADO',	'15/04/2023',	620.00,	'PIX',	4079652),
							(4563,	'QUITADO',	'15/04/2023',	460.00,	'Crédito',	2384917),
							(8176,	'QUITADO',	'15/04/2023',	220.00,	'Débito',	7946820),
							(5396,	'RECUSADO',	'15/04/2023',	640.00,	'Boleto',	5230764),
							(2974,	'QUITADO',	'15/04/2023',	420.00,	'PIX',	1862957),
							(8640,	'QUITADO',	'15/04/2023',	660.00,	'Débito',	6592471),
							(1235,	'QUITADO',	'15/04/2023',	240.00,	'Crédito',	4703285),
							(8719,	'RECUSADO',	'15/04/2023',	440.00,	'Boleto',	5234076),
							(4297,	'QUITADO',	'15/04/2023',	620.00,	'PIX',	2869751),
							(7854,	'RECUSADO',	'15/04/2023',	260.00,	'Débito',	6542791),
							(3519,	'QUITADO',	'15/04/2023',	460.00,	'Crédito',	4370825);

-- 2° Mês do trimestre
INSERT INTO Pagamento VALUES (7398,	'QUITADO',	'15/03/2023',	440.00,	'Débito',	9832174),
							(5021, 'QUITADO', '15/03/2023', 460.00, 'Boleto', 5428769),
							(8643, 'RECUSADO', '15/03/2023', 420.00, 'PIX', 7258391),
							(1579, 'QUITADO', '15/03/2023', 220.00, 'Crédito', 6104785),
							(6214, 'QUITADO', '15/03/2023', 260.00, 'PIX', 3972168),
							(3856, 'QUITADO', '15/03/2023', 460.00, 'Débito', 8547320),
							(9642, 'QUITADO', '15/03/2023', 240.00, 'Crédito', 1692534),
							(2187, 'RECUSADO', '15/03/2023', 640.00, 'Boleto', 4268937),
							(7034, 'QUITADO', '15/03/2023', 620.00, 'PIX', 7315462),
							(4265, 'QUITADO', '15/03/2023', 240.00, 'Crédito', 5483791),
							(1897, 'QUITADO', '15/03/2023', 620.00, 'Débito', 1269045),
							(5463, 'QUITADO', '15/03/2023', 440.00, 'Boleto', 3972854),
							(9821, 'QUITADO', '15/03/2023', 460.00, 'PIX', 6187504),
							(3076, 'QUITADO', '15/03/2023', 660.00, 'Débito', 4726938),
							(8654, 'QUITADO', '15/03/2023', 220.00, 'Boleto', 8659143),
							(2307, 'RECUSADO', '15/03/2023', 260.00, 'PIX', 3450192),
							(4169, 'QUITADO', '15/03/2023', 640.00, 'Débito', 5201348),
							(7984, 'QUITADO', '15/03/2023', 420.00, 'Crédito', 9146825),
							(3541, 'QUITADO', '15/03/2023', 240.00, 'Boleto', 2639054),
							(6729, 'QUITADO', '15/03/2023', 620.00, 'Débito', 8743506),
							(4083, 'QUITADO', '15/03/2023', 440.00, 'PIX', 6394218),
							(9257, 'QUITADO', '15/03/2023', 660.00, 'Crédito', 3059286),
							(5130, 'QUITADO', '15/03/2023', 460.00, 'Boleto', 7532184),
							(7609, 'QUITADO', '15/03/2023', 220.00, 'PIX', 4823069),
							(3915, 'QUITADO', '15/03/2023', 640.00, 'Débito', 1974635),
							(6479, 'QUITADO', '15/03/2023', 420.00, 'Boleto', 5389721),
							(8216, 'QUITADO', '15/03/2023', 260.00, 'Crédito', 4208563),
							(1954, 'QUITADO', '15/03/2023', 240.00, 'PIX', 7384195),
							(5763, 'QUITADO', '15/03/2023', 440.00, 'Boleto', 5146209),
							(9240, 'RECUSADO', '15/03/2023', 660.00, 'Débito', 8465702),
							(6703, 'QUITADO', '15/03/2023', 620.00, 'Crédito', 3592178),
							(4327, 'QUITADO', '15/03/2023', 460.00, 'PIX', 7029315),
							(9872, 'QUITADO', '15/03/2023', 220.00, 'Boleto', 1627390),
							(3018, 'QUITADO', '15/03/2023', 420.00, 'Débito', 4958012),
							(7421, 'QUITADO', '15/03/2023', 640.00, 'PIX', 8247691),
							(1694, 'QUITADO', '15/03/2023', 660.00, 'Crédito', 2963148),
							(3859, 'QUITADO', '15/03/2023', 240.00, 'Débito', 6750983),
							(5276, 'QUITADO', '15/03/2023', 260.00, 'Boleto', 8440986),
							(8407, 'RECUSADO', '15/03/2023', 440.00, 'Crédito', 9306417),
							(1635, 'QUITADO', '15/03/2023', 620.00, 'PIX', 4079652),
							(5192, 'QUITADO', '15/03/2023', 460.00, 'Débito', 2384917),
							(9386, 'QUITADO', '15/03/2023', 220.00, 'Boleto', 7946820),
							(2750, 'QUITADO', '15/03/2023', 640.00, 'Crédito', 5230764),
							(4562, 'QUITADO', '15/03/2023', 420.00, 'PIX', 1862957),
							(7135, 'QUITADO', '15/03/2023', 460.00, 'Débito', 6592471),
							(8904, 'QUITADO', '15/03/2023', 240.00, 'Crédito', 4703285),
							(3468, 'RECUSADO', '15/03/2023', 440.00, 'PIX', 5234076),
							(6910, 'QUITADO', '15/03/2023', 620.00, 'Boleto', 2869751),
							(8274, 'QUITADO', '15/03/2023', 260.00, 'Débito', 6542791),
							(2045, 'QUITADO', '15/03/2023', 260.00, 'PIX', 4370825),
							(5674, 'QUITADO', '15/03/2023', 260.00, 'Crédito', 2654134),
							(7761, 'QUITADO', '15/03/2023', 220.00, 'Boleto', 3409123);

-- 1° Mês do trimestre
INSERT INTO Pagamento VALUES (5874,	'QUITADO',	'15/02/2023',	420.00,	'Crédito',	9832174),
							(7333, 'QUITADO', '15/03/2023', 440.00, 'Débito', 9832174),
							(9241, 'QUITADO', '15/02/2023', 260.00, 'Boleto', 5428769),
							(3168, 'RECUSADO', '15/02/2023', 420.00, 'PIX', 7258391),
							(7530, 'QUITADO', '15/02/2023', 220.00, 'Débito', 6104785),
							(6829, 'QUITADO', '15/02/2023', 260.00, 'Crédito', 3972168),
							(1093, 'QUITADO', '15/02/2023', 440.00, 'PIX', 8547320),
							(4057, 'RECUSADO', '15/02/2023', 240.00, 'Boleto', 1692534),
							(8312, 'QUITADO', '15/02/2023', 640.00, 'Débito', 4268937),
							(2467, 'QUITADO', '15/02/2023', 620.00, 'Crédito', 7315462),
							(5891, 'QUITADO', '15/02/2023', 240.00, 'PIX', 5483791),
							(7238, 'QUITADO', '15/02/2023', 620.00, 'Débito', 1269045),
							(4316, 'RECUSADO', '15/02/2023', 440.00, 'Boleto', 3972854),
							(8962, 'QUITADO', '15/02/2023', 420.00, 'Crédito', 6187504),
							(2703, 'QUITADO', '15/02/2023', 460.00, 'PIX', 4726938),
							(6418, 'QUITADO', '15/02/2023', 220.00, 'Débito', 8659143),
							(3752, 'QUITADO', '15/02/2023', 260.00, 'Boleto', 3450192),
							(9514, 'QUITADO', '15/02/2023', 640.00, 'Crédito', 5201348),
							(1247, 'QUITADO', '15/02/2023', 420.00, 'PIX', 9146825),
							(8666, 'QUITADO', '15/02/2023', 240.00, 'Boleto', 2639054),
							(5391, 'RECUSADO', '15/02/2023', 220.00, 'Débito', 8743506),
							(2176, 'QUITADO', '15/02/2023', 440.00, 'Crédito', 6394218),
							(7840, 'QUITADO', '15/02/2023', 660.00, 'PIX', 3059286),
							(3956, 'QUITADO', '15/02/2023', 460.00, 'Débito', 7532184),
							(6189, 'QUITADO', '15/02/2023', 220.00, 'Boleto', 4823069),
							(4723, 'QUITADO', '15/02/2023', 640.00, 'Crédito', 1974635),
							(8065, 'QUITADO', '15/02/2023', 420.00, 'Débito', 5389721),
							(1369, 'QUITADO', '15/02/2023', 260.00, 'PIX', 4208563),
							(5802, 'QUITADO', '15/02/2023', 240.00, 'Boleto', 7384195),
							(9513, 'QUITADO', '15/02/2023', 440.00, 'Crédito', 5146209),
							(3679, 'QUITADO', '15/02/2023', 460.00, 'PIX', 8465702),
							(5201, 'QUITADO', '15/02/2023', 620.00, 'Débito', 3592178),
							(1748, 'QUITADO', '15/02/2023', 460.00, 'Boleto', 7029315),
							(6092, 'QUITADO', '15/02/2023', 220.00, 'PIX', 1627390),
							(3520, 'RECUSADO', '15/02/2023', 420.00, 'Crédito', 4958012),
							(7283, 'QUITADO', '15/02/2023', 640.00, 'Débito', 8247691),
							(9467, 'QUITADO', '15/02/2023', 660.00, 'Boleto', 2963148),
							(4032, 'QUITADO', '15/02/2023', 240.00, 'PIX', 6750983),
							(8174, 'QUITADO', '15/02/2023', 260.00, 'Débito', 8440986),
							(2596, 'QUITADO', '15/02/2023', 440.00, 'Crédito', 9306417),
							(6718, 'QUITADO', '15/02/2023', 620.00, 'Boleto', 4079652),
							(9834, 'QUITADO', '15/02/2023', 260.00, 'PIX', 2384917),
							(5061, 'QUITADO', '15/02/2023', 220.00, 'Débito', 7946820),
							(2417, 'RECUSADO', '15/02/2023', 640.00, 'Crédito', 5230764),
							(6948, 'QUITADO', '15/02/2023', 420.00, 'PIX', 1862957),
							(1387, 'QUITADO', '15/02/2023', 660.00, 'Boleto', 6592471),
							(8710, 'QUITADO', '15/02/2023', 240.00, 'Débito', 4703285),
							(3145, 'QUITADO', '15/02/2023', 440.00, 'Crédito', 5234076),
							(7629, 'QUITADO', '15/02/2023', 420.00, 'PIX', 2869751),
							(4285, 'QUITADO', '15/02/2023', 260.00, 'Boleto', 6542791),
							(8903, 'QUITADO', '15/02/2023', 220.00, 'Débito', 4370825),
							(2056, 'RECUSADO', '15/02/2023', 260.00, 'PIX', 2654134),
							(5490, 'QUITADO', '15/02/2023', 220.00, 'Crédito', 3409123),
							(9888, 'QUITADO', '15/02/2023', 420.00, 'Boleto', 2873564),
							(6735, 'QUITADO', '15/02/2023', 220.00, 'Débito', 3227865);
							
-- Tabela Frequencia

SELECT * from frequencia

-- pergunatr pra prof se tem que mostrar o insert 


-- TABELA ATIVIDADE(Precisa de boletim)

SELECT* FROM ATIVIDADE

INSERT INTO Atividade VALUES (5739,	7.3,	'01/02/23',	12345678);

INSERT INTO Atividade VALUES(8024, 8.6, '01/02/23', 98765432),
							(9167, 6.8, '02/02/23', 55551234),
							(2485, 9.1, '02/02/23', 99998888),
							(6791, 6.5, '03/02/23', 24681357),
							(1358, 7.8, '03/02/23', 75319864),
							(4927, 9.3, '04/02/23', 87654321),
							(7163, 6.7, '06/02/23', 11223344),
							(3640, 8.4, '06/02/23', 56789012),
							(5982, 9.7, '08/02/23', 65432109),
							(4296, 7.9, '09/02/23', 78901234),
							(7510, 8.2, '10/02/23', 98565432),
							(874, 6.9, '10/02/23', 54321987),
							(6235, 9.5, '13/02/23', 13572468),
							(9481, 7.6, '15/02/23', 86421357),
							(3179, 8.9, '15/02/23', 19875432),
							(5864, 6.6, '16/02/23', 90123456),
							(2047, 9.4, '18/02/23', 33333333),
							(9678, 8.3, '18/02/23', 44444444),
							(7409, 7.3, '18/02/23', 77777777),
							(1523, 6.4, '18/02/23', 22222222),
							(8685, 9.2, '20/02/23', 66666666),
							(3956, 6.3, '22/02/23', 88888888),
							(6217, 7.5, '24/02/23', 99999999),
							(7436, 9.8, '27/02/23', 12121212),
							(9583, 8.8, '01/03/23', 34343434),
							(2961, 6.2, '02/03/23', 56565656),
							(5087, 7.1, '04/03/23', 78787878),
							(6392, 9.6, '06/03/23', 23232323),
							(4251, 8.5, '08/03/23', 45454545),
							(1740, 6.1, '09/03/23', 67676767),
							(6028, 7.7, '09/03/23', 89898989),
							(8793, 8.1, '09/03/23', 45678901),
							(1374, 9.9, '13/03/23', 97123456),
							(9530, 6.0, '15/03/23', 23456789),
							(3651, 8.7, '15/03/23', 56789712),
							(7182, 7.4, '17/03/23', 89012345),
							(2084, 9.0, '20/03/23', 12345698),
							(5427, 6.8, '22/03/23', 78921234),
							(9861, 7.9, '22/03/23', 43210987),
							(7342, 9.3, '24/03/23', 87654331),
							(6290, 6.7, '24/03/23', 10987654),
							(587, 8.4, '27/03/23', 54321887),
							(4863, 9.7, '27/03/23', 98765442),
							(1764, 7.8, '29/03/23', 32109876),
							(9253, 8.2, '31/03/23', 76543210),
							(3748, 6.9, '31/03/23', 23756789),
							(6827, 9.5, '03/04/23', 67890123),
							(2978, 7.6, '03/04/23', 34567890),
							(5406, 8.9, '06/04/23', 78001234);
							
-- Tabela Boletim

SELECT * FROM boletim

INSERT INTO boletim VALUES (9234567,	7,	8.7,	530,	12345678,	5739,	6317);

INSERT INTO boletim VALUES (2545678, 4.5, 6, 591, 98765432, 8024, 4328),
							(3456789, 8.6, 3, 567, 55551234, 9167, 5127),
							(4567890, 7.3, 9, 554, 99998888, 2485, 6117),
							(5678901, 6.5, 7.5, 566, 24681357, 6791, 4228),
							(6789012, 9.5, 9.6, 594, 75319864, 1358, 5228),
							(7890123, 8.5, 8.2, 590, 87654321, 4927, 5317),
							(8901234, 4.6, 5.5, 558, 11223344, 7163, 6127),
							(9012345, 7.3, 6.3, 542, 56789012, 3640, 6218),
							(7123456, 6.1, 5.5, 569, 65432109, 5982, 6118),
							(9888543, 8.6, 4.6, 504, 78901234, 4296, 6318);
							
INSERT INTO boletim VALUES	(8765432, 4.5, 9.3, 518, 98565432, 7510, 4318),
							(7650001, 5.3, 7.7, 545, 54321987, 874, 5218),
							(6500010, 6.9, 6, 570, 13572468, 6235, 6328),
							(5432109, 6.7, 4.5, 523, 86421357, 9481, 5227),
							(4321098, 8.3, 1.2, 555, 19875432, 3179, 4218),
							(3210987, 4.6, 8.1, 596, 90123456, 5864, 4317),
							(2109876, 8.2, 9.3, 578, 33333333, 2047, 4327),
							(1098765, 7.3, 4.6, 562, 44444444, 9678, 6128);
							
INSERT INTO boletim VALUES	(9870654, 7.5, 7.5, 572, 77777777, 7409, 5328),
							(9876543, 9.3, 2.3, 553, 22222222, 1523, 5228),
							(8700432, 6.8, 8.8, 574, 66666666, 8685, 6217),
							(7654321, 3.6, 6.6, 577, 88888888, 3956, 5318),
							(6543210, 9.5, 9.9, 564, 99999999, 6217, 5128),
							(5432999, 8.3, 7.7, 581, 12121212, 7436, 6118),
							(6392057, 4.3, 1.2, 586, 34343434, 9583, 4117),
							(8927436, 4.5, 6.6, 550, 56565656, 2961, 6327),
							(5068124, 6.1, 6, 573, 78787878, 5087, 4227),
							(3214978, 5.2, 3.5, 536, 23232323, 6392, 4118),
							(7489032, 7, 9, 599, 45454545, 4251, 4327);
							
INSERT INTO boletim VALUES	(1652379, 4.3, 0.3, 587, 67676767, 1740, 6217),
							(9836412, 4.9, 10, 560, 89898989, 6028, 4127),
							(4275986, 7.6, 9, 500, 45678901, 8793, 6317),
							(7103582, 4.3, 8.6, 540, 97123456, 1374, 6117),
							(8549163, 9.5, 5.5, 579, 23456789, 9530, 5227),
							(2394875, 8.8, 6, 593, 56789712, 3651, 4118),
							(6758091, 6, 4.6, 514, 89012345, 7182, 4218),
							(1047382, 3.9, 6.5, 539, 12345698, 2084, 5318),
							(5826937, 8.4, 10, 565, 78921234, 5427, 4128),
							(3764509, 5.2, 9.5, 592, 43210987, 9861, 5117),
							(9215843, 9.6, 5.8, 525, 87654331, 7342, 6127);
							
INSERT INTO boletim VALUES	(4580762, 7.5, 6.3, 502, 10987654, 6290, 5228),
							(7039156, 8.8, 4.5, 505, 54321887, 587, 6318),
							(2906137, 6.6, 7.7, 588, 98765442, 4863, 5327),
							(8351742, 7.7, 6.5, 559, 32109876, 1764, 4317),
							(5642908, 7.4, 10, 534, 76543210, 9253, 6128),
							(1987256, 7.3, 9.6, 552, 23756789, 3748, 5328),
							(7536409, 8.3, 8.8, 580, 67890123, 6827, 5127),
							(4218763, 6.2, 5.5, 522, 34567890, 2978, 4117),
							(6079482, 4.6, 9.3, 548, 78001234, 5406, 4217);
							
--Tipo avalia

SELECT * FROM TIPO_Avalia 

Insert into tipo_avalia VALUES ('1111111-1',	1,	1,	2,	2,	837490,	12345678,	5327);

Insert into tipo_avalia VALUES('2222222-2', 1, 3, 5, 5, 562831, 98765432, 5218),
								('3333333-3', 2, 4, 4, 4, 194257, 55551234, 6217),
								('4444444-4', 2, 2, 3, 3, 675408, 99998888, 6218),
								('5555555-5', 1, 5, 1, 1, 320976, 24681357, 4127),
								('6666666-6', 2, 1, 2, 2, 901543, 75319864, 5318),
								('7777777-7', 1, 3, 1, 1, 486209, 87654321, 5217),
								('8888888-8', 2, 1, 3, 2, 725164, 11223344, 5227),
								('9999999-9', 1, 2, 5, 5, 368502, 56789012, 6228),
								('0111111-4', 1, 5, 4, 4, 587401, 65432109, 4317),
								('1111171-2', 1, 4, 2, 3, 213679, 78901234, 4318),
								('2222222-3', 1, 3, 1, 1, 894316, 98765432, 6327),
								('3333333-4', 2, 1, 3, 2, 156207, 54321987, 4128),
								('4444444-5', 2, 2, 4, 4, 439682, 13572468, 5117),
								('5555555-6', 2, 5, 2, 3, 706921, 86421357, 5127),
								('6666666-7', 1, 4, 5, 1, 928463, 19875432, 4318);

Insert into tipo_avalia VALUES ('7777777-8', 2, 3, 1, 2, 315790, 90123456, 6318),
								('8888888-9', 1, 1, 3, 5, 640187, 33333333, 5217),
								('9999999-0', 1, 2, 1, 4, 187543, 44444444, 4327),
								('000001-1', 1, 1, 2, 4, 572819, 77777777, 5227),
								('111111-3', 2, 3, 5, 2, 349706, 22222222, 5228),
								('2222222-4', 2, 5, 4, 5, 891654, 66666666, 6217),
								('3333333-5', 1, 4, 3, 1, 206845, 88888888, 6328),
								('4444444-6', 2, 2, 1, 3, 473190, 99999999, 4317),
								('5555555-7', 1, 1, 2, 1, 819327, 12121212, 4318),
								('6666666-8', 1, 3, 5, 2, 837490, 34343434, 4327),
								('7777777-9', 1, 4, 4, 5, 562831, 56565656, 5128),
								('8888888-0', 2, 2, 3, 2, 194257, 78787878, 5227),
								('9999999-1', 2, 5, 1, 5, 675408, 23232323, 4318),
								('000002-2', 2, 1, 2, 1, 320976, 45454545, 5218),
								('1111111-4', 1, 3, 1, 3, 901543, 67676767, 4317),
								('2222222-5', 1, 1, 3, 4, 486209, 89898989, 6218),
								('3333333-6', 2, 2, 5, 2, 725164, 45678901, 5218),
								('4444444-7', 1, 5, 4, 5, 368502, 90123456, 6327),
								('5555555-8', 1, 4, 2, 5, 587401, 23456789, 6118),
								('6666666-9', 2, 3, 1, 4, 213679, 56789012, 6117),
								('7777777-0', 2, 1, 3, 3, 894316, 89012345, 4117);

Insert into tipo_avalia VALUES ('8888888-1', 1, 2, 4, 5, 156207, 12345678, 5227),
								('9999999-2', 1, 5, 2, 4, 439682, 78901234, 5217),
								('000003-3', 1, 4, 5, 2, 706921, 43210987, 5127),
								('1111111-5', 1, 3, 1, 1, 928463, 87654321, 5317),
								('2222222-6', 2, 1, 3, 3, 315790, 10987654, 6118),
								('3333333-7', 2, 2, 1, 4, 640187, 54321987, 6117),
								('4444444-8', 2, 1, 1, 2, 187543, 98765432, 6227),
								('5555555-9', 1, 3, 3, 5, 572819, 32109876, 6118),
								('000000-6', 1, 5, 4, 1, 349706, 76543210, 6328),
								('7777777-1', 2, 4, 2, 3, 891654, 23456789, 5128),
								('8888888-2', 1, 2, 5, 1, 206845, 67890123, 4317),
								('9999999-3', 1, 1, 1, 3, 473190, 34567890, 6228),
								('000004-4', 2, 3, 3, 1, 819327, 78901234, 4127),
								('1111111-6', 1, 4, 1, 2, 837490, 12345678, 5327),
								('2222222-7', 1, 2, 2, 5, 562831, 98765432, 5218),
								('3333333-8', 1, 5, 5, 4, 194257, 55551234, 6217),
								('4444444-9', 2, 1, 4, 3, 675408, 99998888, 6218),
								('5555555-0', 2, 3, 3, 1, 320976, 24681357, 4127),
								('6666666-1', 1, 1, 1, 2, 901543, 75319864, 5318),
								('7777777-2', 2, 2, 2, 4, 486209, 87654321, 5217),
								('8888888-3', 1, 5, 5, 3, 725164, 11223344, 5227),
								('9999999-4', 2, 4, 4, 1, 368502, 56789012, 6228),
								('000005-5', 1, 3, 3, 2, 587401, 65432109, 4317),
								('1111111-7', 1, 1, 1, 1, 213679, 78901234, 4318);
								
Insert into tipo_avalia VALUES ('2220952-8', 1, 2, 2, 3, 894316, 98765432, 6327),
								('3301235-9', 2, 5, 1, 5, 156207, 54321987, 4128),
								('4440190-0', 2, 4, 3, 1, 439682, 13572468, 5117),
								('5093550-1', 2, 3, 5, 3, 706921, 86421357, 5127),
								('6091669-2', 2, 1, 4, 1, 928463, 19875432, 4318),
								('1739077-3', 1, 2, 2, 2, 315790, 90123456, 6318),
								('8903888-4', 2, 1, 1, 5, 640187, 33333333, 5217),
								('9999039-5', 1, 3, 3, 4, 187543, 44444444, 4327),
								('0398006-6', 1, 5, 4, 3, 572819, 77777777, 5227);
								
Insert into tipo_avalia VALUES	('1136411-8', 1, 4, 2, 3, 349706, 22222222, 5228),
								('2294822-9', 2, 5, 5, 5, 891654, 66666666, 6217),
								('3338533-0', 1, 1, 4, 5, 206845, 88888888, 6328),
								('4496344-1', 2, 5, 2, 2, 473190, 99999999, 4317),
								('5598535-2', 2, 5, 5, 5, 819327, 12121212, 4318),
								('6696446-3', 1, 2, 1, 1, 837490, 34343434, 4327),
								('9230777-4', 1, 3, 3, 4, 562831, 56565656, 5128),
								('8880381-5', 1, 5, 5, 2, 194257, 78787878, 5227),
								('9029019-6', 2, 5, 5, 5, 675408, 23232323, 5318);
								
								('000007-7', 2, 2, 3, 4, 320976, 45454545, 5218),
								('1111111-9', 1, 3, 5, 4, 901543, 67676767, 4317),
								('2222222-0', 1, 1, 2, 5, 486209, 89898989, 6218),
								('3333333-1', 2, 2, 4, 3, 725164, 45678901, 5218),
								('4444444-2', 1, 5, 1, 4, 368502, 90123456, 6327),
								('5555555-3', 1, 4, 3, 3, 587401, 23456789, 6118),
								('6666666-4', 2, 3, 1, 2, 213679, 56789012, 6117),
								('7777777-5', 2, 1, 3, 1, 894316, 89012345, 4117),
								('8888888-6', 1, 2, 4, 4, 156207, 12345678, 5227),
								('9999999-7', 1, 5, 2, 3, 439682, 78901234, 5217),
								('000008-8', 1, 4, 5, 5, 706921, 43210987, 5127),
								('1111111-0', 1, 3, 1, 1, 928463, 87654321, 5317);
								
--Insert into tipo_avalia VALUES ('2222222-1', 2, 1, 3, 3, 315790, 10987654, 6118),
								('3333333-2', 2, 2, 1, 4, 640187, 54321987, 6117),
								('4444444-3', 2, 1, 1, 2, 187543, 98765432, 6227),
								('5555555-4', 1, 3, 3, 5, 572819, 32109876, 6118),
								('6666666-5', 1, 5, 4, 1, 349706, 76543210, 6328),
								('7777777-6', 2, 4, 2, 3, 891654, 23456789, 5128),
								('8888888-7', 1, 2, 5, 1, 206845, 67890123, 4317),
								('9999999-8', 1, 1, 1, 3, 473190, 34567890, 6228),
								('000009-9', 2, 3, 3, 1, 819327, 78901234, 4127),
								('119111-8', 1, 4, 1, 2, 837490, 12345678, 5327),
								('2222999-2', 1, 2, 2, 5, 562831, 98765432, 5218),
								('3333333-3', 1, 5, 5, 4, 194257, 55551234, 6217),
								('4444444-4', 2, 1, 4, 3, 675408, 99998888, 6218),
								('5555555-5', 2, 3, 3, 1, 320976, 24681357, 4127),
								('6666666-6', 1, 1, 1, 2, 901543, 75319864, 5318),
								('7777777-7', 2, 2, 2, 4, 486209, 87654321, 5217),
								('8888888-8', 1, 5, 5, 3, 725164, 11223344, 5227),
								('9999999-9', 2, 4, 4, 1, 368502, 56789012, 6228),
								('000000-0', 1, 3, 3, 2, 587401, 65432109, 4317),
								('1111111-2', 1, 1, 1, 1, 213679, 78901234, 4318),
								('2222222-3', 1, 2, 2, 3, 894316, 98765432, 6327),
								('3333333-4', 1, 5, 1, 5, 156207, 54321987, 4128),
								('4444444-5', 2, 4, 3, 1, 439682, 13572468, 5117),
								('5555555-6', 2, 3, 5, 3, 706921, 86421357, 5127),
								('6666666-7', 2, 1, 4, 1, 928463, 19875432, 4318),
								('7777777-8', 1, 2, 2, 2, 315790, 90123456, 6318),
								('8888888-9', 2, 1, 1, 5, 640187, 33333333, 5217),
								('9999999-0', 1, 3, 3, 4, 187543, 44444444, 4327),
								('000001-1', 1, 5, 4, 3, 572819, 77777777, 5227),
								('1111111-2', 1, 4, 2, 3, 349706, 22222222, 5228),
								('2222222-3', 2, 2, 5, 1, 891654, 66666666, 6217),
								('3333333-4', 1, 1, 4, 5, 206845, 88888888, 6328),
								('4444444-5', 2, 5, 2, 2, 473190, 99999999, 4317),
								('5555555-6', 2, 4, 4, 5, 819327, 12121212, 4318),
								('6666666-7', 1, 2, 1, 1, 837490, 34343434, 4327),
								('7777777-8', 1, 3, 3, 4, 562831, 56565656, 5128),
								('8888888-9', 1, 5, 5, 2, 194257, 78787878, 5227),
								('9999999-0', 2, 4, 1, 5, 675408, 23232323, 4318),
								('000002-2', 2, 2, 3, 4, 320976, 45454545, 5218),
								('1111111-3', 1, 3, 5, 4, 901543, 67676767, 4317),
								('2222222-4', 1, 1, 2, 5, 486209, 89898989, 6218);
								
------------------------------------- CONSULTAS NO BANCO DE DADOS ECC ----------------------------------------------

/*Mostrar o nome dos professores que receberam nota maxima na avaliação no dominio de materia em espanhol Business
e em qual nivel recebeu a avaliação*/


SELECT tp.tipo_avalia,tp.dominio_da_materia, i.descricao_idioma,i.tipo_nivel,i.nivel,p.cod_prof,p.nome_prof
FROM Tipo_avalia tp JOIN idioma i ON (tp.id_idioma = i.id_idioma)
					JOIN professor p ON (tp.cod_professor = p.cod_prof) 
WHERE UPPER (dominio_da_materia) = '5' AND 
UPPER (tp.tipo_avalia) ='2'  AND
UPPER (tp.id_idioma) LIKE '5%8'
ORDER BY p.nome_prof;

/*Mostrar o nome dos professores que receberam nota maxima em todos os aspectos da avaliação, 
mostrando o nivel,tipo e idioma em que recebeu a avaliação*/

SELECT tp.tipo_avalia,tp.dominio_da_materia,tp.desempenho,tp.pontualidade, i.descricao_idioma,i.tipo_nivel,i.nivel,p.cod_prof,p.nome_prof
FROM Tipo_avalia tp JOIN idioma i ON (tp.id_idioma = i.id_idioma)
					JOIN professor p ON (tp.cod_professor = p.cod_prof) 
WHERE UPPER (dominio_da_materia) = '5' AND
UPPER (desempenho) = '5' AND  UPPER (pontualidade) = '5' AND
UPPER (tp.tipo_avalia) ='2'
ORDER BY p.nome_prof;

/* Mostrar os alunos aprovados, com media de P1,P2 + Atividades => 6 e frequencia => 0.30, 
repronota quando a a media das provas e atividades for <= 6, reprofalta, quando a frequencia for <= 0.30*/

Select * From Atividade
Select * From boletim
ALter table boletim add media_final float 
ALTER TABLE boletim ADD resultado CHAR(15)

 
Select b.ra AS Aluno, ROUND( CAST (AVG(((b.nota_P1+ b.nota_P2)/2) + (at.nota_atv/10)) AS NUMERIC), 2) AS  media_final
  from boletim b 
  JOIN atividade at ON (b.RA = at.RA)
 Group by b.ra ;

update boletim set media_final =9.88 where ra = '78921234';
update boletim set media_final =6.48 where ra = '55551234';
update boletim set media_final =6.04 where ra = '89012345';
update boletim set media_final =6.76 where ra = '78787878';
update boletim set media_final =7.57 where ra = '10987654';
update boletim set media_final =5.72 where ra = '11223344';
update boletim set media_final =6.78 where ra = '44444444';
update boletim set media_final =6.44 where ra = '22222222';
update boletim set media_final =7.84 where ra = '78001234';
update boletim set media_final =8.98 where ra = '12121212';
update boletim set media_final =7.88 where ra = '32109876';
update boletim set media_final =6.77 where ra = '65432109';
update boletim set media_final =7.72 where ra = '98565432';
update boletim set media_final =7.64 where ra = '56789012';
update boletim set media_final =9.11 where ra = '45678901';
update boletim set media_final =6.36 where ra = '86421357';
update boletim set media_final =7.39 where ra = '78901234';
update boletim set media_final =5.64 where ra = '19875432';
update boletim set media_final =6.17 where ra = '56565656';
update boletim set media_final =7.65 where ra = '24681357';
update boletim set media_final =8.63 where ra = '87654331';
update boletim set media_final =9.50 where ra = '67890123';
update boletim set media_final =7.49 where ra = '54321887';
update boletim set media_final =10.00 where ra = '99999999';
update boletim set media_final =5.73 where ra = '88888888';
update boletim set media_final =7.40 where ra = '13572468';
update boletim set media_final =8.22 where ra = '89898989';
update boletim set media_final =7.19 where ra = '54321987';

update boletim set media_final =5.31 where ra = '23232323';
update boletim set media_final =7.44 where ra = '97123456';
update boletim set media_final =8.14 where ra = '43210987';
update boletim set media_final =9.06 where ra = '99998888';
update boletim set media_final =9.52 where ra = '76543210';
update boletim set media_final =6.10 where ra = '12345698';
update boletim set media_final =10.00 where ra = '75319864';
update boletim set media_final =7.01 where ra = '90123456';
update boletim set media_final =8.27 where ra = '56789712';
update boletim set media_final =8.72 where ra = '66666666';
update boletim set media_final =9.14 where ra = '23756789';
update boletim set media_final =8.12 where ra = '98765442';
update boletim set media_final =8.85 where ra = '45454545';
update boletim set media_final =8.58 where ra = '12345678';
update boletim set media_final =8.10 where ra = '23456789';
update boletim set media_final =9.28 where ra = '87654321';
update boletim set media_final =8.23 where ra = '77777777';
update boletim set media_final =3.63 where ra = '34343434';
update boletim set media_final =2.91 where ra = '67676767';
update boletim set media_final =6.61 where ra = '34567890';
update boletim set media_final =6.11 where ra = '98765432';
update boletim set media_final =9.69 where ra = '33333333';

-- Colocar Aprovado ou Reprovado de acordo com a nota

UPDATE boletim
 SET resultado = 'Reprovado'
   WHERE media_final < 6.0 

UPDATE boletim
 SET resultado = 'Aprovado'
   WHERE media_final >=  6.0 
  		 

-- Mostrar os alunos que tem reposições disponiveis, com nome e telefone do aluno para contato 

SELECT * FROM ALUNO
SELECT * FROM AULA 

Select a.nome_aluno,a.tel_aluno,au.situacao_aula,au.reposicao
FROM Aluno a JOIN Aula au ON a.ra = au.ra
WHERE situacao_aula = 'Falta'
AND TO_CHAR(au.reposicao, 'YYYY.MM.DD') >= TO_CHAR(current_date, 'YYYY.MM.DD')
ORDER BY a.nome_aluno;


