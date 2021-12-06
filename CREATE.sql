CREATE TABLE Fabryka (
    ID_ZamowieniaZfab NUMBER NOT NULL,
    ID_Towaru         NUMBER NOT NULL,
    Cena              NUMBER(5, 2) NOT NULL,
    Uwagi             VARCHAR2(255)
);

ALTER TABLE Fabryka ADD CONSTRAINT fabryka_pk PRIMARY KEY ( ID_ZamowieniaZfab );

CREATE TABLE Fabryka_katalog (
    ID_Towaru         NUMBER NOT NULL,
    ID_ZamowienieZfab NUMBER NOT NULL,
    Ilosc             NUMBER NOT NULL
);

ALTER TABLE Fabryka_katalog ADD CONSTRAINT fabryka_katalog_pk PRIMARY KEY ( ID_Towaru );

CREATE TABLE Gwarancja (
    ID_gwarancji  NUMBER NOT NULL,
    Nazwa         VARCHAR2(255) NOT NULL,
    Ubezpieczenie VARCHAR2(255) NOT NULL
);

ALTER TABLE Gwarancja ADD CONSTRAINT Gwarancja_pk PRIMARY KEY ( ID_gwarancji );

CREATE TABLE Informacje_dod (
    ID_Inf           NUMBER NOT NULL,
    Szczepiony       CHAR(1) NOT NULL,
    Stan_zdrowia     VARCHAR2(255) NOT NULL,
    Wymagania        VARCHAR2(255),
    Data_badania_okr DATE NOT NULL,
    Plec             VARCHAR2(255)NOT NULL,
    Dzieci           VARCHAR2(255),
    Uwagi            VARCHAR2(255)
);

ALTER TABLE Informacje_dod ADD CONSTRAINT Informacje_dod_pk PRIMARY KEY ( ID_Inf );

CREATE TABLE Kasa (
    ID_Zamowienia  NUMBER NOT NULL,
    ID_Towaru      NUMBER,
    ID_Uslugi      NUMBER,
    Znizka         VARCHAR2(255),
    Platnosc       VARCHAR2(255),
    Cena_calkowita NUMBER(5, 2),
    Uwagi          VARCHAR2(255),
    Kasjer         NUMBER,
    Data           DATE
);

ALTER TABLE Kasa ADD CONSTRAINT kasa_pk PRIMARY KEY ( ID_Zamowienia );

CREATE TABLE Kasa_towar (
    ID_Zamowienia NUMBER NOT NULL,
    ID_Towaru     NUMBER
);

ALTER TABLE Kasa_towar ADD CONSTRAINT Kasa_towar_pk PRIMARY KEY ( ID_Zamowienia );

CREATE TABLE Kasa_uslugi (
    ID_Zamowienia NUMBER NOT NULL,
    ID_Uslugi     NUMBER
);

ALTER TABLE Kasa_uslugi ADD CONSTRAINT Kasa_uslugi_pk PRIMARY KEY ( ID_Zamowienia );

CREATE TABLE Katalog (
    ID_Towaru  NUMBER NOT NULL,
    Nazwa      VARCHAR2(255) NOT NULL,
    Cena       NUMBER(5, 2) NOT NULL,
    Informacja VARCHAR2(255)
);

ALTER TABLE Katalog ADD CONSTRAINT Katalog_pk PRIMARY KEY ( ID_Towaru );

CREATE TABLE Komplety (
    ID_Komplet    NUMBER NOT NULL,
    Cena_kompletu NUMBER(5, 2) NOT NULL
);

ALTER TABLE Komplety ADD CONSTRAINT Komplety_pk PRIMARY KEY ( ID_Komplet );

CREATE TABLE Kontakt (
    ID_Kontakt    NUMBER NOT NULL,
    Telefon       VARCHAR2(255) NOT NULL,
    Miasto        VARCHAR2(255) NOT NULL,
    Ulica         VARCHAR2(255) NOT NULL,
    Nr_budynku    NUMBER,
    Nr_mieszkania NUMBER,
    Mail          VARCHAR2(255)
);

ALTER TABLE Kontakt ADD CONSTRAINT Kontakt_pk PRIMARY KEY ( ID_Kontakt );

CREATE TABLE Podtypy (
    ID_Podtypu NUMBER NOT NULL,
    Nazwa      VARCHAR2(255)
);

ALTER TABLE Podtypy ADD CONSTRAINT Podtypy_pk PRIMARY KEY ( ID_Podtypu );

CREATE TABLE Prac_uslugi (
    ID_Uslugi     NUMBER NOT NULL,
    ID_pracownika NUMBER NOT NULL
);

ALTER TABLE Prac_uslugi ADD CONSTRAINT Prac_uslugi_pk PRIMARY KEY ( ID_Uslugi );

CREATE TABLE Pracownicy (
    ID_Pracownika NUMBER NOT NULL,
    Imie          VARCHAR2(255),
    Nazwisko      VARCHAR2(255),
    Stanowisko    VARCHAR2(255),
    ID_Kontakt    NUMBER,
    ID_Inf        NUMBER,
    Data_ur       DATE
);

ALTER TABLE Pracownicy ADD CONSTRAINT Pracownicy_pk PRIMARY KEY ( ID_Pracownika );

CREATE TABLE Towar (
    ID_Towaru  NUMBER NOT NULL,
    Nazwa      VARCHAR2(255),
    Material   VARCHAR2(255),
    Cena       NUMBER(5, 2),
    Gwarancja  DATE,
    Uwagi      VARCHAR2(255),
    ID_Komplet NUMBER,
    Dostepnosc CHAR(1)
);

ALTER TABLE Towar ADD CONSTRAINT Towar_pk PRIMARY KEY ( ID_Towaru );

CREATE TABLE Typy (
    ID_Typu    NUMBER NOT NULL,
    Nazwa      VARCHAR2(255),
    ID_podtypu NUMBER
);

ALTER TABLE Typy ADD CONSTRAINT Typy_pk PRIMARY KEY ( ID_Typu );

CREATE TABLE Uslugi (
    ID_Uslugi NUMBER NOT NULL,
    Nazwa     VARCHAR2(255),
    Cena      NUMBER(5, 2),
    Uwagi     VARCHAR2(255)
);

ALTER TABLE Uslugi ADD CONSTRAINT Uslugi_pk PRIMARY KEY ( ID_Uslugi );