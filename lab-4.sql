--1,2,3
--Done via GUI
--1,2,3

--4
CREATE TABLE tableB AS
SELECT popp.gid, popp.cat, popp.f_codedesc, popp.f_code, popp.type, popp.geom 
FROM popp, majrivers GROUP BY popp.gid HAVING MIN(ST_Distance(majrivers.geom, popp.geom)) < 100000 AND popp.f_codedesc='Building';

SELECT COUNT(*) FROM tableB;
--4

--5
CREATE TABLE airportsNew AS
SELECT name, geom, elev FROM airports;
	
	--a)
	SELECT MIN(ST_Y(geom)), MAX(ST_Y(geom)) FROM airportsNew;
	--a)
	
	--b)
	INSERT INTO airportsNew (name, geom, elev) VALUES ('airportB', (SELECT ST_Centroid(ST_MakeLine(
	       (SELECT geom FROM airportsNew WHERE ST_Y(geom)=(SELECT MIN(ST_Y(geom)) FROM airportsNew)),
	       (SELECT geom FROM airportsNew WHERE ST_Y(geom)=(SELECT MAX(ST_Y(geom)) FROM airportsNew))))), 344.42);
	--b)
--5

--6
SELECT ST_Area(ST_Buffer((SELECT ST_ShortestLine(lakes.geom, airports.geom) FROM lakes, airports 
WHERE lakes.names='Iliamna Lake' AND airports.name='AMBLER'), 1000));
--6

--7
--7
