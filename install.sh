#!/bin/bash

echo "===== Vérification des dépendances système ====="

# --- Vérification Java ---
if command -v java >/dev/null 2>&1; then
    echo "Java est déjà installé : $(java -version 2>&1 | head -n 1)"
else
    echo "Java non trouvé. Installation..."
    sudo apt update
    sudo apt install -y default-jdk
fi

# --- Vérification Python3 ---
if command -v python3 >/dev/null 2>&1; then
    echo "Python3 est déjà installé : $(python3 --version)"
else
    echo "Python3 non trouvé. Installation..."
    sudo apt update
    sudo apt install -y python3 python3-pip
fi

echo "===== INSTALLATION MG2D ====="

# Définition variables
REPO_URL="https://github.com/synave/MG2D.git"
TEMP_DIR="/tmp/MG2D_install"
TARGET_DIR="$HOME/MG2D"

# Vérifier si MG2D est déjà installé
if [ -d "$TARGET_DIR" ]; then
    echo "MG2D est déjà présent dans $TARGET_DIR"
else
    echo "Clonage du dépôt..."
    rm -rf "$TEMP_DIR"
    git clone "$REPO_URL" "$TEMP_DIR"

    if [ ! -d "$TEMP_DIR/MG2D" ]; then
        echo "Erreur : dossier MG2D introuvable dans le repo."
        exit 1
    fi

    echo "Déplacement du dossier MG2D vers $HOME ..."
    mv "$TEMP_DIR/MG2D" "$TARGET_DIR"

    echo "Nettoyage..."
    rm -rf "$TEMP_DIR"

    echo "===== MG2D INSTALLÉ AVEC SUCCÈS ====="
fi

echo "===== SCRIPT TERMINÉ ====="
