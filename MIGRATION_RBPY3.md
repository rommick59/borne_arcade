# Guide de Migration : Rasbian 2017 → RBpy3-RBPyOS

**Date de création :** 12 février 2026  
**Projet :** Borne d'arcade IUT du Littoral Côte d'Opale  
**Type de migration :** Remplacement complet du système d'exploitation

---

## 📋 Table des matières

1. [Préparation et sauvegarde](#1-préparation-et-sauvegarde)
2. [Matériel nécessaire](#2-matériel-nécessaire)
3. [Sauvegarde des données critiques](#3-sauvegarde-des-données-critiques)
4. [Installation de RBpy3-RBPyOS](#4-installation-de-rbpy3-rbpyos)
5. [Configuration initiale du système](#5-configuration-initiale-du-système)
6. [Restauration du projet borne arcade](#6-restauration-du-projet-borne-arcade)
7. [Installation des dépendances](#7-installation-des-dépendances)
8. [Configuration du clavier personnalisé](#8-configuration-du-clavier-personnalisé)
9. [Configuration de l'autostart](#9-configuration-de-lautostart)
10. [Tests et validation](#10-tests-et-validation)
11. [Dépannage](#11-dépannage)

---

## 1. Préparation et sauvegarde

### 1.1 Évaluation de l'ancien système

Avant de commencer, identifiez ce qui doit être sauvegardé :

```bash
# Sur l'ancien Rasbian 2017, listez vos applications
dpkg --get-selections > ~/installed_packages.txt

# Vérifiez la version actuelle
cat /etc/os-release
uname -a

# Notez votre configuration réseau
ip addr show
cat /etc/network/interfaces
```

### 1.2 Créer un inventaire du matériel

- **Raspberry Pi :** Modèle 3 (ou supérieur)
- **Écran :** 4:3, résolution 1280x1024
- **Contrôleurs :** 2 joysticks + 12 boutons (6×2)
- **Carte SD :** Minimum 16 Go (32 Go recommandé)
- **Périphériques USB :** Clavier, souris (pour l'installation)

---

## 2. Matériel nécessaire

### Liste de matériel pour la migration

- ✅ Carte SD neuve (32 Go, classe 10 ou supérieur)
- ✅ Lecteur de carte SD pour PC
- ✅ Clé USB (pour sauvegarde temporaire si besoin)
- ✅ Clavier et souris USB standard
- ✅ Connexion Internet (Ethernet recommandé)
- ✅ PC avec accès Internet (pour télécharger l'OS)

### Logiciels nécessaires sur votre PC

- **Raspberry Pi Imager** (https://www.raspberrypi.com/software/)
- **Balena Etcher** (alternative : https://www.balena.io/etcher/)
- **Client SSH** (optionnel : PuTTY sur Windows, natif sur Linux/Mac)

---

## 3. Sauvegarde des données critiques

### 3.1 Sauvegarde sur l'ancien système

**🚀 MÉTHODE AUTOMATISÉE (RECOMMANDÉE)**

Un script d'automatisation complet est disponible dans le projet :

```bash
cd ~/git/borne_arcade/automatisation

# Rendre le script exécutable
chmod +x 01_backup_ancien_systeme.sh

# Lancer la sauvegarde automatique
./01_backup_ancien_systeme.sh
```

Ce script sauvegarde automatiquement :
- ✅ Projet borne_arcade complet
- ✅ Bibliothèque MG2D
- ✅ Tous les highscores de jeux
- ✅ Fichier de mapping clavier personnalisé
- ✅ Configurations système (.bashrc, .profile)
- ✅ Informations système détaillées
- ✅ Liste des paquets Python installés

**Méthode manuelle (si nécessaire)**

Connectez-vous à votre Raspberry Pi actuel et effectuez les sauvegardes suivantes :

```bash
# Créer un répertoire de sauvegarde
mkdir -p ~/backup_migration
cd ~/backup_migration

# 1. Sauvegarder le projet borne arcade
tar -czf borne_arcade_backup.tar.gz ~/git/borne_arcade/

# 2. Sauvegarder MG2D
tar -czf MG2D_backup.tar.gz ~/MG2D/

# 3. Sauvegarder les configurations système importantes
cp ~/.bashrc bashrc_backup
cp ~/.profile profile_backup
cp /etc/X11/xorg.conf xorg_backup 2>/dev/null || echo "Pas de xorg.conf"

# 4. Sauvegarder le fichier de mapping clavier personnalisé
sudo cp -r /usr/share/X11/xkb/symbols/borne xkb_borne_backup 2>/dev/null || echo "Fichier borne non trouvé"

# 5. Sauvegarder les highscores
mkdir -p highscores_backup
find ~/git/borne_arcade/projet/ -name "highscore" -exec cp {} highscores_backup/ \;

# 6. Créer un fichier d'informations système
echo "=== Informations système ===" > system_info.txt
cat /etc/os-release >> system_info.txt
echo -e "\n=== Version Java ===" >> system_info.txt
java -version 2>> system_info.txt
echo -e "\n=== Paquets installés ===" >> system_info.txt
dpkg -l >> system_info.txt

# Compresser le tout
cd ~
tar -czf backup_migration_complete.tar.gz backup_migration/

# Vérifier la taille
ls -lh backup_migration_complete.tar.gz
```

### 3.2 Transfert de la sauvegarde

**Option A : Clé USB**
```bash
# Identifier votre clé USB
lsblk

# Monter la clé (remplacer sdX1 par votre périphérique)
sudo mount /dev/sdX1 /mnt

# Copier la sauvegarde
cp ~/backup_migration_complete.tar.gz /mnt/

# Démonter proprement
sudo umount /mnt
```

**Option B : Réseau (SCP/SFTP)**
```bash
# Sur votre PC, récupérer la sauvegarde
scp pi@<ip_raspberry>:~/backup_migration_complete.tar.gz ./
```

**Option C : Cloud/Git**
```bash
# Si vous avez un dépôt Git privé
cd ~/git/borne_arcade
git add .
git commit -m "Backup avant migration vers RBpy3-RBPyOS"
git push
```

---

## 4. Installation de RBpy3-RBPyOS

### 4.1 Téléchargement de l'image RBpy3-RBPyOS

1. **Télécharger l'image officielle**
   - Site officiel : [URL de RBpy3-RBPyOS - à adapter selon la source réelle]
   - Vérifier la somme de contrôle (SHA256) du fichier téléchargé

```bash
# Sur votre PC Linux
sha256sum rbpy3-rbpyos-latest.img.xz
# Comparer avec la somme fournie sur le site officiel
```

### 4.2 Préparation de la carte SD

**Sur Linux :**

```bash
# 1. Identifier votre carte SD
lsblk
# Exemple de sortie : sdb (votre carte SD - ATTENTION à bien identifier)

# 2. Démonter tous les partitions de la carte
sudo umount /dev/sdb*

# 3. Flasher l'image (méthode 1 : avec dd)
sudo dd if=rbpy3-rbpyos-latest.img bs=4M status=progress of=/dev/sdb conv=fsync
# ⚠️ ATTENTION : Vérifiez bien que /dev/sdb est votre carte SD !

# 4. Synchroniser
sync
```

**Méthode alternative avec Raspberry Pi Imager (recommandé) :**

```bash
# Installer Raspberry Pi Imager
sudo apt install rpi-imager

# Lancer l'interface graphique
rpi-imager
```

Dans l'interface :
1. **Choose OS** → "Use custom" → Sélectionner `rbpy3-rbpyos-latest.img`
2. **Choose Storage** → Sélectionner votre carte SD
3. Cliquer sur l'icône ⚙️ (paramètres avancés)
4. Configurer :
   - ✅ Enable SSH
   - ✅ Set username and password (ex: `pi` / `raspberry`)
   - ✅ Configure WiFi (optionnel)
   - ✅ Set locale settings (Europe/Paris, fr)
5. **Write**

### 4.3 Première montage de la carte SD (configuration pré-boot)

Avant d'insérer la carte dans le Raspberry Pi, vous pouvez activer SSH :

```bash
# Remonter la partition boot
mkdir -p /tmp/boot_mount
sudo mount /dev/sdb1 /tmp/boot_mount

# Activer SSH (créer un fichier vide nommé "ssh")
sudo touch /tmp/boot_mount/ssh

# Configuration WiFi (optionnel)
sudo nano /tmp/boot_mount/wpa_supplicant.conf
```

Contenu de `wpa_supplicant.conf` :
```
country=FR
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="VotreSSID"
    psk="VotreMotDePasse"
    key_mgmt=WPA-PSK
}
```

```bash
# Démonter
sudo umount /tmp/boot_mount
```

---

## 5. Configuration initiale du système

### 5.1 Premier démarrage

1. Insérer la carte SD dans le Raspberry Pi
2. Connecter écran, clavier, souris, Ethernet
3. Brancher l'alimentation

Le système devrait démarrer et vous présenter l'écran de connexion.

### 5.2 Connexion initiale

**Connexion locale :**
- Utilisateur : `pi` (ou celui configuré)
- Mot de passe : `raspberry` (ou celui configuré)

**Connexion SSH (optionnel) :**
```bash
# Sur votre PC, trouver l'IP du Raspberry
nmap -sn 192.168.1.0/24 | grep -B 2 "Raspberry"

# Se connecter
ssh pi@<adresse_ip>
```

### 5.3 Configuration de base avec raspi-config

```bash
sudo raspi-config
```

**Configuration recommandée :**

1. **System Options**
   - **S3 Password** : Changer le mot de passe par défaut
   - **S4 Hostname** : Nommer votre Pi (ex: `borne-arcade`)
   - **S5 Boot / Auto Login** : Choisir "Console Autologin" ou "Desktop Autologin"

2. **Display Options**
   - **D1 Resolution** : Choisir 1280×1024 (ou DMT Mode 32)
   - **D3 Screen Blanking** : Désactiver pour la borne

3. **Interface Options**
   - **I2 SSH** : Activer (si pas déjà fait)

4. **Localization Options**
   - **L1 Locale** : `fr_FR.UTF-8 UTF-8`
   - **L2 Timezone** : Europe/Paris
   - **L3 Keyboard** : Generic 105-key PC → French → Default
   - **L4 WLAN Country** : FR

5. **Advanced Options**
   - **A1 Expand Filesystem** : Oui (utiliser toute la carte SD)
   - **A3 Memory Split** : 256 Mo (pour les graphiques)

6. **Finish** → Reboot

### 5.4 Mise à jour du système

```bash
# Mise à jour complète
sudo apt update
sudo apt full-upgrade -y

# Installation des outils de base
sudo apt install -y vim git curl wget htop

# Redémarrage
sudo reboot
```

---

## 6. Restauration du projet borne arcade

### 6.1 Restauration depuis la sauvegarde

**🚀 MÉTHODE AUTOMATISÉE (RECOMMANDÉE)**

```bash
# Copier d'abord l'archive de sauvegarde sur le nouveau système
# (via clé USB, SCP, ou autre)

cd ~/git/borne_arcade/automatisation  # ou créer le dossier si besoin

# Rendre le script exécutable
chmod +x 02_restauration_nouveau_systeme.sh

# Lancer la restauration
./02_restauration_nouveau_systeme.sh
```

Le script va automatiquement :
- 🔍 Trouver l'archive de sauvegarde
- 📦 Extraire tous les fichiers
- 📁 Recréer la structure des répertoires
- 🎮 Restaurer tous les jeux et highscores
- ⌨️ Installer le fichier de clavier personnalisé
- ✅ Configurer l'autostart

**Méthode manuelle**

**Option A : Depuis la clé USB**

```bash
# Monter la clé USB
sudo mount /dev/sda1 /mnt

# Copier la sauvegarde
cp /mnt/backup_migration_complete.tar.gz ~/

# Démonter
sudo umount /mnt

# Extraire
cd ~
tar -xzf backup_migration_complete.tar.gz
```

**Option B : Depuis votre PC via SCP**

```bash
# Sur votre PC
scp backup_migration_complete.tar.gz pi@<ip_raspberry>:~/

# Sur le Raspberry Pi
cd ~
tar -xzf backup_migration_complete.tar.gz
```

### 6.2 Recréer la structure des répertoires

```bash
# Créer la structure git comme dans l'ancien système
mkdir -p ~/git
cd ~/git

# Restaurer borne_arcade
tar -xzf ~/backup_migration/borne_arcade_backup.tar.gz -C ~/
mv ~/git/borne_arcade ~/git/borne_arcade_backup_old 2>/dev/null || true
mv ~/home/pi/git/borne_arcade ~/git/ 2>/dev/null || mv ~/git/borne_arcade ~/git/

# Restaurer MG2D (si sauvegardé)
tar -xzf ~/backup_migration/MG2D_backup.tar.gz -C ~/

# Vérifier la structure
ls -la ~/git/
ls -la ~/MG2D/
```

**Option alternative : Clonage depuis Git (recommandé si vos dépôts sont à jour)**

```bash
mkdir -p ~/git
cd ~/git

# Cloner MG2D
git clone https://github.com/synave/MG2D.git

# Cloner borne_arcade (adapter l'URL selon votre dépôt)
git clone http://iut.univ-littoral.fr/gitlab/synave/borne_arcade.git

# Ou votre fork
# git clone https://github.com/votre-compte/borne_arcade.git
```

### 6.3 Restaurer les highscores

```bash
# Copier les anciens highscores
cp ~/backup_migration/highscores_backup/* ~/git/borne_arcade/projet/*/highscore 2>/dev/null || echo "Highscores à restaurer manuellement"

# Ou manuellement pour chaque jeu
# cp ~/backup_migration/highscores_backup/highscore_columns ~/git/borne_arcade/projet/Columns/highscore
```

---

## 7. Installation des dépendances

### 7.1 Utilisation du script d'installation automatique

**🚀 SCRIPT COMPLET D'INSTALLATION (RECOMMANDÉ)**

Un nouveau script complet est disponible pour installer TOUTES les dépendances :

```bash
cd ~/git/borne_arcade/automatisation

# Rendre le script exécutable
chmod +x 03_install_dependances_complete.sh

# Lancer l'installation complète
./03_install_dependances_complete.sh
```

Ce script installe dans l'ordre :
1. ✅ Mise à jour du système
2. ✅ Outils de base (git, vim, curl, wget, htop)
3. ✅ **Java** (OpenJDK 17 JDK + JRE)
4. ✅ **Python 3** + pip + outils de développement
5. ✅ **Bibliothèques système** (X11, audio, ALSA, PulseAudio)
6. ✅ **Lua 5.3** + **Love2D** (pour CursedWare)
7. ✅ **Pygame** (pour ball-blast, TronGame, PianoTile)
8. ✅ **lxterminal** (pour l'autostart)
9. ✅ **MG2D** (bibliothèque graphique, clonée depuis GitHub)
10. ✅ **Dépendances spécifiques** des jeux Python (requirements.txt)

**Scripts existants (alternatifs)**

```bash
cd ~/git/borne_arcade/automatisation

# Mise à jour complète du système
./install_all.sh

# Installation des dépendances de base (Java, Python, MG2D)
./install.sh
```

### 7.2 Installation manuelle (si nécessaire)

**Java (OpenJDK ou Adoptium Temurin) :**

```bash
# Vérifier si Java est installé
java -version

# Si non installé, installer OpenJDK 17
sudo apt install -y openjdk-17-jdk

# Alternative : Adoptium Temurin (recommandé par le script install.sh)
sudo apt install -y wget gnupg software-properties-common
wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo gpg --dearmor -o /usr/share/keyrings/adoptium.gpg
echo "deb [signed-by=/usr/share/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
sudo apt update
sudo apt install -y temurin-17-jdk

# Vérifier l'installation
java -version
javac -version
```

**Python 3 :**

```bash
# Python3 devrait être préinstallé sur RBpy3-RBPyOS
python3 --version

# Si nécessaire
sudo apt install -y python3 python3-pip
```

**Git :**

```bash
sudo apt install -y git
git --version
```

**Bibliothèques graphiques (pour Java) :**

```bash
# Installer les bibliothèques X11 et audio
sudo apt install -y libx11-6 libxext6 libxrender1 libxtst6 libxi6
sudo apt install -y libasound2 libasound2-plugins

# Pour le support audio Java si nécessaire
sudo apt install -y libpulse0
```

**Lua (pour CursedWare) :**

```bash
sudo apt install -y lua5.3 love
```

**Dépendances Python pour les jeux Python :**

```bash
# ball-blast par exemple
cd ~/git/borne_arcade/projet/ball-blast
if [ -f requirements.txt ]; then
    pip3 install -r requirements.txt --user
fi
```

### 7.3 Installation de MG2D

Si vous n'avez pas restauré depuis votre sauvegarde :

```bash
cd ~
git clone https://github.com/synave/MG2D.git

# Ou depuis l'ancien dépôt IUT
# git clone http://iut.univ-littoral.fr/gitlab/synave/MG2D.git
```

Vérifiez que MG2D est dans `~/MG2D` ou `~/git/MG2D` (ajuster les chemins si nécessaire).

---

## 8. Configuration du clavier personnalisé

### 8.1 Restaurer le fichier de mapping clavier

Le projet utilise un layout clavier personnalisé nommé `borne`. Ce fichier mappe les touches de la borne d'arcade aux touches du clavier.

```bash
# Vérifier si le fichier existe dans votre sauvegarde
ls ~/backup_migration/xkb_borne_backup

# Copier le fichier vers le système
sudo cp ~/backup_migration/xkb_borne_backup /usr/share/X11/xkb/symbols/borne

# Si le fichier n'existe pas dans la sauvegarde, utiliser celui du projet
cd ~/git/borne_arcade
if [ -f borne ]; then
    sudo cp borne /usr/share/X11/xkb/symbols/borne
else
    echo "Fichier 'borne' non trouvé, vérifier le nom du fichier"
    ls -la | grep -i borne
fi
```

### 8.2 Vérifier le contenu du fichier borne

```bash
# Afficher le contenu
cat ~/git/borne_arcade/borne

# Ou si déjà installé
cat /usr/share/X11/xkb/symbols/borne
```

Vous devriez voir un fichier de configuration XKB avec des mappings comme :
```
key <UP>   { [ Up ] };
key <DOWN> { [ Down ] };
// ... autres mappings
```

### 8.3 Activer le layout personnalisé

**Méthode 1 : Temporaire (pour tester)**
```bash
setxkbmap borne
```

Si cette commande fonctionne sans erreur, votre layout est correctement installé.

**Méthode 2 : Permanent (dans le script de lancement)**

Le script `lancerBorne.sh` contient déjà `setxkbmap borne`, donc le layout sera activé automatiquement au lancement de la borne.

**Méthode 3 : Configuration système (optionnel)**

Pour activer le layout dès le démarrage de X11 :

```bash
# Créer/éditer le fichier de configuration X11
sudo nano /etc/X11/xorg.conf.d/00-keyboard.conf
```

Contenu :
```
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "borne"
EndSection
```

---

## 9. Configuration de l'autostart

### 9.1 Adapter le fichier borne.desktop

Le fichier `borne.desktop` doit pointer vers le bon chemin :

```bash
cd ~/git/borne_arcade

# Éditer le fichier
nano borne.desktop
```

**Contenu à vérifier/modifier :**

```ini
[Desktop Entry]
Type=Application
Name=Borne Arcade
Comment=Lancement automatique de la borne d'arcade
Exec=/usr/bin/lxterminal -e /home/pi/git/borne_arcade/lancerBorne.sh
Icon=gtk-dialog-authentication
Terminal=true
X-KeepTerminal=false
```

**Vérifications importantes :**
- Remplacer `/home/pi/` par votre répertoire utilisateur si différent
- Vérifier que `lxterminal` est installé (ou utiliser `xterm`, `gnome-terminal`, etc.)

```bash
# Vérifier si lxterminal est disponible
which lxterminal

# Si non installé
sudo apt install -y lxterminal
```

**Déterminer l'utilisateur courant :**
```bash
echo $USER
echo $HOME
```

### 9.2 Installation de l'autostart

```bash
cd ~/git/borne_arcade

# Créer le répertoire autostart s'il n'existe pas
mkdir -p ~/.config/autostart

# Copier le fichier
cp borne.desktop ~/.config/autostart/

# Rendre exécutable
chmod +x ~/.config/autostart/borne.desktop

# Vérifier
ls -la ~/.config/autostart/
```

### 9.3 Rendre les scripts exécutables

```bash
cd ~/git/borne_arcade

# Rendre tous les scripts .sh exécutables
chmod +x *.sh
chmod +x projet/*/*.sh

# Vérifier
ls -la *.sh
```

### 9.4 Vérifier les chemins dans lancerBorne.sh

```bash
cd ~/git/borne_arcade
nano lancerBorne.sh
```

Contenu actuel :
```bash
#!/bin/bash

setxkbmap borne

echo "nettoyage des répertoires"
echo "Veuillez patienter"
./clean.sh
./compilation.sh

echo "Lancement du Menu"
echo "Veuillez patienter"

java -cp .:$HOME Main
./clean.sh

for i in {30..1}
do
    echo Extinction de la borne dans $i secondes
    sleep 1
done

#sudo halt
```

**Modifications à considérer :**

1. **Ajouter le bon CLASSPATH pour MG2D :**

```bash
#!/bin/bash

# Se placer dans le bon répertoire
cd /home/pi/git/borne_arcade

# Activer le layout clavier personnalisé
setxkbmap borne

echo "Nettoyage des répertoires"
echo "Veuillez patienter"
./clean.sh

echo "Compilation du menu principal"
./compilation.sh

echo "Lancement du Menu"
echo "Veuillez patienter"

# Définir le CLASSPATH avec MG2D
export CLASSPATH=".:$HOME/MG2D:$HOME/git/MG2D"

java -cp $CLASSPATH Main

./clean.sh

# Compte à rebours avant extinction
for i in {30..1}
do
    echo "Extinction de la borne dans $i secondes"
    sleep 1
done

# Décommenter pour extinction automatique
#sudo halt
```

### 9.5 Configuration de l'autologin (borne autonome)

Pour que la borne démarre automatiquement sans interaction :

```bash
sudo raspi-config
```

- **System Options** → **Boot / Auto Login** → **Desktop Autologin**
- Reboot

---

## 10. Tests et validation

### 10.1 Test du script de lancement (sans autostart)

Avant de redémarrer, testez manuellement :

```bash
cd ~/git/borne_arcade

# Test de compilation
./compilation.sh

# Vérifier qu'il n'y a pas d'erreurs
cat logs/compilation.log
```

Si des erreurs de compilation apparaissent :
```bash
# Vérifier le CLASSPATH
echo $CLASSPATH
export CLASSPATH=".:$HOME/MG2D"

# Vérifier que MG2D existe
ls -la ~/MG2D/

# Recompiler
./compilation.sh
```

**Lancer la borne manuellement :**

```bash
cd ~/git/borne_arcade
./lancerBorne.sh
```

### 10.2 Test du layout clavier

```bash
# Activer le layout
setxkbmap borne

# Ouvrir un éditeur de texte et tester les touches de la borne
nano test_clavier.txt
```

Appuyez sur les boutons de la borne et vérifiez que les bonnes touches sont reconnues :
- Joystick 1 : Flèches (Haut, Bas, Gauche, Droite)
- Joystick 2 : O, L, K, M
- Boutons J1 : R, T, Y, F, G, H
- Boutons J2 : A, Z, E, Q, S, D

### 10.3 Test d'un jeu individuel

```bash
cd ~/git/borne_arcade/projet/Columns

# Compiler le jeu
javac -cp .:$HOME/MG2D *.java

# Lancer le jeu
java -cp .:$HOME/MG2D Main
```

### 10.4 Vérification automatisée du système

**🚀 SCRIPT DE VÉRIFICATION COMPLET**

Avant de tester l'autostart, vérifiez que tout est bien configuré :

```bash
cd ~/git/borne_arcade/automatisation

# Rendre le script exécutable
chmod +x 04_verification_systeme.sh

# Lancer la vérification complète
./04_verification_systeme.sh
```

Ce script vérifie automatiquement :
- ✅ Java, Python, Lua, Love2D
- ✅ Pygame et autres dépendances Python
- ✅ Structure des répertoires
- ✅ Présence de tous les fichiers critiques
- ✅ Clavier personnalisé "borne"
- ✅ Configuration de l'autostart
- ✅ **Compilation du menu** (test réel)
- ✅ Présence et type de tous les jeux

Le script affiche un rapport détaillé avec :
- ✅ Éléments OK en vert
- ⚠️ Avertissements en jaune
- ❌ Erreurs en rouge

### 10.5 Test de l'autostart

```bash
sudo reboot
```

Au redémarrage :
1. Le système doit se connecter automatiquement
2. Un terminal doit s'ouvrir
3. Le menu de la borne doit apparaître après 10-15 secondes

Si ça ne fonctionne pas, voir section Dépannage.

---

## 11. Dépannage

### 11.1 La borne ne démarre pas automatiquement

**Vérification 1 : Autostart**

```bash
# Vérifier que le fichier existe
ls -la ~/.config/autostart/borne.desktop

# Vérifier le contenu
cat ~/.config/autostart/borne.desktop

# Vérifier les permissions
chmod +x ~/.config/autostart/borne.desktop
```

**Vérification 2 : Autologin**

```bash
# Vérifier la configuration de l'autologin
cat /etc/systemd/system/getty@tty1.service.d/autologin.conf
```

Devrait contenir quelque chose comme :
```
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin pi --noclear %I $TERM
```

**Vérification 3 : Session graphique**

```bash
# Vérifier que le serveur X démarre
ps aux | grep X

# Vérifier les logs X
cat ~/.xsession-errors
```

### 11.2 Erreur de compilation Java

**Erreur : "package mg2d does not exist"**

```bash
# Vérifier que MG2D est installé
ls -la ~/MG2D

# Vérifier le CLASSPATH
echo $CLASSPATH

# Définir le CLASSPATH
export CLASSPATH=".:$HOME/MG2D"

# Recompiler
cd ~/git/borne_arcade
./compilation.sh
```

**Erreur : "class file has wrong version"**

Vous avez probablement compilé avec Java 17 mais exécutez avec Java 8 (ou inverse).

```bash
# Vérifier la version de Java
java -version
javac -version

# Installer la même version partout
sudo apt install -y openjdk-17-jdk

# Définir JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-armhf/
export PATH=$JAVA_HOME/bin:$PATH

# Nettoyer et recompiler
cd ~/git/borne_arcade
./clean.sh
./compilation.sh
```

### 11.3 Problème d'affichage (mauvaise résolution)

**Solution 1 : raspi-config**

```bash
sudo raspi-config
# Display Options → Resolution → 1280×1024
```

**Solution 2 : Configuration manuelle dans /boot/config.txt**

```bash
sudo nano /boot/config.txt
```

Ajouter/modifier :
```
# Force résolution 1280×1024
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=32
disable_overscan=1
```

Modes HDMI courants :
- Mode 32 : 1280×1024 @ 60Hz
- Mode 35 : 1280×1024 @ 75Hz

```bash
# Redémarrer
sudo reboot
```

**Solution 3 : xrandr (temporaire)**

```bash
# Lister les résolutions disponibles
xrandr

# Forcer la résolution
xrandr --output HDMI-1 --mode 1280x1024
```

### 11.4 Problème de son

```bash
# Vérifier les périphériques audio
aplay -l

# Tester le son (fichier WAV de test)
speaker-test -t wav -c 2

# Vérifier le mixer
alsamixer

# Augmenter le volume si nécessaire (touche flèche haut)
# Sortir avec Échap

# Configuration ALSA par défaut
sudo nano /etc/asound.conf
```

Contenu recommandé :
```
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

### 11.5 Le clavier personnalisé ne fonctionne pas

**Vérification 1 : Fichier installé**

```bash
ls -la /usr/share/X11/xkb/symbols/borne
```

Si le fichier n'existe pas :
```bash
sudo cp ~/git/borne_arcade/borne /usr/share/X11/xkb/symbols/borne
```

**Vérification 2 : Syntaxe du fichier**

```bash
# Vérifier qu'il n'y a pas d'erreur de syntaxe
sudo xkbcomp /usr/share/X11/xkb/symbols/borne $DISPLAY 2>&1 | grep -i error
```

**Vérification 3 : Activation**

```bash
# Activer manuellement
setxkbmap borne

# Vérifier le layout actif
setxkbmap -query
```

**Si setxkbmap borne échoue :**

```bash
# Revenir au layout par défaut
setxkbmap fr

# Déboguer le fichier borne
sudo xkbcomp /usr/share/X11/xkb/symbols/borne $DISPLAY
```

### 11.6 Erreur "Permission denied" au lancement

```bash
cd ~/git/borne_arcade

# Rendre tous les scripts exécutables
chmod +x *.sh
chmod +x compilation.sh lancerBorne.sh clean.sh

# Vérifier
ls -la *.sh
```

### 11.7 Java ne trouve pas les classes

```bash
# Vérifier que vous êtes dans le bon répertoire
pwd
# Devrait afficher : /home/pi/git/borne_arcade

# Vérifier les fichiers .class
ls -la *.class

# Si absents, compiler
./compilation.sh

# Vérifier les erreurs
cat logs/compilation.log
```

### 11.8 Les jeux Python ne fonctionnent pas

```bash
# Vérifier Python
python3 --version

# Installer pip si absent
sudo apt install -y python3-pip

# Installer les dépendances du jeu
cd ~/git/borne_arcade/projet/ball-blast
pip3 install -r requirements.txt --user

# Tester le jeu
python3 src/main.py
```

### 11.9 Logs pour déboguer

```bash
# Logs de compilation
cat ~/git/borne_arcade/logs/compilation.log

# Logs système
journalctl -xe

# Logs X11
cat ~/.xsession-errors

# Logs de démarrage
dmesg | tail -50
```

---

## 12. Menu d'automatisation interactif

**🎯 OUTIL TOUT-EN-UN**

Pour simplifier toute la procédure, un menu interactif est disponible :

```bash
cd ~/git/borne_arcade/automatisation

# Rendre le script exécutable
chmod +x menu_migration.sh

# Lancer le menu
./menu_migration.sh
```

Le menu propose :

**PHASE 1 - ANCIEN SYSTÈME**
1. Sauvegarder l'ancien système
2. Voir le tutoriel de migration

**PHASE 2 - NOUVEAU SYSTÈME**
3. Restaurer la sauvegarde
4. Installer toutes les dépendances
5. Vérifier le système
6. Tester la compilation

**MAINTENANCE**
7. Mettre à jour le système
8. Voir l'état des jeux

Ce menu guide pas à pas à travers l'ensemble du processus de migration.

---

## 13. Optimisations post-installation

### 12.1 Désactiver les services inutiles

Pour accélérer le démarrage :

```bash
# Désactiver Bluetooth (si non utilisé)
sudo systemctl disable bluetooth.service

# Désactiver le WiFi (si Ethernet câblé)
sudo systemctl disable wpa_supplicant.service

# Désactiver les mises à jour automatiques (pour stabilité)
sudo systemctl disable apt-daily.timer
sudo systemctl disable apt-daily-upgrade.timer
```

### 12.2 Augmenter la mémoire GPU

Pour de meilleures performances graphiques :

```bash
sudo nano /boot/config.txt
```

Modifier :
```
gpu_mem=256
```

### 12.3 Overclock (optionnel, attention à la chaleur)

```bash
sudo nano /boot/config.txt
```

Pour Raspberry Pi 3 :
```
# Overclock modéré
arm_freq=1350
core_freq=500
sdram_freq=500
over_voltage=2

# Température max avant throttling
temp_limit=75
```

⚠️ **Attention :** L'overclock peut rendre le système instable et diminuer la durée de vie. Utilisez un dissipateur thermique et testez la stabilité.

### 12.4 Configuration de la mémoire swap

```bash
# Désactiver le swap (optionnel, pour prolonger la vie de la SD)
sudo systemctl disable dphys-swapfile.service
```

### 12.5 Créer un script de mise à jour

```bash
nano ~/update_borne.sh
```

Contenu :
```bash
#!/bin/bash

echo "=== Mise à jour de la borne d'arcade ==="

# Mise à jour du système
echo "[1/4] Mise à jour du système..."
sudo apt update
sudo apt upgrade -y

# Mise à jour de MG2D
echo "[2/4] Mise à jour de MG2D..."
cd ~/MG2D
git pull

# Mise à jour de borne_arcade
echo "[3/4] Mise à jour de borne_arcade..."
cd ~/git/borne_arcade
git pull

# Recompilation
echo "[4/4] Recompilation..."
./compilation.sh

echo "✓ Mise à jour terminée !"
```

```bash
chmod +x ~/update_borne.sh
```

---

## 14. Checklist finale

Avant de considérer la migration terminée, vérifiez :

- [ ] Le système démarre automatiquement
- [ ] L'utilisateur se connecte automatiquement
- [ ] Le menu de la borne se lance après 15 secondes
- [ ] Les joysticks et boutons sont reconnus correctement
- [ ] Tous les jeux se lancent sans erreur
- [ ] Les highscores sont restaurés
- [ ] Le son fonctionne
- [ ] La résolution d'écran est correcte (1280×1024)
- [ ] Le système s'éteint proprement après 30 secondes de fermeture du menu
- [ ] Vous avez une sauvegarde de la nouvelle configuration

---

## 15. Sauvegarde post-migration

Une fois la migration réussie et testée, créez une image de sauvegarde complète :

```bash
# Sur le Raspberry Pi, éteindre proprement
sudo shutdown -h now

# Sur votre PC, créer une image de la carte SD
sudo dd if=/dev/sdb of=borne_arcade_rbpy3_backup.img bs=4M status=progress

# Compresser l'image
gzip borne_arcade_rbpy3_backup.img

# Vous obtenez : borne_arcade_rbpy3_backup.img.gz
```

Cette image pourra être restaurée en cas de problème.

---

## 16. Conclusion

Vous avez maintenant migré votre borne d'arcade de Rasbian 2017 vers RBpy3-RBPyOS ! 🎉

**Prochaines étapes suggérées :**

1. Tester tous les jeux individuellement
2. Jouer plusieurs parties pour valider la stabilité
3. Noter les éventuels bugs ou améliorations
4. Documenter les différences entre l'ancien et le nouveau système
5. Envisager des améliorations (nouveaux jeux, meilleurs graphismes, etc.)

**Ressources supplémentaires :**

- Documentation Raspberry Pi : https://www.raspberrypi.com/documentation/
- Forum Raspberry Pi : https://forums.raspberrypi.com/
- Dépôt MG2D : https://github.com/synave/MG2D

---

**Auteur :** Guide de migration créé le 12 février 2026  
**Version :** 1.0  
**Licence :** MIT / Éducatif

---

## 17. Scripts d'automatisation disponibles

### Vue d'ensemble

Tous les scripts d'automatisation sont dans [`automatisation/`](automatisation/) :

| Script | Phase | Description |
|--------|-------|-------------|
| `menu_migration.sh` | 🎯 Tout-en-un | Menu interactif guidé |
| `01_backup_ancien_systeme.sh` | 📦 Ancien système | Sauvegarde complète automatique |
| `02_restauration_nouveau_systeme.sh` | 📥 Nouveau système | Restauration automatique |
| `03_install_dependances_complete.sh` | ⚙️ Installation | Toutes les dépendances |
| `04_verification_systeme.sh` | ✅ Vérification | Test complet du système |
| `install_all.sh` | 🔄 Maintenance | Mise à jour du système |
| `install.sh` | 🔄 Maintenance | Vérification des dépendances |

### Usage recommandé

**Sur l'ancien système :**
```bash
cd ~/git/borne_arcade/automatisation
./01_backup_ancien_systeme.sh
# Copier l'archive créée sur clé USB ou PC
```

**Sur le nouveau système :**
```bash
# Copier l'archive de sauvegarde
# Copier ou cloner le projet
cd ~/git/borne_arcade/automatisation

# Option simple : menu guidé
./menu_migration.sh

# Option manuelle : scripts séquentiels
./02_restauration_nouveau_systeme.sh
./03_install_dependances_complete.sh
./04_verification_systeme.sh
```

### Documentation complète

Consultez [`automatisation/README.md`](automatisation/README.md) pour :
- Guide détaillé de chaque script
- Exemples d'utilisation
- Résolution de problèmes
- Structure après migration

---

## 18. Notes spécifiques à RBpy3-RBPyOS

> ⚠️ **Note importante :** RBpy3-RBPyOS n'est pas un système d'exploitation officiellement documenté dans mes bases en février 2026. 
> 
> Si "RBpy3-RBPyOS" désigne un OS personnalisé ou une distribution spécifique à votre institution, vous devrez adapter ce guide avec :
> 
> - L'URL de téléchargement officielle de l'image
> - Les spécificités de configuration propres à cette distribution
> - Les outils préinstallés (ou manquants)
> - La documentation officielle du système
>
> **Alternatives courantes :**
> - **Raspberry Pi OS (ex-Raspbian)** : Distribution officielle
> - **Ubuntu Server for Raspberry Pi** : Ubuntu optimisé
> - **RetroPie** : Pour émulation et jeux retro
> - **Lakka** : OS léger pour gaming
>
> Si vous utilisez une distribution standard, remplacez simplement l'étape de téléchargement par l'image appropriée.

---

## Annexe A : Jeux de la borne

### Liste des jeux installés

| Jeu | Type | Langage | Dépendances |
|-----|------|---------|-------------|
| **Columns** | Puzzle | ☕ Java | MG2D |
| **CursedWare** | Mini-jeux | 🌙 Lua | Love2D |
| **DinoRail** | Action | ☕ Java | MG2D |
| **InitialDrift** | Course | ☕ Java | MG2D |
| **JavaSpace** | Shoot'em up | ☕ Java | MG2D |
| **Kowasu_Renga** | Casse-briques | ☕ Java | MG2D |
| **Minesweeper** | Puzzle | ☕ Java | MG2D |
| **OsuTile** | Rythme | ☕ Java | MG2D |
| **PianoTile** | Rythme | 🐍 Python | Pygame |
| **Pong** | Arcade | ☕ Java | MG2D |
| **Puissance_X** | Stratégie | ☕ Java | MG2D |
| **Snake_Eater** | Arcade | ☕ Java | MG2D |
| **TronGame** | Action | 🐍 Python | Pygame |
| **ball-blast** | Action | 🐍 Python | Pygame |

### Dépendances par type

**Jeux Java (☕)** - Majorité
- OpenJDK 17 ou supérieur
- MG2D (bibliothèque graphique)
- Bibliothèques X11, audio

**Jeux Python (🐍)** - 3 jeux
- Python 3.7+ (certains scripts spécifient python3.7)
- Pygame >= 2.5.0
- Voir `requirements.txt` dans chaque dossier

**Jeux Lua (🌙)** - 1 jeu
- Lua 5.3
- Love2D (framework de jeu)

### Highscores

Chaque jeu a son propre fichier `highscore` dans son répertoire.
Les highscores sont sauvegardés et restaurés lors de la migration.

---

## Annexe B : Structure du fichier clavier "borne"

Le fichier [`borne_arcade/borne`](borne_arcade/borne) est un fichier de configuration XKB (X Keyboard) qui mappe les touches physiques de la borne d'arcade vers des touches clavier standard.

### Extrait du fichier

```ini
default  partial alphanumeric_keys
xkb_symbols "basic" {
    include "latin"
    name[Group1]="French Borne";
    
    # Mappings personnalisés pour la borne
    key <AE01>  { [         f,  ampersand,  onesuperior,   exclamdown ] };
    key <AE02>  { [         g,     eacute,   asciitilde,    oneeighth ] };
    key <AE03>  { [         h,   quotedbl,   numbersign,     sterling ] };
    key <AE04>  { [         r, apostrophe,    braceleft,       dollar ] };
    key <AE05>  { [         t,  parenleft,  bracketleft, threeeighths ] };
    key <AE06>  { [         y,      minus,          bar,  fiveeighths ] };
    
    # Joysticks
    key   <UP> {	[  Up			]	};
    key   <DOWN> {	[  Down			]	};
    # ...
}
```

**Installation :**
```bash
sudo cp borne /usr/share/X11/xkb/symbols/borne
setxkbmap borne
```

---

## Annexe C : Correspondance des touches de la borne

| Contrôle | Joueur 1 | Joueur 2 |
|----------|----------|----------|
| **Joystick** |
| Haut | ↑ | O |
| Bas | ↓ | L |
| Gauche | ← | K |
| Droite | → | M |
| **Boutons** |
| Bouton 1 | R | A |
| Bouton 2 | T | Z |
| Bouton 3 | Y | E |
| Bouton 4 | F | Q |
| Bouton 5 | G | S |
| Bouton 6 | H | D |

---

## Annexe D : Structure du projet après migration

```
/home/pi/
├── MG2D/                           # Bibliothèque graphique
├── git/
│   └── borne_arcade/               # Projet principal
│       ├── borne                   # Fichier de mapping clavier
│       ├── borne.desktop           # Autostart
│       ├── lancerBorne.sh          # Script de lancement
│       ├── compilation.sh          # Script de compilation
│       ├── clean.sh                # Nettoyage
│       ├── Main.java               # Menu principal
│       ├── automatisation/
│       │   ├── install.sh          # Installation dépendances
│       │   └── install_all.sh      # Mise à jour système
│       ├── projet/                 # Tous les jeux
│       │   ├── Columns/
│       │   ├── CursedWare/
│       │   ├── DinoRail/
│       │   └── ...
│       └── logs/                   # Logs de compilation
└── .config/
    └── autostart/
        └── borne.desktop           # Copie pour autostart
```

---

**Fin du tutoriel** ✅
