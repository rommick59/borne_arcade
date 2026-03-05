#!/bin/bash

print_section() {
    echo ""
    echo "=================================================="
    echo " $1"
    echo "=================================================="
}

# === 0. Copier le fichier de configuration clavier ===
print_section "Setup des touches de la borne"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
sudo cp $SCRIPT_DIR/borne /usr/share/X11/xkb/symbols/borne

# === 0.5. Setup lancement automatique
print_section "Setup du lancement automatique"
mkdir -p $HOME/.config/autostart
sudo cp $SCRIPT_DIR/borne.desktop $HOME/.config/autostart

setxkbmap borne

print_section "Nettoyage des répertoires. Veuillez patienter"
./clean.sh
./compilation.sh

print_section "Lancement du  Menu. Veuillez patienter"

java -cp .:$HOME Main
./clean.sh

#for i in {30..1}
#do
#    echo Extinction de la borne dans $i secondes
#    sleep 1
#done

#sudo halt