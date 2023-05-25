\! echo "Requête 1 : Liste des utilisateurs abonnés à un utilisateur donné :"

SELECT u.pseudo
FROM utilisateur u
JOIN abonnement a ON u.id_user = a.abonne
JOIN utilisateur artiste ON a.suivi = artiste.id_user
WHERE artiste.pseudo = 'daft_punk';

\! echo "Requête 2 : Nombre moyen d'avis par musique :"

SELECT m.titre, COUNT(a.id_auteur) AS nombre_avis
FROM musique m
LEFT JOIN avis_musique a ON m.id_musique = a.id_objet
GROUP BY m.id_musique, m.titre;

\! echo "Requête 3 : Les auteurs des musiques d'une playlist :" 

SELECT u.pseudo, m.titre
FROM utilisateur u
JOIN musique m ON u.id_user = m.id_user
JOIN playlist p ON m.id_musique = p.id_musique
WHERE p.id_playlist = 1; --on choisit l'id de la playlist

\! echo "Requête 4 : Calculer la moyenne des notes d'une musique et obtenir le nombre total d'avis :"

SELECT m.titre, COUNT(am.note) AS nombre_avis, ROUND(AVG(am.note), 1) AS moyenne_notes
FROM musique m
LEFT JOIN avis_musique am ON m.id_musique = am.id_objet
GROUP BY m.titre
ORDER BY moyenne_notes DESC;

\! echo "Requête 5 : Récupérer les utilisateurs qui ont créé des musiques dans un genre spécifique et qui ont reçu une note moyenne élevée :"

SELECT u.pseudo, g.nom AS genre, AVG(am.note) AS note_moyenne
FROM utilisateur u
JOIN musique m ON u.id_user = m.id_user
JOIN genre g ON m.id_genre = g.id_genre
JOIN avis_musique am ON m.id_musique = am.id_objet
WHERE g.nom = 'Rock' --On choisit le nom du genre 
GROUP BY u.id_user, g.id_genre
HAVING AVG(am.note) > 7
ORDER BY AVG(am.note) DESC;

\! echo "Requête 6 : Les événements populaires, ayant un nombre de participants supérieur à la moyenne :"

SELECT e.nom, e.localisation, e.prix, e.places, e.nbr_participants
FROM evenement e
WHERE e.nbr_participants > (
    SELECT AVG(nbr_participants)
    FROM evenement
)
ORDER BY e.nbr_participants DESC;

\! echo "Requête 7 : Les utilisateurs qui ont le plus d'amis en commun avec un utilisateur spécifique :"
--Si 1 est l'utilisateur spécifique,
--On prends les users qui ne sont pas 1, et pour chaque on compte le nombre d'amis qu'ils ont qui sont ami avec 1.

SELECT u.pseudo, u.id_user, COUNT(a1.user1) AS amis_en_commun
FROM utilisateur u
JOIN ami a1 ON (u.id_user = a1.user2 OR u.id_user = a1.user1)
WHERE a1.user1 IN (
    SELECT user1
    FROM ami
    WHERE user2 = 1 AND u.id_user = a1.user2 -- 1 est l'ID de l'utilisateur choisi
)
OR a1.user1 IN (
    SELECT user2
    FROM ami
    WHERE user1 = 1 AND u.id_user = a1.user2 -- 1 est l'ID de l'utilisateur choisi
)
OR a1.user2 IN (
    SELECT user1
    FROM ami
    WHERE user2 = 1 AND u.id_user = a1.user1
)
OR a1.user2 IN (
    SELECT user2
    FROM ami
    WHERE user1 = 1 AND u.id_user = a1.user1
)--
AND u.id_user <> 1 -- ID de l'utilisateur choisi
GROUP BY u.id_user, u.pseudo
ORDER BY COUNT(a1.user1) DESC;

\! echo "Requête 8 : Obtenir la moyenne des notes données par un utilisateur à chaque genre musical :"

SELECT g.nom, ROUND(AVG(am.note), 1) AS moyenne_note
FROM utilisateur u
JOIN avis_musique am ON u.id_user = am.id_auteur
JOIN musique m ON am.id_objet = m.id_musique
JOIN genre g ON m.id_genre = g.id_genre
WHERE u.id_user = 5 -- ID de l'utilisateur spécifique
GROUP BY g.nom;

\! echo "Requête 9 :Les utilisateurs possédant la musique 'Smooth' dans une de leur playlist."
SELECT pseudo
FROM (utilisateur NATURAL JOIN playlist) 
     NATURAL JOIN musique
WHERE titre LIKE "Smooth"
;

\! echo "Requête 10 :Liste de utilisateurs qui se suivent mutuellement."
SELECT DISTINCT A1.suivi
FROM abonnement AS A1,
     abonnement AS A2
WHERE A1.suivi = A2.abonnement
      AND A1.abonnement = A2.suivi
;

\! echo "Requête 11 :Les playlists qui durent le plus longtemp."
WITH temps (id_playlist, duree) AS (
    SELECT id_playlist, SUM(duree) 
    FROM playlist JOIN musique ON playlist.id_musique = musique.id_musique
    GROUP BY id_playlist
)
SELECT id_playlist
FROM temps
WHERE duree = (SELECT MAX(duree)
               FROM temps)
;

\! echo "Requête 12 : Le nombre de tags existants."
SELECT COUNT(DISTINCT tag) as nbr_tag
FROM (SELECT tag FROM tagged_evenement
      UNION
      SELECT tag FROM tagged_genre
      UNION
      SELECT tag FROM tagged_musique
      UNION 
      SELECT tag FROM tagged_user) as all_tags
;

\! echo "Requête 13 : La playlist qui dure le moins longtemps."
WITH temps (id_playlist, duree) AS (
    SELECT id_playlist, SUM(duree) 
    FROM playlist JOIN musique ON playlist.id_musique = musique.id_musique
    GROUP BY id_playlist
)
SELECT id_playlist
FROM temps as T1
WHERE t1.duree <ALL (SELECT duree
                     FROM temps AS T2
                     WHERE t1.id_playlist <> t2.id_playlist)
;

\i echo "Requête 14 : Les playlist qui durent plus de 20 min."
SELECT id_playlist, SUM(duree) as temps
FROM playlist JOIN musique ON playlist.id_musique = musique.id_musique
GROUP BY id_playlist
HAVING temps > "20:00"
;

\! echo "Requête 15 : Les groupes qui ont plus de 3 memmbres."
SELECT id_groupe, COUNT(id_personne) as nb_membres
FROM membre
GROUP BY id_groupe
HAVING nb_membres > 3
;

\! echo "Requête 16 : La moyenne de la durée des playlists de chaque utilisateurs."
WITH temps (id_user, id_playlist, duree) AS (
    SELECT ide_user, id_playlist, SUM(duree) 
    FROM playlist JOIN musique ON playlist.id_musique = musique.id_musique
    GROUP BY id_user, id_playlist
)
SELECT id_user, AVG(duree) AS duree_moyenne
FROM temps
GROUP BY id_user
;

\! echo "Requête 17 : Les musiques les plus longues de chaque playlist."
SELECT id_playlist, id_musique
FROM playlist JOIN musique ON playlist.id_musique = musique.id_musique AS T1
WHERE duree >ALL (SELECT duree
                  FROM playlist JOIN musique ON playlist.id_musique = musique.id_musique AS T2
                  WHERE T1.id_playlist = T2.id_playlist
                        AND
                        T1.id_musique <> T2.id_musique)
;

SELECT id_playlist, id_musique
FROM playlist JOIN musique ON playlist.id_musique = musique.id_musique
WHERE duree = (SELECT MAX(duree)
               FROM playlist JOIN musique ON playlist.id_musique = musique.id_musique)
;

\! echo "Requête 18 : Le nombres de participation totale de tous les évènements ayant eu lieu au 'Parc Central'."
SELECT SUM(participants) AS participants_totaux
FROM evenement
WHERE localisation LIKE "Parc Central"
;

SELECT COALESCE(SUM(participants), 0) AS participants_totaux
FROM evenement
WHERE localisation LIKE "Parc Central"
;

\! echo "Requête 19 : Le nombres moyen de participation totale de tous les évènements ayant eu lieu au 'Parc Central'."
SELECT AVG(participants) AS participants_moyens
FROM evenement
WHERE localisation LIKE "Parc Central"
;

SELECT COALESCE(AVG(participants), 0) AS participants_moyens
FROM evenement
WHERE localisation LIKE "Parc Central"
;

--— une requête récursive (par exemple, une requête permettant de calculer quel est le prochain jour
--off d’un groupe actuellement en tournée) ;
--Exemple : Napalm Death est actuellement en tournée (Campagne for Musical Destruction 2023),
--ils jouent sans interruption du 28/02 au 05/03, mais ils ont un jour off le 06/03 entre Utrecht
--(05/03) et Bristol (07/03). En supposant qu’on est aujourd’hui le 28/02, je souhaite connaître leur
--prochain jour off, qui est donc le 06/03.
-- une requête utilisant du fenêtrage (par exemple, pour chaque mois de 2022, les dix groupes dont
--les concerts ont eu le plus de succès ce mois-ci, en termes de nombre d’utilisateurs ayant indiqué
--souhaiter y participer).