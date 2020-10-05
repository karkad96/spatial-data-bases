--1
CREATE DATABASE s283109;
\c s283109
--1

BEGIN TRANSACTION;

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
	--a)
	
	--b)
	ALTER TABLE wynagrodzenia 
	ALTER COLUMN data TYPE VARCHAR;
	--b)
	
	--c)
	--c)
--5
ROLLBACK TRANSACTION;
