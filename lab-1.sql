--1
CREATE DATABASE s283109;
\c s283109
--1

drop table wynagrodzenia;
drop table godziny;
drop table pracownicy;
drop table pensja_stanowisko;
drop table premia;

--2
CREATE SCHEMA firma;
SET search_path TO firma;
--2

--3
CREATE ROLE ksiegowosc;

GRANT USAGE ON SCHEMA firma TO ksiegowosc;
GRANT SELECT ON ALL TABLES IN SCHEMA firma TO ksiegowosc;

ALTER DEFAULT PRIVILEGES IN SCHEMA firma GRANT SELECT ON TABLES TO ksiegowosc;

/* stworzenie i przypiasnie uzytkownika do roli ksiegowosc */
CREATE USER dummy WITH PASSWORD '123';
GRANT ksiegowosc TO dummy;
--3

--4
	--a)
	CREATE TABLE pracownicy(id_pracownika SERIAL, imie VARCHAR(50) NOT NULL, nazwisko VARCHAR(50) NOT NULL, adres VARCHAR(50) NOT NULL, telefon VARCHAR(9));

	CREATE TABLE godziny(id_godziny SERIAL, data DATE NOT NULL, liczba_godzin INTEGER NOT NULL, id_pracownika INTEGER NOT NULL);

	CREATE TABLE pensja_stanowisko(id_pensji SERIAL, stanowisko VARCHAR(50) NOT NULL, kwota NUMERIC(10, 2));

	CREATE TABLE premia(id_premii SERIAL, rodzaj VARCHAR(50) NOT NULL, kwota NUMERIC(10, 2));

	CREATE TABLE wynagrodzenia(id_wynagrodzenia SERIAL, data DATE, id_pracownika INTEGER NOT NULL, id_godziny INTEGER NOT NULL, id_pensji INTEGER NOT NULL, id_premii INTEGER NOT NULL);
	--a)
	
	--b)
	ALTER TABLE pracownicy ADD PRIMARY KEY (id_pracownika);
	ALTER TABLE godziny ADD PRIMARY KEY (id_godziny);
	ALTER TABLE pensja_stanowisko ADD PRIMARY KEY (id_pensji);
	ALTER TABLE premia ADD PRIMARY KEY (id_premii);
	ALTER TABLE wynagrodzenia ADD PRIMARY KEY (id_wynagrodzenia);
	--b)
	
	--c)
	ALTER TABLE godziny 
	ADD CONSTRAINT constraint_godziny_pracownik 
	FOREIGN KEY (id_pracownika) 
	REFERENCES pracownicy (id_pracownika);

	ALTER TABLE wynagrodzenia 
	ADD CONSTRAINT constraint_wynagrodzenia_pracownik
	FOREIGN KEY (id_pracownika) 
	REFERENCES pracownicy (id_pracownika);

	ALTER TABLE wynagrodzenia 
	ADD CONSTRAINT constraint_wynagrodzania_godzina
	FOREIGN KEY (id_godziny) 
	REFERENCES godziny(id_godziny);

	ALTER TABLE wynagrodzenia 
	ADD CONSTRAINT constraint_wynagrodzenia_pensja
	FOREIGN KEY (id_pensji) 
	REFERENCES pensja_stanowisko (id_pensji);

	ALTER TABLE wynagrodzenia 
	ADD CONSTRAINT constraint_wynagrodzenia_premia
	FOREIGN KEY (id_premii) 
	REFERENCES premia (id_premii);
	--c)
	
	--d)
	CREATE INDEX pracownicy_id_index ON pracownicy USING BTREE (id_pracownika);
	CREATE INDEX godziny_id_index ON godziny USING BTREE (id_godziny);
	CREATE INDEX pensja_stanowisko_id_index ON pensja_stanowisko USING BTREE (id_pensji);
	CREATE INDEX premia_id_index ON premia USING BTREE (id_premii);
	CREATE INDEX wynagrodzenia_id_index ON wynagrodzenia USING BTREE (id_wynagrodzenia);
	--d)
	
	--e)
	COMMENT ON TABLE pracownicy IS 'Dane o pracownikach';
	COMMENT ON TABLE godziny IS 'Liczba przepracowanych godzin pracownika';
	COMMENT ON TABLE pensja_stanowisko IS 'Pensja za dane stanowisko w firmie';
	COMMENT ON TABLE premia IS 'Premie dla pracownikow';
	COMMENT ON TABLE wynagrodzenia IS 'Wynagrodzenie pracownika';
	--e)
	
	--f)
	--f)
--4

--5
	--a)
	ALTER TABLE godziny ADD COLUMN miesiac DATE NOT NULL;
	ALTER TABLE godziny ADD COLUMN numer_tygodnia DATE NOT NULL;
	--a)
	
	--b)
	ALTER TABLE wynagrodzenia 
	ALTER COLUMN data TYPE VARCHAR;
	--b)
	
	--c)
	UPDATE premia SET kwota = 0 WHERE rodzaj = 'brak' or rodzaj is NULL;
	--c)
--5

--inserting
INSERT INTO pracownicy (imie, nazwisko, adres, telefon) 
VALUES ('Jan',      'Kowalski',   'Wadowicka 19',       '123343456'),
       ('Szczepan', 'Konon',      'Akadamicka 60',      '124233857'),
       ('Karol',    'Nowak',      'Dwornika 13',        '623740856'),
       ('Jaroslaw', 'Polskezbaw', 'Schizofreniczna 69', '720073851'),
       ('Beata',    'Kula',       'Starowislna 23',     '223343052'),
       ('Marek',    'Niezdarek',  'Matecznego 1',       '482343459'),
       ('Pawel',    'Broda',      'Rydlowka 53',        '423052450'),
       ('Alicja',   'Czara',      'Krakowska 109',      '227343456'),
       ('Adam',     'Dlugopis',   'Mickiewicza 6',      '520343056'),
       ('Jessica',  'Jones',      'Mostowa 666',        '923303457');
       
/* 
	aby dostac numer tygodnia trzeba uzyc: 
	DATE_PART('year', AGE((select miesiac from godziny where id_godziny=<id>), (select miesiac from godziny where id_godziny=<id>)));
	
	aby dostac miesiac trzeba uzyc:
	SELECT EXTRACT(MONTH FROM (select miesiac from godziny where id_godziny=<id>));
*/
INSERT INTO godziny (data, liczba_godzin, id_pracownika, miesiac, numer_tygodnia) 
VALUES ('2019-09-10', 5,  2,  '1753-09-01', '1790-01-01'),
       ('2020-12-17', 4,  3,  '1753-12-01', '1804-01-01'),
       ('2018-03-06', 12, 10, '1753-03-01', '1763-01-01'),
       ('2019-01-20', 8,  4,  '1753-01-01', '1756-01-01'),
       ('2020-02-14', 8,  9,  '1753-02-01', '1760-01-01'),
       ('2019-11-13', 8,  6,  '1753-11-01', '1799-01-01'),
       ('2018-05-30', 10, 8,  '1753-05-01', '1775-01-01'),
       ('2019-10-15', 5,  1,  '1753-10-01', '1795-01-01'),
       ('2020-06-27', 7,  5,  '1753-06-01', '1779-01-01'),
       ('2021-04-16', 9,  7,  '1753-04-01', '1753-01-01'),
       ('2019-08-31', 8,  10, '1753-08-01', '1788-01-01'),
       ('2020-11-21', 6,  6,  '1753-11-01', '1799-01-01'),
       ('2020-09-17', 7,  7,  '1753-09-01', '1791-01-01'),
       ('2019-03-09', 8,  1,  '1753-03-01', '1763-01-01'),
       ('2020-06-01', 9,  3,  '1753-06-01', '1776-01-01');
       
INSERT INTO pensja_stanowisko (stanowisko, kwota) 
VALUES ('kurier',        999.45),
       ('ksiegowy',      3500.80),
       ('szefunio',      10500.66),
       ('HR',            4555.23),
       ('programista',   15541.50),
       ('htmlowiec',     1643.76),
       ('menadzer',      6231.54),
       ('bazodanowiec',  544.87),
       ('admin_sieci',   10505.34),
       ('admin_sysopow', 340.65),
       ('sprzatacz',     2340.97),
       ('kucharz',       3430.23);
       
INSERT INTO premia (rodzaj, kwota) 
VALUES ('nadgodziny',    12.66),
       ('sprzatanie',    203.53),
       ('bycie_milym',   102.46),
       ('nienarzekanie', 34.18),
       ('kawa_z_szefem', 141.95),
       ('wolne',     	  634.34),
       ('siedzenie',     5.86),
       ('stanie',        10.12),
       ('lezenie',       12.54),
       ('brak',      	  0);
       
INSERT INTO wynagrodzenia (data, id_pracownika, id_godziny, id_pensji, id_premii) 
VALUES ('2020-01-15', 1,  15, 12, 3),
       ('2020-09-15', 6,  3,  3,  8),
       ('2019-03-15', 7,  10, 11, 7),
       ('2019-09-15', 3,  7,  10, 6),
       ('2019-04-15', 2,  1,  2,  4),
       ('2020-07-15', 10, 13, 6,  2),
       ('2019-02-15', 9,  6,  9,  10),
       ('2020-05-15', 8,  4,  8,  9),
       ('2020-11-15', 5,  11, 1,  1),
       ('2020-12-15', 4,  5,  4,  5);
--inserting

--6
	--a)
	SELECT id_pracownika, nazwisko FROM pracownicy;
	--a)
	
	--b)
	SELECT id_pracownika FROM wynagrodzenia INNER JOIN pensja_stanowisko ON wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji WHERE pensja_stanowisko.kwota > 1000;
	--b)
	
	--c)
	SELECT id_pracownika FROM wynagrodzenia INNER JOIN pensja_stanowisko ON wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji INNER JOIN premia ON wynagrodzenia.id_premii=premia.id_premii WHERE premia.rodzaj='brak' AND pensja_stanowisko.kwota>2000;
	--c)
	
	--d)
	SELECT imie, nazwisko FROM pracownicy WHERE imie LIKE 'J%';
	--d)
	
	--e)
	SELECT imie, nazwisko FROM pracownicy WHERE imie LIKE '%a' AND nazwisko LIKE '%n%';
	--e)
	
	--f)
	--f)
	
	--g)
	SELECT imie, nazwisko FROM id_pracownika FROM wynagrodzenia INNER JOIN pensja_stanowisko ON wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji where pensja_stanowisko.kwota BETWEEN 1500 AND 3000;
	--g)
	
	--h)
	--h)
--6

--7
	--a)
	SELECT imie, nazwisko FROM pracownicy INNER JOIN wynagrodzenia ON wynagrodzenia.id_pracownika=pracownicy.id_pracownika INNER JOIN pensja_stanowisko ON wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji ORDER BY pensja_stanowisko.kwota;
	--a)
	
	--b)
	SELECT imie, nazwisko FROM pracownicy INNER JOIN wynagrodzenia ON wynagrodzenia.id_pracownika=pracownicy.id_pracownika INNER JOIN pensja_stanowisko ON wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji INNER JOIN premia ON wynagrodzenia.id_premii=premia.id_premii ORDER BY pensja_stanowisko.kwota DESC, premia.kwota DESC;
	--b)
	
	--c)
	
	--c)
	
	--d)
	SELECT imie, nazwisko FROM pracownicy WHERE imie LIKE 'J%';
	--d)
	
	--e)
	SELECT imie, nazwisko FROM pracownicy WHERE imie LIKE '%a' AND nazwisko LIKE '%n%';
	--e)
	
	--f)
	--f)
	
	--g)
	SELECT id_pracownika FROM wynagrodzenia INNER JOIN pensja_stanowisko ON wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji where pensja_stanowisko.kwota BETWEEN 1500 AND 3000;
	--g)
	
	--h)
	--h)
--7

