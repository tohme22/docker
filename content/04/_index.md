---
title: "4. Variables"
description: "docker"
draft: false
weight: 4
---
### Variables d’environnement 

- Dans Docker, les **variables d'environnement** permettent de personnaliser le comportement des conteneurs sans avoir à modifier l'image. 

- Elles sont utilisées pour définir des paramètres comme l'utilisateur, les chemins, les options de configuration ou encore les secrets (ex. mots de passe, clés API).

- Elles peuvent être **définies directement** dans la commande `docker run` ou bien **centralisées** dans un fichier `.env`.

   **`-e`** **`--env`** --> Permet de définir directement une variable d’environnement lors du lancement du conteneur.   

   **`--env-file`** --> Permet de charger plusieurs variables d’environnement à partir d’un fichier texte.

#### Exemple 1 : Utilisation des variables d’environnement avec l’option -e

```yaml
[root@earth]# docker run --rm -it alpine
echo $VAR1
exit

# Spécifier la valeur de la variable $VAR1 dans la comamnde docker run
[root@earth]# docker run --rm -it -e VAR1="Bonjour Antoine" alpine
echo $VAR1
Bonjour Antoine
exit
```
##### 🔹 Explication de l'option -e

-`e` (abréviation de `--env`) sert à définir une variable d’environnement dans le conteneur au moment de son exécution.

Dans ton exemple : **-e VAR1="Bonjour Antoine"**

Cela crée une variable d’environnement nommée `VAR1` à l’intérieur du conteneur, avec la valeur Bonjour Antoine.

##### 🔹 À quoi ça sert ?

Les variables d’environnement permettent de :
- Passer des paramètres de configuration aux applications dans le conteneur.
- Changer le comportement du logiciel sans modifier l’image Docker.
- Stocker des informations comme des mots de passe, clés API, chemins, etc.

#### Exemple 2 : Utilisation des variables d’environnement avec l’option -e (Base de donnée)

Example d'utilisation des **variables d'environnement** avec `mysql`

```yaml
[root@earth]# docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=Password123 -e MYSQL_DATABASE=school mysql
```
-e MYSQL_ROOT_PASSWORD=Password123 → Indique à MySQL le mot de passe à configurer pour l’utilisateur root.

-e MYSQL_DATABASE=school → Indique à MySQL de créer automatiquement une base de données nommée "school".

#### Exemple 3 : Utilisation des variables d’environnement avec l’option -e (Web Interface)

Example d'utilisation des **variables d'environnement** avec `jupyter/minimal-notebook`

**https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html**

```yaml
[root@earth]# mkdir /data
[root@earth]# touch /data/fichier1.txt

# Lancer un conteneur Docker basé sur l’image jupyter/minimal-notebook. 
# Monter /data vers le répertoire personnel de l'utilisateur jovyan et mapper le port 8080
[root@earth]# docker run --rm -v /data:/home/jovyan/data -p 8080:8888 jupyter/minimal-notebook

# Tester avec un navigateur
http://127.0.0.1:8080
```
- Essayez de créer un fichier dans le répertoire data.
- Vous obtiendrez une erreur « Permission denied » car le répertoire appartient à l’utilisateur root.

![](../images/variable1.png?height=400&classes=border,shadow,inline)


- Solution : Utiliser des **variables d’environnement** pour attribuer la propriété à l’utilisateur jovyan.

```yaml
[root@earth]# docker run --rm -v /data:/home/jovyan/data -p 8080:8888 -e CHOWN_HOME=yes -e NB_USER=jovyan --user root -w /home/$NB_USER -e CHOWN_HOME_OPTS='-R' jupyter/minimal-notebook
```
##### 🔹 Description des options

-   **`-e CHOWN_HOME=yes`**\
    Indique au script de démarrage du conteneur de **changer le
    propriétaire** (`chown`) du répertoire personnel (`/home/$NB_USER`)
    pour qu'il appartienne à l'utilisateur du notebook (`jovyan`).\
    Cela évite les problèmes de permissions lorsque des volumes montés
    appartiennent à `root` ou à un autre utilisateur.

-   **`-e NB_USER=jovyan`**\
    Définit l'utilisateur du notebook à l'intérieur du conteneur. Par
    défaut, les images Jupyter utilisent `jovyan` comme utilisateur
    non-root principal. Ce paramètre permet aux scripts de démarrage de
    savoir quel compte doit posséder et exécuter les notebooks.

-   **`--user root`**\
    Lance le conteneur initialement avec les droits **root**.\
    C'est nécessaire pour ajuster les permissions des volumes montés ou
    installer des paquets au démarrage.\
    Ensuite, les scripts de Jupyter redescendent les privilèges vers
    `jovyan` pour plus de sécurité.

-   **`-w /home/$NB_USER`**\
    Définit le **répertoire de travail** à l'intérieur du conteneur.
    Ici, il pointe vers le répertoire personnel de `jovyan`
    (`/home/jovyan`). Ainsi, à l'ouverture, on se trouve directement
    dans ce dossier.

-   **`-e CHOWN_HOME_OPTS='-R'`**\
    Fournit des options supplémentaires à la commande `chown`.\
    `-R` signifie *récursif*, donc le changement de propriétaire
    s'applique non seulement au dossier `/home/jovyan`, mais aussi à
    tous ses fichiers et sous-dossiers.\
    Exemple équivalent :

```yaml
chown -R jovyan:users /home/jovyan
```

##### 🔹 Pourquoi cette configuration ?

-   Lorsqu'on monte un volume hôte (`/data:/home/jovyan/data`), il peut
    ne pas appartenir à l'utilisateur `jovyan`.\
-   En démarrant avec `root` et en utilisant `CHOWN_HOME=yes` avec
    l'option `-R`, le conteneur s'assure que `jovyan` ait les droits
    nécessaires pour écrire dans `/home/jovyan/data`.\
-   Ensuite, l'exécution repasse sous l'utilisateur non-root `jovyan`
    pour la sécurité.


![](../images/env01.png?height=550&classes=border,shadow,inline)


#### Exemple 4 : Utilisation d’un fichier d'environnement avec l'option --env-file

##### 🔹 Exemple de fichier `.env`

Le fichier `.env` contient les variables d'environnement :

```yaml
[root@earth]#  vim .env
CHOWN_HOME=yes
NB_USER=jovyan
CHOWN_HOME_OPTS=-R
```
##### 🔹 Lancement du conteneur

```yaml
[root@earth]# docker run --rm -v /data:/home/jovyan/data -p 8080:8888 --env-file .env --user root -w /home/$NB_USER jupyter/minimal-notebook
```

##### 🔹 Avantage de `--env-file`

L'utilisation d'un fichier `.env` est pratique car :
- Elle permet de centraliser les variables d'environnement.
- Elle évite de surcharger la ligne de commande avec plusieurs `-e`.
- Elle rend la configuration réutilisable et facile à partager.

-------------------------

Ressources:

_https://docs.docker.com/compose/environment-variables/_
