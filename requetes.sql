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

\! echo "Requête : Obtenir la moyenne des notes données par un utilisateur à chaque genre musical :"

SELECT g.nom, ROUND(AVG(am.note), 1) AS moyenne_note
FROM utilisateur u
JOIN avis_musique am ON u.id_user = am.id_auteur
JOIN musique m ON am.id_objet = m.id_musique
JOIN genre g ON m.id_genre = g.id_genre
WHERE u.id_user = 5 -- ID de l'utilisateur spécifique
GROUP BY g.nom;

-- SELECT DISTINCT u1.pseudo AS utilisateur1, u2.pseudo AS utilisateur2, COUNT(DISTINCT m1.id_genre) AS nb_genres_communs
-- FROM utilisateur u1
-- JOIN musique m1 ON u1.id_user = m1.id_user
-- JOIN musique m2 ON m1.id_genre = m2.id_genre AND m1.id_musique <> m2.id_musique
-- JOIN utilisateur u2 ON m2.id_user = u2.id_user
-- WHERE u1.id_user <> u2.id_user
-- GROUP BY u1.pseudo, u2.pseudo
-- HAVING COUNT(DISTINCT m1.id_genre) >= 3
-- ORDER BY nb_genres_communs DESC;

--une ’auto jointure’ ou ’jointure réflexive’ (jointure de deux copies d’une même table)

-- une sous-requête corrélée ;

--— une sous-requête dans le FROM ;

--— une sous-requête dans le WHERE ;

--— deux agrégats nécessitant GROUP BY et HAVING ;

--— une requête impliquant le calcul de deux agrégats (par exemple, les moyennes d’un ensemble de
--maximums) ;

--— une jointure externe (LEFT JOIN, RIGHT JOIN ou FULL JOIN) ;

--— deux requêtes équivalentes exprimant une condition de totalité, l’une avec des sous requêtes corrélées et l’autre avec de l’agrégation ;

--— deux requêtes qui renverraient le même résultat si vos tables ne contenaient pas de nulls, mais
--qui renvoient des résultats différents ici (vos données devront donc contenir quelques nulls), vous
--proposerez également de petites modifications de vos requêtes (dans l’esprit de ce qui sera présenté
--dans le cours sur l’information incomplète) afin qu’elles retournent le même résultat ;

--— une requête récursive (par exemple, une requête permettant de calculer quel est le prochain jour
--off d’un groupe actuellement en tournée) ;
--Exemple : Napalm Death est actuellement en tournée (Campagne for Musical Destruction 2023),
--ils jouent sans interruption du 28/02 au 05/03, mais ils ont un jour off le 06/03 entre Utrecht
--(05/03) et Bristol (07/03). En supposant qu’on est aujourd’hui le 28/02, je souhaite connaître leur
--prochain jour off, qui est donc le 06/03.
-- une requête utilisant du fenêtrage (par exemple, pour chaque mois de 2022, les dix groupes dont
--les concerts ont eu le plus de succès ce mois-ci, en termes de nombre d’utilisateurs ayant indiqué
--souhaiter y participer).