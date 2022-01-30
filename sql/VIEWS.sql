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
SELECT O.imie, O.Nazwisko, O.PESEL, O.nr_telefonu, O.mail, O.plec, P.pensja, 
TO_CHAR(P.Data_zatrudnienia, 'YYYY/MM/DD HH24:MI:SS') AS Data_zatrudnienia, P.Stan_zdrowia, 
TO_CHAR(P.Data_Badania_okr, 'YYYY/MM/DD HH24:MI:SS') AS Data_Badania_okr, P.Szczepiony AS SZCZEPIONY,
ROUND(SUM(U.cena_netto), 2) AS ZYSK_NETTO, ROUND(SUM(U.cena_netto)-P.pensja, 2) AS Bilans_dla_firmy FROM Pracownicy P
INNER JOIN Pracownicy_zlecen PZ ON P.ID_Pracownika = PZ.ID_Pracownika
INNER JOIN Zlecenia_Uslug ZU ON ZU.ID_Zlecenia_Uslugi = PZ.ID_Zlecenia_Uslugi
INNER JOIN Uslugi U ON ZU.ID_Uslugi = U.ID_Uslugi
INNER JOIN Osoby O ON P.ID_Osoby = O.ID_Osoby
WHERE ZU.data_realizacji_uslugi > sysdate-30
GROUP BY O.imie, O.Nazwisko, O.PESEL, O.nr_telefonu, O.mail, O.plec, P.pensja, P.Data_zatrudnienia, P.Stan_zdrowia, 
P.Data_Badania_okr, P.Szczepiony
ORDER BY ZYSK_NETTO DESC;

SELECT * FROM W_kadrowa;

--DROP VIEW W_kadrowa;


--Widok kadrowa wszyscy prcowników:
CREATE OR REPLACE VIEW W_kadrowa_wszyscy_prac AS
SELECT O.imie, O.Nazwisko, O.PESEL, A.ulica, A.nr_budynku, A.nr_mieszkania, A.miasto,
O.nr_telefonu, O.mail, O.plec, P.pensja, 
TO_CHAR(P.Data_zatrudnienia, 'YYYY/MM/DD HH24:MI:SS') AS Data_zatrudnienia, P.Stan_zdrowia, 
TO_CHAR(P.Data_Badania_okr, 'YYYY/MM/DD HH24:MI:SS') AS Data_Badania_okr, P.Szczepiony AS SZCZEPIONY,
P.uwagi
FROM Pracownicy P
INNER JOIN Osoby O ON P.ID_Osoby = O.ID_Osoby
INNER JOIN Adresy A ON O.ID_Adresu = A.ID_Adresu
WHERE O.ID_Osoby = P.ID_Osoby;

SELECT * FROM W_kadrowa_wszyscy_prac;

--DROP VIEW W_kadrowa_wszyscy_prac;


--Widok kadrowa hierarchia prcowników:
CREATE OR REPLACE VIEW W_kadrowa_hierarchia_prac AS
SELECT P.ID_Pracownika, O.imie, O.Nazwisko, O.PESEL, P.ID_Przelozonego
FROM Pracownicy P
INNER JOIN Osoby O ON P.ID_Osoby = O.ID_Osoby
INNER JOIN Adresy A ON O.ID_Adresu = A.ID_Adresu
WHERE O.ID_Osoby = P.ID_Osoby;

SELECT * FROM W_kadrowa_hierarchia_prac;

--DROP VIEW W_kadrowa_hierarchia_prac;


--Widok kadrowa stanowiska prcowników:
CREATE OR REPLACE VIEW W_kadrowa_stanowiska_prac AS
SELECT SP.ID_Pracownika AS ID_Pracownika, ST.nazwa, ST.obowiazki
FROM Stanowiska_pracownikow SP
INNER JOIN Pracownicy P ON SP.ID_Pracownika = P.ID_Pracownika
INNER JOIN Stanowiska ST ON SP.ID_Stanowiska = ST.ID_Stanowiska;

SELECT * FROM W_kadrowa_stanowiska_prac;

--DROP VIEW W_kadrowa_stanowiska_prac;


--Widok księgowa produkty:
CREATE OR REPLACE VIEW W_ksiegowa_produkty AS

SELECT ROUND(SUM(PR.cena_netto), 2) AS ZYSK_NETTO, Z.ID_Zamowienia, 
PR.kod_produktu, PR.nazwa, PRD.nazwa AS NAZWA_PRODUCENTA, PR.cena_netto, COUNT(*) AS ILOSC FROM Zamowienia Z
INNER JOIN Zamowienia_produkty ZP ON Z.ID_Zamowienia = ZP.ID_Zamowienia
INNER JOIN Produkty PR ON PR.ID_Produktu = ZP.ID_Produktu
INNER JOIN Producenci PRD ON PR.ID_Producenta = PRD.ID_Producenta
WHERE Z.data_realizacji_zamowienia > sysdate-30 AND Z.czy_zrealizowano_zamowienie LIKE '1'
GROUP BY Z.ID_Zamowienia, PR.kod_produktu, PR.nazwa, 
PRD.nazwa, PR.cena_netto, ZP.ilosc
ORDER BY ZYSK_NETTO DESC;

SELECT * FROM W_ksiegowa_produkty;

--DROP VIEW W_ksiegowa_produkty;


--Widok księgowa uslugi:
CREATE OR REPLACE VIEW W_ksiegowa_uslugi AS

SELECT ROUND(SUM(U.cena_netto), 2) AS ZYSK_NETTO, ZU.ID_Zlecenia_Uslugi, 
U.ID_Uslugi, U.nazwa AS NAZWA_USLUGI, U.cena_netto, COUNT(*) AS ILOSC FROM Zlecenia_uslug ZU
INNER JOIN Uslugi U ON ZU.ID_Uslugi = U.ID_Uslugi
WHERE ZU.data_realizacji_uslugi > sysdate-30 AND ZU.czy_zrealizowano_usluge LIKE '1'
GROUP BY U.cena_netto, ZU.ID_Zlecenia_Uslugi, 
U.ID_Uslugi, U.nazwa, U.cena_netto
ORDER BY ZYSK_NETTO DESC;

SELECT * FROM W_ksiegowa_uslugi;

--DROP VIEW W_ksiegowa_uslugi;

--Widok księgowa pracownicy uslug:
CREATE OR REPLACE VIEW W_ksiegowa_prac_us AS

SELECT DISTINCT O.imie, O.nazwisko, O.PESEL, ZU.ID_Zlecenia_Uslugi FROM Osoby O
INNER JOIN Pracownicy P ON O.ID_Osoby = P.ID_Osoby
INNER JOIN Pracownicy_zlecen PZ ON P.ID_Pracownika = PZ.ID_Pracownika
INNER JOIN Zlecenia_Uslug ZU ON PZ.ID_Zlecenia_Uslugi = ZU.ID_Zlecenia_Uslugi;

SELECT * FROM W_ksiegowa_prac_us;

--DROP VIEW W_ksiegowa_prac_us;

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
ZP.ilosc, TO_CHAR(Z.data_zlozenia_zamowienia, 'YYYY/MM/DD HH24:MI:SS') AS data_zlozenia_zamowienia, 
Z.czy_przyjeto_zamowienie, Z.czy_zrealizowano_zamowienie,
 TO_CHAR(Z.data_realizacji_zamowienia, 'YYYY/MM/DD HH24:MI:SS') AS data_realizacji_zamowienia, 
 Z.czy_do_wysylki FROM Zamowienia_produkty ZP
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

--widok magazyniera
CREATE OR REPLACE VIEW W_magazynier
AS
SELECT P.Nazwa AS Nazwa, P.Kod_produktu, P.Ilosc, LP.Nazwa AS Budynek,LP.Nr_Budynku FROM Produkty P, Lokalizacje_produktow LP WHERE P.ID_LOKALIZACJI_PROD=LP.ID_LOKALIZACJI ORDER BY P.Ilosc ASC;

SELECT * FROM W_magazynier;

--DROP VIEW W_magazynier;

--widok dostawcy
CREATE OR REPLACE VIEW W_dostawca
AS
SELECT Z.ID_Zamowienia, A.Miasto || ', ' || A.Ulica || ' ' || A.NR_Budynku ||'/' ||A.NR_Mieszkania AS "Adres dostawy", Z.Data_przyjecia_zamowienia FROM Zamowienia Z, Adresy A WHERE A.ID_Adresu = Z.ID_Adresu_wysylki AND Z.Czy_przyjeto_zamowienie = 1 AND Z.Czy_zrealizowano_zamowienie = 0;

SELECT * FROM W_dostawca;

--DROP VIEW W_dostawca;

