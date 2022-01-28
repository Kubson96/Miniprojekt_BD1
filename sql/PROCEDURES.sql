CREATE OR REPLACE PROCEDURE Zamow_produkt (ID_Produktu IN NUMBER, ID_Klienta IN NUMBER, 
										   ilosc IN NUMBER, czy_do_wysylki IN CHAR,
										   ID_Adresu IN NUMBER, kod_odp OUT NUMBER, wiadomosc OUT VARCHAR2)
IS
BEGIN

	INSERT INTO Zamowienia VALUES(Zamowienia_ID_Sek.nextval, ID_Klienta, sysdate, '0', 0, 
	'0', 0, czy_do_wysylki, ID_Adresu);

	INSERT INTO Zamowienia_produkty VALUES(Zamowienia_produkty_ID_Sek.nextval, ID_Produktu, 
	Zamowienia_ID_Sek.currval, ilosc);

END;
/