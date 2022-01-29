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