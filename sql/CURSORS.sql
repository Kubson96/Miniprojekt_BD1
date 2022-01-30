-- 1

CREATE OR REPLACE PROCEDURE zw_cene_naj_wyb_uslug(procent_podwyzki IN NUMBER DEFAULT 5)
IS
max_zamowien_uslug NUMBER := 0;
CURSOR ilosc_pos_uslug_cur IS
	SELECT COUNT(ZU.ID_Uslugi) AS ILOSC_ZAMOWIEN_USLUG, ZU.ID_Uslugi, U.cena_netto FROM Zlecenia_uslug ZU
	INNER JOIN Uslugi U ON ZU.ID_Uslugi = U.ID_Uslugi
	GROUP BY ZU.ID_Uslugi, U.cena_netto
	ORDER BY ILOSC_ZAMOWIEN_USLUG DESC;

BEGIN

if (procent_podwyzki > 100 OR procent_podwyzki < 1) THEN

	RAISE_APPLICATION_ERROR(-20000, 'Wyjatek: procent do zmiany ceny musi byc z przedzialu od 1% do 100%.');

END IF;

SELECT MAX(ILOSC_ZAMOWIEN_USLUG) INTO max_zamowien_uslug FROM (
	SELECT COUNT(ZU.ID_Uslugi) AS ILOSC_ZAMOWIEN_USLUG, ZU.ID_Uslugi, U.cena_netto FROM Zlecenia_uslug ZU
	INNER JOIN Uslugi U ON ZU.ID_Uslugi = U.ID_Uslugi
	GROUP BY ZU.ID_Uslugi, U.cena_netto);

FOR us IN ilosc_pos_uslug_cur LOOP

	UPDATE Uslugi SET cena_netto = cena_netto * (1 + procent_podwyzki/100) WHERE ID_Uslugi = us.ID_Uslugi
	AND us.ILOSC_ZAMOWIEN_USLUG = max_zamowien_uslug;

END LOOP;

END;
/

EXEC zw_cene_naj_wyb_uslug;

DROP PROCEDURE zw_cene_naj_wyb_uslug;

-- 2

CREATE OR REPLACE PROCEDURE zw_cene_naj_wyb_zamowien(procent_podwyzki IN NUMBER DEFAULT 5)
IS
max_zamowien NUMBER := 0;
CURSOR ilosc_pos_zamowien_cur IS
	SELECT COUNT(Z.ID_Zamowienia) AS ILOSC_ZAMOWIEN, ZP.ID_Produktu, P.cena_netto FROM Zamowienia Z
	INNER JOIN Zamowienia_produkty ZP ON Z.ID_Zamowienia = ZP.ID_Zamowienia
	INNER JOIN Produkty P ON ZP.ID_Produktu = P.ID_Produktu
	GROUP BY Z.ID_Zamowienia, ZP.ID_Produktu, P.cena_netto
	ORDER BY ILOSC_ZAMOWIEN DESC;

BEGIN

if (procent_podwyzki > 100 OR procent_podwyzki < 1) THEN

	RAISE_APPLICATION_ERROR(-20000, 'Wyjatek: procent do zmiany ceny musi byc z przedzialu od 1% do 100%.');

END IF;

SELECT MAX(ILOSC_ZAMOWIEN) INTO max_zamowien FROM (
	SELECT COUNT(Z.ID_Zamowienia) AS ILOSC_ZAMOWIEN, ZP.ID_Produktu, P.cena_netto FROM Zamowienia Z
	INNER JOIN Zamowienia_produkty ZP ON Z.ID_Zamowienia = ZP.ID_Zamowienia
	INNER JOIN Produkty P ON ZP.ID_Produktu = P.ID_Produktu
	GROUP BY Z.ID_Zamowienia, ZP.ID_Produktu, P.cena_netto);

FOR pr IN ilosc_pos_zamowien_cur LOOP

	UPDATE Produkty SET cena_netto = cena_netto * (1 + procent_podwyzki/100) WHERE ID_Produktu = pr.ID_Produktu 
	AND pr.ILOSC_ZAMOWIEN = max_zamowien;

END LOOP;

END;
/

EXEC zw_cene_naj_wyb_zamowien;

DROP PROCEDURE zw_cene_naj_wyb_zamowien;

-- 3

CREATE OR REPLACE PROCEDURE nadaj_prom_na_min_wyb_prod(procent_prom IN NUMBER DEFAULT 5)
IS
min_zamowien NUMBER := 1000000;
CURSOR ilosc_pos_zamowien_cur IS
	SELECT COUNT(Z.ID_Zamowienia) AS ILOSC_ZAMOWIEN, ZP.ID_Produktu, P.cena_netto FROM Zamowienia Z
	INNER JOIN Zamowienia_produkty ZP ON Z.ID_Zamowienia = ZP.ID_Zamowienia
	INNER JOIN Produkty P ON ZP.ID_Produktu = P.ID_Produktu
	GROUP BY Z.ID_Zamowienia, ZP.ID_Produktu, P.cena_netto
	ORDER BY ILOSC_ZAMOWIEN ASC;

BEGIN

if (procent_prom > 100 OR procent_prom < 0) THEN

	RAISE_APPLICATION_ERROR(-20000, 'Wyjatek: procent do zmiany promocji musi byc z przedzialu od 1 do 100.');

END IF;

SELECT MIN(ILOSC_ZAMOWIEN) INTO min_zamowien FROM (
	SELECT COUNT(Z.ID_Zamowienia) AS ILOSC_ZAMOWIEN, ZP.ID_Produktu, P.cena_netto FROM Zamowienia Z
	INNER JOIN Zamowienia_produkty ZP ON Z.ID_Zamowienia = ZP.ID_Zamowienia
	INNER JOIN Produkty P ON ZP.ID_Produktu = P.ID_Produktu
	GROUP BY Z.ID_Zamowienia, ZP.ID_Produktu, P.cena_netto);

FOR pr IN ilosc_pos_zamowien_cur LOOP

	UPDATE Produkty SET procent_promocji = procent_prom WHERE ID_Produktu = pr.ID_Produktu 
	AND pr.ILOSC_ZAMOWIEN = min_zamowien;

END LOOP;

END;
/

EXEC nadaj_prom_na_min_wyb_prod;

DROP PROCEDURE nadaj_prom_na_min_wyb_prod;

-- 4

-- ustawia date przyjecia zamowienia na aktualna dla zamowionych produktow nie przyjetych
-- do realizacji, ktorych cena jest mniejsza do sredniej ceny
-- oraz ilosc jest wieksza niz 5 
CREATE OR REPLACE PROCEDURE skroc_czas_przyjecia_zam
IS
CURSOR zam_do_skroc_czasu_cur IS
	SELECT Z.ID_Zamowienia, Z.czy_przyjeto_zamowienie FROM Zamowienia Z
	INNER JOIN Zamowienia_produkty ZP ON Z.ID_Zamowienia = ZP.ID_Zamowienia
	INNER JOIN Produkty P ON ZP.ID_Produktu = P.ID_Produktu
	WHERE P.ilosc > 5 AND P.cena_netto < (SELECT AVG(cena_netto) FROM Produkty);

BEGIN

FOR zm IN zam_do_skroc_czasu_cur LOOP

	IF (zm.czy_przyjeto_zamowienie = 0) THEN
	
		UPDATE Zamowienia SET data_przyjecia_zamowienia = sysdate, czy_przyjeto_zamowienie = 1
		WHERE ID_Zamowienia = zm.ID_Zamowienia;
	
	END IF;


END LOOP;

END;
/

EXEC skroc_czas_przyjecia_zam;

DROP PROCEDURE skroc_czas_przyjecia_zam;