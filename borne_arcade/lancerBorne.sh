#!/bin/bash

print_section() {
    echo ""
    echo "=================================================="
    echo " $1"
    echo "=================================================="
}

# Permet d'exécuter ce script depuis n'importe quel dossier.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

setxkbmap borne

print_section "Nettoyage des répertoires. Veuillez patienter"
./clean.sh
./compilation.sh

print_section "Lancement du  Menu. Veuillez patienter"

java -cp "$SCRIPT_DIR:$HOME" Main
./clean.sh

#for i in {30..1}
#do
#    echo Extinction de la borne dans $i secondes
#    sleep 1
#done

#sudo halt