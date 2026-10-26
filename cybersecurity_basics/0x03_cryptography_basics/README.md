# 0x03 - Cryptography basics

Mes notes sur ce projet (hashing + cassage de mots de passe). Pas besoin de conteneur :
tout tourne en local sous WSL avec `sha1sum`/`sha256sum`/`md5sum`/`openssl`, puis `john` et
`hashcat`.

## Contraintes du projet (à ne pas oublier)

- Chaque script fait **exactement 2 lignes** (`wc -l` doit afficher 2) : ligne 1 `#!/bin/bash`,
  ligne 2 la commande. Donc **pas de commentaire** dans les scripts.
- Pas de backticks, ni `&&`, `||`, `;`. (J'utilise `|`, `>`, `$(...)` qui sont autorisés.)
- Tous les fichiers finissent par un saut de ligne et sont exécutables (`chmod +x`).
- Noms d'algos en minuscules (`sha1`, `sha256`, `raw-md5`, `nt`...).

Autre piège validé dès le départ : hacher **sans saut de ligne final** → `echo -n` (ou
`printf '%s'`), jamais `echo` tout court (qui ajoute un `\n` et change le hash).

---

## Task 0 — sha1

```bash
#!/bin/bash
echo "$(echo -n "$1" | sha1sum | cut -d " " -f 1)" > 0_hash.txt
```

`echo -n "$1" | sha1sum` donne `hash  -` ; `cut -d " " -f 1` ne garde que le hash ; le `echo
"$(...)"` l'écrit dans le fichier. Vérif "Holberton" → `808f94d2847fb381839b4bbbd7cdf30804fd47ac`.

## Task 1 — sha256

```bash
#!/bin/bash
echo "$(echo -n "$1" | sha256sum | cut -d " " -f 1)" > 1_hash.txt
```

"Holberton" → `77c4925c01e8d9f79c8a6a61685c6b3182be10f2fa553de915f3733ee19c0204`.

## Task 2 — md5

```bash
#!/bin/bash
echo "$(echo -n "$1" | md5sum | cut -d " " -f 1)" > 2_hash.txt
```

"Holberton" → `f3b21c0205fba4fc7e6cb96ae6edc950`.

## Task 3 — sel + sha512 (OpenSSL)

```bash
#!/bin/bash
echo -n "$1$(openssl rand -hex 8)" | openssl dgst -sha512 > 3_hash.txt
```

`openssl rand -hex 8` = 8 octets = 16 caractères hex (le sel aléatoire). Je le colle au mot de
passe puis je hache en sha512. Le hash change à chaque exécution (sel aléatoire), c'est normal.

> Note version : mon OpenSSL 3.x écrit `SHA2-512(stdin)=` au lieu du `SHA512(stdin)=` de
> l'énoncé. Juste un changement de libellé entre OpenSSL 1.1 et 3.x, le hash est bien du sha512.

---

## Tasks 4 à 9 — cassage (john / hashcat)

### Setup (une fois)

`john`, `hashcat` et RockYou n'étaient pas là par défaut. RockYou vient de mon snap seclists
(le paquet apt `wordlists` n'existe pas sur mon Ubuntu) :

```bash
sudo apt install -y john hashcat
sudo mkdir -p /usr/share/wordlists
sudo tar -xzf /snap/seclists/current/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /usr/share/wordlists/
```

⚠️ Le `john` d'Ubuntu est la version **core 1.9.0**, qui ne connaît pas `raw-md5`/`raw-sha256`/
`nt` (« Unknown ciphertext format name requested »). Ces formats viennent de **john-jumbo**
(présent sur le Kali du correcteur). En local j'ai donc récupéré les mots de passe avec
**hashcat** (résultat identique) : `-m 0` = md5, `-m 1400` = sha256, `-m 1000` = ntlm.

Chaque script fait juste le crack (2 lignes). Les mots de passe trouvés, je les mets à la main
dans les `N-password.txt` (comme le montre l'énoncé avec `echo ... > N-password.txt`).

### Task 4 — john wordlist

```bash
#!/bin/bash
john --wordlist=/usr/share/wordlists/rockyou.txt --format=raw-md5 "$1"
```

⚠️ L'énoncé parle de « sha256 » mais les hash fournis dans `hash.txt` sont des **md5** (32 hex),
je l'ai confirmé en les cassant. D'où `--format=raw-md5`. Si jamais le correcteur fournit un
`hash.txt` en sha256 (64 hex), il faudra remettre `--format=raw-sha256`.
Résultat : `Password123`, `helloworld`, `herro` → `4-password.txt`.

### Task 5 — john NT (Windows)

```bash
#!/bin/bash
john --wordlist=/usr/share/wordlists/rockyou.txt --format=nt "$1"
```

NThash = format des mots de passe Windows modernes. `895F4653...B7242` → `good` → `5-password.txt`.

### Task 6 — john sha256 (crack.txt)

```bash
#!/bin/bash
john --wordlist=/usr/share/wordlists/rockyou.txt --format=raw-sha256 "$1"
```

`aee40884...bee85f27` (64 hex = vrai sha256) → `success` → `6-password.txt`.

### Task 7 — hashcat attaque directe

```bash
#!/bin/bash
hashcat -m 0 -a 0 "$1" /usr/share/wordlists/rockyou.txt
```

`-m 0` = md5, `-a 0` = dictionnaire. `5f4dcc3b...cf99` → `password` → `7-password.txt`.

### Task 8 — hashcat combinaison de 2 wordlists

```bash
#!/bin/bash
hashcat -a 1 --stdout "$1" "$2"
```

`-a 1` = combinaison : chaque mot de la liste 1 (gauche) collé à chaque mot de la liste 2
(droite). `pass/123/hello` × `word/world/000` → `password`, `passworld`, `pass000`, … `hello000`.

### Task 9 — hashcat attaque par combinaison

```bash
#!/bin/bash
hashcat -m 0 -a 1 "$1" wordlist1.txt wordlist2.txt
```

Réutilise la combinaison de la task 8 pour casser un md5. `5ad8699d...69b9` → `hello000`
(= "hello" + "000") → `9-password.txt`.

---

### Récap des mots de passe

| Fichier | Valeur |
|---|---|
| 4-password.txt | Password123 / helloworld / herro |
| 5-password.txt | good |
| 6-password.txt | success |
| 7-password.txt | password |
| 9-password.txt | hello000 |
