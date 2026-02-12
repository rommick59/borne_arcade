# 🎮 Tutoriel Complet : Migration vers RBpy3-RBPyOS

**Guide de migration de A à Z pour borne d'arcade Raspberry Pi**

```
┌─────────────────────────────────────────────────────────┐
│  Rasbian 2017  ────────────►  RBpy3-RBPyOS              │
│  (Ancien système)           (Nouveau système)           │
└─────────────────────────────────────────────────────────┘
```

**Projet :** Borne d'arcade IUT du Littoral Côte d'Opale  
**Date :** 12 février 2026  
**Durée estimée :** 2-3 heures  
**Niveau :** Débutant à intermédiaire

---

## 📖 Introduction

Ce tutoriel vous guide pas à pas pour **migrer votre borne d'arcade** d'un ancien système Rasbian 2017 vers le nouveau système **RBpy3-RBPyOS**. Que vous soyez débutant ou expérimenté, suivez simplement les étapes dans l'ordre.

### 🎯 Ce que vous allez accomplir :

1. ✅ Sauvegarder votre système actuel (jeux, scores, configurations)
2. ✅ Installer le nouveau système d'exploitation RBpy3-RBPyOS
3. ✅ Configurer le Raspberry Pi (résolution, clavier, réseau)
4. ✅ Restaurer votre projet borne d'arcade
5. ✅ Installer toutes les dépendances (Java, Python, Lua, MG2D)
6. ✅ Tester et valider le fonctionnement complet
7. ✅ Configurer le démarrage automatique de la borne

### ⚠️ Attention

- **Opération irréversible** : L'installation effacera la carte SD
- **Sauvegardez tout** : Jeux, highscores, configurations
- **Prévoyez du temps** : Environ 2-3 heures pour une migration complète
- **Testez avant** : Vérifiez le bon fonctionnement avant de déployer

---

## 📋 Table des Matières

### PARTIE 1 : PRÉPARATION (30 min)
1. [Matériel et prérequis](#partie-1--préparation)
2. [Sauvegarde de l'ancien système](#étape-1--sauvegarder-lancien-système)

### PARTIE 2 : INSTALLATION (45 min)
3. [Téléchargement de RBpy3-RBPyOS](#étape-2--télécharger-rbpy3-rbpyos)
4. [Création de la carte SD](#étape-3--créer-la-carte-sd-bootable)
5. [Premier démarrage](#étape-4--premier-démarrage-du-système)

### PARTIE 3 : CONFIGURATION (60 min)
6. [Configuration système de base](#étape-5--configuration-système-de-base)
7. [Restauration du projet](#étape-6--restaurer-le-projet-borne-arcade)
8. [Installation des dépendances](#étape-7--installer-les-dépendances)
9. [Configuration du clavier arcade](#étape-8--configurer-le-clavier-personnalisé)

### PARTIE 4 : FINALISATION (30 min)
10. [Configuration de l'autostart](#étape-9--configurer-le-démarrage-automatique)
11. [Tests et validation](#étape-10--tester-et-valider)
12. [Dépannage](#dépannage)

---

# PARTIE 1 : PRÉPARATION

## 🛠️ Matériel nécessaire

### Hardware requis

| Composant | Spécification | Obligatoire |
|-----------|--------------|-------------|
| **Raspberry Pi** | Modèle 3B, 3B+ ou 4 | ✅ |
| **Carte SD** | 32 Go minimum, Classe 10 | ✅ |
| **Lecteur carte SD** | USB pour PC | ✅ |
| **Clé USB** | Pour sauvegarde (8 Go min) | ⭐ Recommandé |
| **Clavier USB** | Standard (pour config) | ✅ |
| **Souris USB** | Standard (pour config) | ✅ |
| **Câble Ethernet** | Connexion réseau stable | ⭐ Recommandé |
| **Écran** | 1280x1024 (4:3) | ✅ |

### Software requis sur votre PC

| Logiciel | Utilisation | Téléchargement |
|----------|-------------|----------------|
| **Raspberry Pi Imager** | Flasher la carte SD | https://www.raspberrypi.com/software/ |
| **Balena Etcher** | Alternative au Imager | https://www.balena.io/etcher/ |
| **Client SSH** | Accès distant (optionnel) | Natif Linux/Mac, PuTTY Windows |

---

## ÉTAPE 1 : Sauvegarder l'ancien système

> ⏱️ **Durée : 15-20 minutes**  
> 📍 **Localisation : Sur votre ancien Raspberry Pi (Rasbian 2017)**

### Option A : Sauvegarde automatique (RECOMMANDÉ) 🚀

Si le dossier `automatisation/` existe déjà sur votre système :

```bash
# Se connecter au Raspberry Pi actuel
ssh pi@<adresse_ip_actuelle>

# Aller dans le dossier automatisation
cd ~/git/borne_arcade/automatisation

# Rendre le script exécutable
chmod +x 01_backup_ancien_systeme.sh

# Lancer la sauvegarde complète
./01_backup_ancien_systeme.sh
```

**Le script sauvegarde automatiquement :**
- ✅ Projet complet borne_arcade
- ✅ Bibliothèque MG2D
- ✅ Tous les highscores
- ✅ Configuration clavier personnalisé (fichier `borne`)
- ✅ Fichiers système (.bashrc, .profile)
- ✅ Liste des paquets installés

📁 **Résultat** : Fichier `backup_migration_complete.tar.gz` dans `/home/pi/`

### Option B : Sauvegarde manuelle

Si vous n'avez pas les scripts ou préférez faire manuellement :

```bash
# 1. Créer un répertoire de sauvegarde
mkdir -p ~/backup_migration
cd ~/backup_migration

# 2. Sauvegarder le projet borne arcade
echo "Sauvegarde du projet..."
tar -czf borne_arcade_backup.tar.gz ~/git/borne_arcade/

# 3. Sauvegarder MG2D
echo "Sauvegarde de MG2D..."
tar -czf MG2D_backup.tar.gz ~/MG2D/

# 4. Sauvegarder les configurations
echo "Sauvegarde des configurations..."
cp ~/.bashrc bashrc_backup
cp ~/.profile profile_backup

# 5. Sauvegarder le clavier personnalisé
echo "Sauvegarde du clavier arcade..."
sudo cp /usr/share/X11/xkb/symbols/borne xkb_borne_backup 2>/dev/null || echo "Fichier borne non trouvé"

# 6. Sauvegarder les highscores
echo "Sauvegarde des highscores..."
mkdir -p highscores_backup
find ~/git/borne_arcade/projet/ -name "highscore" -exec cp {} highscores_backup/ \; 2>/dev/null

# 7. Informations système
echo "Collecte des informations système..."
echo "=== OS ===" > system_info.txt
cat /etc/os-release >> system_info.txt
echo -e "\n=== Java ===" >> system_info.txt
java -version 2>> system_info.txt
echo -e "\n=== Python ===" >> system_info.txt
python3 --version >> system_info.txt

# 8. Tout compresser ensemble
cd ~
tar -czf backup_migration_complete.tar.gz backup_migration/

# 9. Vérifier
echo "✓ Sauvegarde créée :"
ls -lh backup_migration_complete.tar.gz
```

### Transférer la sauvegarde sur votre PC

**Méthode 1 : Via clé USB**

```bash
# 1. Insérer la clé USB dans le Raspberry Pi
# 2. Identifier la clé
lsblk
# Exemple de sortie : sda1 (votre clé USB)

# 3. Monter la clé
sudo mkdir -p /mnt/usb
sudo mount /dev/sda1 /mnt/usb

# 4. Copier la sauvegarde
cp ~/backup_migration_complete.tar.gz /mnt/usb/
sync

# 5. Démonter proprement
sudo umount /mnt/usb

# 6. Retirer la clé USB
```

**Méthode 2 : Via réseau (SCP)**

```bash
# Sur votre PC Linux/Mac
scp pi@<adresse_ip>:~/backup_migration_complete.tar.gz ~/

# Sur Windows avec WinSCP
# Utiliser l'interface graphique WinSCP
```

**Méthode 3 : Via Git (si dépôt à jour)**

```bash
cd ~/git/borne_arcade
git status
git add .
git commit -m "Backup avant migration RBpy3-RBPyOS - $(date +%Y%m%d)"
git push
```

✅ **Point de contrôle** : Vous avez maintenant une sauvegarde complète sur votre PC ou clé USB

---

# PARTIE 2 : INSTALLATION

## ÉTAPE 2 : Télécharger RBpy3-RBPyOS

> ⏱️ **Durée : 10-15 minutes** (selon vitesse Internet)  
> 📍 **Localisation : Sur votre PC**

### Téléchargement de l'image

```bash
# Sur votre PC Linux
cd ~/Téléchargements/

# Télécharger l'image (adapter l'URL selon votre source)
wget https://example.com/rbpy3-rbpyos-latest.img.xz

# Alternative si téléchargement manuel depuis navigateur
# Déplacer le fichier dans ~/Téléchargements/
```

> ⚠️ **Note importante** : RBpy3-RBPyOS est un système spécifique. Si vous n'avez pas accès à cette image :
> 
> **Alternative officielle :**
> ```bash
> # Télécharger Raspberry Pi OS Lite (Debian Bookworm)
> wget https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2024-XX-XX/2024-XX-XX-raspios-bookworm-armhf-lite.img.xz
> ```

### Vérifier l'intégrité du fichier (recommandé)

```bash
# Calculer le checksum SHA256
sha256sum rbpy3-rbpyos-latest.img.xz

# Comparer avec celui fourni sur le site de téléchargement
# Les valeurs doivent correspondre exactement
```

✅ **Point de contrôle** : Fichier image téléchargé et vérifié

---

## ÉTAPE 3 : Créer la carte SD bootable

> ⏱️ **Durée : 15-20 minutes**  
> 📍 **Localisation : Sur votre PC**

### Méthode A : Avec Raspberry Pi Imager (RECOMMANDÉ) 🎯

**Installation de Raspberry Pi Imager**

```bash
# Sur Ubuntu/Debian
sudo apt install rpi-imager

# Sur Fedora
sudo dnf install rpi-imager

# Sur Arch Linux
sudo pacman -S rpi-imager
```

**Utilisation**

1. **Lancer le programme**
   ```bash
   rpi-imager
   ```

2. **Dans l'interface graphique :**
   - **CHOOSE OS** → "Use custom" → Sélectionner `rbpy3-rbpyos-latest.img.xz`
   - **CHOOSE STORAGE** → Sélectionner votre carte SD (ex: 32 GB SD Card)
   
3. **Cliquer sur l'icône ⚙️ (paramètres avancés)**
   
   **Configurer les options :**
   ```
   ✅ Set hostname : borne-arcade
   ✅ Enable SSH : ✓ Use password authentication
   ✅ Set username and password
      Username: pi
      Password: [votre_mot_de_passe]
   ✅ Configure wireless LAN (si besoin)
      SSID: [votre_wifi]
      Password: [mot_de_passe_wifi]
      Country: FR
   ✅ Set locale settings
      Time zone: Europe/Paris
      Keyboard layout: fr
   ```

4. **WRITE** → Confirmer → Attendre la fin (~10-15 min)

5. **Vérification** → "Write Successful" → CONTINUE

### Méthode B : Avec ligne de commande (utilisateurs avancés)

```bash
# 1. Insérer la carte SD
# 2. Identifier la carte
lsblk
# Exemple de sortie :
# sdb           8:16   1  29.7G  0 disk 
# └─sdb1        8:17   1  29.7G  0 part 

# ⚠️ ATTENTION : Vérifiez bien que c'est votre carte SD !
# Remplacer /dev/sdX par votre appareil

# 3. Démonter toutes les partitions
sudo umount /dev/sdb*

# 4. Flasher l'image
sudo dd if=rbpy3-rbpyos-latest.img.xz bs=4M status=progress of=/dev/sdb conv=fsync

# 5. Synchroniser
sync
```

### Configuration pré-boot (si SSH non activé avec Imager)

```bash
# Remonter la partition boot
sudo mkdir -p /mnt/boot
sudo mount /dev/sdb1 /mnt/boot

# Activer SSH
sudo touch /mnt/boot/ssh

# Configuration WiFi (optionnel)
sudo nano /mnt/boot/wpa_supplicant.conf
```

Contenu de `wpa_supplicant.conf` :
```ini
country=FR
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="NomDeVotreWiFi"
    psk="MotDePasseWiFi"
    key_mgmt=WPA-PSK
}
```

```bash
# Démonter
sudo umount /mnt/boot
```

✅ **Point de contrôle** : Carte SD prête avec RBpy3-RBPyOS installé

---

## ÉTAPE 4 : Premier démarrage du système

> ⏱️ **Durée : 5-10 minutes**  
> 📍 **Localisation : Raspberry Pi**

### Branchements

1. **Retirer la carte SD** de votre PC
2. **Insérer la carte SD** dans le Raspberry Pi
3. **Brancher** dans l'ordre :
   - ✅ Câble HDMI → Écran
   - ✅ Clavier USB
   - ✅ Souris USB (optionnel)
   - ✅ Câble Ethernet (recommandé pour première config)
   - ✅ **Alimentation** (en dernier)

### Démarrage

```
┌─────────────────────────────────────┐
│  Le Raspberry Pi démarre...         │
│  Texte défile à l'écran...          │
│  Attendre 1-2 minutes               │
└─────────────────────────────────────┘
```

### Connexion

**Si autologin activé** : Vous arrivez directement au bureau ou terminal

**Sinon** :
```
Login: pi
Password: [votre_mot_de_passe]
```

### Trouver l'adresse IP (si connexion SSH souhaitée)

```bash
# Sur le Raspberry Pi directement
hostname -I

# Ou depuis votre PC (scan réseau)
nmap -sn 192.168.1.0/24 | grep -B 2 "Raspberry"
```

✅ **Point de contrôle** : Système démarré, vous êtes connecté

---

# PARTIE 3 : CONFIGURATION

## ÉTAPE 5 : Configuration système de base

> ⏱️ **Durée : 20-30 minutes**  
> 📍 **Localisation : Raspberry Pi (local ou SSH)**

### Configuration avec raspi-config

```bash
sudo raspi-config
```

**Naviguer avec les flèches → Entrée pour valider**

### Configuration étape par étape

#### 1️⃣ **System Options** (S)

```
S3 Password          → Changer le mot de passe (sécurité)
S4 Hostname          → "borne-arcade" (identification)
S5 Boot / Auto Login → "Console Autologin" ou "Desktop Autologin"
   ↪ Console Autologin = démarrage en terminal automatique
   ↪ Desktop Autologin = démarrage interface graphique automatique
```

#### 2️⃣ **Display Options** (D)

```
D1 Resolution    → DMT Mode 32 (1280x1024 @ 60Hz)
                    ou DMT Mode 35 (1280x1024 @ 75Hz)
D3 Screen Blanking → No (désactiver veille écran pour borne)
```

#### 3️⃣ **Interface Options** (I)

```
I2 SSH → Yes (activer SSH pour accès distant)
```

#### 4️⃣ **Localization Options** (L)

```
L1 Locale    → fr_FR.UTF-8 UTF-8 (cocher)
                Définir fr_FR.UTF-8 par défaut
L2 Timezone  → Europe/Paris
L3 Keyboard  → Generic 105-key PC → French → Default
L4 WLAN Country → FR (même si Ethernet utilisé)
```

#### 5️⃣ **Advanced Options** (A)

```
A1 Expand Filesystem → Yes (utiliser toute la carte SD)
A3 Memory Split      → 256 (allouer mémoire GPU pour graphismes)
```

#### 6️⃣ **Finish** → **Yes** (redémarrer)

```bash
# Le système redémarre automatiquement
# Attendre 30 secondes
```

### Mise à jour complète du système

```bash
# Reconnexion après redémarrage
ssh pi@<adresse_ip>
# ou directement sur le Pi

# Mise à jour de la liste des paquets
sudo apt update

# Mise à jour de tous les paquets (peut prendre 10-20 min)
sudo apt full-upgrade -y

# Installation outils de base
sudo apt install -y git vim curl wget htop tree

# Nettoyage
sudo apt autoremove -y
sudo apt clean

# Redémarrage final
sudo reboot
```

✅ **Point de contrôle** : Système configuré, à jour et redémarré

---

## ÉTAPE 6 : Restaurer le projet borne arcade

> ⏱️ **Durée : 10-15 minutes**  
> 📍 **Localisation : Raspberry Pi**

### Transférer la sauvegarde vers le nouveau système

**Méthode 1 : Via clé USB**

```bash
# 1. Insérer la clé USB contenant backup_migration_complete.tar.gz
# 2. Identifier la clé
lsblk

# 3. Monter
sudo mkdir -p /mnt/usb
sudo mount /dev/sda1 /mnt/usb

# 4. Copier vers home
cp /mnt/usb/backup_migration_complete.tar.gz ~/

# 5. Démonter
sudo umount /mnt/usb
```

**Méthode 2 : Via SCP depuis votre PC**

```bash
# Sur votre PC
scp backup_migration_complete.tar.gz pi@<adresse_ip_rpi>:~/

# Attendre transfert (peut prendre quelques minutes selon taille)
```

**Méthode 3 : Via Git (si vous aviez push)**

```bash
# Configurer Git
git config --global user.name "Votre Nom"
git config --global user.email "votre@email.com"

# Cloner le projet
mkdir -p ~/git
cd ~/git
git clone https://github.com/votre-compte/borne_arcade.git
# ou votre URL Git IUT

# Cloner MG2D
git clone https://github.com/synave/MG2D.git ~/MG2D
```

### Extraire la sauvegarde (si méthode archive)

```bash
# Se placer dans home
cd ~

# Extraire l'archive
tar -xzf backup_migration_complete.tar.gz

# Vérifier le contenu
ls -la backup_migration/

# Restaurer borne_arcade
mkdir -p ~/git
tar -xzf backup_migration/borne_arcade_backup.tar.gz
mv git/borne_arcade ~/git/ 2>/dev/null || echo "Déjà au bon endroit"

# Restaurer MG2D
tar -xzf backup_migration/MG2D_backup.tar.gz
mv MG2D ~/MG2D 2>/dev/null || echo "Déjà au bon endroit"

# Vérifier la structure
echo "=== Structure restaurée ==="
ls -la ~/git/borne_arcade/
ls -la ~/MG2D/
```

### Restaurer les highscores

```bash
# Restaurer tous les highscores
cd ~/backup_migration/highscores_backup/

# Copier vers chaque jeu
for game_dir in ~/git/borne_arcade/projet/*/; do
    game_name=$(basename "$game_dir")
    if [ -f "highscore_${game_name}" ]; then
        cp "highscore_${game_name}" "${game_dir}highscore"
        echo "✓ Highscore restauré pour $game_name"
    fi
done
```

✅ **Point de contrôle** : Projet et MG2D restaurés, highscores récupérés

---

## ÉTAPE 7 : Installer les dépendances

> ⏱️ **Durée : 30-40 minutes**  
> 📍 **Localisation : Raspberry Pi**

### Option A : Script automatique complet (RECOMMANDÉ) 🚀

```bash
cd ~/git/borne_arcade/automatisation

# Rendre exécutable
chmod +x 03_install_dependances_complete.sh

# Lancer l'installation complète
./03_install_dependances_complete.sh

# Le script installe :
# ✅ Java (OpenJDK 17)
# ✅ Python 3 + pip
# ✅ Lua + Love2D
# ✅ Pygame
# ✅ Bibliothèques système (X11, audio)
# ✅ MG2D (compilation)
# ✅ Dépendances Python des jeux
# ✅ lxterminal
```

**Durée** : ~30 minutes, installation automatique complète

### Option B : Installation manuelle (si script indisponible)

#### 1️⃣ **Java (OpenJDK 17)**

```bash
# Installation
sudo apt install -y openjdk-17-jdk openjdk-17-jre

# Vérification
java -version
javac -version

# Devrait afficher : openjdk version "17.x.x"
```

#### 2️⃣ **Python 3 et pip**

```bash
# Installation (normalement déjà présent)
sudo apt install -y python3 python3-pip python3-dev

# Vérification
python3 --version
pip3 --version
```

#### 3️⃣ **Lua et Love2D (pour CursedWare)**

```bash
sudo apt install -y lua5.3 love

# Vérification
lua -v
love --version
```

#### 4️⃣ **Bibliothèques système**

```bash
# Bibliothèques graphiques
sudo apt install -y libx11-6 libxext6 libxrender1 libxtst6 libxi6

# Bibliothèques audio
sudo apt install -y libasound2 libasound2-plugins pulseaudio

# Outils de compilation
sudo apt install -y build-essential
```

#### 5️⃣ **Pygame (pour jeux Python)**

```bash
# Installation globale
sudo apt install -y python3-pygame

# Ou via pip (plus récent)
pip3 install pygame --user

# Vérification
python3 -c "import pygame; print(pygame.version.ver)"
```

#### 6️⃣ **lxterminal (pour autostart)**

```bash
sudo apt install -y lxterminal

# Vérification
which lxterminal
```

#### 7️⃣ **Dépendances Python des jeux individuels**

```bash
# ball-blast
cd ~/git/borne_arcade/projet/ball-blast
if [ -f requirements.txt ]; then
    pip3 install -r requirements.txt --user
fi

# TronGame
cd ~/git/borne_arcade/projet/TronGame
if [ -f requirements.txt ]; then
    pip3 install -r requirements.txt --user
fi

# PianoTile
cd ~/git/borne_arcade/projet/PianoTile
if [ -f requirements.txt ]; then
    pip3 install -r requirements.txt --user
fi
```

### Vérifier toutes les dépendances

```bash
echo "=== VÉRIFICATION DES DÉPENDANCES ==="
echo -n "Java : "; java -version 2>&1 | head -n1
echo -n "Python : "; python3 --version
echo -n "Lua : "; lua -v
echo -n "Love2D : "; love --version
echo -n "Pygame : "; python3 -c "import pygame; print('OK -', pygame.version.ver)" 2>/dev/null || echo "ERREUR"
echo -n "lxterminal : "; which lxterminal
echo -n "MG2D : "; ls ~/MG2D/ >/dev/null 2>&1 && echo "OK" || echo "MANQUANT"
```

✅ **Point de contrôle** : Toutes les dépendances installées et vérifiées

---

## ÉTAPE 8 : Configurer le clavier personnalisé

> ⏱️ **Durée : 5 minutes**  
> 📍 **Localisation : Raspberry Pi**

### Qu'est-ce que le clavier "borne" ?

Le fichier `borne` est un **layout clavier XKB personnalisé** qui mappe les boutons physiques de la borne d'arcade vers des touches clavier : - Joystick 1 : ↑ ↓ ← → (flèches)
- Joystick 2 : O L K M
- Boutons J1 : R T Y F G H
- Boutons J2 : A Z E Q S D

### Installation du fichier

```bash
# Vérifier si le fichier existe dans la sauvegarde
ls ~/backup_migration/xkb_borne_backup

# Si oui, copier
sudo cp ~/backup_migration/xkb_borne_backup /usr/share/X11/xkb/symbols/borne

# Sinon, utiliser celui du projet
sudo cp ~/git/borne_arcade/borne /usr/share/X11/xkb/symbols/borne

# Vérifier l'installation
ls -la /usr/share/X11/xkb/symbols/borne
```

### Tester le layout

```bash
# Activer le layout temporairement
setxkbmap borne

# Vérifier qu'il est actif
setxkbmap -query

# Devrait afficher :
# layout:     borne
```

**Test pratique** :
```bash
# Ouvrir un éditeur
nano test_clavier.txt

# Appuyer sur les boutons de la borne
# Vérifier que les bonnes touches sont détectées
```

### Désactiver/Revenir au clavier normal (pour conf)

```bash
# Revenir au clavier français standard
setxkbmap fr

# Revenir au clavier borne
setxkbmap borne
```

> 💡 **Note** : Le script `lancerBorne.sh` contient déjà `setxkbmap borne`, donc le clavier sera activé automatiquement au lancement de la borne.

✅ **Point de contrôle** : Clavier arcade installé et fonctionnel

---

## ÉTAPE 9 : Configurer le démarrage automatique

> ⏱️ **Durée : 10 minutes**  
> 📍 **Localisation : Raspberry Pi**

### Rendre les scripts exécutables

```bash
cd ~/git/borne_arcade

# Tous les scripts .sh à la racine
chmod +x *.sh

# Tous les scripts de lancement de jeux
chmod +x projet/*/*.sh

# Vérifier
ls -la *.sh
```

### Adapter le script de lancement

```bash
cd ~/git/borne_arcade
nano lancerBorne.sh
```

**Contenu recommandé** :

```bash
#!/bin/bash

# Se placer dans le bon répertoire
cd /home/pi/git/borne_arcade

# Activer le clavier arcade
setxkbmap borne

# Nettoyage et compilation
echo "====================================="
echo "  BORNE D'ARCADE - DÉMARRAGE"
echo "====================================="
echo ""
echo "Nettoyage des fichiers temporaires..."
./clean.sh

echo "Compilation du menu principal..."
./compilation.sh

# Vérifier compilation réussie
if [ $? -ne 0 ]; then
    echo "ERREUR : Compilation échouée !"
    echo "Consultez logs/compilation.log pour détails"
    sleep 10
    exit 1
fi

# Définir le CLASSPATH pour MG2D
export CLASSPATH=".:$HOME/MG2D:$HOME/git/MG2D"

echo ""
echo "Lancement du menu principal..."
echo "====================================="

# Lancer le menu Java
java -cp "$CLASSPATH" Main

# Nettoyage après fermeture
./clean.sh

# Compte à rebours avant extinction
echo ""
echo "====================================="
for i in {30..1}; do
    echo "Extinction dans $i secondes... (Ctrl+C pour annuler)"
    sleep 1
done

# Extinction automatique (décommenter si souhaité)
#sudo halt
```

**Sauvegarder** : Ctrl+O → Entrée → Ctrl+X

### Configurer le fichier autostart

```bash
# Créer le répertoire autostart
mkdir -p ~/.config/autostart

# Éditer le fichier desktop
nano ~/git/borne_arcade/borne.desktop
```

**Contenu** :

```ini
[Desktop Entry]
Type=Application
Name=Borne Arcade
Comment=Lancement automatique de la borne d'arcade
Exec=/usr/bin/lxterminal -e /home/pi/git/borne_arcade/lancerBorne.sh
Icon=applications-games
Terminal=true
X-GNOME-Autostart-enabled=true
```

**Sauvegarder** et copier :

```bash
# Copier vers autostart
cp ~/git/borne_arcade/borne.desktop ~/.config/autostart/

# Rendre exécutable
chmod +x ~/.config/autostart/borne.desktop

# Vérifier
ls -la ~/.config/autostart/
cat ~/.config/autostart/borne.desktop
```

### Configuration autologin (rappel)

Si pas déjà fait lors de raspi-config :

```bash
sudo raspi-config
# System Options → Boot / Auto Login → Desktop Autologin
# Finish → Reboot
```

✅ **Point de contrôle** : Autostart configuré

---

## ÉTAPE 10 : Tester et valider

> ⏱️ **Durée : 15-20 minutes**  
> 📍 **Localisation : Raspberry Pi**

### Test 1 : Compilation manuelle

```bash
cd ~/git/borne_arcade

# Test de nettoyage
./clean.sh

# Test de compilation
./compilation.sh

# Vérifier les erreurs
if [ -f logs/compilation.log ]; then
    echo "=== Dernières lignes du log ==="
    tail -n 20 logs/compilation.log
fi

# Vérifier les fichiers .class créés
ls -la *.class | head -n 10
```

**Attendu** : Pas d'erreur, fichiers .class présents

### Test 2 : Lancement manuel du menu

```bash
cd ~/git/borne_arcade

# Définir CLASSPATH
export CLASSPATH=".:$HOME/MG2D"

# Lancer le menu
java -cp "$CLASSPATH" Main
```

**Attendu** : 
- Menu graphique s'affiche
- Liste des jeux visible
- Navigation avec flèches ou joystick fonctionne

**Tester** :
- ✅ Navigation entre jeux
- ✅ Sélection d'un jeu
- ✅ Lancement d'un jeu
- ✅ Retour au menu
- ✅ Quitter le menu

### Test 3 : Test d'un jeu Python

```bash
cd ~/git/borne_arcade/projet/ball-blast
python3 src/main.py
```

**Attendu** : Jeu se lance, contrôles fonctionnent

### Test 4 : Test d'un jeu Lua

```bash
cd ~/git/borne_arcade/projet/CursedWare
love .
```

**Attendu** : CursedWare démarre

### Test 5 : Script de vérification automatique

```bash
cd ~/git/borne_arcade/automatisation

# Rendre exécutable
chmod +x 04_verification_systeme.sh

# Lancer la vérification complète
./04_verification_systeme.sh
```

**Résultat** : Rapport complet avec ✅ pour chaque élément OK

### Test 6 : Autostart (test final)

```bash
# Redémarrer le système
sudo reboot
```

**Attendu après redémarrage** :
1. ✅ Connexion automatique (pas de login)
2. ✅ Terminal lxterminal s'ouvre automatiquement
3. ✅ Nettoyage et compilation s'exécutent
4. ✅ Menu de la borne s'affiche (après ~15-30 secondes)
5. ✅ Jeux fonctionnent correctement
6. ✅ Après fermeture menu : compte à rebours 30 secondes

**Si problème** → Voir section Dépannage ci-dessous

✅ **Point de contrôle final** : Borne complètement fonctionnelle !

---

# PARTIE 4 : DÉPANNAGE

## Problèmes fréquents et solutions

### ❌ Problème 1 : Autostart ne fonctionne pas

**Symptôme** : Après redémarrage, rien ne se lance automatiquement

**Solutions** :

```bash
# Vérifier que le fichier existe
ls -la ~/.config/autostart/borne.desktop

# Vérifier les permissions
chmod +x ~/.config/autostart/borne.desktop

# Vérifier le contenu
cat ~/.config/autostart/borne.desktop

# Vérifier que lxterminal est installé
which lxterminal
sudo apt install -y lxterminal

# Vérifier autologin
sudo raspi-config
# S5 Boot / Auto Login → Desktop Autologin

# Tester manuellement
/usr/bin/lxterminal -e /home/pi/git/borne_arcade/lancerBorne.sh
```

### ❌ Problème 2 : Erreur "package mg2d does not exist"

**Symptôme** : Compilation Java échoue avec erreur MG2D

**Solutions** :

```bash
# Vérifier que MG2D existe
ls -la ~/MG2D

# Si manquant, cloner
cd ~
git clone https://github.com/synave/MG2D.git

# Définir CLASSPATH
echo 'export CLASSPATH=".:$HOME/MG2D"' >> ~/.bashrc
source ~/.bashrc

# Vérifier dans le script compilation.sh
cd ~/git/borne_arcade
grep -i classpath compilation.sh

# Modifier si nécessaire
nano compilation.sh
# Ajouter : export CLASSPATH=".:$HOME/MG2D"

# Nettoyer et recompiler
./clean.sh
./compilation.sh
```

### ❌ Problème 3 : Mauvaise résolution d'écran

**Symptôme** : Écran 1280x1024 non détecté, résolution incorrecte

**Solution A : raspi-config**

```bash
sudo raspi-config
# Display Options → D1 Resolution → DMT Mode 32 (1280x1024 @ 60Hz)
# Finish → Reboot
```

**Solution B : Modification manuelle**

```bash
sudo nano /boot/config.txt
```

Ajouter/modifier :

```ini
# Force résolution 1280x1024
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=32
disable_overscan=1
```

```bash
sudo reboot
```

**Solution C : xrandr (temporaire)**

```bash
# Lister résolutions disponibles
xrandr

# Forcer la résolution
xrandr --output HDMI-1 --mode 1280x1024
```

### ❌ Problème 4 : Clavier "borne" ne fonctionne pas

**Symptôme** : `setxkbmap borne` renvoie une erreur

**Solutions** :

```bash
# Vérifier le fichier
ls -la /usr/share/X11/xkb/symbols/borne

# Si absent, copier
sudo cp ~/git/borne_arcade/borne /usr/share/X11/xkb/symbols/borne

# Vérifier syntaxe
sudo xkbcomp /usr/share/X11/xkb/symbols/borne $DISPLAY

# Test activation
setxkbmap borne

# Vérifier
setxkbmap -query
```

### ❌ Problème 5 : Pas de son

**Symptôme** : Jeux muets, pas de son

**Solutions** :

```bash
# Vérifier carte son
aplay -l

# Tester son
speaker-test -t wav -c 2

# Mixer ALSA
alsamixer
# Augmenter volume (flèche haut), Échap pouRegarder pour installer un nouvel OS raspberry py

On passera d'un Rasbian 2017 à un RBpy3-RBPyOS

fait moi un tuto de A à Zr quitter

# Forcer sortie HDMI (si écran avec son)
sudo raspi-config
# System Options → Audio → HDMI

# Configuration ALSA
sudo nano /etc/asound.conf
```

Contenu :

```ini
pcm.!default {
    type hw
    card 0
    device 0
}

ctl.!default {
    type hw
    card 0
}
```

```bash
sudo reboot
```

### ❌ Problème 6 : Jeux Python ne fonctionnent pas

**Symptôme** : Erreur `ModuleNotFoundError: No module named 'pygame'`

**Solutions** :

```bash
# Installer Pygame
pip3 install pygame --user

# Ou version système
sudo apt install python3-pygame

# Vérifier
python3 -c "import pygame; print(pygame.version.ver)"

# Installer dépendances du jeu
cd ~/git/borne_arcade/projet/ball-blast
pip3 install -r requirements.txt --user
```

### ❌ Problème 7 : Erreur "Permission denied"

**Symptôme** : `bash: ./script.sh: Permission denied`

**Solution** :

```bash
cd ~/git/borne_arcade

# Rendre tous les scripts exécutables
chmod +x *.sh
chmod +x projet/*/*.sh
chmod +x automatisation/*.sh

# Vérifier
ls -la *.sh
```

### ❌ Problème 8 : Compilation lente ou freeze

**Symptôme** : Compilation prend très longtemps ou semble bloquée

**Solutions** :

```bash
# Vérifier charge système
htop

# Augmenter swap si nécessaire
sudo nano /etc/dphys-swapfile
# CONF_SWAPSIZE=1024 (au lieu de 100)
sudo dphys-swapfile setup
sudo dphys-swapfile swapon

# Compiler en mode verbeux
cd ~/git/borne_arcade
javac -verbose -cp ".:$HOME/MG2D" *.java 2>&1 | tee compile_debug.log
```

### 📋 Checklist finale de validation

Avant de considérer la migration terminée :

```
 Système
   [✓] RBpy3-RBPyOS installé et à jour
   [✓] Configuration raspi-config complète
   [✓] Résolution 1280x1024 correcte
   [✓] Autologin activé

 Projet
   [✓] borne_arcade restauré dans ~/git/
   [✓] MG2D présent dans ~/MG2D/
   [✓] Highscores restaurés
   [✓] Tous les scripts exécutables

 Dépendances
   [✓] Java 17 installé et fonctionnel
   [✓] Python 3 + Pygame
   [✓] Lua + Love2D
   [✓] lxterminal installé

 Configuration
   [✓] Clavier "borne" installé et testé
   [✓] Fichier borne.desktop dans ~/.config/autostart/
   [✓] Script lancerBorne.sh adapté
   [✓] CLASSPATH correctement défini

 Tests
   [✓] Compilation manuelle OK
   [✓] Menu principal se lance
   [✓] Au moins 3 jeux testés avec succès
   [✓] Clavier arcade réactif (joysticks + boutons)
   [✓] Son fonctionnel
   [✓] Autostart fonctionne après reboot

 Sécurité
   [✓] Sauvegarde complète existante
   [✓] Mot de passe changé (différent du défaut)
   [✓] SSH sécurisé ou désactivé si non nécessaire
```

---

## 📚 Annexes

### Annexe A : Correspondance touches arcade

| Contrôle | Joueur 1 | Joueur 2 |
|----------|----------|----------|
| **Joystick Haut** | ↑ | O |
| **Joystick Bas** | ↓ | L |
| **Joystick Gauche** | ← | K |
| **Joystick Droite** | → | M |
| **Bouton 1** | R | A |
| **Bouton 2** | T | Z |
| **Bouton 3** | Y | E |
| **Bouton 4** | F | Q |
| **Bouton 5** | G | S |
| **Bouton 6** | H | D |

### Annexe B : Structure finale du système

```
/home/pi/
├── MG2D/                        # Bibliothèque graphique Java
│   ├── geometrie/
│   ├── noyau/
│   └── ...
├── git/
│   └── borne_arcade/            # Projet principal
│       ├── borne                # Layout clavier XKB
│       ├── borne.desktop        # Fichier autostart
│       ├── lancerBorne.sh       # Script lancement principal
│       ├── compilation.sh       # Compilation Java
│       ├── clean.sh             # Nettoyage
│       ├── Main.java            # Menu principal
│       ├── Boite*.java          # Classes menu
│       ├── automatisation/      # Scripts automatisation
│       ├── projet/              # Tous les jeux
│       │   ├── Columns/
│       │   ├── CursedWare/
│       │   ├── DinoRail/
│       │   ├── InitialDrift/
│       │   ├── JavaSpace/
│       │   ├── ball-blast/
│       │   └── ...
│       ├── fonts/               # Polices
│       ├── img/                 # Images menu
│       ├── sound/               # Sons menu
│       └── logs/                # Logs compilation
├── .config/
│   └── autostart/
│       └── borne.desktop        # Copie pour lancement auto
└── backup_migration/            # Sauvegarde (optionnel)
    └── ...
```

### Annexe C : Liste des jeux disponibles

| Jeu | Langage | Dépendances | Type |
|-----|---------|-------------|------|
| Columns | ☕ Java | MG2D | Puzzle (Tetris-like) |
| CursedWare | 🌙 Lua | Love2D | Mini-jeux WarioWare-like |
| DinoRail | ☕ Java | MG2D | Action (Dino infini) |
| InitialDrift | ☕ Java | MG2D | Course arcade |
| JavaSpace | ☕ Java | MG2D | Shoot'em up spatial |
| Kowasu_Renga | ☕ Java | MG2D | Casse-briques |
| Minesweeper | ☕ Java | MG2D | Démineur |
| OsuTile | ☕ Java | MG2D | Rythme |
| PianoTile | 🐍 Python | Pygame | Rythme (Piano Tiles) |
| Pong | ☕ Java | MG2D | Arcade classique |
| Puissance_X | ☕ Java | MG2D | Puissance 4 |
| Snake_Eater | ☕ Java | MG2D | Snake classique |
| TronGame | 🐍 Python | Pygame | Tron lightcycles |
| ball-blast | 🐍 Python | Pygame | Action (casse-boules) |

### Annexe D : Commandes utiles

```bash
# Système
sudo reboot                      # Redémarrer
sudo halt                        # Éteindre
sudo raspi-config                # Configuration Raspberry Pi
htop                             # Moniteur système

# Réseau
hostname -I                      # Adresse IP
ip addr show                     # Infos réseau détaillées
ping google.com                  # Test connexion Internet

# Borne d'arcade
cd ~/git/borne_arcade            # Aller au projet
./compilation.sh                 # Compiler menu
./lancerBorne.sh                 # Lancer menu
./clean.sh                       # Nettoyer fichiers .class

# Clavier
setxkbmap borne                  # Activer clavier arcade
setxkbmap fr                     # Revenir clavier français
setxkbmap -query                 # Voir layout actif

# Java
java -version                    # Version Java
javac -version                   # Version compilateur
export CLASSPATH=".:$HOME/MG2D"  # Définir CLASSPATH

# Python
python3 --version                # Version Python
pip3 list                        # Paquets installés
pip3 install pygame --user       # Installer Pygame

# Git (mise à jour projet)
cd ~/git/borne_arcade
git pull                         # Récupérer dernières modifications
git status                       # Voir état du dépôt

# Logs et débogage
tail -f ~/git/borne_arcade/logs/compilation.log  # Suivre log compilation
journalctl -xe                   # Logs système
dmesg | tail -50                 # Messages noyau
```

### Annexe E : Ressources et documentation

**Documentation Raspberry Pi**
- Site officiel : https://www.raspberrypi.com/documentation/
- Forums : https://forums.raspberrypi.com/

**Bibliothèque MG2D**
- GitHub : https://github.com/synave/MG2D
- Documentation : Voir README du dépôt

**Projet borne_arcade**
- Documentation : `~/git/borne_arcade/Documents/Documentation/`
- README : `~/git/borne_arcade/README.md`

**Systèmes d'exploitation alternatives**
- Raspberry Pi OS : https://www.raspberrypi.com/software/operating-systems/
- Ubuntu for Raspberry Pi : https://ubuntu.com/download/raspberry-pi
- RetroPie : https://retropie.org.uk/

---

## 🎉 Conclusion

**Félicitations !** Vous avez migré avec succès votre borne d'arcade de Rasbian 2017 vers RBpy3-RBPyOS.

### Ce que vous avez accompli :

✅ Sauvegarde complète de l'ancien système  
✅ Installation d'un système d'exploitation moderne  
✅ Configuration optimisée pour borne d'arcade  
✅ Restauration de tous les jeux et highscores  
✅ Installation de toutes les dépendances  
✅ Configuration du clavier personnalisé  
✅ Démarrage automatique de la borne  

### Prochaines étapes suggérées :

1. **Tester intensivement** : Jouez à tous les jeux, vérifiez la stabilité
2. **Sauvegarder l'image** : Créer une sauvegarde de la carte SD configurée
3. **Documenter les modifications** : Noter les personnalisations spécifiques
4. **Optimiser** : Ajuster performances, résolution, son selon besoin
5. **Développer** : Ajouter de nouveaux jeux ou fonctionnalités !

### Support et aide

**En cas de problème** :
- Consultez la section [Dépannage](#partie-4--dépannage)
- Vérifiez les logs : `~/git/borne_arcade/logs/`
- Forums Raspberry Pi
- Documentation du projet

### Sauvegarde post-migration (IMPORTANT)

Une fois tout validé, créez une image de sauvegarde :

```bash
# Éteindre proprement le Raspberry Pi
sudo halt

# Sur votre PC, sauvegarder la carte SD
sudo dd if=/dev/sdX of=borne_arcade_rbpy3_OK_$(date +%Y%m%d).img bs=4M status=progress

# Compresser
gzip borne_arcade_rbpy3_OK_$(date +%Y%m%d).img

# Stocker dans un endroit sûr
```

---

**Guide créé le :** 12 février 2026  
**Version :** 2.0 - Tutoriel complet A à Z  
**Projet :** Borne d'arcade IUT du Littoral Côte d'Opale  
**Auteur :** Documentation technique SAÉ  
**Licence :** Éducatif / MIT

---

🎮 **Bonne arcade !** 🕹️
