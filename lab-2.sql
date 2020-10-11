\c s283109

--1,2,3,4,5

--here we insert Vertabelo generated DDL with command: "\i /path/to/sklep_create.sql"

--1,2,3,4,5

--6
INSERT INTO producenci (nazwa_producenta, mail, telefon) 
VALUES ('A', 'A@gmail.com', '12353454'),
       ('B', 'B@gmail.com', '46798723'),
       ('C', 'C@gmail.com', '89745783'),
       ('D', 'D@gmail.com', '94897462'),
       ('E', 'E@gmail.com', '23576496'), 
       ('F', 'F@gmail.com', '34865732'),
       ('G', 'G@gmail.com', '53489345'),
       ('H', 'H@gmail.com', '42378444'),
       ('I', 'I@gmail.com', '69847324'),
       ('J', 'J@gmail.com', '25783468');
       
INSERT INTO produkty (nazwa_produktu, cena, id_producenta) 
VALUES ('Odkurzacz',          249.99,  6),
       ('Komputer',           4499.99, 1),
       ('Okulary',            499.00,  7),
       ('Myszka Komputerowa', 40.00,   9),
       ('Plecak',             85.75,   2), 
       ('Lampka Biurowa',     50.00,   10),
       ('Wieza stereo',       500.49,  5),
       ('Pralka',             799.99,  3),
       ('Baterie',            3.00,    4),
       ('Patelnia',           39.99,   8);
       
INSERT INTO zamowienia (data, ilosc_zamowien, id_producenta, id_produktu) 
VALUES ('2020-10-10', 101, 3,  8),
       ('2020-12-15', 401, 4,  9),
       ('2020-01-30', 56,  5,  7),
       ('2020-05-21', 12,  6,  1),
       ('2020-09-01', 97,  1,  2),
       ('2020-04-02', 24,  6,  1),
       ('2020-01-06', 65,  10, 6),
       ('2020-11-18', 23,  2,  5),
       ('2020-03-13', 1,   10, 6),
       ('2020-09-09', 2,   2,  5),
       ('2020-01-14', 3,   2,  5),
       ('2020-12-25', 6,   6,  1),
       ('2020-08-30', 31,  7,  3),
       ('2020-03-18', 76,  1,  2),
       ('2020-06-26', 4,   8,  10),
       ('2020-01-11', 47,  5,  7),
       ('2020-05-18', 8,   9,  4),
       ('2020-09-02', 24,  1,  2),
       ('2020-07-07', 5,   9,  4),
       ('2020-08-08', 57,  8,  10);
--6

--7,8,9,10

--su - postgres
--pg_dump s283109 > s283109.bak
--dropdb s283109
--createdb backups283109
--psql backups283109 < s283109.bak
--psql
--\l
--ALTER DATABASE "backups283109" RENAME TO "s283109";

--7,8,9,10

--11
	--a)
	SELECT 'Producent: '||nazwa_producenta||', liczba zamowien: '||ilosc_zamowien||', wartosc_zamowienia: '||(ilosc_zamowien*cena) 
	AS raport FROM zamowienia
	INNER JOIN produkty ON produkty.id_produktu=zamowienia.id_produktu
	INNER JOIN producenci ON producenci.id_producenta=zamowienia.id_producenta;
	--a)
	
	--b)
	SELECT 'Produkt: '||nazwa_produktu||', liczba zamowien: '||SUM(ilosc_zamowien)
	AS raport FROM zamowienia
	INNER JOIN produkty ON produkty.id_produktu=zamowienia.id_produktu
	INNER JOIN producenci ON producenci.id_producenta=zamowienia.id_producenta
	GROUP BY nazwa_produktu;
	--b)
	
	--c)
	SELECT * FROM produkty NATURAL JOIN zamowienia;
	--c)
	
	--d)
	--Done in Vertabelo
	--d)
	
	--e)
	SELECT * FROM zamowienia WHERE EXTRACT(MONTH FROM data)='01';
	--e)
	
	--f)
	SELECT EXTRACT(DAY FROM data) FROM zamowienia
 	INNER JOIN produkty ON zamowienia.id_produktu=produkty.id_produktu 
 	WHERE cena*ilosc_zamowien=(SELECT MAX(cena*ilosc_zamowien) FROM zamowienia
 	INNER JOIN produkty ON zamowienia.id_produktu=produkty.id_produktu);
	--f)
	
	--g)
	SELECT nazwa_produktu, MAX(ilosc) AS mx FROM
	(SELECT nazwa_produktu, SUM(ilosc_zamowien) AS ilosc FROM zamowienia
	INNER JOIN produkty ON produkty.id_produktu=zamowienia.id_produktu
	INNER JOIN producenci ON producenci.id_producenta=zamowienia.id_producenta
	GROUP BY nazwa_producenta, nazwa_produktu) AS foo GROUP BY nazwa_produktu ORDER BY mx DESC LIMIT 1;
	--g)
--11

--12
	--a)
	SELECT 'Produkt '||UPPER(nazwa_produktu)||', ktorego producentami jest '||LOWER(nazwa_producenta)||', zamowiono '||SUM(ilosc_zamowien)||' razy'
	AS opis FROM zamowienia
	INNER JOIN produkty ON produkty.id_produktu=zamowienia.id_produktu
	INNER JOIN producenci ON producenci.id_producenta=zamowienia.id_producenta
	GROUP BY nazwa_produktu, nazwa_producenta ORDER BY SUM(ilosc_zamowien) DESC;
	--a)
	
	--b)
	SELECT nazwa_produktu, SUM(ilosc_zamowien*cena) AS ilosc FROM zamowienia
	INNER JOIN produkty ON produkty.id_produktu=zamowienia.id_produktu
	INNER JOIN producenci ON producenci.id_producenta=zamowienia.id_producenta
	GROUP BY nazwa_produktu ORDER BY SUM(ilosc_zamowien*cena);
	--b)
	
	--c)
	CREATE TABLE sklep.klienci (id_klienta SERIAL, nazwa_klienta VARCHAR(50)  NOT NULL, mail varchar(50)  NOT NULL, telefon varchar(17));
	ALTER TABLE klienci ADD PRIMARY KEY (id_klienta);
	--c)
	
	--d)
	ALTER TABLE zamowienia 
	ADD COLUMN id_klienta INTEGER NOT NULL DEFAULT 0;
	
	INSERT INTO klienci (nazwa_klienta, mail, telefon) 
	VALUES ('klient1',  'klient1@gmail.com',  '12353454'),
	       ('klient2',  'klient2@gmail.com',  '46798723'),
	       ('klient3',  'klient3@gmail.com',  '89745783'),
	       ('klient4',  'klient4@gmail.com',  '94897462'),
	       ('klient5',  'klient5@gmail.com',  '23576496'), 
	       ('klient6',  'klient6@gmail.com',  '34865732'),
	       ('klient7',  'klient7@gmail.com',  '53489345'),
	       ('klient8',  'klient8@gmail.com',  '42378444'),
	       ('klient9',  'klient9@gmail.com',  '69847324'),
	       ('klient10', 'klient10@gmail.com', '25783468');
	
	UPDATE zamowienia SET id_klienta = 9 WHERE id_zamowenia = 1;
	UPDATE zamowienia SET id_klienta = 3 WHERE id_zamowenia = 2;
	UPDATE zamowienia SET id_klienta = 4 WHERE id_zamowenia = 3;
	UPDATE zamowienia SET id_klienta = 10 WHERE id_zamowenia = 4;
	UPDATE zamowienia SET id_klienta = 3 WHERE id_zamowenia = 5;
	UPDATE zamowienia SET id_klienta = 4 WHERE id_zamowenia = 6;
	UPDATE zamowienia SET id_klienta = 5 WHERE id_zamowenia = 7;
	UPDATE zamowienia SET id_klienta = 1 WHERE id_zamowenia = 8;
	UPDATE zamowienia SET id_klienta = 3 WHERE id_zamowenia = 9;
	UPDATE zamowienia SET id_klienta = 6 WHERE id_zamowenia = 10;
	UPDATE zamowienia SET id_klienta = 8 WHERE id_zamowenia = 11;
	UPDATE zamowienia SET id_klienta = 2 WHERE id_zamowenia = 12;
	UPDATE zamowienia SET id_klienta = 8 WHERE id_zamowenia = 13;
	UPDATE zamowienia SET id_klienta = 1 WHERE id_zamowenia = 14;
	UPDATE zamowienia SET id_klienta = 2 WHERE id_zamowenia = 15;
	UPDATE zamowienia SET id_klienta = 1 WHERE id_zamowenia = 16;
	UPDATE zamowienia SET id_klienta = 6 WHERE id_zamowenia = 17;
	UPDATE zamowienia SET id_klienta = 1 WHERE id_zamowenia = 18;
	UPDATE zamowienia SET id_klienta = 7 WHERE id_zamowenia = 19;
	UPDATE zamowienia SET id_klienta = 10 WHERE id_zamowenia = 20;
	
	ALTER TABLE zamowienia 
	ADD CONSTRAINT constraint_zamowienia_klient
	FOREIGN KEY (id_klienta) 
	REFERENCES klienci (id_klienta)
	ON DELETE CASCADE;
	--d)
	
	--e)
	SELECT nazwa_klienta, nazwa_produktu, ilosc_zamowien, SUM(ilosc_zamowien*cena) AS wartosc_zamowienia FROM zamowienia
	INNER JOIN produkty ON produkty.id_produktu=zamowienia.id_produktu
	INNER JOIN producenci ON producenci.id_producenta=zamowienia.id_producenta
	INNER JOIN klienci ON klienci.id_klienta=zamowienia.id_klienta
	GROUP BY nazwa_klienta, nazwa_produktu, ilosc_zamowien;
	--e)
	
	--f)
	--f)
	
	--g)
	--g)
--12

--13
	--a)
	CREATE TABLE sklep.numer (liczba SMALLINT);
	--a)
	
	--b)
	CREATE SEQUENCE liczba_seq
	INCREMENT 5
	MINVALUE 0 
	MAXVALUE 125
	START 100
	CYCLE
	OWNED BY numer.liczba;
	--b)
	
	--c)
	INSERT INTO numer(liczba)
	VALUES (nextval('liczba_seq')),
	       (nextval('liczba_seq')),
	       (nextval('liczba_seq')),
	       (nextval('liczba_seq')),
	       (nextval('liczba_seq')),
	       (nextval('liczba_seq')),
	       (nextval('liczba_seq'));
	--c)
	
	--d)
	ALTER SEQUENCE liczba_seq
	INCREMENT BY 6;
	--d)
	
	--e)
	SELECT last_value FROM liczba_seq;
	SELECT nextval('liczba_seq');
	--e)
	
	--f)
	DROP SEQUENCE liczba_seq;
	--f)
--13

--14
	--a)
	\du
	--a)
	
	--b)
	--b)
	
	--c)
	--c)
--14

--15
	--a)
	BEGIN;
	UPDATE produkty SET cena = cena + 10.00;
	COMMIT;
	--a)
	
	--b)
	--b)
	
	--c)
	--c)
--15
