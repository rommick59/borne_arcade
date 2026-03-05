#!/bin/bash

# === 0. Copier le fichier de configuration clavier ===
echo "Setup des touches de la borne"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
sudo cp $SCRIPT_DIR/borne /usr/share/X11/xkb/symbols/borne
# Créer le dossier autostart
mkdir -p $HOME/.config/autostart
cp $SCRIPT_DIR/borne.desktop $HOME/.config/autostart

setxkbmap borne

echo "nettoyage des répertoires"
echo "Veuillez patienter"
./clean.sh
./compilation.sh

echo "Lancement du  Menu"
echo "Veuillez patienter"

java -cp .:$HOME Main
./clean.sh

#for i in {30..1}
#do
#    echo Extinction de la borne dans $i secondes
#    sleep 1
#done

#sudo halt