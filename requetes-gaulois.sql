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
SELECT nom_specialite, COUNT(nom_personnage) AS nb_personnage
FROM personnage
INNER JOIN specialite ON personnage.id_specialite = specialite.id_specialite
GROUP BY nom_specialite
ORDER BY nb_personnage DESC;

--5. Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées au format jj/mm/aaaa).
SELECT nom_bataille, nom_lieu, DATE_FORMAT(date_bataille, "%d/%m/%Y") AS date_bataille
FROM bataille
INNER JOIN lieu ON bataille.id_lieu = lieu.id_lieu
ORDER BY date_bataille DESC

--6. Nom des potions + coût de réalisation de la potion (trié par coût décroissant).
SELECT nom_potion, SUM(qte*cout_ingredient) AS cout_total
FROM potion
INNER JOIN composer ON potion.id_potion = composer.id_potion
INNER JOIN ingredient ON composer.id_ingredient = ingredient.id_ingredient
GROUP BY nom_potion
ORDER BY cout_total DESC 