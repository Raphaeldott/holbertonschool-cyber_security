# Security Principles — Medium blog series

Livrable Holberton : un article Medium unique couvrant les 5 principes (Defense in Depth,
Least Privilege, Separation of Duties, Secure by Design, Security Through Obscurity) + une
synthèse. Le rendu attendu = **l'URL de l'article publié** (à mettre dans `blog_url.txt`).

## Fichiers

- `blog.md` — le texte complet de l'article (anglais), prêt à coller dans Medium.
- `01-defense-in-depth.svg` … `06-synthesis.svg` — les schémas à uploader dans Medium.
- `blog_url.txt` — à remplir avec l'URL Medium une fois publié.

## Comment publier sur Medium

1. Medium → **Write a story**.
2. Colle le contenu de `blog.md`. Les titres `#`/`##` deviennent des titres Medium ; le
   texte en italique d'intro peut servir de sous-titre.
3. À chaque repère `> Suggested visual: 0X-....svg`, clique sur le `+` de Medium → image →
   uploade le SVG correspondant (ou une version PNG si Medium refuse le SVG : ouvre le SVG
   dans un navigateur et exporte/capture en PNG).
4. Relis une fois en preview (Medium gère bien le markdown collé, mais vérifie les listes).
5. **Publish**, copie l'URL, mets-la dans `blog_url.txt`.

> Astuce SVG→PNG si besoin : `rsvg-convert 01-defense-in-depth.svg -o 01.png`
> (paquet `librsvg2-bin`), ou ouvrir le `.svg` dans Chrome et faire une capture.
