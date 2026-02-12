#!/bin/bash

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