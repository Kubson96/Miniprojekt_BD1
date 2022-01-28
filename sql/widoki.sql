--Widok klient - do usuniecia:
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

--DROP VIEW W_kadrowa;


--Widok księgowa:
CREATE OR REPLACE VIEW W_ksiegowa AS

SELECT SUM (PR.cena_netto) AS ZYSK_NETTO, Z.ID_Zamowienia, 
PR.kod_produktu, PR.nazwa, PRD.nazwa AS NAZWA_PRODUCENTA, PR.cena_netto, COUNT(*) AS ILOSC FROM Zamowienia Z
INNER JOIN Zamowienia_produkty ZP ON Z.ID_Zamowienia = ZP.ID_Zamowienia
INNER JOIN Produkty PR ON PR.ID_Produktu = ZP.ID_Produktu
INNER JOIN Producenci PRD ON PR.ID_Producenta = PRD.ID_Producenta
WHERE Z.data_realizacji_zamowienia > sysdate-30 AND Z.czy_zrealizowano_zamowienie LIKE '1'
GROUP BY Z.ID_Zamowienia, PR.kod_produktu, PR.nazwa, 
PRD.nazwa, PR.cena_netto, ZP.ilosc
ORDER BY ZYSK_NETTO DESC;

SELECT * FROM W_ksiegowa;

--DROP VIEW W_ksiegowa;


--Widok Klient:
CREATE OR REPLACE VIEW W_klient AS

SELECT P.ID_Produktu, KT.nazwa AS NAZWA_KATEGORII, P.nazwa, P.opis, ROUND(P.cena_netto*(1+P.stawka_vat/100), 2) AS CENA_BRUTTO, 
P.ilosc, P.kod_produktu, PRD.nazwa AS NAZWA_PROD, P.mies_gwarancji 
FROM Produkty P 
INNER JOIN Producenci PRD ON P.ID_Producenta = PRD.ID_Producenta 
INNER JOIN kategorie_produktow KT ON P.ID_Kategorii_prod = KT.ID_Kategorii_prod;

SELECT * FROM W_klient;

--DROP VIEW W_klient;


--Widok Zamowienia klienta:
CREATE OR REPLACE VIEW W_zamowienia_klienta AS

SELECT Z.ID_Klienta, P.nazwa, P.kod_produktu, ROUND(P.cena_netto*(1+P.stawka_vat/100), 2) AS CENA_BRUTTO, 
ZP.ilosc, TO_CHAR(Z.data_zlozenia_zamowienia, 'YYYY/MM/DD HH24:MI:SS') AS data_zlozenia_zamowienia, Z.czy_przyjeto_zamowienie, TO_CHAR(Z.data_realizacji_zamowienia, 'YYYY/MM/DD HH24:MI:SS') AS data_realizacji_zamowienia, 
Z.czy_zrealizowano_zamowienie, Z.czy_do_wysylki FROM Zamowienia_produkty ZP
INNER JOIN Zamowienia Z ON ZP.ID_Zamowienia = Z.ID_Zamowienia
INNER JOIN Produkty P ON ZP.ID_Produktu = P.ID_Produktu;

SELECT * FROM W_zamowienia_klienta;

--DROP VIEW W_zamowienia_klienta;


--Wybor klienta:
CREATE OR REPLACE VIEW W_wybor_klienta AS

SELECT K.ID_Klienta, O.imie, O.nazwisko, O.nr_telefonu, O.mail, K.nip FROM Klienci K
INNER JOIN Osoby O ON K.ID_Osoby = O.ID_Osoby;

SELECT * FROM W_wybor_klienta;

--DROP VIEW W_wybor_kilenta;


--Adres klienta:
CREATE OR REPLACE VIEW W_adres_klienta AS

SELECT K.ID_Klienta, A.* FROM Klienci K 
INNER JOIN Osoby O ON K.ID_Osoby = O.ID_Osoby 
INNER JOIN Adresy A ON O.ID_Adresu = A.ID_Adresu;

SELECT * FROM W_adres_klienta;

--DROP VIEW W_adres_kilenta;
