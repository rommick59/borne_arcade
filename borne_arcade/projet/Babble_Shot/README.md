# Babble_Shot

## Aperçu du projet
Babble_Shot est un jeu de tir à l'arc conçu pour être joué sur des appareils mobiles. Le joueur doit viser des cibles en utilisant un arc et accumuler des points en touchant des cibles. Le jeu inclut un système de haut score pour suivre les performances des joueurs.

## Fonctionnalités principales
- **Système de haut score** : Sauvegarde les performances des joueurs via le fichier `highscore`
- **Capture d'images** : Utilise `photo_small.png` pour afficher l'arrière-plan du jeu
- **Interface utilisateur** : Le fichier `bouton.txt` définit les éléments visuels des boutons
- **Son et effet sonore** : Intégré via des bibliothèques Python (détails dans `requirements.txt`)
- **Jeu principal** : Exécuté via `main.py` avec des paramètres de difficulté

## Installation
1. Clonez le repository :  
   ```bash
   git clone https://github.com/votre_nom/Babble_Shot.git
   ```
2. Installez les dépendances :  
   ```bash
   pip install -r requirements.txt
   ```
3. Vérifiez que les fichiers suivants sont présents :  
   - `bouton.txt` (configuration des boutons)  
   - `description.txt` (documentation technique)  
   - `photo_small.png` (arrière-plan)  
   - `highscore` (fichier de sauvegarde)  
   - `main.py` (point d'entrée du jeu)

## Utilisation
1. Exécutez le jeu :  
   ```bash
   python main.py --difficulty easy
   ```
   Options disponibles :  
   - `--difficulty easy` : difficulté basse  
   - `--difficulty hard` : difficulté élevée  
2. Utilisez les boutons définis dans `bouton.txt` pour contrôler le jeu  
3. Les scores sont automatiquement sauvegardés dans `highscore`

## Contribuer
1. Clonez le repository  
2. Créez une branche : `git checkout -b feature/xxx`  
3. Ajoutez vos modifications : `git add .`  
4. Commitez : `git commit -m "Description de la modification"`  
5. Poussez : `git push origin feature/xxx`  
6. Ouvrez une Pull Request

## Licence
Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour les détails.

## Reconnaissances
- Bibliothèque de son : `pygame` (détaillée dans `requirements.txt`)  
- Fichier d'arrière-plan : `photo_small.png` (créé par [Nom de l'artiste])  
- Documentation : basée sur la structure fournie et les fichiers du projet