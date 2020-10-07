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
	ALTER TABLE godziny ADD COLUMN miesiac INTEGER NOT NULL;
	ALTER TABLE godziny ADD COLUMN numer_tygodnia INTEGER NOT NULL;
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
       ('Jessica',  'Jones',      'Mostowa 666',        '923303457'),
       ('Curt',     'Cobain',     'Kaliber 44',         '287246728'),
       ('Monika',   'Worek',      'Workowa 76',         '234267457'),
       ('Ozzy',     'Osbourne',    'Sabatowa 666',       '783645877'),
       ('Ian',      'Anderson',   'Flecista 1',         '123768393');
        
DO
$do$
DECLARE
   data DATE := '2020-10-01';
BEGIN 
   FOR i IN 1..600 LOOP
   	data := (SELECT DATE((SELECT TIMESTAMP '2020-10-01' + random() * (TIMESTAMP '2020-12-31 20:00:00' - TIMESTAMP '2020-10-01 10:00:00'))));
	INSERT INTO godziny (data, liczba_godzin, id_pracownika, miesiac, numer_tygodnia)
	VALUES (data, (SELECT floor(random() * (12-5+1) + 5)::INTEGER), (SELECT floor(random() * (14-1+1) + 1)::INTEGER), 
	(SELECT EXTRACT(MONTH FROM data)), (SELECT EXTRACT(WEEK FROM data)));
   END LOOP;
END
$do$;
       
INSERT INTO pensja_stanowisko (stanowisko, kwota) 
VALUES ('kurier',             999.45),
       ('ksiegowy',           3500.80),
       ('kierownik_kadry_HR', 10504.66),
       ('kierownik_zespolu',  12578.66),
       ('kierownik_firmy',    14502.66),
       ('HR',                 4555.23),
       ('programista',        15541.50),
       ('htmlowiec',          1643.76),
       ('menadzer',           6231.54),
       ('bazodanowiec',       544.87),
       ('admin_sieci',        10505.34),
       ('admin_sysopow',      340.65),
       ('sprzatacz',          2340.97),
       ('kucharz',            3430.23);
       
INSERT INTO premia (rodzaj, kwota) 
VALUES ('pomoc_koledze', 12.66),
       ('sprzatanie',    203.53),
       ('bycie_milym',   102.46),
       ('nienarzekanie', 34.18),
       ('kawa_z_szefem', 141.95),
       ('wolne',     	  634.34),
       ('siedzenie',     5.86),
       ('stanie',        10.12),
       ('lezenie',       12.54),
       ('brak',      	  0);

CREATE TABLE temp (id SERIAL, id_pracownika INTEGER NOT NULL, id_pensji INTEGER NOT NULL);

INSERT INTO temp (id_pracownika, id_pensji) 
VALUES (1,  11),
       (2,  5),
       (3,  10),
       (4,  3),
       (5,  4),
       (6,  9),
       (7,  12),
       (8,  2),
       (9,  6),
       (10, 14),
       (11, 8),
       (12, 1),
       (13, 13),
       (14, 7);

DO
$do$
DECLARE
data DATE := '2020-01-01';
pracownik INTEGER := 0;
godzina INTEGER := 0;
pensja INTEGER := 0;
BEGIN 
   FOR i IN 1..600 LOOP
   	data := (SELECT godziny.data from godziny WHERE id_godziny=i);
   	pracownik := (SELECT id_pracownika from godziny WHERE id_godziny=i);
   	pensja := (SELECT id_pensji from temp WHERE id_pracownika=pracownik);
	INSERT INTO wynagrodzenia (data, id_pracownika, id_godziny, id_pensji, id_premii) 
	VALUES (data, pracownik, i, pensja, (SELECT floor(random() * (10-1+1) + 1)::INTEGER));
   END LOOP;
END
$do$;

DROP TABLE temp;
       
--inserting

--6
	--a)
	SELECT id_pracownika, nazwisko FROM pracownicy;
	--a)
	
	--b)
	SELECT DISTINCT id_pracownika FROM wynagrodzenia, pensja_stanowisko WHERE wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji
	AND pensja_stanowisko.kwota > 1000;
	--b)
	
	--c)
	SELECT DISTINCT id_pracownika FROM wynagrodzenia, pensja_stanowisko, premia WHERE wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji
	AND wynagrodzenia.id_premii=premia.id_premii AND premia.rodzaj='brak' AND pensja_stanowisko.kwota > 2000;
	--c)
	
	--d)
	SELECT imie, nazwisko FROM pracownicy WHERE imie LIKE 'J%';
	--d)
	
	--e)
	SELECT imie, nazwisko FROM pracownicy WHERE imie LIKE '%a' AND nazwisko LIKE '%n%';
	--e)
	
	--f)
	SELECT imie, nazwisko, miesiac, (SUM(liczba_godzin)-160) AS nadgodziny FROM godziny
	JOIN pracownicy ON godziny.id_pracownika=pracownicy.id_pracownika 
	GROUP BY imie, nazwisko, miesiac ORDER BY imie, nazwisko, miesiac;
	--f)
	
	--g)
	SELECT DISTINCT imie, nazwisko FROM pracownicy, wynagrodzenia, pensja_stanowisko WHERE
	pracownicy.id_pracownika=wynagrodzenia.id_pracownika AND wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji AND
	pensja_stanowisko.kwota BETWEEN 1500 AND 3000;
	--g)
	
	--h)
	SELECT imie, nazwisko, miesiac, SUM(liczba_godzin) FROM pracownicy 
	INNER JOIN wynagrodzenia ON wynagrodzenia.id_pracownika=pracownicy.id_pracownika
	INNER JOIN godziny ON godziny.id_godziny=wynagrodzenia.id_godziny
	GROUP BY imie, nazwisko, miesiac HAVING SUM(liczba_godzin) > 160 ORDER BY imie, nazwisko, miesiac;
	--h)
--6

--7
	--a)
	SELECT DISTINCT imie, nazwisko, pensja_stanowisko.kwota FROM pracownicy, wynagrodzenia, pensja_stanowisko WHERE
	wynagrodzenia.id_pracownika=pracownicy.id_pracownika AND wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji 
	ORDER BY pensja_stanowisko.kwota;
	--a)
	
	--b)
	SELECT imie, nazwisko, pensja_stanowisko.kwota + SUM(premia.kwota) AS pensja_premia FROM pracownicy	
	INNER JOIN wynagrodzenia ON wynagrodzenia.id_pracownika=pracownicy.id_pracownika
	INNER JOIN premia ON premia.id_premii=wynagrodzenia.id_premii
	INNER JOIN pensja_stanowisko ON pensja_stanowisko.id_pensji=wynagrodzenia.id_pensji
	GROUP BY imie, nazwisko, pensja_stanowisko.kwota ORDER BY pensja_stanowisko.kwota + SUM(premia.kwota) DESC;
	--b)
	
	--c)
	SELECT stanowisko, count(stanowisko) FROM pensja_stanowisko, wynagrodzenia WHERE 
	wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji GROUP BY stanowisko, ;
	--c)
	
	--d)
	SELECT MIN(pensja_stanowisko.kwota), MAX(pensja_stanowisko.kwota), AVG(pensja_stanowisko.kwota) FROM 
	pensja_stanowisko WHERE pensja_stanowisko.stanowisko LIKE '%kierownik%';
	--d)
	
	--e)
	SELECT SUM(sumy) AS suma_wszystkich_wynagrodzen FROM (SELECT pensja_stanowisko.kwota+premia.kwota*COUNT(premia.rodzaj) AS sumy FROM pracownicy
	INNER JOIN wynagrodzenia ON wynagrodzenia.id_pracownika=pracownicy.id_pracownika
	INNER JOIN pensja_stanowisko ON wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji
	INNER JOIN premia ON wynagrodzenia.id_premii=premia.id_premii
	GROUP BY premia.rodzaj, premia.kwota, pensja_stanowisko.kwota) AS foo;
	--e)
	
	--f)
	SELECT stanowisko, SUM(sumy) FROM (SELECT stanowisko, pensja_stanowisko.kwota + premia.kwota*COUNT(premia.rodzaj) AS sumy FROM pracownicy
	INNER JOIN wynagrodzenia ON wynagrodzenia.id_pracownika=pracownicy.id_pracownika
	INNER JOIN pensja_stanowisko ON wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji
	INNER JOIN premia ON wynagrodzenia.id_premii=premia.id_premii
	GROUP BY stanowisko, pensja_stanowisko.kwota, premia.kwota) AS foo GROUP BY stanowisko;
	--f)
	
	--g)
	SELECT stanowisko, COUNT(premia.id_premii) AS liczba_premii FROM pensja_stanowisko, wynagrodzenia, premia
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
	ALTER COLUMN telefon TYPE VARCHAR(17);
	
	UPDATE pracownicy SET telefon = CONCAT('(+48) ', telefon);
	--a)
	
	--b)
	UPDATE pracownicy SET telefon = CONCAT(LEFT(telefon, 6), SUBSTRING(telefon, 7, 3), '-', SUBSTRING(telefon, 10, 3), '-', RIGHT(telefon, 3));
	--b)
	
	--c)
	SELECT id_pracownika, UPPER(imie), UPPER(nazwisko), UPPER(adres), telefon FROM pracownicy WHERE 
	LENGTH(nazwisko) = (SELECT MAX(LENGTH(nazwisko)) FROM pracownicy);
	--c)
	
	--d)
	SELECT MD5(imie||nazwisko||adres||telefon||pensja_stanowisko.kwota) FROM pracownicy, pensja_stanowisko, wynagrodzenia WHERE
	wynagrodzenia.id_pracownika=pracownicy.id_pracownika AND wynagrodzenia.id_pensji=pensja_stanowisko.id_pensji 
	GROUP BY pracownicy.id_pracownika, pensja_stanowisko.kwota;
	--d)
--8

--9

--9

