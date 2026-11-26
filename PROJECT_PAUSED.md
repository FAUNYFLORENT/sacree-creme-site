# Sacrée Crème — état du projet site internet

**Statut : REPRISE AUTORISÉE — CONSTRUCTION V0.1 EN COURS**  
**Date de reprise : 25 novembre 2026**  
Florent a explicitement autorisé la reprise de la construction. La création du dépôt GitHub reste suspendue jusqu’à validation de son nom définitif et de son statut public ou privé.

## Travail réalisé avant la pause

- Référentiels consultés : ligne éditoriale, brandbook 2024, présentation « Point digital », maquette Figma référencée, sources immobilières et médias SharePoint.
- Inventaire complet du dossier vidéo Plein Format : 47 vidéos, dont 28 fichiers `Plan_vertical_*`.
- Téléchargement local des 28 vidéos verticales du Havre.
- Téléchargement local de `Plan_horizontal_concept_archi_1.mov` et `Montage_3_site_horizontal.mov`.
- Analyse technique des 30 sources téléchargées avec ffprobe : durée, dimensions, codec et taille consignés dans `reports/source_probe.json`.
- Analyse préparatoire, non définitive, de `Montage_3_site_horizontal.mov` : détection de changements de plans et planche-contact.
- Planche-contact de `Plan_horizontal_concept_archi_1.mov`.
- Téléchargement du logo SVG et d’une photo du concept du Havre.
- **Aucune compression web produite. Aucun extrait définitif découpé. Aucun fichier publié. Aucun développement du site réalisé.**

## Médias retenus pour la sélection avec Florent

Ordre source confirmé par Florent — les réordonnancements provisoires précédents sont annulés :

1. `Plan_horizontal_concept_archi_1.mov`
2. `Plan_horizontal_concept_archi_2.mov`
3. `Plan_horizontal_concept_archi_3.mov`
4. `Plan_horizontal_concept_archi_4.mov`
5. `Plan_horizontal_concept_archi_5.mov`
6. `Plan_horizontal_concept_archi_6.mov`
7. `Plan_horizontal_concept_archi_7.mov`
8. `Plan_horizontal_concept_archi_8.mov`
9. `Plan_horizontal_concept_archi_9.mov`
10. `Plan_horizontal_concept_archi_logo_extérieur.mov` — **focus sur l’enseigne extérieure avec le ciel en fond**, à placer après archi_9.

Exception à arbitrer avec Florent : la séquence de prélèvement de la glace à la cuillère. Son fichier de base sera précisé plus tard. `archi_6` a été cité pour la sortie du focus glace, mais son placement définitif n’est pas arrêté.

Sources complémentaires :

- Les 28 vidéos `Plan_vertical_*` du Havre — usages mobiles et séquence glace à sélectionner avec Florent.
- `Plan_vertical_chocolat_chaud.mov` — rôle validé : **vidéo de fond animée pour la présentation Coffee Shop**, avec une typographie blanche superposée. Lien possible avec l’encart « Produit du moment » et les déclinaisons de chocolats chauds issues des visuels stop-trottoir de Robin. Emplacement et texte définitifs restent à valider ; la lisibilité du blanc devra être contrôlée plan par plan.
- `Plan_vertical_concept_archi_3.mov` — **transition verticale, position à arbitrer** : le logo Sacrée Crème apparaît dans un miroir. À insérer entre deux plans de la séquence archi_1 → archi_9, au point que Florent choisira au montage. Ne pas confondre avec `Plan_horizontal_concept_archi_3.mov`.
- `Plan_horizontal_pluie_sucre_glace.mov` — **pluie de sucre glace** ; catégorie « position à arbitrer », hors de l’ordre archi_1 → archi_9 → logo extérieur. Sa position sera requalifiée par Florent au montage.
- `Montage_3_site_horizontal.mov` — source complémentaire pour **Caen**, à analyser avec Florent et découper en séquences courtes : intérieur, façade, produits, ambiance.

Le montage final, les raccords et les découpes seront décidés seulement lorsque la structure du site sera visible.

Métadonnées communiquées par Florent pour les plans horizontaux : auteur **Capucine Bertault**, modification **28/09/2026**. Ces indications devront être vérifiées dans SharePoint au moment de la reprise.

## Sources locales conservées

- `source-videos/` : 28 plans verticaux, la séquence horizontale `archi_1` à `archi_9`, le focus enseigne extérieure, la pluie de sucre glace et `montage_3_site_horizontal.mov`.
- `public/media/` : 114 livrables web optimisés (MP4, WebM, mobile, desktop, posters et scrubbing) totalisant environ 62 Mo ; aucun fichier ne dépasse 10 Mo et aucune vidéo de fond ne contient de piste audio.
- `reports/source_probe.json` et `reports/horizontal_probe.json` : caractéristiques techniques des sources téléchargées.
- `reports/media-manifest-final.csv` et `reports/media-audit.json` : inventaire et contrôle des fichiers optimisés.
- `reports/montage_contact_sheet.jpg` : planche-contact préparatoire de Montage 3 sites.
- `reports/montage_scene_changes.txt` : changements de plans détectés automatiquement ; non validés éditorialement.
- `reports/travelling_contact_sheet.jpg` : planche-contact du travelling archi 1.
- `public/assets/logo-sacree-creme.svg` et `public/assets/concept-le-havre-hero.jpeg`.
- `scripts/reference_ffmpeg.sh` : script de référence non exécuté.

## Consignes de reprise

Avant tout traitement :

1. Conserver l’ordre numérique confirmé d’`archi_1` à `archi_9`, suivi du focus `archi_logo_extérieur`.
2. Faire apparaître la structure du site avant de décider du montage final, des raccords et des découpes.
3. Arbitrer avec Florent la séquence de prélèvement de la glace, son fichier de base et le placement définitif d’`archi_6`.
4. Confirmer les timecodes retenus pour Caen dans `Montage_3_site_horizontal.mov`.
5. Télécharger seulement les sources horizontales manquantes après validation.
6. Produire ensuite, pour chaque vidéo validée : MP4 H.264, WebM, desktop, mobile, poster, version sans audio et version scrubbing à GOP rapproché.
7. Contrôler chaque fichier : idéalement < 10 Mo, impérativement < 100 Mo pour GitHub Pages.
8. Ne rien publier sans validation humaine explicite.
