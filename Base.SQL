-- Date: 2023-12-12 15:00:00
-- Permet la suppression du schéma si il existe déja
DROP SCHEMA IF EXISTS transmusicales CASCADE;
CREATE SCHEMA transmusicales;
SET SCHEMA 'transmusicales';
-- Création des tables
CREATE TABLE _Groupe_artiste (
    id_groupe_artiste VARCHAR(3) NOT NULL,
    nom_groupe_artiste VARCHAR(50),
    site_web VARCHAR(25),
    annee INTEGER NOT NULL,
    pays_origine VARCHAR(25) NOT NULL,
CONSTRAINT _Groupe_artiste_pk PRIMARY KEY(id_groupe_artiste)
);

CREATE TABLE _Lieu (
    id_lieu VARCHAR(3) NOT NULL,
    nom_lieu VARCHAR(20) NOT NULL,
    accesPMR BOOLEAN NOT NULL,
    capacite_max INTEGER,
    type_lieu VARCHAR(25),
    id_lieu_ville VARCHAR(30) NOT NULL,
CONSTRAINT _Lieu_pk PRIMARY KEY(id_lieu)
);

CREATE TABLE _Representation (
    numero_representation VARCHAR(3) NOT NULL,
    heure VARCHAR(10),
    date_representation DATE NOT NULL,
    lieu_a_lieu_dans VARCHAR(5) NOT NULL,
    concert_correspond VARCHAR(3),
    id_groupe_artiste_jouee_par VARCHAR(3),
CONSTRAINT _Representation_pk PRIMARY KEY(numero_representation)
);

CREATE TABLE _Concert (
    no_concert VARCHAR(3) NOT NULL,
    titre VARCHAR(15) NOT NULL,
    resume VARCHAR(25) NOT NULL,
    duree INTEGER NOT NULL,
    tarif FLOAT NOT NULL,
    type_musique_est_de VARCHAR(5) NOT NULL,
    edition_se_deroule VARCHAR(3) NOT NULL,
CONSTRAINT _Concert_pk PRIMARY KEY(no_concert)
);

CREATE TABLE _Formation (
    libelle_formation VARCHAR(50) NOT NULL,
CONSTRAINT _Formation_pk PRIMARY KEY(libelle_formation)
);

CREATE TABLE _Type_musique (
    type_m VARCHAR(30) NOT NULL,
CONSTRAINT _Type_musique_pk PRIMARY KEY(type_m)
);

CREATE TABLE _Pays (
    nom_p VARCHAR(30) NOT NULL,
CONSTRAINT _Pays_pk PRIMARY KEY(nom_p)
);

CREATE TABLE _Ville (
    nom_v VARCHAR(30) NOT NULL,
    nom_p_pays VARCHAR(30) NOT NULL,
CONSTRAINT _Ville_pk PRIMARY KEY(nom_v)
);

CREATE TABLE _Annee (
    an INTEGER,
CONSTRAINT _Annee_pk PRIMARY KEY(an)
);

CREATE TABLE _Edition (
    nom_edition VARCHAR(30),
    an_annee INTEGER,
CONSTRAINT _Edition_pk PRIMARY KEY(nom_edition)
);

-- Tables pour nos contraintes
CREATE TABLE type_ponctuel (
    id_groupe_artiste VARCHAR(3) NOT NULL,
    type_m VARCHAR(30) NOT NULL,
    CONSTRAINT type_ponctuel_pk PRIMARY KEY(id_groupe_artiste, type_m),
    CONSTRAINT type_ponctuel_fk_groupe_artiste
    FOREIGN KEY(id_groupe_artiste)
    REFERENCES _Groupe_artiste(id_groupe_artiste),
    CONSTRAINT type_ponctuel_fk_type_musique
    FOREIGN KEY(type_m)
    REFERENCES _Type_musique(type_m)
);
CREATE TABLE a_pour (
    id_groupe_artiste VARCHAR(3) NOT NULL,
    libelle_formation VARCHAR(50) NOT NULL,
    CONSTRAINT a_pour__pk PRIMARY KEY(id_groupe_artiste, libelle_formation),
    CONSTRAINT a_pour__fk_groupe_artiste
    FOREIGN KEY(id_groupe_artiste)
    REFERENCES _Groupe_artiste(id_groupe_artiste),
    CONSTRAINT a_pour__fk_formation
    FOREIGN KEY(libelle_formation)
    REFERENCES _Formation(libelle_formation)
);
-- Création des contraintes
ALTER TABLE _Groupe_artiste
ADD CONSTRAINT _Groupe_artiste_fk_debut
FOREIGN KEY(annee)
REFERENCES _Annee(an);

ALTER TABLE _Groupe_artiste
ADD CONSTRAINT _Groupe_artiste_fk_sortie_disco
FOREIGN KEY(annee)
REFERENCES _Annee(an);

ALTER TABLE _Representation
ADD CONSTRAINT _representation_fk_a_lieu_dans
FOREIGN KEY(lieu_a_lieu_dans)
REFERENCES _Lieu(id_lieu);

ALTER TABLE _Representation
ADD CONSTRAINT _representation_fk_correspond
FOREIGN KEY(concert_correspond)
REFERENCES _Concert(no_concert);

ALTER TABLE _Representation
ADD CONSTRAINT _representation_fk_jouee_par
FOREIGN KEY(id_groupe_artiste_jouee_par)
REFERENCES _Groupe_artiste(id_groupe_artiste);

ALTER TABLE _Edition
ADD CONSTRAINT _Edition_fk_annee
FOREIGN KEY(an_annee)
REFERENCES _Annee(an);

ALTER TABLE _Ville
ADD CONSTRAINT _Ville_fk_pays
FOREIGN KEY(nom_p_pays)
REFERENCES _Pays(nom_p);

ALTER TABLE _Lieu
ADD CONSTRAINT _Lieu_fk_ville
FOREIGN KEY(id_lieu_ville)
REFERENCES _Ville(nom_v);

ALTER TABLE _Type_musique
ADD CONSTRAINT _Type_musique_fk_type_ponc
FOREIGN KEY(type_m)
REFERENCES _Type_musique(type_m);

ALTER TABLE _Concert
ADD CONSTRAINT _Concert_fk_type_musique
FOREIGN KEY(type_musique_est_de)
REFERENCES _Type_musique(type_m);

ALTER TABLE _Concert
ADD CONSTRAINT _Concert_fk_edition
FOREIGN KEY(edition_se_deroule)
REFERENCES _edition(nom_edition);
