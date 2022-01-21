-- 1

CREATE OR REPLACE VIEW pracownicy_info_podstawowe AS
SELECT P.ID_Pracownika, O.ID_Osoby, O.imie, O.Nazwisko, O.mail, O.plec, ST.nazwa AS Stanowisko FROM Osoby O 
INNER JOIN Pracownicy P ON P.ID_Osoby = O.ID_Osoby 
INNER JOIN Stanowiska_pracownikow SP ON P.ID_Pracownika = SP.ID_Pracownika
INNER JOIN Stanowiska ST ON SP.ID_Stanowiska = ST.ID_Stanowiska;

SELECT * FROM pracownicy_info_podstawowe;

DROP VIEW pracownicy_info_podstawowe;

-- 2

CREATE OR REPLACE VIEW zysk_pracownicy_netto AS

SELECT SUM(U.cena_netto) AS ZYSK_NETTO, PZ.ID_Pracownika, O.imie, 
O.Nazwisko, O.PESEL, O.nr_telefonu, O.mail, P.pensja FROM Zlecenia_uslug ZU
INNER JOIN Uslugi U ON ZU.ID_Uslugi = U.ID_Uslugi
INNER JOIN Pracownicy_zlecen PZ ON ZU.ID_Zlecenia_uslugi = PZ.ID_Zlecenia_uslugi
INNER JOIN Pracownicy P ON PZ.ID_Pracownika = P.ID_Pracownika
INNER JOIN Osoby O ON P.ID_Osoby = O.ID_Osoby
WHERE ZU.data_realizacji_uslugi > sysdate-30
GROUP BY PZ.ID_Pracownika, O.imie, O.Nazwisko, 
O.PESEL, O.nr_telefonu, O.mail, P.pensja
ORDER BY ZYSK_NETTO DESC;

SELECT * FROM zysk_pracownicy_netto;

DROP VIEW zysk_pracownicy_netto;

