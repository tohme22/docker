---
title: "Exercice"
description: "docker"
draft: false
weight: 3
---
### Exercice - Création de conteneurs pour l’analyse de données

1- Cherchez sur le site https://hub.docker.com/ l’application **jupyter/tensorflow-notebook** afin de vérifier qu’elle existe.

2- Lancer un conteneur **Jupyter TensorFlow Notebook** et mapper le port **12345** vers **8888**. 
```yaml
$ docker run --rm -p 12345:8888 jupyter/tensorflow-notebook

# --rm : signifie que le conteneur sera automatiquement supprimé lorsqu’il sera arrêté.
```

3- Ouvrir un navigateur Internet pour accéder à Jupyter Notebook: **http://127.0.0.1:12345**

4- Copier le **token** affiché dans le terminal Docker et le coller dans le navigateur

![](../../images/ex1a.png?height=150&classes=border,shadow,inline)

5- Vous devriez avoir cette page ouverte :

![](../../images/ex1.png?height=400&classes=border,shadow,inline)

6- Cliquez sur **Notebook --> Python 3 (ipykernel)**

7- Tapez cette commande pour tester le conteneur :

`!pip freeze`

Ensuite, cliquez sur le bouton run (l'icône play) pour lancer le test. Vous devriez obtenir ce résultat.

Remarque : La commande `!pip freeze`  dans un Notebook Jupyter (ou dans tout environnement Python) affiche la liste de tous les paquets Python installés ainsi que leurs versions.

![](../../images/ex1b.png?height=400&classes=border,shadow,inline)

8- Effectuez un autre test : Fermez le Notebook et cliquez sur **Terminal**

![](../../images/ex1c.png?height=150&classes=border,shadow,inline)

9- Essayez quelques commandes :

![](../../images/ex1d.png?height=200&classes=border,shadow,inline)

10- Ouvrez un nouveau terminal linux et affichez les conteneurs en cours d’exécution avec `docker ps -a` et remarquez le nouveau conteneur avec le port `12345`.

11 – Arrêtez le nouveau conteneur et exécutez à nouveau `docker ps -a`, le nouveau conteneur a été automatiquement supprimé.

