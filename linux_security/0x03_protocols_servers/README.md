# 0x03 - Protocols & Servers (sécurité)

Mes notes sur ce projet : audit et durcissement de services réseau (iptables, SSH, NFS, SNMP,
SMTP) + quelques outils offensifs (hping3, nmap). Conventions : `#!/bin/bash` en 1ʳᵉ ligne,
pas de backtick/`&&`/`||`, exécutables. Task 9 doit faire exactement 3 lignes.

⚠️ Rien exécuté en local : ça touche iptables, fait un `chmod` récursif depuis `/`, lance une
**vraie attaque DoS** (task 7) et des scans réseau. Outils souvent absents de ma WSL (lynis,
hping3, nmap scripts, snmpd, postfix). Tests sur la Kali du lab.

---

## Task 0 — règles iptables lisibles avec numéros

```bash
#!/bin/bash
iptables -L -v -n --line-numbers
```

`-L` liste, `-v` verbeux (pkts/bytes), `-n` numérique (pas de résolution DNS), `--line-numbers`
ajoute le `num` en tête de chaque règle.

## Task 1 — audit de la conf SSH

```bash
#!/bin/bash
grep -vE "^#|^$" /etc/ssh/sshd_config
```

Je ne garde que les directives **actives** : `grep -v` enlève les lignes de commentaire (`^#`)
et les lignes vides (`^$`).

## Task 2 — durcir les dossiers world-writable

```bash
#!/bin/bash
find / -type d -perm -0002 -print -exec chmod o-w {} \; 2>/dev/null
```

`-perm -0002` = dossiers où « others » peut écrire (dangereux). `-print` les liste, puis
`-exec chmod o-w` retire le droit d'écriture aux autres. `2>/dev/null` masque les erreurs.

## Task 3 — vulnérabilités avec lynis

```bash
#!/bin/bash
lynis audit system
```

`lynis audit system` = audit de sécurité complet de la machine.

## Task 4 — partages NFS ouverts

```bash
#!/bin/bash
showmount -e "$1"
```

`showmount -e <ip>` liste les exports NFS d'un hôte (et qui peut les monter). `(everyone)` =
accessible par tout le monde → vulnérable.

## Task 5 — SNMP en accès public

```bash
#!/bin/bash
grep -v "^#" /etc/snmp/snmpd.conf | grep public
```

J'enlève les commentaires, puis je cherche `public` (la community string par défaut, non
sécurisée) dans la conf SNMP.

## Task 6 — SMTP : STARTTLS présent ?

```bash
#!/bin/bash
if grep -q "smtpd_tls_security_level" /etc/postfix/main.cf
then
	grep "smtpd_tls_security_level" /etc/postfix/main.cf
else
	echo "STARTTLS not configured"
fi
```

Je cherche `smtpd_tls_security_level` dans la conf Postfix. S'il existe je l'affiche, sinon
j'affiche `STARTTLS not configured`. (Pas de `||` autorisé → j'utilise un `if/else`.)

## Task 7 — simulation DoS (hping3)

```bash
#!/bin/bash
hping3 -S -p 80 --flood "$1"
```

`-S` = paquets SYN, `-p 80` = port HTTP, `--flood` = envoi le plus rapide possible (SYN flood).
À n'utiliser QUE contre une cible à moi, en lab. C'est l'illustration offensive du cours.

## Task 8 — ciphers SSL/TLS faibles (nmap)

```bash
#!/bin/bash
nmap --script ssl-enum-ciphers -p 443 "$1"
```

Le script NSE `ssl-enum-ciphers` liste les suites de chiffrement supportées sur le 443 et leur
note (A à F) → on repère les faibles.

## Task 9 — firewall de base : tout bloquer sauf SSH (3 lignes)

```bash
#!/bin/bash
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -P INPUT DROP
```

D'abord j'**autorise** le SSH entrant (port 22), ensuite je passe la politique par défaut de la
chaîne INPUT à **DROP** (tout le reste est bloqué). L'ordre compte : la règle ACCEPT est évaluée
avant la policy.

---

### Points à surveiller au checker

- **Task 2** : `-perm -0002` touche aussi les dossiers sticky (type `/tmp`). Si le checker veut
  les exclure, ajouter `! -perm -1000`.
- **Tasks 5/6** : chemins `/etc/snmp/snmpd.conf` et `/etc/postfix/main.cf` (dépendent des
  services installés sur la machine de test).
