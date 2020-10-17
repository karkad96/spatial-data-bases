--1,2,3
CREATE DATABASE postgis;
CREATE EXTENSION postgis;
--1,2,3

--4
CREATE TABLE budynki(id_budynku SERIAL, geometria geometry, nazwa VARCHAR(50) NOT NULL);
CREATE TABLE drogi(id_drogi SERIAL, geometria geometry, nazwa VARCHAR(50) NOT NULL);
CREATE TABLE punkty_informacyjne(id_punktu SERIAL, geometria geometry, nazwa VARCHAR(50) NOT NULL);
--4

--5
INSERT INTO budynki (geometria, nazwa) 
VALUES ('POLYGON((10.5 4, 10.5 1.5, 8 1.5, 8 4, 10.5 4))', 'BuildingA'),
       ('POLYGON((6 7, 6 5, 4 5, 4 7, 6 7))', 'BuildingB'),
       ('POLYGON((5 8, 5 6, 3 6, 3 8, 5 8))', 'BuildingC'),
       ('POLYGON((10 9, 10 8, 9 8, 9 9, 10 9))', 'BuildingD'),
       ('POLYGON((2 2, 2 1, 1 1, 1 2, 2 2))', 'BuildingF');
       
INSERT INTO drogi (geometria, nazwa) 
VALUES ('LINESTRING(0 4.5, 12 4.5)', 'RoadX'),
       ('LINESTRING(7.5 0, 7.5 10.5)', 'RoadY');
       
INSERT INTO punkty_informacyjne (geometria, nazwa) 
VALUES ('POINT(1 3.5)', 'G'),
       ('POINT(5.5 1.5)', 'H'),
       ('POINT(9.5 6)', 'I'),
       ('POINT(6.5 6)', 'J'),
       ('POINT(6 9.5)', 'K');
--5

--6
	--a)
	SELECT SUM(ST_Length(geometria)) FROM drogi;
	--a)
	
	--b)
	SELECT ST_AsEWKT(geometria), ST_Area(geometria), ST_Perimeter(geometria) FROM budynki WHERE nazwa='BuildingA';
	--b)
	
	--c)
	SELECT nazwa, ST_Area(geometria) FROM budynki ORDER BY nazwa;
	--c)
	
	--d)
	SELECT nazwa, ST_Perimeter(geometria) FROM budynki ORDER BY ST_Area(geometria) DESC LIMIT 2;
	--d)
	
	--e
	SELECT ST_Distance(budynki.geometria, punkty_informacyjne.geometria)
	FROM budynki, punkty_informacyjne WHERE budynki.nazwa='BuildingC' AND punkty_informacyjne.nazwa='G';
	--e)
	
	--f)
	SELECT ST_Area(g) FROM (SELECT ST_Intersection(ST_Buffer((SELECT geometria FROM budynki WHERE nazwa='BuildingB'), 0.5), 
	(SELECT geometria FROM budynki WHERE nazwa='BuildingC')) AS g) AS foo;
	--f)
	
	--g)
	SELECT budynki.nazwa FROM budynki WHERE ST_X(ST_Centroid(budynki.geometria)) > 4.5;
	SELECT ST_Area((SELECT geometria FROM budynki WHERE nazwa='BuildingC')) + ST_Area('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))') - 
	ST_Area(ST_Intersection((SELECT geometria FROM budynki WHERE nazwa='BuildingC'), 'POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')) AS area;
	--g)
--6

--7
--No exercises
--7

