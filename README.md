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

## Résultats clés

Sur **99 441 commandes** (dont 96 470 livrées) :

- **Délai moyen de livraison : 12 jours**, pour un **taux de retard de 8,1 %** par rapport à la date de livraison estimée annoncée au client.
- **Le retard fait chuter la satisfaction** : les commandes livrées en retard obtiennent une note moyenne de **2,57 / 5**, contre **4,29 / 5** pour les commandes livrées à temps (**−1,7 point**).
- **Plus de la moitié (54 %) des commandes en retard reçoivent une note de 1 ou 2**, contre 9 % des commandes livrées à temps.
- **L'effet s'aggrave avec la durée du retard** : 3,29 / 5 pour 1 à 3 jours de retard, 2,11 pour 4 à 7 jours, 1,70 au-delà de 8 jours.

**Enseignement métier** : la ponctualité de livraison est un levier majeur de la satisfaction client ; le suivi du taux de retard par vendeur et par catégorie permet de cibler les actions correctives.

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
