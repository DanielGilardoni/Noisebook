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

SELECT u.pseudo, g.nom AS genre, ROUND(AVG(am.note), 1) AS note_moyenne
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

\! echo "Requête 9 : Les genres de musique avec plus de 5 musiques associées et une note moyenne supérieure à 7 :"

SELECT g.nom AS genre, COUNT(*) AS total_musiques, AVG(a.note) AS moyenne_note
FROM musique m
INNER JOIN genre g ON m.id_genre = g.id_genre
LEFT JOIN avis_musique a ON m.id_musique = a.id_objet
GROUP BY g.nom
HAVING COUNT(*) > 5 AND AVG(a.note) > 7
ORDER BY total_musiques DESC;

\! echo "Requête 10 :Liste de utilisateurs qui se suivent mutuellement."
SELECT DISTINCT A1.suivi
FROM abonnement AS A1,
     abonnement AS A2
WHERE A1.suivi = A2.abonne
      AND A1.abonne = A2.suivi
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
-- une maniére de vérifier qu'il n'y a pas des tags en trops ou en moins en comparant au nombre de tags de la table tag
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

\! echo "Requête 14 : Les playlist qui durent plus de 20 min."

SELECT id_playlist, SUM(duree) as temps
FROM playlist JOIN musique ON playlist.id_musique = musique.id_musique
GROUP BY id_playlist
HAVING SUM(duree) > INTERVAL '20 minutes'
;

\! echo "Requête 15 : Les utilisateurs qui ont donné un avis sur toutes les musiques :"
--Avec sous-requête corrélée :
SELECT DISTINCT u.pseudo
FROM utilisateur u
WHERE NOT EXISTS (
    SELECT m.id_musique
    FROM musique m
    WHERE NOT EXISTS (
        SELECT *
        FROM avis_musique am
        WHERE am.id_auteur = u.id_user
        AND am.id_objet = m.id_musique
    )
);
--Avec agrégation : 
SELECT u.pseudo
FROM utilisateur u
LEFT JOIN avis_musique am ON am.id_auteur = u.id_user
GROUP BY u.id_user, u.pseudo
HAVING COUNT(DISTINCT am.id_objet) = (
    SELECT COUNT(DISTINCT id_musique)
    FROM musique
);

\! echo "Requête 16 : Les utilisateurs les plus actifs sur NoiseBook en termes de publications de musique et d'organisation d'événements :"

WITH user_activity AS (
    SELECT
        u.id_user,
        COUNT(DISTINCT musique.id_musique) AS total_musique,
        COUNT(DISTINCT evenement.id_event) AS total_evenement,
        RANK() OVER (ORDER BY COUNT(DISTINCT musique.id_musique) + COUNT(DISTINCT evenement.id_event) DESC) AS activity_rank
    FROM
        utilisateur u
    LEFT JOIN
        musique ON u.id_user = musique.id_user
    LEFT JOIN
        playlist ON u.id_user = playlist.id_user
    LEFT JOIN
        organisateur ON u.id_user = organisateur.id_user
    LEFT JOIN 
        evenement ON organisateur.id_event = evenement.id_event
    GROUP BY
        u.id_user
)
SELECT
    id_user,
    total_musique,
    total_evenement,
    activity_rank
FROM
    user_activity
LIMIT 10;

\! echo "Requête 17 : Les musiques les plus longues de chaque playlist :"

SELECT p1.id_playlist, m1.id_musique
FROM playlist p1 JOIN musique m1 ON p1.id_musique = m1.id_musique
WHERE m1.duree >ALL (SELECT m2.duree
                  FROM playlist p2 JOIN musique m2 ON p2.id_musique = m2.id_musique
                  WHERE p1.id_playlist = p2.id_playlist
                        AND
                        m1.id_musique <> m2.id_musique)
;


\! echo "Requête 18 : Récupére tous les genres parents d'un genre donnée jusqu'à la racine de l'arborescence des genres."

WITH RECURSIVE genre_recursive AS (
    SELECT id_genre, nom, id_parent
    FROM genre
    JOIN sub_genre sg ON sg.id_enfant = genre.id_genre
    WHERE nom = 'Dub'
    
    UNION ALL
    
    SELECT g.id_genre, g.nom, sg.id_parent
    FROM genre g
    INNER JOIN sub_genre sg ON sg.id_enfant = g.id_genre
    INNER JOIN genre_recursive gr ON gr.id_parent = sg.id_enfant
    WHERE g.id_genre = gr.id_parent
)
SELECT *
FROM genre_recursive;

\! echo "Requête 19 : Le nombres moyen de participation totale de tous les évènements ayant eu lieu au 'Parc Central'."
SELECT AVG(nbr_participants) AS participants_moyens
FROM evenement
WHERE localisation LIKE 'Parc Central'
;

--les valeurs null sont remplacé par 0, le résultat est donc différent s'il y a des valeurs null
SELECT AVG(COALESCE(nbr_participants, 0)) AS participants_moyens
FROM evenement e
WHERE localisation = 'Parc Central'
;

\! echo "Requête 20 : La moyenne des notes maximales attribuées à chaque musique, par genre :"

SELECT g.nom AS genre, ROUND(AVG(max_note), 1) AS moyenne_notes_max
FROM (
    SELECT m.id_genre, MAX(am.note) AS max_note
    FROM musique m
    LEFT JOIN avis_musique am ON m.id_musique = am.id_objet
    GROUP BY m.id_musique
) AS max_notes
JOIN genre g ON max_notes.id_genre = g.id_genre
GROUP BY g.nom;





