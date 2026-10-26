# 0x01 - Permissions, SUID & SGID

Mes notes sur ce projet (gestion d'utilisateurs, groupes, permissions, bits SUID/SGID).
Scripts bash, testés sur Kali. Pas de conteneur.

## Contraintes du projet

- 1ʳᵉ ligne exactement `#!/bin/bash`, fichiers exécutables, finissent par un saut de ligne.
- Interdits : backticks, `&&`, `||`. (Le `;` est autorisé ici, utile pour `find -exec ... \;`.)
- Chaque task impose un **nombre de lignes exact** (respecté, vérifié avec `wc -l`).
- Style Betty.

⚠️ Ces scripts modifient le système pour de vrai (créer un user, éditer `/etc/sudoers`,
`chmod`/`chown`). Je les teste avec `sudo`, et pas n'importe où. Rappels de bits :
- **SUID** (4000) : le fichier s'exécute avec les droits du **propriétaire** (ex. `passwd`).
- **SGID** (2000) : s'exécute avec les droits du **groupe** ; sur un dossier, les nouveaux
  fichiers héritent du groupe du dossier.
- `find -perm -4000` = SUID posé ; `-perm -2000` = SGID ; `-perm /6000` = SUID **ou** SGID.

---

## Task 0 — créer un user + mot de passe (3 lignes, pas de printf)

```bash
#!/bin/bash
useradd -m "$1"
echo -e "$2\n$2" | passwd "$1"
```

`useradd -m` crée l'utilisateur `$1` avec son home. Puis j'envoie le mot de passe deux fois
(new + retype) à `passwd` via `echo -e` → d'où la sortie « New password: Retype new password:
passwd: password updated successfully ».

## Task 1 — créer un groupe + chgrp + droits (4 lignes, pas de printf ni echo)

```bash
#!/bin/bash
addgroup "$1"
chgrp "$1" "$2"
chmod g+rx "$2"
```

`addgroup` (sortie « Adding group ... Done. »), `chgrp` met le fichier dans le nouveau groupe,
`chmod g+rx` ajoute **read + execute** au groupe. Depuis `rw-rw-r--` → le groupe passe à `rwx`.

## Task 2 — sudo sans mot de passe (2 lignes)

```bash
#!/bin/bash
echo "$1 ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
```

Ajoute une règle NOPASSWD pour `$1` à la fin de `/etc/sudoers`. (En vrai : à ne jamais faire,
c'est exactement la mauvaise config qu'on cherche en pentest.)

## Task 3 — chasse aux SUID/SGID (2 lignes, erreurs masquées)

```bash
#!/bin/bash
find "$1" -perm /6000 -type f -exec ls -l {} \; 2>/dev/null
```

`-perm /6000` = fichiers avec SUID **ou** SGID. `-exec ls -l` pour le détail. `2>/dev/null`
jette les erreurs (dossiers interdits, etc.) comme demandé.

## Task 4 — lister les SUID (2 lignes)

```bash
#!/bin/bash
find "$1" -type f -perm -4000
```

`-perm -4000` = bit SUID posé. Sortie = chemins des fichiers.

## Task 5 — lister les SGID (2 lignes)

```bash
#!/bin/bash
find "$1" -type f -perm -2000
```

Pareil mais `-perm -2000` = bit SGID.

## Task 6 — SUID/SGID modifiés dans les dernières 24h (2 lignes)

```bash
#!/bin/bash
find "$1" -mtime -1 -perm /6000 -type f -exec ls -l {} \;
```

`-mtime -1` = modifié il y a moins d'un jour. Combiné à `/6000` + `ls -l` pour le détail.

## Task 7 — lecture seule pour les autres (find + -exec chmod)

```bash
#!/bin/bash
find "$1" -type f -exec chmod o=r {} \;
```

`chmod o=r` force les permissions **others** à `r--` (lecture seule) sans toucher owner/group.
Ex. `-rwxrwxr-x` → `-rwxrwxr--`.

## Task 8 — changer user2 -> user3 (2 lignes)

```bash
#!/bin/bash
find "$1" -user user2 -exec chown user3 {} \;
```

`-user user2` ne sélectionne que les fichiers appartenant à `user2`, puis `chown user3`.

## Task 9 — pleins droits sur les fichiers vides (2 lignes)

```bash
#!/bin/bash
find "$1" -type f -empty -exec chmod 777 {} \;
```

`-empty` = fichiers vides, `chmod 777` = rwx pour tout le monde.

---

### Comment je teste (moi-même, avec sudo)

```bash
chmod +x *.sh
sudo ./0-add_user.sh holberton 'H@ck$@f3Gu@rD!'
sudo ./1-add_group.sh security example.txt
sudo ./3-find_files.sh /usr/bin
```
