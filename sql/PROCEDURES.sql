CREATE OR REPLACE PROCEDURE Zamow_produkt (ID_Produktu_v IN NUMBER, ID_Klienta_v IN NUMBER, 
										   ilosc_v IN NUMBER, czy_do_wysylki_v IN CHAR,
										   ID_Adresu_v IN NUMBER, kod_odp OUT NUMBER, wiadomosc OUT VARCHAR2)
IS
niedostepna_ilosc EXCEPTION;
blad_klient_id EXCEPTION;
blad_adres_id EXCEPTION;
magazyn_ilosc NUMBER(6) := 0;
id_klienta_t NUMBER := NULL;
id_adresu_t NUMBER := NULL;
BEGIN

	SELECT ilosc INTO magazyn_ilosc FROM Produkty WHERE ID_Produktu = ID_Produktu_v;
	SELECT ID_Klienta INTO id_klienta_t FROM Klienci WHERE ID_Klienta = ID_Klienta_v;
	SELECT ID_Adresu INTO id_adresu_t FROM Adresy WHERE ID_Adresu = ID_Adresu_v;
	
	IF (ilosc_v > magazyn_ilosc) THEN
		RAISE niedostepna_ilosc;
	END IF;
	
	IF (id_klienta_t = NULL) THEN
		RAISE blad_klient_id;
	END IF;
	
	IF (id_adresu_t = NULL) THEN
		RAISE blad_adres_id;
	END IF;

	INSERT INTO Zamowienia VALUES(Zamowienia_ID_Sek.nextval, ID_Klienta_v, sysdate, '0', TO_DATE(1, 'YYYY'), 
	'0', TO_DATE(1, 'YYYY'), czy_do_wysylki_v, ID_Adresu_v);

	INSERT INTO Zamowienia_produkty VALUES(Zamowienia_produkty_ID_Sek.nextval, ID_Produktu_v, 
	Zamowienia_ID_Sek.currval, ilosc_v);
	
	UPDATE Produkty SET ilosc = ilosc - ilosc_v WHERE ID_Produktu = ID_Produktu_v;
	
	EXCEPTION
	WHEN niedostepna_ilosc THEN
		kod_odp := -1;
		wiadomosc := 'Blad: brak wystarczajacej ilosci produktow w magazynie.';
	WHEN blad_klient_id THEN
		kod_odp := -2;
		wiadomosc := 'Blad: podano niepoprawne ID klienta.';
	WHEN blad_adres_id THEN
		kod_odp := -3;
		wiadomosc := 'Blad: podano niepoprawne ID adresu.';

END;
/

DROP PROCEDURE Zamow_produkt;

-- 

CREATE OR REPLACE PROCEDURE Dodaj_pracownika (imie_v IN VARCHAR2, nazwisko_v IN VARCHAR2, 
											  data_ur_v IN VARCHAR2, PESEL_v IN NUMBER,
											  nr_telefonu_v IN VARCHAR2, email_v IN VARCHAR2,
											  plec_v IN VARCHAR2, miasto_v IN VARCHAR2, ulica_v IN VARCHAR2,
											  nr_budynku_v IN VARCHAR2, nr_mieszkania_v IN VARCHAR2,
											  pensja_v IN NUMBER, st_zdrowia_v IN VARCHAR2,
											  data_bad_okresowego_v IN VARCHAR2, szczepiony_v IN VARCHAR2,
											  ID_Stanowiska_v IN NUMBER, ID_Przelozonego_v IN NUMBER,
											  uwagi_v IN VARCHAR2)
IS
BEGIN

INSERT INTO Adresy VALUES(Adresy_ID_Sek.nextval, miasto_v, ulica_v, nr_budynku_v, nr_mieszkania_v);

INSERT INTO Osoby VALUES(Osoby_ID_Sek.nextval, Adresy_ID_Sek.currval, imie_v, nazwisko_v, 
TO_DATE(data_ur_v, 'YYYY-MM-DD'), PESEL_v, nr_telefonu_v, email_v, plec_v);

IF (ID_Przelozonego > 0) THEN

INSERT INTO Pracownicy VALUES(Pracownicy_ID_Sek.nextval, Osoby_ID_Sek.currval, ID_Przelozonego_v, sysdate, pensja_v,
st_zdrowia_v, TO_DATE(data_bad_okresowego_v, 'YYYY-MM-DD'), szczepiony_v, uwagi_v);

ELSE

INSERT INTO Pracownicy VALUES(Pracownicy_ID_Sek.nextval, Osoby_ID_Sek.currval, Osoby_ID_Sek.currval, sysdate, pensja_v,
st_zdrowia_v, TO_DATE(data_bad_okresowego_v, 'YYYY-MM-DD'), szczepiony_v, uwagi_v);

END IF;

INSERT INTO Stanowiska_pracownikow VALUES(Stanowiska_pracownikow_ID_Sek.nextval, ID_Stanowiska_v, 
Pracownicy_ID_Sek.currval);

END;
/

DROP PROCEDURE Dodaj_pracownika;