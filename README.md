# Site Sacrée Crème — prototype V0.1

Prototype statique desktop/mobile du futur site Sacrée Crème. Il sépare clairement :

- le parcours **consommateur** : expérience, glaces, coffee shop, crêpes/gaufres, boutiques, produit du moment ;
- le parcours **futur franchisé** : concept, piliers, zones de développement et prise de contact.

## Statut

**Projet à valider — aucune publication publique.** L’indexation est bloquée dans `robots.txt`. Le formulaire franchise est volontairement inactif.

## Lancer localement

```bash
cd sacree-creme-site
python3 -m http.server 4173
# ouvrir http://localhost:4173
```

## Médias

```bash
bash scripts/build_selected_media.sh
```

Le script génère :

- MP4 H.264 et WebM ;
- versions desktop et mobile ;
- posters JPEG ;
- MP4 à GOP 3 pour le scrubbing au scroll ;
- un manifeste et un audit des tailles dans `reports/`.

Les sources `.mov` restent hors Git via `.gitignore`.

## Contrôler

```bash
python3 scripts/validate_site.py
```

## Décision GitHub en attente

Aucun dépôt n’a été créé. Avant toute création, Florent doit confirmer :

1. le **nom définitif** du nouveau dépôt ;
2. son statut **public ou privé**.

Le dépôt `FAUNYFLORENT/ALPHA-Process-Site-V1` est explicitement hors périmètre et ne doit jamais être modifié sans instruction séparée.
