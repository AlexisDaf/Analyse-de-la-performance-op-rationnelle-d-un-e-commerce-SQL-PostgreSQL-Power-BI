# Olist - Analyse de la performance opérationnelle e-commerce

Projet d’analyse de données réalisé à partir du dataset public **Olist**, avec pour objectif d’étudier la performance commerciale, logistique et la satisfaction client.

## Objectif

Construire une chaîne analytique complète permettant de :

- suivre le volume et la valeur des commandes ;
- analyser les délais de livraison et les retards ;
- étudier la relation entre retard et satisfaction client ;
- comparer la performance des vendeurs ;
- comparer la performance des catégories produits.

## Outils utilisés

- PostgreSQL
- pgAdmin 4
- SQL
- Power BI
- DAX

## Travail réalisé

### SQL
Préparation et structuration des données à travers plusieurs vues analytiques :

- `vw_order_performance` : analyse au niveau commande ;
- `vw_seller_performance` : comparaison des vendeurs ;
- `vw_category_performance` : comparaison des catégories.

Les traitements incluent notamment des jointures, agrégations, calculs de délais, taux de retard et contrôles de qualité.

### Power BI
Création d’un dashboard interactif organisé autour de cinq axes :

1. Performance globale
2. Performance logistique
3. Retard et satisfaction client
4. Performance des vendeurs
5. Performance des catégories

Principaux KPI suivis :

- Total Orders
- Total Order Value
- Average Order Value
- Average Delivery Time
- Late Delivery Rate
- Average Review Score

## Principaux axes d’analyse

L’analyse permet notamment d’identifier :

- l’évolution du volume de commandes ;
- les écarts de performance logistique ;
- l’impact des retards sur la satisfaction client ;
- les vendeurs à forte contribution économique ;
- les catégories les plus importantes en revenu et en volume.

## Dataset

Source : **Brazilian E-Commerce Public Dataset by Olist**

## Auteur

**Alexis Da Fonseca**  
Projet Data Analytics & BI

## Organisation du dépôt

```text
.
├── README.md
├── .gitignore
├── sql/           # Script SQL et vues analytiques
├── powerbi/       # Dashboard Power BI Desktop
├── reports/       # Rapport PDF existant
└── data/
    └── raw/       # Données locales non versionnées
```

### Livrables

- [olist_analysis.sql](sql/olist_analysis.sql)
- [Analyse performance opérationnelle Olist.pbix](powerbi/Analyse%20performance%20op%C3%A9rationnelle%20Olist.pbix)
- [Analyse des performances opérationnelles du dataset Olist.pdf](reports/Analyse%20des%20performances%20op%C3%A9rationnelles%20du%20dataset%20Olist.pdf)

## Exécution locale

Les données sources ne sont pas incluses. Voir [data/raw/README.md](data/raw/README.md) pour les fichiers attendus et la provenance disponible.

1. Installer PostgreSQL et créer une base locale dédiée à Olist.
2. Télécharger les CSV puis les importer avec pgAdmin dans les tables `customers`, `orders`, `order_items`, `products`, `sellers`, `order_reviews` et `product_category_name_translation`. Les noms de colonnes doivent correspondre aux en-têtes CSV ; utiliser des types numériques pour prix et scores et des types timestamp pour les dates.
3. Exécuter `sql/olist_analysis.sql` de haut en bas dans cette base. Le script contient des contrôles, des créations de vues et des requêtes exploratoires. Il suppose les tables déjà importées et n'est pas idempotent : les vues doivent être absentes à la première exécution. Le dépôt initial ne fournit pas de DDL ni de procédure d'import automatisée.
4. Ouvrir le `.pbix` dans Power BI Desktop, adapter ses paramètres de connexion PostgreSQL (serveur et base), puis actualiser. Les connexions internes du fichier binaire doivent être vérifiées dans Power BI Desktop.

Le script SQL a été conservé sans modification de ses calculs. Aucun fichier de dépendances Python n'est nécessaire.
