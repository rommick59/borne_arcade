#!/bin/bash

print_section() {
    echo ""
    echo "=================================================="
    echo " $1"
    echo "=================================================="
}

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