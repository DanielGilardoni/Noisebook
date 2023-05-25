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
    passe BOOLEAN NOT NULL, --est-ce que l'évenement à déjà eu lieu
    nbr_participants INT,
    CHECK ((passe = false AND nbr_participants IS NULL) OR (passe = true AND nbr_participants IS NOT NULL)) --si l'évenement n'a pas encore eu lieu le nombre de participants est inconnue
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
    id_genre SERIAL PRIMARY KEY,
    nom VARCHAR UNIQUE
);

CREATE TABLE musique (
    id_musique SERIAL PRIMARY KEY,
    id_user INT, --le créateur de la musique (ou celui qui l'a posté qu'on suppose être l'auteur)
    titre VARCHAR NOT NULL,
    duree INTERVAL NOT NULL, 
    id_genre INT,
    FOREIGN KEY (id_user) REFERENCES utilisateur(id_user),
    FOREIGN KEY (id_genre) REFERENCES genre(id_genre)
);

CREATE TABLE playlist (
    id_playlist INT,
    id_user INT,
    id_musique INT,
    PRIMARY KEY (id_playlist, id_user, id_musique),
    FOREIGN KEY (id_user) REFERENCES utilisateur(id_user),
    FOREIGN KEY (id_musique) REFERENCES musique(id_musique),
    CONSTRAINT unique_musique UNIQUE (id_playlist, id_user, id_musique) --pas plusieurs fois la même musique dans un playlist
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
    note INT NOT NULL CHECK (note > 0 AND note < 10),
    commentaire VARCHAR,
    PRIMARY KEY (id_auteur, id_objet),
    FOREIGN KEY (id_auteur) REFERENCES utilisateur(id_user),
    FOREIGN KEY (id_objet) REFERENCES evenement(id_event)
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
    id_parent INT,
    id_enfant INT,
    PRIMARY KEY (id_parent, id_enfant),
    FOREIGN KEY (id_parent) REFERENCES genre(id_genre),
    FOREIGN KEY (id_enfant) REFERENCES genre(id_genre),
    CHECK (id_parent <> id_enfant)
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
    FOREIGN KEY (user2) REFERENCES utilisateur(id_user)
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
    id_objet INT,
    PRIMARY KEY (tag, id_objet),
    FOREIGN KEY (tag) REFERENCES tag(tag_name),
    FOREIGN KEY (id_objet) REFERENCES genre(id_genre)
);

CREATE TABLE tagged_evenement (
    tag VARCHAR,
    id_objet INT,
    PRIMARY KEY (tag, id_objet),
    FOREIGN KEY (tag) REFERENCES tag(tag_name),
    FOREIGN KEY (id_objet) REFERENCES evenement(id_event)
);


-- Insertion de données :

\COPY evenement FROM 'csv/evenement.csv' DELIMITER ',' CSV HEADER;
\COPY type_user FROM 'csv/type_user.csv' DELIMITER ',' CSV HEADER;
\COPY utilisateur FROM 'csv/utilisateur.csv' DELIMITER ',' CSV HEADER;
\COPY genre FROM 'csv/genre.csv' DELIMITER ',' CSV HEADER;
\COPY musique FROM 'csv/musique.csv' DELIMITER ',' CSV HEADER;
\COPY playlist FROM 'csv/playlist.csv' DELIMITER ',' CSV HEADER;
\COPY avis_musique FROM 'csv/avis_musique.csv' DELIMITER ',' CSV HEADER;
\COPY avis_evenement FROM 'csv/avis_evenement.csv' DELIMITER ',' CSV HEADER;
\COPY tag FROM 'csv/tag.csv' DELIMITER ',' CSV HEADER;
\COPY organisateur FROM 'csv/organisateur.csv' DELIMITER ',' CSV HEADER;
\COPY sub_genre FROM 'csv/sub_genre.csv' DELIMITER ',' CSV HEADER;
\COPY abonnement FROM 'csv/abonnement.csv' DELIMITER ',' CSV HEADER;
\COPY ami FROM 'csv/ami.csv' DELIMITER ',' CSV HEADER;
\COPY membre FROM 'csv/membre.csv' DELIMITER ',' CSV HEADER;
\COPY tagged_user FROM 'csv/tagged_user.csv' DELIMITER ',' CSV HEADER;
\COPY tagged_musique FROM 'csv/tagged_musique.csv' DELIMITER ',' CSV HEADER;
\COPY tagged_evenement FROM 'csv/tagged_evenement.csv' DELIMITER ',' CSV HEADER;
\COPY tagged_genre FROM 'csv/tagged_genre.csv' DELIMITER ',' CSV HEADER;