---
title: "Exercice"
description: "$ docker"
draft: false
weight: 2
---
### Exercice - Création des réseaux docker

- Créer un réseau entre un containeur **Base de données** et un containeur **Serveur Web**

##### **Étapes:**
1- Créer un réseau nommé **`monreseau`**.
```yaml
$ docker network create monreseau
$ docker network ls
NETWORK ID     NAME        DRIVER    SCOPE
d26075b0d8d3   monreseau   bridge    local
```

2.	Lancer un conteneur **Postgres (Base de données)** :

```yaml
$ docker run -d --name postgres -v database:/var/lib/postgresql/data -p 5432:5432 -e POSTGRES_PASSWORD=mysecretpassword --network monreseau postgres
```

3. Utilsier la command e`exec` pour créer une table avec des données dans la base données `postgres`

```yaml
$ docker exec -it postgres psql postgres postgres
psql (16.1 (Debian 16.1-1.pgdg120+1))
Type "help" for help.

# Taper ces commandes pour créer la table 
postgres=# CREATE TABLE helloworld (_id INTEGER, name TEXT);
CREATE TABLE

postgres=# INSERT INTO helloworld VALUES (1, 'Bonjour le Monde');
INSERT 0 1

postgres=# INSERT INTO helloworld VALUES (2, 'Salut, ca va?');
INSERT 0 1

postgres=# SELECT * FROM helloworld;
 _id |       name       
-----+------------------
   1 | Bonjour le Monde
   2 | Salut, ca va?
(2 rows)

postgres=# \q
```

4. Lancer le conteneur pour **Jupyter (Serveur Web)** :

```yaml
docker run -p 8888:8888 --network monreseau jupyter/scipy-notebook
```

5. Ouvrez un navigateur et accéder au site web du serveur Jupyter et copiez le token:

    **http://127.0.0.1:8888/**
	
6. Tester la connexion entre le Serveur Web et la Base de données :

   6.1 Sur le site de Jupyter, ouvrer un **Noteboook Python3**.
   
   6.2 Installer le paquet **`psycopg2-binary`** pour pouvoir exécuter une requête du serveur web à la base deonnées.
   
   6.3 Importer les bibliothèques `pandas`, `psycopg2` et le module `extras` de la bibliothèque `psycopg2`.
   	
   6.4 Créer la connexion avec la base de données **postgres**.
	
   6.5 Créer un curseur _(cursor)_ qui vous permet de lire à partir de la BD.
	
   6.6 Utiliser ce curseur pour exécuter une requête et afficher les résultats.
   
   Voici les commandes à utiliser **pour réaliser les étapes 6.2 à 6.6** :
	
	![](../../images/net.png?height=400&classes=border,shadow,inline)
