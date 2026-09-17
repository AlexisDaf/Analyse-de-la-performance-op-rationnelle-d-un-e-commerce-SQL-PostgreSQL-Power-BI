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
