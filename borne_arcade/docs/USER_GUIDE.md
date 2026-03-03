# **Documentation Utilisateur - Borne d'Arcade**

---

## 📚 **Introduction**
Bienvenue dans la documentation utilisateur de la borne d'arcade ! Cette borne intègre plusieurs jeux classiques et modernes, disponibles via des scripts automatisés. Ce guide vous explique comment installer, lancer, et gérer les jeux, ainsi que les contrôles et les fonctionnalités spécifiques.

---

## 🧰 **Configuration Système**
### **Requis**
- **Système d'exploitation** : Linux (Ubuntu/Debian recommandés)
- **Java** : Version 8 ou supérieure (pour les jeux Java)
- **Python 3** : Version 3.6 ou supérieure (pour les jeux Python)
- **Deps** : Installez les packages requis via `requirements.txt` (pour TronGame)

---

## 🛠️ **Installation & Mise à Jour**
### **1. Préparation**
- **Clonez le repo** :  
  ```bash
  git clone [URL_REPO]
  ```
- **Installez les dépendances** :  
  ```bash
  sudo apt install xdotool openjdk-8-jdk python3
  ```

### **2. Compilation des Jeux**
- **Exécutez le script de compilation** :  
  ```bash
  ./compilation.sh
  ```
  - Compile tous les jeux Java (via `javac`)
  - Crée des fichiers `highscore` pour chaque jeu
  - Gère les logs et warnings dans `logs/`

---

## 🕹️ **Lancement des Jeux**
### **1. Lancer le Menu Principal**
```bash
./lancerBorne.sh
```
- Nettoie les répertoires
- Compile les jeux
- Lance le menu principal (via `Main.java`)

### **2. Lancer un Jeu Directement**
Utilisez les scripts `.sh` spécifiques :
```bash
./Puissance_X.sh       # Jeu Java (avec JVM options)
./TronGame.sh          # Jeu Python (via Python 3)
./Snake_Eater.sh       # Jeu Java
./Pong.sh              # Jeu Java
```
- **Note** : Les scripts `xdotool` positionnent le curseur à `(1280, 1024)` pour une compatibilité avec les écrans.

---

## 🎮 **Contrôles des Jeux**
| Jeu              | Contrôles Joueur 1 | Contrôles Joueur 2 | Notes |
|------------------|--------------------|--------------------|-------|
| **Pong**         | Flèches directionnelles | WASD | P (pause), ESPACE (redémarrage) |
| **Snake_Eater**  | Flèches | WASD | P (pause) |
| **Puissance_X**  | Flèches | WASD | -Dsun.java2d.opengl=true pour OpenGL |
| **TronGame**     | Flèches | WASD | Python 3 requis |
| **Columns**     | Flèches | WASD | - Toucher `highscore` avant de lancer |

---

## 🧾 **Gestion des Scores**
- **Création des fichiers `highscore`** :  
  ```bash
  touch projet/<jeu>/highscore
  ```
- **Visualisation** :  
  - Chaque jeu écrit automatiquement les scores dans `highscore`
  - Utilisez un éditeur de texte pour consulter les scores.

---

## 🧪 **Débogage & Solutions**
### **Problèmes Courants**
1. **Mouse Positionning** :  
   - Si le curseur ne se positionne pas, vérifiez `xdotool` est installé.
2. **Compilation Erreurs** :  
   - Vérifiez les logs dans `logs/compilation.log`
3. **Dépendances Manquantes** :  
   - Installez `openjdk-8-jdk` et `python3` si nécessaire.
4. **Scores Non Sauvegardés** :  
   - Assurez-vous que `highscore` existe dans chaque dossier de jeu.

---

## 📁 **Structure des Dossiers**
```
/projet/
├── Ball-Blast/
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
└── TronGame/
```

---

## 📜 **Fichiers de Configuration**
- **`bouton.txt`** : Configuration des boutons (à personnaliser selon le matériel)
- **`requirements.txt`** : Dépendances Python (pour TronGame)
- **`README.md`** : Description générale du projet

---

## 🚀 **Bonus : Lancement Automatisé**
- **Script `lancerBorne.sh`** :  
  - Nettoie, compile, et lance le menu principal
  - Utilisé pour démarrer la borne d'arcade

---

## 📌 **Notes Finales**
- **Fermeture** : Utilisez `sudo halt` pour éteindre la borne après utilisation.
- **Mises à Jour** : Vérifiez régulièrement les scripts et dépendances pour des mises à jour.
- **Support** : Consultez `DOCUMENTATION_DEVELOPPEUR.md` pour des détails techniques.

---

**Enjoy your arcade experience! 🕹️**