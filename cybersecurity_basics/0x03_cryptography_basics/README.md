# 0x03 - Cryptography basics

Mes notes sur ce projet (hashing + cassage de mots de passe). Pas besoin de conteneur :
tout tourne en local sous WSL avec `sha1sum`/`sha256sum`/`md5sum`/`openssl`, puis `john` et
`hashcat` pour le cassage.

Un piège que j'ai validé dès le départ : il faut hacher **sans saut de ligne final**. Donc
`printf '%s' "$1"` et surtout pas `echo "$1"` (qui ajoute un `\n` et change le hash).

---

## Task 0 — SHA-1

Je hache l'argument `$1` en SHA-1 et je ne garde que le hash (pas le `  -` que `sha1sum`
ajoute), dans `0_hash.txt`.

```bash
printf '%s' "$1" | sha1sum | awk '{print $1}' > 0_hash.txt
```

Vérif : `./0-sha1.sh "Holberton"` → `808f94d2847fb381839b4bbbd7cdf30804fd47ac`. OK.

## Task 1 — SHA-256

Pareil avec `sha256sum`.

```bash
printf '%s' "$1" | sha256sum | awk '{print $1}' > 1_hash.txt
```

Vérif "Holberton" → `77c4925c01e8d9f79c8a6a61685c6b3182be10f2fa553de915f3733ee19c0204`. OK.

## Task 2 — MD5

Pareil avec `md5sum`.

```bash
printf '%s' "$1" | md5sum | awk '{print $1}' > 2_hash.txt
```

Vérif "Holberton" → `f3b21c0205fba4fc7e6cb96ae6edc950`. OK.

## Task 3 — Hash sécurisé (sel + SHA-512 via OpenSSL)

Je génère un sel aléatoire de 16 caractères hex avec OpenSSL (`openssl rand -hex 8` = 8 octets
= 16 hex), je le colle au mot de passe, puis je hache le tout en SHA-512 avec OpenSSL. Le but
du sel : deux utilisateurs avec le même mot de passe n'ont pas le même hash, et on casse plus
difficilement avec des rainbow tables.

```bash
salt=$(openssl rand -hex 8)
printf '%s' "$1$salt" | openssl dgst -sha512 > 3_hash.txt
cat 3_hash.txt
```

Le hash change à chaque exécution (sel aléatoire), c'est normal.

> Note version : mon OpenSSL (3.x) écrit `SHA2-512(stdin)= ...` alors que l'énoncé montre
> `SHA512(stdin)= ...`. C'est juste le libellé qui a changé entre OpenSSL 1.1 et 3.x, le hash
> est bien du SHA-512. Comme le sel est aléatoire, la valeur n'est pas vérifiable de toute façon.

---

## Tasks 4 à 9 — cassage (John the Ripper / hashcat)

### Setup (une fois)

`john`, `hashcat` et RockYou n'étaient pas là par défaut sur ma WSL. Je les ai mis comme ça
(RockYou vient de mon snap seclists, car le paquet apt `wordlists` n'existe pas sur mon Ubuntu) :

```bash
sudo apt install -y john hashcat
sudo mkdir -p /usr/share/wordlists
sudo tar -xzf /snap/seclists/current/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /usr/share/wordlists/
```

⚠️ Piège important : le `john` du dépôt Ubuntu est la version **core 1.9.0**, qui ne connaît
PAS les formats `Raw-MD5` / `Raw-SHA256` / `nt` (erreur « Unknown ciphertext format name
requested »). Ces formats viennent de **john-jumbo**. Sur l'environnement du correcteur
(Kali) john est en jumbo, donc mes scripts `john` sont bons là-bas. En local, j'ai récupéré
les mots de passe avec **hashcat** (résultat identique) :
`-m 0` = MD5, `-m 1400` = SHA-256, `-m 1000` = NTLM.

### Task 4 — John, mode wordlist (MD5)

`hash.txt` contient 3 hash. L'énoncé dit « SHA-256 » mais ce sont en fait des **MD5** (32 hex),
je l'ai confirmé en les cassant en MD5. Donc mon script force `--format=Raw-MD5`.

```bash
john --wordlist=/usr/share/wordlists/rockyou.txt --format=Raw-MD5 "$1"
john --show --format=Raw-MD5 "$1" | awk -F: 'NF>1 {print $2}' > 4-password.txt
```

Résultat : `Password123`, `helloworld`, `herro`.

### Task 5 — John, hash Windows NT/NTLM

NThash = le format de hash des mots de passe Windows modernes. Le flag clé c'est `--format=nt`.

```bash
john --wordlist=/usr/share/wordlists/rockyou.txt --format=nt "$1"
john --show --format=nt "$1" | awk -F: 'NF>1 {print $2}' > 5-password.txt
```

Hash `895F465356A0403458759A6B104B7242` → `good`.

### Task 6 — John, SHA-256 (crack.txt)

Même principe que la task 4 mais le hash est bien un SHA-256 (64 hex), format `Raw-SHA256`.

```bash
john --wordlist=/usr/share/wordlists/rockyou.txt --format=Raw-SHA256 "$1"
john --show --format=Raw-SHA256 "$1" | awk -F: 'NF>1 {print $2}' > 6-password.txt
```

`aee40884...bee85f27` → `success`.

### Task 7 — hashcat, attaque directe (straight)

`-m 0` = MD5, `-a 0` = attaque par dictionnaire (straight) sur RockYou. `--show` relit le
potfile pour afficher `hash:motdepasse`.

```bash
hashcat -m 0 -a 0 "$1" /usr/share/wordlists/rockyou.txt
hashcat -m 0 "$1" --show | awk -F: 'NF>1 {print $NF}' > 7-password.txt
```

`5f4dcc3b...cf99` → `password`.

### Task 8 — hashcat, combinaison de 2 wordlists

`-a 1` = attaque par combinaison : chaque mot de la liste 1 (gauche) est collé à chaque mot
de la liste 2 (droite). `--stdout` affiche les combinaisons au lieu de cracker.

```bash
hashcat -a 1 --stdout "$1" "$2"
```

Avec `pass/123/hello` × `word/world/000` → `password`, `passworld`, `pass000`, `123word`, …,
`hello000`.

### Task 9 — hashcat, attaque par combinaison

On réutilise la combinaison de la task 8 (`-a 1` avec wordlist1 + wordlist2) pour casser un MD5.

```bash
hashcat -m 0 -a 1 "$1" wordlist1.txt wordlist2.txt
hashcat -m 0 "$1" --show | awk -F: 'NF>1 {print $NF}' > 9-password.txt
```

`5ad8699d...69b9` → `hello000` (= "hello" + "000").

---

### Récap des mots de passe trouvés

| Fichier | Mot(s) de passe |
|---|---|
| 4-password.txt | Password123 / helloworld / herro |
| 5-password.txt | good |
| 6-password.txt | success |
| 7-password.txt | password |
| 9-password.txt | hello000 |
