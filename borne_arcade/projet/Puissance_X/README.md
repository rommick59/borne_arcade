# Documentation du Projet Puissance_X

## 1. Introduction
Le projet Puissance_X est une application de jeu de plateau basé sur le jeu de puissance 4. Il intègre une interface graphique, une gestion des parties, des paramètres de jeu personnalisables, et des fonctionnalités de pause et de fin de partie. Le projet utilise Java avec une architecture modulaire comprenant des classes pour la gestion des éléments graphiques, des joueurs, des parties, et des menus.

## 2. Architecture
### 2.1 Structure de package
- **com.puissanceX.core**: Classes centrales du jeu (Plateau, Joueur, PartieSprite)
- **com.puissanceX.ui**: Gestion de l'interface graphique (Ecran, ElementMenu, BoutonItem)
- **com.puissanceX.config**: Paramétrage des parties et joueurs (ConfigurationPartie, ConfigurationJoueurMenu)
- **com.pulezX.util**: Outils généraux (GenerateurCouleur, Rendu)

### 2.2 Dépendances
- JavaFX pour l'interface graphique
- Fichiers de ressources (bouton.txt, photo.png) pour l'UI
- Classes de base Java (java.awt, java.util)

## 3. Fichiers Principaux
### 3.1 BoutonItem.java
- **Rôle**: Gère les boutons interactifs dans l'interface
- **Dépendances**: ElementMenu, TexteItem
- **Notes**: Implémente l'interaction utilisateur via clics

### 3.2 Case.java
- **Rôle**: Représente une case du plateau de jeu
- **Dépendances**: Plateau, Point
- **Notes**: Gère l'état de la case (vide, joueur 1, joueur 2)

### 3.3 Joueur.java
- **Rôle**: Classe de base pour les joueurs
- **Dépendances**: VraiIA (pour l'intelligence artificielle)
- **Notes**: Interface commune pour JoueurNormal et VraiIA

### 3.4 Plateau.java
- **Rôle**: Gère la logique du plateau de jeu
- **Dépendances**: Case, Entree, GenerateurCouleur
- **Notes**: Implémente les règles de placement des pions

### 3.5 Menu.java
- **Rôle**: Gère l'ensemble des menus du jeu
- **Dépendances**: MenuPrincipal, MenuNouvellePartie, MenuFinPartie
- **Notes**: Centralise la navigation entre les écrans

## 4. Fichiers de Ressources
### 4.1 bouton.txt
- **Rôle**: Définit les étiquettes des boutons
- **Format**: Lignes de texte correspondant aux boutons (ex: "Nouvelle Partie")
- **Utilisation**: Charge les étiquettes dans l'interface

### 4.2 photo.png
- **Rôle**: Logo principal du jeu
- **Dimensions**: 512x512 pixels
- **Utilisation**: Affiché dans l'écran principal

### 4.3 photo_small.png
- **Rôle**: Logo réduit pour les menus
- **Dimensions**: 128x128 pixels
- **Utilisation**: Affiché dans les menus secondaires

## 5. Fonctionnalités Clés
### 5.1 Gestion des Parties
- Création de parties via MenuNouvellePartie
- Paramétrage des joueurs (ConfigurationJoueurMenu)
- Sauvegarde/chargement des parties (à implémenter)

### 5.2 Interface Graphique
- Utilisation de JavaFX pour l'affichage
- Support des menus de pause et de fin de partie
- Animation des pions via PartieSprite

### 5.3 Intelligence Artificielle
- Implémentation de VraiIA pour les joueurs IA
- Algorithme de sélection de colonnes (à détailler)

## 6. Notes Techniques
- **Mode Force**: Le mode FORCED_UPDATE active des mises à jour automatiques des ressources
- **Performance**: Optimisation des rendus via Rendu.java
- **Compatibilité**: Testé sur Java 17 avec JavaFX 17

## 7. Points à Développer
1. Implémenter le système de sauvegarde/chargement
2. Ajouter des effets sonores et animations
3. Développer un système de difficulté pour VraiIA
4. Gérer les erreurs d'entrée utilisateur

## 8. Liens Utiles
- [Documentation JavaFX](https://openjfx.io/)
- [Guide Java 17](https://docs.oracle.com/en/java/javase/17/)
- [Exemple de jeu de puissance 4](https://github.com/yourusername/power4)

DOC_OK