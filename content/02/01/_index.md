---
title: "Exemples"
description: "docker"
draft: false
weight: 2
---
### Exemples - Création de conteneurs

```yaml
EXEMPLE 1 - Image Ubuntu:
--------------------------
# Lister toutes les images Docker disponibles localement
$ docker image ls

# Recherchez sur Docker Hub une image officielle Ubuntu.
$ docker search ubuntu

# Télécharger l’image Ubuntu depuis Docker Hub
$ docker pull ubuntu

# Créer et exécuter un conteneur basé sur Ubuntu pour exécuter la commande 'ls'
$ docker run ubuntu

# Lister tous les conteneurs (actifs et arrêtés)
$ docker ps -a

# Supprimer un conteneur (remplacer <container_name> par le nom du conteneur)
$ docker rm <container_name>

# Créez un conteneur à partir de l’image ubuntu sans l’exécuter immédiatement.
$ docker create ubuntu
$ docker ps -a

# Démarrez le conteneur créé à l’étape précédent
$ docker start <nom_container>
$ docker ps -a

Supprimez tous les conteneurs et confirmez qu’ils sont bien supprimés.
$ docker rm -f $(docker ps -a -q)
$ docker ps -a

# Créer et exécuter un conteneur interactif nommé 'ubuntu1 basé sur Ubuntu
$ docker run -it --name ubuntu1 ubuntu
$ docker ps -a

# Lister les fichiers dans le conteneur (dans le shell root du conteneur)
root@9dad023013d9:/# ls
# CTRL + p, puis CTRL + q pour sortir du conteneur sans l'arrêter

# Afficher en temps réel les statistiques d’utilisation (CPU, mémoire, etc.) des conteneurs
$ docker stats 
# CTRL + c pour sortir de l’écran de surveillance.

# Lister tous les conteneurs (actifs et arrêtés)
$ docker ps -a

# Exécutez une commande simple (ls, pwd) sans passer en mode interactif.
$ docker exec ubuntu1 ls
$ docker exec ubuntu1 pwd

# Rentrez dans le container en utilisant le terminal bash
$ docker exec -it ubuntu1 bash

# Sortir du conteneur et l'arrêter
root@9dad023013d9:/# exit

# Renommer le conteneur ubuntu1 en ubuntu2
$ docker rename ubuntu1 ubuntu2

# Arrêtez le conteneur et vérifiez
$ docker stop ubuntu2
$ docker ps -a

# Supprimer un conteneur et vérifiez
$ docker rm ubuntu2
$ docker ps -a
```

```yaml
EXEMPLE 2 - Image Node.js Python et Redis:
--------------------------------------------
# Lancer un conteneur interactif basé sur l’image Node.js
$ docker run -it node 

# Effectuer une addition dans le REPL Node.js
> 1 + 1
2
# Quitter le REPL Node.js
> .exit

# Lancer un conteneur interactif basé sur l’image Python
$ docker run -it python 

# Effectuer une addition dans l’interpréteur Python
>>> 1 + 1
2
# Quitter l’interpréteur Python
>>> exit()

# Lister tous les conteneurs (actifs et arrêtés)
$ docker ps -a

# Lister tous images téléchargées
$ docker image ls

# Démarrer un conteneur (remplacer <nom_conteneur> par le nom du conteneur)
$ docker start <nom_conteneur>
$ docker ps -a

# Démarrer un conteneur en mode interactif
$ docker start -i <nom_conteneur>
# CTRL + p, puis CTRL + q pour sortir du conteneur sans l'arrêter
$ docker ps -a

# Arrêter un conteneur en cours d’exécution
$ docker stop <nom_conteneur>
$ docker ps -a

# Forcer l’arrêt immédiat d’un conteneur (kill)
$ docker kill <nom_conteneur>
$ docker ps -a

# Afficher les logs d’un conteneur
$ docker logs <nom_conteneur>

# Afficher toutes les informations détaillées d’un conteneur en format JSON
$ docker inspect <nom_conteneur>

# Lancer un conteneur Redis en arrière-plan et nommer-le redis1 :
$ docker run -d --name redis1 redis
$ docker ps -a

# Ouvrir une session redis-cli dans un conteneur existant
$ docker exec -it redis1 redis-cli 

# Quitter l’invite redis-cli
127.0.0.1:6379> exit

# Lister tous les conteneurs
$ docker ps -a

# Arrêter un conteneur
$ docker stop redis1
```

```yaml
EXEMPLE 3 - Image Apache:
-------------------------
# Télécharger l’image httpd depuis Docker Hub
$ docker pull httpd   
$ docker image ls

# Lancez un conteneur httpd en arrière-plan, nommez-le apache et mappez le port 80 :
$ docker run -d --name apache -p 80:80 httpd

# Accéder au serveur Apache
 curl http://localhost:80

# Lister tous les conteneurs (actifs et arrêtés)
$ docker ps -a  

# Arrêter le conteneur apache
$ docker stop apache

# Supprimer le conteneur apache
$ docker rm apache
```
```yaml
Commandes pour arrêter et supprimer les conteneurs et les images:
-----------------------------------------------------------------
# Arrêter tous les conteneurs en cours et arrêtés
$ docker stop $(docker ps -a -q)

# Supprimer tous les conteneurs
$ docker rm $(docker ps -a -q)

# Supprimer toutes les images Docker
$ docker rmi $(docker images -a -q)

# Supprimer uniquement les images non utilisées par aucun conteneur
$ docker image prune -a

# Nettoyer toutes les ressources Docker inutilisées pour libérer de l’espace disque
$ docker system prune
```
