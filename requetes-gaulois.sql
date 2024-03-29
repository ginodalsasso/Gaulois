--1 Nom des lieux qui finissent par 'um'.

SELECT nom_lieu
    FROM lieu
    WHERE nom_lieu LIKE '%um'; -- %... fonctionne aussi avec ...%, %...% ...


--2 Nombre de personnages par lieu (trié par nombre de personnages décroissant).

SELECT COUNT(nom_personnage) AS nb_personnages, l.nom_lieu
    FROM personnage p 
    INNER JOIN lieu l
    ON l.id_lieu = p.id_lieu --lien entre la table lieu grace à la clé étragère id_lieu et la table personnage
    GROUP BY p.id_lieu -- GROUP BY toujours l'id de préférence pour éviter les erreurs
    ORDER BY nb_personnages DESC -- trie par nombre de personnages décroissant


--3. Nom des personnages + spécialité + adresse et lieu d'habitation, triés par lieu puis par nom de personnage.

SELECT nom_personnage, adresse_personnage, nom_lieu, nom_specialite
    FROM personnage p
    INNER JOIN lieu l ON p.id_lieu = l.id_lieu
    INNER JOIN specialite s ON p.id_specialite = s.id_specialite --dans cet exercice nous avons deux jointures  pour rechercher à travers les tables specialité et lieu
    ORDER BY nom_lieu, nom_personnage ASC -- trie par lieu puis par nom de personnage


--4. Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de personnages décroissant).

SELECT nom_specialite, COUNT(nom_personnage) AS nb_personnage --COUNT pour compter le nombre de personnage
    FROM personnage p
    INNER JOIN specialite s ON p.id_specialite = s.id_specialite 
    GROUP BY s.id_specialite -- -- GROUP BY toujours l'id de préférence pour éviter les erreurs
    ORDER BY nb_personnage DESC; -- trié par nombre de personnages décroissant


--5. Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées au format jj/mm/aaaa).

SELECT nom_bataille, nom_lieu, DATE_FORMAT(date_bataille, "%d/%m/%Y") AS date_bataille --DATE__FORMAT est une fonction, DATE_FORMAT(date, format)
    FROM bataille b
    INNER JOIN lieu l ON b.id_lieu = l.id_lieu
    ORDER BY date_bataille DESC


--6. Nom des potions + coût de réalisation de la potion (trié par coût décroissant).

SELECT nom_potion, SUM(qte*cout_ingredient) AS cout_total --fonction SUM pour multiplier la qte des ingrédients par leur coùt
    FROM potion p
    INNER JOIN composer c ON p.id_potion = c.id_potion
    INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
    GROUP BY p.id_potion -- GROUP BY quand nous utilisons la fonction SUM est automatique !
    ORDER BY cout_total DESC 


--7. Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'.

SELECT nom_potion, nom_ingredient, cout_ingredient, qte
    FROM potion p
    INNER JOIN composer c ON p.id_potion = c.id_potion
    INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
    WHERE nom_potion IN ('Santé')  -- nous cherchons dans potion => le nom de la potion pour les SELECT cités plus haut


--8. Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village gaulois'.

SELECT p.nom_personnage, SUM(pc.qte) AS nb_casques -- SUM =  prendre_casque => qte
    FROM personnage p, bataille b, prendre_casque pc
    -- Conditions de jointure entre les tables
    WHERE p.id_personnage = pc.id_personnage 
    AND b.nom_bataille = 'Bataille du village gaulois'
    GROUP BY p.id_personnage  -- Regroupez les résultats par l'identifiant du personnage
        -- Filtre les résultats pour inclure uniquement les personnages ayant pris autant de casques que le maximum pris par un personnage
        HAVING nb_casques >= ALL( --HAVING est comme WHERE pour une fonction d'abregation (COUNT, SUM) WHERE ne fonctionne pas dans ces cas
            SELECT SUM(pc.qte) -- Sous-requête : Sélectionnez la somme des quantités de casques prises pour chaque personnage
            FROM prendre_casque pc, bataille b
            WHERE b.id_bataille = pc.id_bataille
            AND b.nom_bataille = 'Bataille du village gaulois'
            GROUP BY pc.id_personnage -- Regroupez les résultats par l'identifiant du personnage
        )


--9. Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur au plus petit).

SELECT nom_personnage, SUM(dose_boire) AS qteTotale
    FROM personnage p
    INNER JOIN boire b ON p.id_personnage = b.id_personnage
    GROUP BY p.id_personnage
    ORDER BY qteTotale DESC


--10. Nom de la bataille où le nombre de casques pris a été le plus important.

SELECT b.nom_bataille, SUM(pc.qte) AS pc_qte -- SUM des casques pris dans prendre_casque => qte
    FROM prendre_casque pc
    INNER JOIN bataille b ON pc.id_bataille = b.id_bataille
    GROUP BY b.id_bataille
        -- Filtre les résultats pour inclure seulement les casques dont la qte est égale à la plus grande quantité de tous les casques
        HAVING pc_qte >= ALL(
            SELECT SUM(pc.qte)
            FROM prendre_casque pc
            INNER JOIN bataille b ON pc.id_bataille = b.id_bataille
    		GROUP BY b.id_bataille
        )      


--11. Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par nombre décroissant)

SELECT COUNT(tc.id_type_casque) AS c, tc.nom_type_casque, SUM(cout_casque) AS cout_total -- le nombre de casques de chaque type, le nom du type de casque, et la somme du coût total de ces casques
    INNER JOIN casque c ON tc.id_type_casque = c.id_type_casque
    GROUP BY tc.id_type_casque --Regroupe les résultats par le nom du type de casque


--12. Nom des potions dont un des ingrédients est le poisson frais.

SELECT nom_potion, nom_ingredient
    FROM potion p
    INNER JOIN composer c ON p.id_potion = c.id_potion
    INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
    WHERE nom_ingredient = 'Poisson frais' ---- Filtre les résultats pour inclure seulement les lignes où l'ingrédient est 'Poisson frais'


--13. Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois.

SELECT l.nom_lieu, COUNT(p.id_lieu) AS c
	FROM lieu l
	INNER JOIN personnage p ON l.id_lieu = p.id_lieu 
	WHERE l.nom_lieu != 'Village gaulois'
	GROUP BY l.nom_lieu
    -- Filtre les résultats pour inclure seulement les lieux ayant le nombre d'habitants égal au maximum de tous les lieux
	HAVING c >= ALL(
		SELECT COUNT(p.id_lieu)
		FROM lieu l
		INNER JOIN personnage p ON l.id_lieu = p.id_lieu
		WHERE l.nom_lieu != 'Village gaulois'
		GROUP BY l.nom_lieu
		)


--14. Nom des personnages qui n'ont jamais bu aucune potion.

SELECT p.nom_personnage, dose_boire
    FROM personnage p
    LEFT JOIN boire b ON p.id_personnage = b.id_personnage -- jointure LEFT JOIN pour inclure tous les personnages, MEME ceux qui n'ont pas bu de potion
    WHERE dose_boire IS NULL ---- Filtre les résultats pour inclure seulement les personnages qui n'ont pas bu de potion


--15. Nom du / des personnages qui n'ont pas le droit de boire de la potion 'Magique'.
SELECT p.nom_personnage, id_potion
    FROM personnage p
    LEFT JOIN autoriser_boire b ON p.id_personnage = b.id_personnage
    WHERE id_potion IS NULL

SELECT p.nom_personnage
FROM personnage p
WHERE p.id_personnage NOT IN (
    SELECT id_personnage FROM autoriser_boire WHERE id_potion = 1
)


-- En écrivant toujours des requêtes SQL, modifiez la base de données comme suit :

--A. Ajoutez le personnage suivant : Champdeblix, agriculteur résidant à la ferme Hantassion de Rotomagus.

    -- en allant chercher les valeures des id dans leurs tables

INSERT INTO personnage p (nom_personnage, adresse_personnage, id_lieu, id_specialite)
-- insertion des nouvelles valeurs dans les catégories associées, donner les valeurs dans le même order que INSERT
    VALUES (
        'Champdeblix', 
        "ferme Hantassion", 
        SELECT id_lieu FROM lieu WHERE nom_lieu = "Rotomagus", 
        SELECT id_specialite FROM specialite WHERE nom_specialite = "Agriculteur"
    ) 

    -- ou en indiquant directement la valeur de l'integer lié à l'id

INSERT INTO personnage p (nom_personnage, adresse_personnage, id_lieu, id_specialite)
-- insertion des nouvelles valeurs dans les catégories associées, donner les valeurs dans le même order que INSERT
    VALUES (
        'Champdeblix', 
        "ferme Hantassion", 
        6,
        12
    ) 


-- B. Autorisez Bonemine à boire de la potion magique, elle est jalouse d'Iélosubmarine..

INSERT INTO autoriser_boire (id_potion, id_personnage)
-- insertion des nouvelles valeurs dans les catégories associées, donner les valeurs dans le même order que INSERT
	VALUES (1, 12) -- id = integer


--C. Supprimez les casques grecs qui n'ont jamais été pris lors d'une bataille.

DELETE FROM prendre_casque pc
-- JOINTURE pour récupérer les informations stockées dans d'autres tables
    RIGHT JOIN casque c ON pc.id_casque = c.id_casque
    RIGHT JOIN type_casque tyc ON c.id_type_casque = tyc.id_type_casque
-- cible la la ligne où les informations sont à remplacer
    WHERE c.id_type_casque = 2 AND pc.qte = 0


--D. Modifiez l'adresse de Zérozérosix : il a été mis en prison à Condate.

UPDATE personnage
-- set nouvelle valeure 
	SET id_lieu = 9
-- cible la/les lignes où les informations sont à remplacer
	WHERE id_personnage = 23


-- E. La potion 'Soupe' ne doit plus contenir de persil.

DELETE FROM composer
-- cible la/les lignes où les informations sont à supprimer
    WHERE id_ingredient = 19 AND id_potion = 9


-- F. Obélix s'est trompé : ce sont 42 casques Weisenau, et non Ostrogoths, qu'il a pris lors de la 
-- bataille 'Attaque de la banque postale'. Corrigez son erreur !

UPDATE prendre_casque pc
    SET pc.qte = 42 AND pc.id_personnage = 10
    WHERE pc.id_bataille = 9