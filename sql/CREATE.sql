CREATE TABLE Adresy (
    ID_Adresu         NUMBER(7) NOT NULL CONSTRAINT Adresy_pk PRIMARY KEY,
    miasto            VARCHAR2(255) NOT NULL,
    ulica             VARCHAR2(255) NOT NULL,
    nr_budynku        VARCHAR2(10) NOT NULL,
	nr_mieszkania     VARCHAR2(10)
);

CREATE TABLE Osoby (
    ID_Osoby          NUMBER(7) NOT NULL CONSTRAINT Osoby_pk PRIMARY KEY,
    ID_Adresu         NUMBER(7) NOT NULL,
    Imie              VARCHAR2(30) NOT NULL,
    Nazwisko          VARCHAR2(45) NOT NULL,
	Data_ur           DATE NOT NULL,
	PESEL             VARCHAR2(11) NOT NULL,
	nr_telefonu       VARCHAR2(20) NOT NULL,
	mail              VARCHAR2(75) NOT NULL,
	plec              CHAR(1) NOT NULL,
	UNIQUE(PESEL),
	UNIQUE(nr_telefonu)
);

ALTER TABLE Osoby ADD CONSTRAINT Osoby_Adresy_fk FOREIGN KEY ( ID_Adresu )
    REFERENCES Adresy ( ID_Adresu )
NOT DEFERRABLE;

CREATE TABLE Klienci (
    ID_Klienta        NUMBER(7) NOT NULL CONSTRAINT Klienci_pk PRIMARY KEY,
    ID_Osoby          NUMBER(7) NOT NULL,
    data_rejestracji  DATE NOT NULL,
    uwagi             VARCHAR2(255),
	NIP               NUMBER(10)
);

ALTER TABLE Klienci ADD CONSTRAINT Klient_Osoby_fk FOREIGN KEY ( ID_Osoby )
    REFERENCES Osoby ( ID_Osoby )
NOT DEFERRABLE;

CREATE TABLE Stanowiska (
    ID_Stanowiska     NUMBER(7) NOT NULL CONSTRAINT Stanowiska_pk PRIMARY KEY,
    nazwa             VARCHAR2(55) NOT NULL,
    obowiazki         VARCHAR2(255) NOT NULL
);

CREATE TABLE Pracownicy (
    ID_Pracownika            NUMBER(7) NOT NULL CONSTRAINT Pracownicy_pk PRIMARY KEY,
    ID_Osoby                 NUMBER(7) NOT NULL,
    ID_Przelozonego          NUMBER(7) NOT NULL,
    data_zatrudnienia        DATE NOT NULL,
	pensja                   NUMBER(5) NOT NULL,
	stan_zdrowia             VARCHAR2(255),
	data_badania_okr         DATE NOT NULL,
	szczepiony               CHAR(1) NOT NULL,
	uwagi                    VARCHAR2(255)
);

ALTER TABLE Pracownicy ADD CONSTRAINT Pracownicy_Osoby_fk FOREIGN KEY ( ID_Osoby )
    REFERENCES Osoby ( ID_Osoby )
NOT DEFERRABLE;
ALTER TABLE Pracownicy ADD CONSTRAINT Pracownicy_Prac_przelozeni_fk FOREIGN KEY ( ID_Przelozonego )
    REFERENCES Pracownicy ( ID_Osoby )
NOT DEFERRABLE;

CREATE TABLE Stanowiska_pracownikow (
    ID_Stanowiska_prac       NUMBER(7) NOT NULL CONSTRAINT Stanowiska_pracownikow_pk PRIMARY KEY,
    ID_Stanowiska            NUMBER(7) NOT NULL,
    ID_Pracownika            NUMBER(7) NOT NULL
);

ALTER TABLE Stanowiska_pracownikow ADD CONSTRAINT Stanow_prac_Stanowiska_fk FOREIGN KEY ( ID_Stanowiska )
    REFERENCES Stanowiska ( ID_Stanowiska )
NOT DEFERRABLE;
ALTER TABLE Stanowiska_pracownikow ADD CONSTRAINT Stanow_prac_Pracownicy_fk FOREIGN KEY ( ID_Pracownika )
    REFERENCES Pracownicy ( ID_Pracownika )
NOT DEFERRABLE;

CREATE TABLE Kategorie_produktow (
    ID_Kategorii_prod        NUMBER(7) NOT NULL CONSTRAINT Kategorie_produktow_pk PRIMARY KEY,
    nazwa                    VARCHAR2(55) NOT NULL UNIQUE,
    opis                     VARCHAR2(255) NOT NULL,
	gabaryt                  CHAR(1) NOT NULL
);

CREATE TABLE Producenci (
    ID_Producenta            NUMBER(7) NOT NULL CONSTRAINT Producenci_pk PRIMARY KEY,
    nazwa                    VARCHAR2(55) NOT NULL UNIQUE
);


CREATE TABLE Lokalizacje_produktow (
    ID_Lokalizacji           NUMBER(7) NOT NULL CONSTRAINT Lokalizacje_produktow_pk PRIMARY KEY,
    nazwa                    VARCHAR2(25) NOT NULL UNIQUE,
    nr_budynku               VARCHAR2(5) NOT NULL UNIQUE,
	uwagi                    VARCHAR2(255),
	UNIQUE(nazwa, nr_budynku)
);

CREATE TABLE Produkty (
    ID_Produktu              NUMBER(7) NOT NULL CONSTRAINT Produkty_pk PRIMARY KEY,
    ID_Kategorii_prod        NUMBER(7) NOT NULL,
    ID_Producenta            NUMBER(7) NOT NULL,
    ID_Lokalizacji_prod      NUMBER(7) NOT NULL,
    kod_produktu             VARCHAR2(10) NOT NULL UNIQUE,
	nazwa                    VARCHAR2(65) NOT NULL,
	opis                     VARCHAR2(255) NOT NULL,
	cena_netto               NUMBER(7, 2) NOT NULL,
	ilosc                    NUMBER(5) NOT NULL,
	stawka_vat               NUMBER(4, 2) NOT NULL,
	rok_produkcji            CHAR(4) NOT NULL,
	mies_gwarancji           NUMBER(3) NOT NULL,
	procent_promocji         NUMBER(3)
);

ALTER TABLE Produkty ADD CONSTRAINT Produkty_Kat_prod_fk FOREIGN KEY ( ID_Kategorii_prod )
    REFERENCES Kategorie_produktow ( ID_Kategorii_prod )
NOT DEFERRABLE;
ALTER TABLE Produkty ADD CONSTRAINT Produkty_Producenci_fk FOREIGN KEY ( ID_Producenta )
    REFERENCES Producenci ( ID_Producenta )
NOT DEFERRABLE;
ALTER TABLE Produkty ADD CONSTRAINT Produkty_Kokali_prod_fk FOREIGN KEY ( ID_Lokalizacji_prod )
    REFERENCES Lokalizacje_produktow ( ID_Lokalizacji )
NOT DEFERRABLE;

CREATE TABLE Zamowienia (
    ID_Zamowienia                 NUMBER(7) NOT NULL CONSTRAINT Zamowienia_pk PRIMARY KEY,
    ID_Klienta                    NUMBER(7) NOT NULL,
    data_zlozenia_zamowienia      DATE NOT NULL,
    czy_przyjeto_zamowienie       CHAR(1) NOT NULL,
    data_przyjecia_zamowienia     DATE NOT NULL,
	czy_zrealizowano_zamowienie   CHAR(1) NOT NULL,
	data_realizacji_zamowienia    DATE NOT NULL,
	czy_do_wysylki                CHAR(1) NOT NULL,
	ID_Adresu_wysylki             NUMBER(7) NOT NULL
);

ALTER TABLE Zamowienia ADD CONSTRAINT Zamowienia_Klienci_fk FOREIGN KEY ( ID_Klienta )
    REFERENCES Klienci ( ID_Klienta )
NOT DEFERRABLE;
ALTER TABLE Zamowienia ADD CONSTRAINT Zamowienia_Adresy_fk FOREIGN KEY ( ID_Adresu_wysylki )
    REFERENCES Adresy ( ID_Adresu )
NOT DEFERRABLE;

CREATE TABLE Zamowienia_produkty (
    ID_Zamowienia_prod     NUMBER(7) NOT NULL CONSTRAINT Zamowienia_prod_pk PRIMARY KEY,
    ID_Produktu            NUMBER(7) NOT NULL,
    ID_Zamowienia          NUMBER(7) NOT NULL,
    ilosc                  NUMBER(3) NOT NULL
);

ALTER TABLE Zamowienia_produkty ADD CONSTRAINT Zam_prod_Produkty_fk FOREIGN KEY ( ID_Produktu )
    REFERENCES Produkty ( ID_Produktu )
NOT DEFERRABLE;
ALTER TABLE Zamowienia_produkty ADD CONSTRAINT Zam_prod_Zamowienia_fk FOREIGN KEY ( ID_Zamowienia )
    REFERENCES Zamowienia ( ID_Zamowienia )
NOT DEFERRABLE;

CREATE TABLE Uslugi (
    ID_Uslugi        NUMBER(7) NOT NULL CONSTRAINT Uslugi_pk PRIMARY KEY,
    nazwa            VARCHAR2(55) NOT NULL UNIQUE,
    opis             VARCHAR2(255) NOT NULL,
    cena_netto       NUMBER(7, 2) NOT NULL,
    stawka_vat       NUMBER(4, 2) NOT NULL
);

CREATE TABLE Zlecenia_uslug (
    ID_Zlecenia_uslugi               NUMBER(7) NOT NULL CONSTRAINT Zlecenia_uslugi_pk PRIMARY KEY,
    ID_Klienta                       NUMBER(7)  NOT NULL,
    ID_Uslugi                        NUMBER(7)  NOT NULL,
    data_zlozenia_zlecenia           DATE  NOT NULL,
    czy_przyjeto_zlecenie            CHAR(1)  NOT NULL,
	data_przyjecia_zlecenia          DATE  NOT NULL,
	czy_zrealizowano_usluge          CHAR(1)  NOT NULL,
	data_realizacji_uslgi            DATE  NOT NULL
);

ALTER TABLE Zlecenia_uslug ADD CONSTRAINT Zlec_uslug_Klienci_fk FOREIGN KEY ( ID_Klienta )
    REFERENCES Klienci ( ID_Klienta )
NOT DEFERRABLE;
ALTER TABLE Zlecenia_uslug ADD CONSTRAINT Zlec_uslug_Uslugi_fk FOREIGN KEY ( ID_Uslugi )
    REFERENCES Uslugi ( ID_Uslugi )
NOT DEFERRABLE;

CREATE TABLE Pracownicy_zlecen (
    ID_Pracownicy_zlecen     NUMBER(7) NOT NULL CONSTRAINT Pracownicy_zlecen_pk PRIMARY KEY,
    ID_Pracownika            NUMBER(7) NOT NULL,
    ID_Zlecenia_uslugi       NUMBER(7) NOT NULL
);

ALTER TABLE Pracownicy_zlecen ADD CONSTRAINT Pracow_zlecen_Pracownicy_fk FOREIGN KEY ( ID_Pracownika )
    REFERENCES Pracownicy ( ID_Pracownika )
NOT DEFERRABLE;
ALTER TABLE Pracownicy_zlecen ADD CONSTRAINT Pracow_zlecen_Zlec_uslug_fk FOREIGN KEY ( ID_Zlecenia_uslugi )
    REFERENCES Zlecenia_uslug ( ID_Zlecenia_uslugi )
NOT DEFERRABLE;

