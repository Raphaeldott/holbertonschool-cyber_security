passive reconnaissance

tips pour trouver le ip range après avoir trouver une ip sur shodan et pourquoi il ne faut pas déduire l'ip range directement.
Pourquoi ce n’est pas sûr automatiquement

Une adresse unique n’indique pas la taille du préfixe qui lui est alloué. Un fournisseur peut annoncer un /32, /24, /20, /16, /12, etc.

Les clouds (AWS, GCP, Azure) publient des blocs d’adresses de tailles variables ; par exemple AWS peut annoncer 35.180.27.0/24 ou 35.180.0.0/16 ou un autre bloc.

Le reverse DNS ec2-35-180-27-154.eu-west-3.compute.amazonaws.com suggère fortement que c’est AWS eu-west-3, mais pas la longueur du préfixe.

Comment vérifier correctement (commande → interprétation)

Exécute ces commandes pour déterminer le bloc réel :

Reverse DNS / hostname

host 35.180.27.154


(utile pour confirmer le fournisseur / la région)

WHOIS — cherche le bloc/inetnum annoncé

whois 35.180.27.154


Regarde les champs inetnum, NetRange, CIDR ou route — ça peut donner le préfixe exact (ex: 35.180.0.0/16 ou 35.180.27.0/24).

ASN / BGP lookup — voir les préfixes annoncés par l’AS du fournisseur

Si whois donne l’AS (ex. AS16509 pour Amazon), tu peux lister les préfixes annoncés par cet AS via des services externes (bgp.he.net) ou :

whois -h whois.cymru.com " -v 35.180.27.154"


(puis utiliser whois/radb queries pour voir les annonces)

Vérifier la source officielle du fournisseur (pour le cloud)

Pour AWS :

curl -s https://ip-ranges.amazonaws.com/ip-ranges.json | jq '.prefixes[] | select(.ip_prefix | startswith("35.180"))'


Ça te dira si AWS publie un préfixe contenant 35.180.* et sa taille exacte.

