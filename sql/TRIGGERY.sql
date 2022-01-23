-- 1

CREATE OR REPLACE PROCEDURE wlacz_logi_t_pracownicy
AS
juz_utworzono_tabele EXCEPTION;
juz_utworzono_sekwencje EXCEPTION;
l_cnt PLS_INTEGER;
l_seq_cnt PLS_INTEGER;
BEGIN

SELECT COUNT(*)
	INTO l_cnt
FROM user_tables
WHERE TABLE_NAME LIKE 'PRACOWNICY_LOG';

SELECT COUNT(*)
	INTO l_seq_cnt
FROM user_sequences
WHERE SEQUENCE_NAME LIKE 'PRACOWNICY_LOG_SEQ';

IF ( l_seq_cnt < 1 ) THEN

	EXECUTE IMMEDIATE 'CREATE SEQUENCE pracownicy_log_seq NOCYCLE ORDER';
	
	DBMS_OUTPUT.PUT_LINE('Utworzono sekwencje do tabeli z logami zmian tabeli pracownicy.');
	
ELSE
	RAISE juz_utworzono_sekwencje;
	
END IF;

IF ( l_cnt < 1 ) THEN

EXECUTE IMMEDIATE 'CREATE TABLE pracownicy_log(
	id_log NUMBER(7) CONSTRAINT Pracownik_log_pk PRIMARY KEY,
	type NUMBER(1),
	data DATE,
	uzytkownik VARCHAR2(20),
	old_id_pracownika NUMBER(7),
	new_id_pracownika NUMBER(7),
	old_id_osoby NUMBER(7),
	new_id_osoby NUMBER(7),
	old_id_przelozonego NUMBER(7),
	new_id_przelozonego NUMBER(7),
	old_data_zatrudnienia DATE,
	new_data_zatrudnienia DATE,
	old_pensja NUMBER(5),
	new_pensja NUMBER(5),
	old_stan_zdrowia VARCHAR2(255),
	new_stan_zdrowia VARCHAR2(255),
	old_data_badania_okr DATE,
	new_data_badania_okr DATE,
	old_szczpiony CHAR(1),
	new_szczpiony CHAR(1),
	old_uwagi VARCHAR2(255),
	new_uwagi VARCHAR2(255)
)';

DBMS_OUTPUT.PUT_LINE('Utworzono tabele z logami tabeli pracownicy.');

ELSE
	RAISE juz_utworzono_tabele;

END IF;

EXCEPTION
WHEN juz_utworzono_sekwencje THEN
	DBMS_OUTPUT.PUT_LINE('Sekwencja pracownicy_log_seq juz istnieje.');
	return;
WHEN juz_utworzono_tabele THEN
	DBMS_OUTPUT.PUT_LINE('Tabela pracownicy_log juz istnieje.');
	return;

END;
/

EXEC wlacz_logi_t_pracownicy;

DROP TABLE pracownicy_log;
DROP SEQUENCE pracownicy_log_seq;
DROP PROCEDURE wlacz_logi_t_pracownicy;

CREATE OR REPLACE TRIGGER pracownicy_trigger
AFTER INSERT OR UPDATE OR DELETE ON Pracownicy
FOR EACH ROW
BEGIN

CASE

WHEN INSERTING THEN
	INSERT INTO pracownicy_log (id_log, type, data, uzytkownik, new_id_pracownika)
	VALUES (pracownicy_log_seq.nextval, 0, SYSDATE, ORA_LOGIN_USER, :NEW.ID_Pracownika);
	
WHEN UPDATING THEN
	INSERT INTO pracownicy_log (id_log, type, data, uzytkownik, 
	old_id_pracownika, new_id_pracownika, 
	old_id_osoby, new_id_osoby,
	old_id_przelozonego, new_id_przelozonego, 
	old_data_zatrudnienia, new_data_zatrudnienia, 
	old_pensja, new_pensja,
	old_stan_zdrowia, new_stan_zdrowia,
	old_data_badania_okr, new_data_badania_okr,
	old_szczpiony, new_szczpiony,
	old_uwagi, new_uwagi)
	VALUES (pracownicy_log_seq.nextval, 1, SYSDATE, ORA_LOGIN_USER, 
	:OLD.ID_Pracownika, :NEW.ID_Pracownika,
	:OLD.ID_Osoby, :NEW.ID_Osoby, 
	:OLD.ID_Przelozonego, :NEW.ID_Przelozonego, 
	:OLD.data_zatrudnienia, :NEW.data_zatrudnienia,
	:OLD.pensja, :NEW.pensja,
	:OLD.stan_zdrowia, :NEW.stan_zdrowia,
	:OLD.data_badania_okr, :NEW.data_badania_okr,
	:OLD.szczepiony, :NEW.szczepiony,
	:OLD.uwagi, :NEW.uwagi);
	
WHEN DELETING THEN
	INSERT INTO pracownicy_log (id_log, type, data, uzytkownik, old_id_pracownika)
	VALUES (pracownicy_log_seq.nextval, 2, SYSDATE, ORA_LOGIN_USER, :OLD.ID_Pracownika);

END CASE;

END;
/

DROP TRIGGER pracownicy_trigger;

-- 2

CREATE OR REPLACE PROCEDURE wlacz_logi_t_zamowienia
AS
juz_utworzono_tabele EXCEPTION;
juz_utworzono_sekwencje EXCEPTION;
l_cnt PLS_INTEGER;
l_seq_cnt PLS_INTEGER;
BEGIN

SELECT COUNT(*)
	INTO l_cnt
FROM user_tables
WHERE TABLE_NAME LIKE 'ZAMOWIENIA_LOG';

SELECT COUNT(*)
	INTO l_seq_cnt
FROM user_sequences
WHERE SEQUENCE_NAME LIKE 'ZAMOWIENIA_LOG_SEQ';

IF ( l_seq_cnt < 1 ) THEN

	EXECUTE IMMEDIATE 'CREATE SEQUENCE zamowienia_log_seq NOCYCLE ORDER';
	
	DBMS_OUTPUT.PUT_LINE('Utworzono sekwencje do tabeli z logami zmian tabeli zamowienia.');
	
ELSE
	RAISE juz_utworzono_sekwencje;
	
END IF;

IF ( l_cnt < 1 ) THEN

EXECUTE IMMEDIATE 'CREATE TABLE zamowienia_log(
	id_log NUMBER(7) CONSTRAINT Zamowienie_log_pk PRIMARY KEY,
	type NUMBER(1),
	data DATE,
	uzytkownik VARCHAR2(20),
	old_id_zamowienia NUMBER(7),
	new_id_zamowienia NUMBER(7),
	old_id_klienta NUMBER(7),
	new_id_klienta NUMBER(7),
	old_data_zlozenia_zamowienia DATE,
	new_data_zlozenia_zamowienia DATE,
	old_czy_przyjeto_zamowienie CHAR(1),
	new_czy_przyjeto_zamowienie CHAR(1),
	old_data_przyjecia_zamowienia DATE,
	new_data_przyjecia_zamowienia DATE,
	old_czy_zrealizowano_zamowienie CHAR(1),
	new_czy_zrealizowano_zamowienie CHAR(1),
	old_data_realizacji_zamowienia DATE,
	new_data_realizacji_zamowienia DATE,
	old_czy_do_wysylki CHAR(1),
	new_czy_do_wysylki CHAR(1),
	old_id_adresu_wysylki NUMBER(7),
	new_id_adresu_wysylki NUMBER(7)
)';

DBMS_OUTPUT.PUT_LINE('Utworzono tabele z logami tabeli zamowienia.');

ELSE
	RAISE juz_utworzono_tabele;

END IF;

EXCEPTION
WHEN juz_utworzono_sekwencje THEN
	DBMS_OUTPUT.PUT_LINE('Sekwencja zamowienia_log_seq juz istnieje.');
	return;
WHEN juz_utworzono_tabele THEN
	DBMS_OUTPUT.PUT_LINE('Tabela zamowienia_log juz istnieje.');
	return;

END;
/

EXEC wlacz_logi_t_zamowienia;

DROP TABLE zamowienia_log;
DROP SEQUENCE zamowienia_log_seq;
DROP PROCEDURE wlacz_logi_t_zamowienia;

CREATE OR REPLACE TRIGGER zamowienia_trigger
AFTER INSERT OR UPDATE OR DELETE ON Zamowienia
FOR EACH ROW
BEGIN

CASE

WHEN INSERTING THEN
	INSERT INTO zamowienia_log (id_log, type, data, uzytkownik, new_id_zamowienia)
	VALUES (zamowienia_log_seq.nextval, 0, SYSDATE, ORA_LOGIN_USER, :NEW.ID_Zamowienia);
	
WHEN UPDATING THEN
	INSERT INTO zamowienia_log (id_log, type, data, uzytkownik, 
	old_id_zamowienia, new_id_zamowienia, 
	old_id_klienta, new_id_klienta,
	old_data_zlozenia_zamowienia, new_data_zlozenia_zamowienia,
	old_czy_przyjeto_zamowienie, new_czy_przyjeto_zamowienie,
	old_data_przyjecia_zamowienia, new_data_przyjecia_zamowienia,
	old_czy_zrealizowano_zamowienie, new_czy_zrealizowano_zamowienie,
	old_data_realizacji_zamowienia, new_data_realizacji_zamowienia,
	old_czy_do_wysylki, new_czy_do_wysylki,
	old_id_adresu_wysylki, new_id_adresu_wysylki)
	VALUES (zamowienia_log_seq.nextval, 1, SYSDATE, ORA_LOGIN_USER, 
	:OLD.ID_Zamowienia, :NEW.ID_Zamowienia,
	:OLD.ID_Klienta, :NEW.ID_Klienta, 
	:OLD.data_zlozenia_zamowienia, :NEW.data_zlozenia_zamowienia, 
	:OLD.czy_przyjeto_zamowienie, :NEW.czy_przyjeto_zamowienie,
	:OLD.data_przyjecia_zamowienia, :NEW.data_przyjecia_zamowienia,
	:OLD.czy_zrealizowano_zamowienie, :NEW.czy_zrealizowano_zamowienie,
	:OLD.data_realizacji_zamowienia, :NEW.data_realizacji_zamowienia,
	:OLD.czy_do_wysylki, :NEW.czy_do_wysylki,
	:OLD.id_adresu_wysylki, :NEW.id_adresu_wysylki);
	
WHEN DELETING THEN
	INSERT INTO zamowienia_log (id_log, type, data, uzytkownik, old_id_zamowienia)
	VALUES (zamowienia_log_seq.nextval, 2, SYSDATE, ORA_LOGIN_USER, :OLD.ID_Zamowienia);

END CASE;

END;
/

DROP TRIGGER zamowienia_trigger;