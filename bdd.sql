DROP TABLE IF EXISTS evenement CASCADE;
DROP TABLE IF EXISTS type_user CASCADE;
DROP TABLE IF EXISTS utilisateur CASCADE;
DROP TABLE IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS musique CASCADE;
DROP TABLE IF EXISTS playlist CASCADE;
DROP TABLE IF EXISTS avis_musique CASCADE;
DROP TABLE IF EXISTS avis_evenement CASCADE;
DROP TABLE IF EXISTS tag CASCADE;
DROP TABLE IF EXISTS organisateur CASCADE;
DROP TABLE IF EXISTS sub_genre CASCADE;
DROP TABLE IF EXISTS abonnement CASCADE;
DROP TABLE IF EXISTS ami CASCADE;
DROP TABLE IF EXISTS membre CASCADE;
DROP TABLE IF EXISTS tagged_user CASCADE;
DROP TABLE IF EXISTS tagged_musique CASCADE;
DROP TABLE IF EXISTS tagged_evenement CASCADE;
DROP TABLE IF EXISTS tagged_genre CASCADE;

CREATE TABLE evenement (   
    id_event SERIAL PRIMARY KEY,
    nom VARCHAR NOT NULL,
    localisation VARCHAR NOT NULL,
    prix INT NOT NULL,
    places INT NOT NULL,
    passe BOOLEAN NOT NULL,
    nbr_participants INT
    CHECK (passe = false AND IS NULL nbr_participants)
);

CREATE TABLE type_user (
    type_name VARCHAR PRIMARY KEY
);

CREATE TABLE utilisateur (
    id_user SERIAL PRIMARY KEY,
    pseudo VARCHAR NOT NULL,
    mdp VARCHAR NOT NULL,
    type_user VARCHAR NOT NULL,
    FOREIGN KEY (type_user) REFERENCES type_user(type_name)
);

CREATE TABLE genre (
    nom VARCHAR PRIMARY KEY
);

CREATE TABLE musique (
    id_musique SERIAL PRIMARY KEY,
    titre VARCHAR NOT NULL,
    duree TIMES NOT NULL,
    genre VARCHAR NOT NULL,
    FOREIGN KEY (genre) REFERENCES genre(nom)
);

CREATE TABLE playlist (
    id_playlist SERIAL,
    id_user INT,
    id_musique INT,
    PRIMARY KEY (id_playlist, id_user, id_musique),
    FOREIGN KEY (id_user) REFERENCES utilisateur(id_user),
    FOREIGN KEY (id_musique) REFERENCES musique(id_musique)
);

CREATE TABLE avis_musique (
    id_auteur INT,
    id_objet INT,
    note INT NOT NULL CHECK (note > 0 AND note < 10),
    commentaire VARCHAR,
    PRIMARY KEY (id_auteur, id_objet),
    FOREIGN KEY (id_auteur) REFERENCES utilisateur(id_user),
    FOREIGN KEY (id_objet) REFERENCES musique(id_musique)
);

CREATE TABLE avis_evenement (
    id_auteur INT,
    id_objet INT,
    note INT NOT NULL,
    commentaire VARCHAR,
    PRIMARY KEY (id_auteur, id_objet),
    FOREIGN KEY (id_auteur) REFERENCES utilisateur(id_user),
    FOREIGN KEY (id_objet) REFERENCES evenement(id_event),
    CHECK (note > 0 AND note < 10)
);

CREATE TABLE tag (
    tag_name VARCHAR PRIMARY KEY
);

CREATE TABLE organisateur (
    id_user INT,
    id_event INT,
    PRIMARY KEY (id_user, id_event),
    FOREIGN KEY (id_user) REFERENCES utilisateur(id_user),
    FOREIGN KEY (id_event) REFERENCES evenement(id_event) 
); 

CREATE TABLE sub_genre (
    parent VARCHAR,
    enfant VARCHAR,
    PRIMARY KEY (parent, enfant),
    FOREIGN KEY (parent) REFERENCES genre(nom),
    FOREIGN KEY (enfant) REFERENCES genre(nom),
    CHECK (parent <> enfant)
);

CREATE TABLE abonnement (
    suivi INT,
    abonne INT,
    PRIMARY KEY (suivi, abonne),
    FOREIGN KEY (suivi) REFERENCES utilisateur(id_user),
    FOREIGN KEY (abonne) REFERENCES utilisateur(id_user),
    CHECK (suivi <> abonne)
);

CREATE TABLE ami (
    user1 INT,
    user2 INT,
    PRIMARY KEY (user1, user2),
    FOREIGN KEY (user1) REFERENCES utilisateur(id_user),
    FOREIGN KEY (user2) REFERENCES utilisateur(id_user),
);

CREATE TABLE membre (
    id_groupe INT,
    id_personne INT,
    PRIMARY KEY (id_groupe, id_personne),
    FOREIGN KEY (id_groupe) REFERENCES utilisateur(id_user),
    FOREIGN KEY (id_personne) REFERENCES utilisateur(id_user)
);

CREATE TABLE tagged_user (
    tag VARCHAR,
    id_objet INT,
    PRIMARY KEY (tag, id_objet),
    FOREIGN KEY (tag) REFERENCES tag(tag_name),
    FOREIGN KEY (id_objet) REFERENCES utilisateur(id_user)
);

CREATE TABLE tagged_musique (
    tag VARCHAR,
    id_objet INT,
    PRIMARY KEY (tag, id_objet),
    FOREIGN KEY (tag) REFERENCES tag(tag_name),
    FOREIGN KEY (id_objet) REFERENCES musique(id_musique)
);

CREATE TABLE tagged_genre (
    tag VARCHAR,
    id_objet VARCHAR,
    PRIMARY KEY (tag, id_objet),
    FOREIGN KEY (tag) REFERENCES tag(tag_name),
    FOREIGN KEY (id_objet) REFERENCES genre(nom)
);

CREATE TABLE tagged_evenement (
    tag VARCHAR,
    id_objet INT,
    PRIMARY KEY (tag, id_objet),
    FOREIGN KEY (tag) REFERENCES tag(tag_name),
    FOREIGN KEY (id_objet) REFERENCES evenement(id_event)
);

CREATE TABLE tagged_user (
    tag VARCHAR,
    id_objet INT,
    PRIMARY KEY (tag, id_objet),
    FOREIGN KEY (tag) REFERENCES tag(tag_name),
    FOREIGN KEY (id_objet) REFERENCES utilisateur(id_user)
);