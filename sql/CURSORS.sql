-- 1

CREATE OR REPLACE PROCEDURE zw_cene_naj_wyb_uslug(procent_podwyzki NUMBER DEFAULT 0.05)
IS
max_zamowien_uslug NUMBER := 0;
CURSOR ilosc_pos_uslug_cur IS
	SELECT COUNT(ZU.ID_Uslugi) AS ILOSC_ZAMOWIEN_USLUG, ZU.ID_Uslugi, U.cena_netto FROM Zlecenia_uslug ZU
	INNER JOIN Uslugi U ON ZU.ID_Uslugi = U.ID_Uslugi
	GROUP BY ZU.ID_Uslugi, U.cena_netto
	ORDER BY ILOSC_ZAMOWIEN_USLUG DESC;

BEGIN

if (procent_podwyzki > 1 OR procent_podwyzki < 0.01) THEN

	RAISE_APPLICATION_ERROR(-20000, 'Wyjatek: procent do zmiany ceny musi byc z przedzialu od 1% do 100%.');

END IF;

SELECT MAX(ILOSC_ZAMOWIEN_USLUG) INTO max_zamowien_uslug FROM (
	SELECT COUNT(ZU.ID_Uslugi) AS ILOSC_ZAMOWIEN_USLUG, ZU.ID_Uslugi, U.cena_netto FROM Zlecenia_uslug ZU
	INNER JOIN Uslugi U ON ZU.ID_Uslugi = U.ID_Uslugi
	GROUP BY ZU.ID_Uslugi, U.cena_netto);

FOR us IN ilosc_pos_uslug_cur LOOP

	UPDATE Uslugi SET cena_netto = cena_netto * (1 + procent_podwyzki) WHERE ID_Uslugi = us.ID_Uslugi
	AND us.ILOSC_ZAMOWIEN_USLUG = max_zamowien_uslug;

END LOOP;

END;
/

EXEC zw_cene_naj_wyb_uslug;

DROP PROCEDURE zw_cene_naj_wyb_uslug;

-- 2

CREATE OR REPLACE PROCEDURE zw_cene_naj_wyb_zamowien(procent_podwyzki NUMBER DEFAULT 0.05)
IS
max_zamowien NUMBER := 0;
CURSOR ilosc_pos_zamowien_cur IS
	SELECT COUNT(Z.ID_Zamowienia) AS ILOSC_ZAMOWIEN, ZP.ID_Produktu, P.cena_netto FROM Zamowienia Z
	INNER JOIN Zamowienia_produkty ZP ON Z.ID_Zamowienia = ZP.ID_Zamowienia
	INNER JOIN Produkty P ON ZP.ID_Produktu = P.ID_Produktu
	GROUP BY Z.ID_Zamowienia, ZP.ID_Produktu, P.cena_netto
	ORDER BY ILOSC_ZAMOWIEN DESC;

BEGIN

if (procent_podwyzki > 1 OR procent_podwyzki < 0.01) THEN

	RAISE_APPLICATION_ERROR(-20000, 'Wyjatek: procent do zmiany ceny musi byc z przedzialu od 1% do 100%.');

END IF;

SELECT MAX(ILOSC_ZAMOWIEN) INTO max_zamowien FROM (
	SELECT COUNT(Z.ID_Zamowienia) AS ILOSC_ZAMOWIEN, ZP.ID_Produktu, P.cena_netto FROM Zamowienia Z
	INNER JOIN Zamowienia_produkty ZP ON Z.ID_Zamowienia = ZP.ID_Zamowienia
	INNER JOIN Produkty P ON ZP.ID_Produktu = P.ID_Produktu
	GROUP BY Z.ID_Zamowienia, ZP.ID_Produktu, P.cena_netto);

FOR pr IN ilosc_pos_zamowien_cur LOOP

	UPDATE Produkty SET cena_netto = cena_netto * (1 + procent_podwyzki) WHERE ID_Produktu = pr.ID_Produktu 
	AND pr.ILOSC_ZAMOWIEN = max_zamowien;

END LOOP;

END;
/

EXEC zw_cene_naj_wyb_zamowien;

DROP PROCEDURE zw_cene_naj_wyb_zamowien;