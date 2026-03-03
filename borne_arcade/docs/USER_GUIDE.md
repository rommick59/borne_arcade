# 🎮 Documentation Utilisateur - Borne d'Arcade

## 📌 Introduction
Bienvenue sur la borne d'arcade ! Cette documentation vous guide à travers l'utilisation des jeux disponibles, les scripts de lancement, et les paramètres de configuration. Les jeux sont disponibles via des scripts shell qui gèrent automatiquement la compilation, le lancement, et la gestion des scores.

---

## 🧰 Prérequis & Configuration

### ⚙️ Dépendances
- **Java 8 ou supérieur** (pour les jeux Java)
- **Python 3** (pour les jeux Python)
- **xdotool** (pour contrôler le curseur)
- **setxkbmap** (pour configurer le clavier)

### 📁 Structure du Projet
```
/projet/
├── ball-blast/
├── Columns/
├── CursedWare/
├── DinoRail/
├── InitialDrift/
├── JavaSpace/
├── Kowasu_Renga/
├── Minesweeper/
├── OsuTile/
├── PianoTile/
├── Pong/
├── Puissance_X/
├── Snake_Eater/
├── TronGame/
└── lancerBorne.sh
```

---

## 🕹️ Liste des Jeux Disponibles

### 🎮 1. **Columns**
```bash
./Columns.sh
```
- **Contrôles** : Flèches directionnelles (Joueur 1), WASD (Joueur 2)
- **Score** : Sauvegardé dans `highscore`

### 🎮 2. **DinoRail**
```bash
./DinoRail.sh
```
- **Contrôles** : Flèches directionnelles (Joueur 1), WASD (Joueur 2)

### 🎮 3. **JavaSpace**
```bash
./JavaSpace.sh
```
- **Contrôles** : Flèches directionnelles (Joueur 1), WASD (Joueur 2)

### 🎮 4. **Kowasu_Renga**
```bash
./Kowasu_Renga.sh
```
- **Contrôles** : Flèches directionnelles (Joueur 1), WASD (Joueur 2)

### 🎮 5. **Minesweeper**
```bash
./Minesweeper.sh
```
- **Contrôles** : Souris (clique gauche/droit)

### 🎮 6. **OsuTile**
```bash
./OsuTile.sh
```
- **Contrôles** : Souris (clique gauche)

### 🎮 7. **PianoTile**
```bash
./PianoTile.sh
```
- **Contrôles** : Souris (clique gauche)

### 🎮 8. **Pong**
```bash
./Pong.sh
```
- **Contrôles** : Flèches directionnelles (Joueur 1), WASD (Joueur 2)

### 🎮 9. **Puissance_X**
```bash
./Puissance_X.sh
```
- **Paramètres** : `-Dsun.java2d.pmoffscreen=false` pour optimiser les performances sur Linux/X11

### 🎮 10. **Snake_Eater**
```bash
./Snake_Eater.sh
```
- **Contrôles** : Flèches directionnelles (Joueur 1), WASD (Joueur 2)

### 🎮 11. **TronGame**
```bash
./TronGame.sh
```
- **Contrôles** : Flèches directionnelles (Joueur 1), WASD (Joueur 2)
- **Son** : Musique et effets sonores via `pygame.mixer`

---

## 🧹 Gestion des Fichiers

### 🧹 Nettoyage
```bash
./clean.sh
```
- Supprime les fichiers compilés (`.class`, `~`) et les scores anciens.

### 🧩 Compilation
```bash
./compilation.sh
```
- Compile tous les projets Java avec vérification des avertissements.
- Les projets Python ne nécessitent pas de compilation.

---

## 🔄 Lancement de la Borne

### 🚀 Démarrage Automatique
```bash
./lancerBorne.sh
```
- Nettoie les répertoires
- Compile les jeux
- Lance le menu principal
- (Optionnel) Démarrage en mode veille après 30 secondes

---

## 📝 Notes Techniques

### 📌 Paramètres Java
- **Puissance_X** : Utilise `-Dsun.java2d.pmoffscreen=false` pour améliorer les performances sur Linux.
- **Compilation** : Les jeux Java utilisent `javac -Xlint:deprecation` pour détecter les dépréciations.

### 📌 Son et Graphismes
- **TronGame** : Utilise **Pygame 2.0** pour la gestion graphique et sonore.
- **Sons** : Les effets sonores sont gérés via `pygame.mixer`.

---

## 🛠️ Troubleshooting

### ❌ Erreur de Compilation
- Vérifiez les logs dans `logs/compilation.log` et `logs/warnings_errors.log`.
- Assurez-vous que Java et Python sont correctement installés.

### ⚠️ Problèmes de Curseur
- Utilisez `xdotool mousemove 1280 1024` pour positionner le curseur avant de lancer un jeu.

### ⚙️ Configuration du Clavier
- Exécutez `setxkbmap borne` pour activer le clavier adapté aux jeux.

---

## 📌 Conclusion
Cette borne d'arcade offre une expérience de jeu variée, allant des classiques comme **Pong** et **Snake** aux jeux plus modernes comme **TronGame** et **OsuTile**. Avec les scripts fournis, le lancement et la gestion des jeux sont simplifiés. Bonne partie ! 🎉

> 📌 *Pour plus d'informations techniques, consultez le fichier `DOCUMENTATION_DEVELOPPEUR.md`.*