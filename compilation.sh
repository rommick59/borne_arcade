#!/bin/bash

echo "Compilation du menu de la borne d'arcade"
echo "Veuillez patienter"
cd MG2D
make
cd ..
cd projet


#PENSER A REMETTRE COMPILATION JEUX!!!
for i in *
do
    cd $i
    # Vérifier s'il y a des fichiers .java dans le dossier
    if ls *.java 1> /dev/null 2>&1; then
        echo "Compilation du jeu "$i
        echo "Veuillez patienter"
        javac -cp  *.java
    else
        echo "Pas de compilation nécessaire pour "$i" (projet Python ou autre)"
    fi
    cd ..
done

cd ..
