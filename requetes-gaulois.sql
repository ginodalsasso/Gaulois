--1 Nom des lieux qui finissent par 'um'.
SELECT nom_lieu
FROM lieu
WHERE nom_lieu LIKE '%um';

--2 Nombre de personnages par lieu (trié par nombre de personnages décroissant).
SELECT COUNT(nom_personnage) AS nb_personnages, l.nom_lieu
FROM personnage p 
INNER JOIN lieu l
ON l.id_lieu = p.id_lieu
GROUP BY p.id_lieu
ORDER BY nb_personnages DESC

--3. Nom des personnages + spécialité + adresse et lieu d'habitation, triés par lieu puis par nom de personnage.
SELECT nom_personnage, adresse_personnage, nom_lieu, nom_specialite
FROM personnage p
INNER JOIN lieu l ON p.id_lieu = l.id_lieu
INNER JOIN specialite s ON p.id_specialite = s.id_specialite
ORDER BY nom_lieu, nom_personnage ASC

--4. Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de personnages décroissant).
SELECT nom_specialite, COUNT(nom_personnage) AS nb_personnage
FROM personnage p
INNER JOIN specialite s ON p.id_specialite = s.id_specialite
GROUP BY nom_specialite
ORDER BY nb_personnage DESC;

--5. Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées au format jj/mm/aaaa).
SELECT nom_bataille, nom_lieu, DATE_FORMAT(date_bataille, "%d/%m/%Y") AS date_bataille
FROM bataille b
INNER JOIN lieu l ON b.id_lieu = l.id_lieu
ORDER BY date_bataille DESC

--6. Nom des potions + coût de réalisation de la potion (trié par coût décroissant).
SELECT nom_potion, SUM(qte*cout_ingredient) AS cout_total
FROM potion p
INNER JOIN composer c ON p.id_potion = c.id_potion
INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
GROUP BY nom_potion
ORDER BY cout_total DESC 

--7. Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'.
SELECT nom_potion, nom_ingredient, cout_ingredient, qte
FROM potion p
INNER JOIN composer c ON p.id_potion = c.id_potion
INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
WHERE nom_potion IN ('Santé')

--8. Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village gaulois'.

--9. Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur au plus petit).
SELECT nom_personnage, dose_boire
FROM personnage p
INNER JOIN boire b ON p.id_personnage = b.id_personnage
ORDER BY dose_boire DESC

--10. Nom de la bataille où le nombre de casques pris a été le plus important.
SELECT nom_bataille, qte
FROM prendre_casque pc
INNER JOIN bataille b ON pc.id_bataille = b.id_bataille
ORDER BY qte DESC
LIMIT 1

--11. Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par nombre décroissant)
SELECT count(tc.id_type_casque) AS c, tc.nom_type_casque, SUM(cout_casque) AS cout_total 
FROM type_casque tc
INNER JOIN casque c ON tc.id_type_casque = c.id_type_casque
GROUP BY tc.nom_type_casque

--12. Nom des potions dont un des ingrédients est le poisson frais.
SELECT nom_potion, nom_ingredient
FROM potion p
INNER JOIN composer c ON p.id_potion = c.id_potion
INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
WHERE nom_ingredient = 'Poisson frais'



