---
title: "Dockerfile"
description: "docker"
draft: false
weight: 2
---
### Fichier Docker (Dockerfile)

- Vous pouvez **créer vos propres images** ou simplement utiliser celles créées par d'autres et publiées dans un registre.
- Pour **construire votre propre image**, vous créez un **`dockerfile`** avec une syntaxe simple pour définir les étapes nécessaires à la création de l'image et à son exécution.
- Chaque instruction dans un dockerfile **crée une couche** dans l'image.
- Lorsque vous modifiez le dockerfile et reconstruisez l'image, seules les couches modifiées sont reconstruites.
- Un **dockerfile** est exécuté par la commande **`docker build`**.

#### Étapes pour construire une image

#### Exemple 1
- Créer une image basée sur `Ubuntu Linux` et `Nginx version 1.10.1`.
- Le Dockerfile copie un fichier `index.html` dans `/usr/share/nginx/html` et expose le port `8080`.

**1. Création d'un repértoire de travail :**

```console
[root@earth]# mkdir nginx-docker
[root@earth]# cd nginx-docker
```

**2. Création des fichiers complémentaires (example: des scripts) :** 

Dans cet exemple c'est **`index.html`** 

```console
[root@earth-nginx-docker]# vim index.html
  <!DOCTYPE html>
  <html>
    <head>
      <title>Ma nouvelle image</title>
    </head>
    <body>
      <h1>Mon site Web !</h1>
    </body>
  </html>
```

**3- Création du fichier `dockerfile` :**

```console
[root@earth-nginx-docker]# vim dockerfile
```

```yaml
# Création d'un dockerfile pour un serveur web Nginx

# 1. FROM : choisir une image ubuntu de base 
FROM ubuntu:24.04

# 2. LABEL : ajouter une description (optionnel mais bon à montrer)
LABEL maintainer="tohmea@itmt.ca" \
      description="Petit serveur Nginx pour démonstration dockerfile"

# 3. ARG : variable disponible seulement pendant la construction (build)
# Ici, elle sert à indiquer le répertoire du site
ARG SITE_DIR=/var/www/html

# 4. ENV : variable d'environnement persistante dans le conteneur
ENV MESSAGE="Bienvenue dans Docker !"

# 5. WORKDIR : définir le dossier de travail par défaut
WORKDIR ${SITE_DIR}

# 6. RUN : exécuter une commande lors de la construction de l’image. Ici installer Nginx
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

# 7. COPY : copier un fichier local dans l'image
COPY index.html ${SITE_DIR}/index.html

# 8. VOLUME : créer un voulme comme point de montage pour modifier les fichiers du site
VOLUME ["${SITE_DIR}"]

# 9. EXPOSE : documenter le port HTTP
EXPOSE 80

# 10. CMD : commande par défaut quand le conteneur démarre
# Cela lance le serveur Nginx en mode premier plan afin que le conteneur ne s’arrête pas immédiatement après son démarrage.
CMD ["nginx", "-g", "daemon off;"]
```

##### Instructions Dockerfile :

* **FROM** : définit l’image de base (doit toujours être la première instruction).
* **LABEL** : ajoute des métadonnées à l’image (description, auteur, version, etc.).
* **ARG** : définit des variables disponibles uniquement pendant la construction (utilisées avec --build-arg).
* **ENV** : définit des variables d’environnement accessibles dans le conteneur.
* **WORKDIR** : définit le répertoire de travail par défaut à l’intérieur du conteneur.
* **RUN** : exécute une commande lors de la construction de l’image (chaque RUN crée une nouvelle couche).
* **COPY** : copie des fichiers locaux dans l’image (préférée à ADD).
* **ADD** : copie aussi des fichiers mais peut, en plus, extraire des archives .tar ou télécharger depuis une URL distante.
* **VOLUME** : déclare un répertoire comme point de montage (données persistantes lors de l’exécution).
* **EXPOSE** : documente les ports que le conteneur utilise (ex. 80 pour HTTP).
* **CMD** : définit la commande ou les paramètres par défaut exécutés au démarrage du conteneur.
* **ENTRYPOINT** : définit la commande principale exécutée au démarrage (CMD peut servir à compléter ses arguments).
* **ONBUILD** : définit une instruction qui sera exécutée automatiquement si cette image est utilisée comme base pour en construire une autre.

**4- Construire la nouvelle image :**

Pour construire une image à partir de ce `dockerfile`, nous utilisons la commande **`docker build -t`**. 

```yaml
docker build -t <build context>
```

Nous passons **`.`** comme contexte de construction, ce qui signifie le répertoire actuel. 

```console
[root@earth-nginx-docker]# docker build -t tohmea/nginx-ubuntu:latest .
[root@earth-nginx-docker]# docker image ls
REPOSITORY              TAG       IMAGE ID       CREATED              SIZE
tohmea/nginx-ubuntu     latest    de8ec9c22f25   About a minute ago   84.6MB
```

**5- Création d'un conteneur de cette nouvelle image :**
```console
[root@earth-nginx-docker]# docker run -d --name nginx-tohmea -p 8080:80 tohmea/nginx-ubuntu
[root@earth-nginx-docker]# docker ps -a
CONTAINER ID   IMAGE                 COMMAND                  CREATED         STATUS         PORTS                                     NAMES
3f7a3503a650   tohmea/nginx-ubuntu   "nginx -g 'daemon of…"   5 seconds ago   Up 4 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   nginx-tohmea
```

**5- Tester le conteneur :**
```console
[root@earth-nginx-docker]# curl http://127.0.0.1:8080
<!DOCTYPE html>
<html>
  <head>
    <title>My new Image</title>
  </head>
  <body>
    <h1>My web site !</h1>
  </body>
</html>

[root@earth-nginx-docker]# docker exec -it nginx-tohmea bash
root@509cba1cca2a:/var/www/html# echo $MESSAGE
Bienvenue dans Docker !
root@509cba1cca2a:/var/www/html# exit
```

#### Exemple 2

Créer un environnement `Python` avec `Flask`.

**1- Création d'un repértoire de travail :**

```console
$ mkdir my-flask-app 
$ cd my-flask-app
```
**2- Création des fichiers complémentaires :**

```yaml
$ vim requirements.txt

# Chaque ligne correspond à une bibliothèque à installer avec pip
# Necessaire pour faire fonctionner flask avec python
Flask==2.0.1
Werkzeug==2.0.1
```
```yaml
$ vim app.py

# Exemple d’application Flask (app.py)
# Importation de la classe Flask depuis le module flask
from flask import Flask

# Création d'une instance de l'application Flask
app = Flask(__name__)

# Définition d'une route (URL "/")
# Quand un utilisateur accède à http://localhost:5000/
# la fonction hello_world() sera exécutée
@app.route('/')
def hello_world():
    return 'Hello, World!'
	
# Point d’entrée principal de l’application
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0') 
```

**3- Création du fichier `dockerfile` :**
```yaml
$ vim dockerfile

# Utilise une image Python officielle comme image parente.
FROM python:3.9-slim

# Définit une variable d’environnement
ENV NAME="World"
  
# Définit le répertoire de travail dans le conteneur sur /app
WORKDIR /app
  
# Copie en premier les fichiers requirements (permet d’utiliser le cache Docker)
COPY requirements.txt /app/

# Installe les paquets nécessaires spécifiés dans requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copie ensuite le reste du code source /app dans le conteneur
COPY . /app
    
# Rend le port 5000 accessible au monde extérieur depuis ce conteneur
EXPOSE 5000
  
# Exécute app.py au démarrage du conteneur
CMD ["python", "app.py"]
```

**4-Création de l'image :**

```console
$ docker build -t tohmea/mon-flask-app:1.0 .
+] Building 5.8s (11/11) FINISHED  docker:default
 => [internal] load build definition from dockerfile                                                                                 
 => => transferring dockerfile: 732B                                                                                                 
...
 => => naming to docker.io/tohmea/mon-flask-app:1.0      
```

**5-Création du conteneur :**
```console
$ docker run -d -p 5000:5000 --name mon-flask tohmea/mon-flask-app:1.0
```

**6-Test :**

![](../../images/image1.png?height=&classes=border,shadow,inline))

