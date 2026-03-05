#!/bin/bash

setxkbmap borne

echo "Setup des touches de la borne"
# === 0. Copier le fichier de configuration clavier ===
sudo cp ~/borne_arcade/borne /usr/share/X11/xkb/symbols/borne


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