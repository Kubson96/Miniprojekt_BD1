--Widok klient:
CREATE OR REPLACE VIEW W_klient
AS
SELECT Kat.Nazwa AS Kategoria, Producent.nazwa AS Nazwa_producenta, Produkt.kod_produktu, Produkt.nazwa AS Nazwa_produktu, Produkt.opis, Produkt.cena_netto, Produkt.ilosc AS Ilosc_sztuk, Produkt.stawka_vat, Produkt.rok_produkcji, Produkt.mies_gwarancji, Produkt.procent_promocji FROM Produkty Produkt
INNER JOIN Kategorie_produktow Kat ON Kat.ID_Kategorii_prod = Produkt.ID_Kategorii_prod
INNER JOIN Producenci Producent ON Producent.ID_Producenta = Produkt.ID_Producenta;

SELECT * FROM W_klient;

DROP VIEW W_klient;


--Widok kadrowa:
CREATE OR REPLACE VIEW W_kadrowa AS
SELECT O.imie, O.Nazwisko, O.PESEL, O.nr_telefonu, O.mail, O.plec, P.pensja, P.Data_zatrudnienia, P.Stan_zdrowia, P.Data_Badania_okr, P.Szczepiony,
SUM(U.cena_netto) AS ZYSK_NETTO, SUM(U.cena_netto)-P.pensja AS Bilans_dla_firmy FROM Pracownicy P
INNER JOIN Pracownicy_zlecen PZ ON P.ID_Pracownika = PZ.ID_Pracownika
INNER JOIN Zlecenia_Uslug ZU ON ZU.ID_Zlecenia_Uslugi = PZ.ID_Zlecenia_Uslugi
INNER JOIN Uslugi U ON ZU.ID_Uslugi = U.ID_Uslugi
INNER JOIN Osoby O ON P.ID_Osoby = O.ID_Osoby
WHERE ZU.data_realizacji_uslugi > sysdate-30
GROUP BY O.imie, O.Nazwisko, O.PESEL, O.nr_telefonu, O.mail, O.plec, P.pensja, P.Data_zatrudnienia, P.Stan_zdrowia, P.Data_Badania_okr, P.Szczepiony
ORDER BY ZYSK_NETTO DESC;

SELECT * FROM W_kadrowa;

DROP VIEW W_kadrowa;


--Widok księgowa:
CREATE OR REPLACE VIEW W_ksiegowa AS

SELECT SUM (PR.cena_netto) AS ZYSK_NETTO, Z.ID_Zamowienia, 
PR.kod_produktu, PR.nazwa, PRD.nazwa AS NAZWA_PRODUCENTA, PR.cena_netto, ZP.ilosc FROM Zamowienia Z
INNER JOIN Zamowienia_produkty ZP ON Z.ID_Zamowienia = ZP.ID_Zamowienia
INNER JOIN Produkty PR ON PR.ID_Produktu = ZP.ID_Produktu
INNER JOIN Producenci PRD ON PR.ID_Producenta = PRD.ID_Producenta
WHERE Z.data_realizacji_zamowienia > sysdate-30 AND Z.czy_zrealizowano_zamowienie LIKE '1'
GROUP BY Z.ID_Zamowienia, PR.kod_produktu, PR.nazwa, 
PRD.nazwa, PR.cena_netto, ZP.ilosc
ORDER BY ZYSK_NETTO DESC;

SELECT * FROM W_ksiegowa;

DROP VIEW W_ksiegowa;

