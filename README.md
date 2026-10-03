# 💍 Système de Gestion de Mariage - Base de Données

Ce mini-projet académique consiste en la modélisation et la création d'une base de données relationnelle pour la gestion complète des prestations d'un mariage (traiteurs, salles, invités, prestataires), avec un prototype d'application construit par-dessus.

Projet réalisé en binôme par **Lina Chtioui** et **Nermine Ben Salah**, dans le cadre de notre cursus en école d'ingénieurs (INSAT, IIA3/1, 2025/2026).

🌐 **[Démo en ligne du prototype]([https://ton-pseudo.github.io/nom-du-depot/](https://github.com/nerminebensalah-ship-it/Marriage_Management_System/blob/main/wedding_Planner_App.html))

## Technologies et Outils
* **SGBD :** Oracle SQL
* **Modélisation :** Looping (MCD, MLD)
* **Langage :** SQL (DDL, DML, Requêtes d'interrogation)
* * **Prototype :** HTML, CSS, JavaScript

## Fonctionnalités réalisées
* Modélisation conceptuelle (MCD) et schéma relationnel de 18 tables.
* Scripts de création des tables avec gestion rigoureuse des contraintes d'intégrité (clés primaires, étrangères, contraintes `CHECK`).
* Jeu d'essai : insertion de données simulées.
* 15 requêtes d'analyse : jointures internes et externes, auto-jointures, regroupements avec `HAVING`, sous-requêtes (`IN`, `NOT IN`, `EXISTS`, `>= ALL`), `UNION ALL` et table dérivée (calcul des restes à payer, suivi des paiements, gestion des menus et des invités).
* Prototype d'application avec quatre espaces : organisateur, couple, invité et prestataire.

## Structure du projet
* `/sql` : Contient le script complet de création, d'insertion et de requêtes.
* `/pdf` : Contient le rapport détaillé du projet et le diagramme MCD.
* `/docs` : Contient le prototype d'application (`index.html`).

## Exécuter la base de données
1. Ouvrir Oracle SQL Developer.
2. Exécuter le script du dossier `/sql` en entier (touche F5).
3. Le script supprime les tables, les recrée, insère les données, puis lance les requêtes.

## À propos du prototype
L'application est un prototype qui illustre le modèle de données. Elle n'est pas reliée à la base Oracle : elle stocke les données dans le navigateur, et il n'y a pas de système de connexion. Il ne faut donc pas y saisir de vraies données personnelles.

*Toutes les données du projet sont fictives.*
