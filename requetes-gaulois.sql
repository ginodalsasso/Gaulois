--1 Nom des lieux qui finissent par 'um'.
SELECT nom_lieu
FROM lieu
WHERE nom_lieu LIKE '%um';

--2 Nombre de personnages par lieu (trié par nombre de personnages décroissant).
SELECT COUNT(nom_personnage) AS nb_personnages 
FROM personnage
GROUP BY id_lieu
ORDER BY nb_personnages DESC

--3. Nom des personnages + spécialité + adresse et lieu d'habitation, triés par lieu puis par nom de personnage.

SELECT nom_personnage, adresse_personnage, nom_lieu, nom_specialite
FROM personnage
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
INNER JOIN specialite ON personnage.id_specialite = specialite.id_specialite
ORDER BY nom_lieu, nom_personnage ASC

--4. Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de personnages décroissant).