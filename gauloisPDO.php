<?php
try
{
    $mysqlClient = new PDO(
        'mysql:host=localhost;dbname=gaulois;charset=utf8', // host = dbname = database name (nom de la table)
       'root', //C'est l'adresse IP de l'ordinateur où MySQL est installé. Le plus souvent, MySQL est installé sur le même ordinateur que PHP : dans ce cas, mettez la valeur localhost . 
       '' //ici pas de mot de passe donc espace vide = ''
    );

      // [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION], //requêtes SQL comportant des erreurs s'afficheront avec un message beaucoup plus clair.
  
  
}

catch (Exception $e)
{
    die('Erreur : ' . $e->getMessage()); //En cas d'erreur, PDO renvoie ce qu'on appelle une exception, qui permet de « capturer » l'erreur.
}


// On récupère tout le contenu de la table
//$sqlQuery peut avoir n'importe quel nom, JAMAIS DE VARIABLE DANS UNE REQUETE DIRECTEMEMENT
$sqlQuery = 'SELECT nom_personnage, nom_lieu, nom_specialite
                FROM personnage p
                INNER JOIN lieu l ON p.id_lieu = l.id_lieu
                INNER JOIN specialite s ON p.id_specialite = s.id_specialite'; 
$pStatement = $mysqlClient->prepare($sqlQuery); //prepare la requête ci-dessus
$pStatement->execute();
$personnages = $pStatement->fetchAll(); //fetch("va chercher") all pour retourner plus d'une ligne d'une table, et fetch pour une seule ligne

echo afficherTableHTML($personnages);

function afficherTableHTML($personnages){
    $table = "<table border=1>             
                    <thead>
                        <tr>
                            <th>NOM PERSONNAGE</th>
                            <th>NOM LIEU</th>
                            <th>NOM SPECIALITE</th>
                        </tr>
                    </thead>
                <tbody>";



    // On affiche chaque ligne une à une, pour un fetchAll (renvoyant un tableau), pour un fetch simple pas besoin de boucle.
    foreach ($personnages as $p) {
            $table.= "<tr>
                        <td>".$p['nom_personnage']."</td>
                        <td>".$p['nom_lieu']."</td>
                        <td>".$p['nom_specialite']."</td>
                      </tr>";    
    }

    $table.="</tbody>
            </table>";

    return $table;

}
?>




<!-- Pour dialoguer avec MySQL depuis PHP, on fait appel à l'extension PDO de PHP.

Avant de dialoguer avec MySQL, il faut s'y connecter. On a besoin de l'adresse IP de la machine où se trouve MySQL, du nom de la base de données ainsi que d'un identifiant et d'un mot de passe.

Les requêtes SQL commençant par SELECT permettent de récupérer des informations dans une base de données.

Il faut faire une boucle en PHP pour récupérer ligne par ligne les données renvoyées par MySQL.

Pour construire une requête en fonction de la valeur d'une variable, on passe par des marqueurs qui permettent d'éviter les dangereuses failles d'injection SQL. -->



<!-- 
$sqlQuery = 'SELECT * FROM recipes WHERE author = :author AND is_enabled = :is_enabled';

$recipesStatement = $mysqlClient->prepare($sqlQuery);
$recipesStatement->execute([
'author' => 'mathieu.nebra@exemple.com',
'is_enabled' => true,
]);
$recipes = $recipesStatement->fetchAll();

Dans cet exemple on évite de concaténer la requêtes pour éviter le risque d'injection SQL -->