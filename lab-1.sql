--1
CREATE DATABASE s283109;
\c s283109
--1

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
	CREATE TABLE pracownicy(id_pracownika SERIAL, imie VARCHAR(50) NOT NULL, nazwisko VARCHAR(50) NOT NULL,
	adres VARCHAR(50) NOT NULL, telefon VARCHAR(11));

	CREATE TABLE godziny(id_godziny SERIAL, data DATE NOT NULL, liczba_godzin INTEGER NOT NULL,
	id_pracownika INTEGER NOT NULL);

	CREATE TABLE pensja_stanowisko(id_pensji SERIAL, stanowisko VARCHAR(50) NOT NULL, kwota NUMERIC(10, 2));

	CREATE TABLE premia(id_premii SERIAL, rodzaj VARCHAR(50) NOT NULL, kwota NUMERIC(10, 2));

	CREATE TABLE wynagrodzenia(id_wynagrodzenia SERIAL, data DATE, id_pracownika INTEGER NOT NULL,
	id_godziny INTEGER NOT NULL, id_pensji INTEGER NOT NULL, id_premii INTEGER NOT NULL);
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
	REFERENCES pracownicy (id_pracownika)
	ON DELETE CASCADE;

	ALTER TABLE wynagrodzenia 
	ADD CONSTRAINT constraint_wynagrodzenia_pracownik
	FOREIGN KEY (id_pracownika) 
	REFERENCES pracownicy (id_pracownika)
	ON DELETE CASCADE;

	ALTER TABLE wynagrodzenia 
	ADD CONSTRAINT constraint_wynagrodzania_godzina
	FOREIGN KEY (id_godziny) 
	REFERENCES godziny(id_godziny)
	ON DELETE CASCADE;

	ALTER TABLE wynagrodzenia 
	ADD CONSTRAINT constraint_wynagrodzenia_pensja
	FOREIGN KEY (id_pensji) 
	REFERENCES pensja_stanowisko (id_pensji)
	ON DELETE CASCADE;

	ALTER TABLE wynagrodzenia 
	ADD CONSTRAINT constraint_wynagrodzenia_premia
	FOREIGN KEY (id_premii) 
	REFERENCES premia (id_premii)
	ON DELETE CASCADE;
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
VALUES ('Jan',      'Kowalski',   'Wadowicka 19',       '123 343 456'),
       ('Szczepan', 'Konon',      'Akadamicka 60',      '124 233 857'),
       ('Karol',    'Nowak',      'Dwornika 13',        '623 740 856'),
       ('Jaroslaw', 'Polskezbaw', 'Schizofreniczna 69', '720 073 851'),
       ('Beata',    'Kula',       'Starowislna 23',     '223 343 052'),
       ('Marek',    'Niezdarek',  'Matecznego 1',       '482 343 459'),
       ('Pawel',    'Broda',      'Rydlowka 53',        '423 052 450'),
       ('Alicja',   'Czara',      'Krakowska 109',      '227 343 456'),
       ('Adam',     'Dlugopis',   'Mickiewicza 6',      '520 343 056'),
       ('Jessica',  'Jones',      'Mostowa 666',        '923 303 457'),
       ('Curt',     'Cobain',     'Kaliber 44',         '287 246 728');
       
/* 
	aby dostac numer tygodnia trzeba uzyc: 
	SELECT DATE_PART('year', AGE((select numer_tygodnia from godziny where id_godziny=<id>), '1753-01-01'));
	
	aby dostac miesiac trzeba uzyc:
	SELECT EXTRACT(MONTH FROM (select miesiac from godziny where id_godziny=<id>));
*/
INSERT INTO godziny (data, liczba_godzin, id_pracownika, miesiac, numer_tygodnia) 
VALUES ('2019-09-10', 115, 2,  '1753-09-01', '1790-01-01'),
       ('2020-12-17', 167, 3,  '1753-12-01', '1804-01-01'),
       ('2018-03-06', 125, 10, '1753-03-01', '1763-01-01'),
       ('2019-01-20', 202, 4,  '1753-01-01', '1756-01-01'),
       ('2020-02-14', 209, 9,  '1753-02-01', '1760-01-01'),
       ('2019-11-13', 176, 6,  '1753-11-01', '1799-01-01'),
       ('2018-05-30', 90,  8,  '1753-05-01', '1775-01-01'),
       ('2019-10-15', 101, 1,  '1753-10-01', '1795-01-01'),
       ('2020-06-27', 154, 5,  '1753-06-01', '1779-01-01'),
       ('2021-04-16', 166, 7,  '1753-04-01', '1753-01-01'),
       ('2019-08-31', 160, 10, '1753-08-01', '1788-01-01'),
       ('2020-11-21', 169, 6,  '1753-11-01', '1799-01-01'),
       ('2020-09-17', 160, 7,  '1753-09-01', '1791-01-01'),
       ('2019-03-09', 161, 1,  '1753-03-01', '1763-01-01'),
       ('2020-06-01', 185, 3,  '1753-06-01', '1776-01-01'),
       ('2019-06-04', 155, 11, '1753-06-01', '1776-01-01');
       
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
       ('2020-12-15', 4,  5,  4,  5),
       ('2020-03-15', 11, 16, 2,  5);
--inserting

--6
	--a)
	SELECT id_pracownika, nazwisko FROM pracownicy;
	--a)
	
	--b)
	SELECT id_pracownika FROM wynagrodzenia, pensja_stanowisko WHERE wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji
	AND pensja_stanowisko.kwota > 1000;
	--b)
	
	--c)
	SELECT id_pracownika FROM wynagrodzenia, pensja_stanowisko, premia WHERE wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji
	AND wynagrodzenia.id_premii=premia.id_premii AND premia.rodzaj='brak' AND pensja_stanowisko.kwota > 2000;
	--c)
	
	--d)
	SELECT imie, nazwisko FROM pracownicy WHERE imie LIKE 'J%';
	--d)
	
	--e)
	SELECT imie, nazwisko FROM pracownicy WHERE imie LIKE '%a' AND nazwisko LIKE '%n%';
	--e)
	
	--f)
	SELECT imie, nazwisko, (godziny.liczba_godzin - 160) AS nadgodziny FROM
	pracownicy, wynagrodzenia, godziny WHERE pracownicy.id_pracownika=wynagrodzenia.id_pracownika AND
	wynagrodzenia.id_godziny=godziny.id_godziny AND godziny.liczba_godzin > 160;
	--f)
	
	--g)
	SELECT imie, nazwisko FROM pracownicy, wynagrodzenia, pensja_stanowisko WHERE
	pracownicy.id_pracownika=wynagrodzenia.id_pracownika AND wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji AND
	pensja_stanowisko.kwota BETWEEN 1500 AND 3000;
	--g)
	
	--h)
	SELECT imie, nazwisko FROM pracownicy, wynagrodzenia, godziny, premia WHERE
	pracownicy.id_pracownika=wynagrodzenia.id_pracownika AND wynagrodzenia.id_godziny=godziny.id_godziny AND
	wynagrodzenia.id_premii=premia.id_premii AND godziny.liczba_godzin > 160 AND premia.rodzaj='brak';
	--h)
--6

--7
	--a)
	SELECT imie, nazwisko FROM pracownicy, wynagrodzenia, pensja_stanowisko WHERE
	wynagrodzenia.id_pracownika=pracownicy.id_pracownika AND wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji 
	ORDER BY pensja_stanowisko.kwota;
	--a)
	
	--b)
	SELECT imie, nazwisko FROM pracownicy, wynagrodzenia, pensja_stanowisko, premia WHERE
	wynagrodzenia.id_pracownika=pracownicy.id_pracownika AND wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji AND
	wynagrodzenia.id_premii=premia.id_premii ORDER BY pensja_stanowisko.kwota + premia.kwota DESC;
	--b)
	
	--c)
	SELECT stanowisko, COUNT(wynagrodzenia.id_pensji) FROM pensja_stanowisko, wynagrodzenia WHERE 
	wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji GROUP BY pensja_stanowisko.stanowisko;
	--c)
	
	--d)
	SELECT MIN(pensja_stanowisko.kwota), MAX(pensja_stanowisko.kwota), AVG(pensja_stanowisko.kwota) FROM 
	pensja_stanowisko WHERE pensja_stanowisko.stanowisko='szefunio';
	--d)
	
	--e)
	SELECT SUM(pensja_stanowisko.kwota + premia.kwota) AS suma_wynagrodzen FROM pensja_stanowisko, wynagrodzenia, premia
	WHERE wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji AND wynagrodzenia.id_premii=premia.id_premii;
	--e)
	
	--f)
	SELECT stanowisko, SUM(pensja_stanowisko.kwota + premia.kwota) AS suma_wynagrodzen FROM pensja_stanowisko, wynagrodzenia, premia
	WHERE wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji AND wynagrodzenia.id_premii=premia.id_premii GROUP BY stanowisko;
	--f)
	
	--g)
	SELECT stanowisko, COUNT(premia.id_premii) AS suma_wynagrodzen FROM pensja_stanowisko, wynagrodzenia, premia
	WHERE wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji AND wynagrodzenia.id_premii=premia.id_premii GROUP BY stanowisko;
	--g)
	
	--h)
	DELETE FROM pracownicy WHERE id_pracownika IN 
	(SELECT pracownicy.id_pracownika FROM pracownicy, wynagrodzenia, pensja_stanowisko WHERE
	wynagrodzenia.id_pracownika=pracownicy.id_pracownika AND wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji AND 
	pensja_stanowisko.kwota < 1200);
	--h)
--7

--8
	--a)
	ALTER TABLE pracownicy 
	ALTER COLUMN telefon TYPE VARCHAR(16);
	
	UPDATE pracownicy SET telefon = CONCAT('(+48)', telefon);
	--a)
	
	--b)
	UPDATE pracownicy SET telefon = REPLACE(telefon, ' ', '-');
	--b)
	
	--c)
	SELECT id_pracownika, UPPER(imie), UPPER(nazwisko), UPPER(adres), telefon FROM pracownicy WHERE 
	LENGTH(nazwisko) = (SELECT MAX(LENGTH(nazwisko)) FROM pracownicy);
	--c)
	
	--d)
	SELECT MD5(imie||nazwisko||adres||telefon||pensja_stanowisko.kwota) FROM pracownicy, pensja_stanowisko, wynagrodzenia WHERE
	wynagrodzenia.id_pracownika=pracownicy.id_pracownika AND wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji;
	--d)
--8

