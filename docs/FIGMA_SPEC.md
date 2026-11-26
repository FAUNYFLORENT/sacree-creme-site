# Spécification Figma — V0.1

Document de transfert pour la maquette UX/UI et le storyboard motion.

## Frames à créer / mettre à jour

1. `Homepage / Desktop / 1440`
2. `Homepage / Mobile / 390`
3. `Consumer / Products / Desktop`
4. `Franchise / Landing / Desktop`
5. `Motion storyboard / Architecture / Desktop`
6. `Motion storyboard / Opening / Mobile`

## Sections de la homepage

- Header transparent puis ivoire au scroll.
- Hero vidéo / prélèvement de glace.
- Manifeste « La glace au cœur. La gourmandise tout autour. »
- Séquence architecturale archi_1 → archi_9 → logo extérieur.
- Transition miroir/logo.
- Trois piliers produits.
- Coffee shop sur fond chocolat chaud avec texte blanc.
- Produit du moment.
- Boutiques Caen / Le Havre.
- Rupture franchise.
- Zones de développement.
- Formulaire d’intérêt.
- Footer.

## Tokens

### Couleurs

- `Brand/Green` — `#335052`
- `Brand/Coral` — `#EF7B59`
- `Brand/Mint` — `#C1DFC6`
- `Brand/Peach` — `#F9BC91`
- `Brand/Cream` — `#E5E1D3`
- `Brand/Pink` — `#DDBEC0`
- `Neutral/White` — `#FFFDF8`

### Typographie

- Famille de marque : Georgia Regular, Italic, Bold, Bold Italic.
- Labels d’interface : sans-serif système, capitales espacées.
- Le logo ne doit jamais être recomposé en texte.

### Espacements

- Grille desktop : conteneur 1240 px, gouttières 24 px.
- Grille mobile : marges 20–24 px.
- Rayon principal : 28 px.

## Composants

- Header desktop/mobile.
- Bouton primaire, secondaire et transparent.
- Carte produit.
- Carte boutique vidéo.
- Pastille ville.
- Champ formulaire.
- Contrôle son/motion.
- Badge « Projet à valider » réservé au prototype.

## Motion

- Toutes les transitions doivent fonctionner dans les deux sens.
- Une variante `Reduced motion` est obligatoire.
- Les médias sont des couches distinctes ; ne jamais importer une capture aplatie de l’interface finale.
- Le scroll architectural respecte l’ordre natif archi_1 à archi_9, puis l’enseigne extérieure.
