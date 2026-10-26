# 0x02 - Mandatory Access Control (SELinux / AppArmor)

Mes notes sur ce projet. MAC = Mandatory Access Control : contrairement aux permissions Unix
classiques (DAC, où le propriétaire décide), ici c'est une **politique système** qui impose qui
peut faire quoi, même à root. Les deux grandes implémentations : **SELinux** (Red Hat/Fedora)
et **AppArmor** (Debian/Ubuntu).

Outils clés :
- `sestatus` / `getenforce` : état/mode SELinux.
- `apparmor_status` (= `aa-status`) : profils AppArmor.
- `semanage` : gère les objets SELinux (ports, users, logins, booleans).
- `setsebool` : (dé)active les booleans SELinux.

⚠️ Ces commandes ne tournent pas sur ma WSL Ubuntu (SELinux désactivé, `semanage` absent) :
scripts écrits + vérifiés en statique, testés sur la Kali du lab. Les tasks 3/5/7 modifient la
config → à lancer avec `sudo` dans un environnement jetable.

---

## Task 0 — mode SELinux

```bash
#!/bin/bash
sestatus
```

`sestatus` affiche l'état SELinux. Quand il est désactivé, il n'affiche qu'une ligne
`SELinux status: disabled` (ce que montre l'exemple). *Si le checker préfère `getenforce`
(qui affiche juste Enforcing/Permissive/Disabled), je bascule.*

## Task 1 — profils AppArmor

```bash
#!/bin/bash
apparmor_status
```

Affiche l'état du module AppArmor et la liste des profils (enforce / complain / etc.).

## Task 2 — ports SELinux liés à HTTP

```bash
#!/bin/bash
semanage port -l | grep http
```

`semanage port -l` liste tous les ports gérés par SELinux ; `grep http` ne garde que les
services HTTP (`http_port_t`, `http_cache_port_t`, `pegasus_http...`).

## Task 3 — ajouter le port TCP 81 à http_port_t

```bash
#!/bin/bash
semanage port -a -t http_port_t -p tcp 81
```

`-a` = add, `-t http_port_t` = le type SELinux, `-p tcp 81` = protocole + port.

## Task 4 — lister les user mappings SELinux

```bash
#!/bin/bash
semanage user -l
```

Liste les utilisateurs SELinux (prefix, niveaux MLS/MCS, rôles).

## Task 5 — ajouter un login mapping vers user_u

```bash
#!/bin/bash
semanage login -a -s user_u "$1"
```

`login -a` = ajouter un mapping, `-s user_u` = l'identité SELinux cible, `$1` = le login Linux.

## Task 6 — lister tous les booleans SELinux

```bash
#!/bin/bash
semanage boolean -l
```

Affiche chaque boolean avec son état courant, son défaut et sa description. *(Alternative :
`getsebool -a`, mais le format de sortie de l'exemple correspond à `semanage boolean -l`.)*

## Task 7 — activer httpd_can_sendmail en permanence

```bash
#!/bin/bash
setsebool -P httpd_can_sendmail on
```

`setsebool` active le boolean ; `-P` = **persistant** (survit au reboot). Sans `-P`, le
changement serait perdu au redémarrage.

---

### Points à surveiller au checker

- **Task 0** : `sestatus` vs `getenforce` (j'ai pris `sestatus` pour coller à la sortie).
- **Task 6** : `semanage boolean -l` vs `getsebool -a` (idem, format de l'exemple).
