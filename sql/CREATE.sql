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
    REFERENCES Pracownicy ( ID_Pracownika )
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

CREATE TABLE Kategorie_prouktow (
    ID_Kategorii_prod        NUMBER(7) NOT NULL CONSTRAINT Kategorie_prouktow_pk PRIMARY KEY,
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
