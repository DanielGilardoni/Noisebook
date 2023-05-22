-- Prenez l’habitude de bien programmer vos requêtes SQL. Structurez vos requêtes et surtout indentez-les
-- correctement. N’utilisez pas les sous-requêtes là où une jointure suffirait. N’utilisez pas les vues si c’est
-- uniquement dans le but de simplifier l’écriture d’une requête complexe. Enfin, vous pouvez essayer de
-- trouver une requête qui vous semble difficile (ou impossible) à effectuer dans votre modèle, et suggérer
-- une modification de votre modélisation initiale qui faciliterait l’implémentation de cette requête.

-- une reqête sur au moins trois table

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