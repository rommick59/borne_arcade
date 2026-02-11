#!/bin/bash

echo "===== Vérification des dépendances système ====="

# Fonction pour comparer les versions
version_greater_equal() {
    # Retourne 0 si $1 >= $2
    printf '%s\n%s\n' "$1" "$2" | sort -V -C
}

# Détecte l'architecture du Pi
ARCH=$(dpkg --print-architecture)
echo "Architecture détectée : $ARCH"

# --- Vérification Java ---
if command -v java >/dev/null 2>&1; then
    CURRENT_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo "Java est installé : version $CURRENT_VERSION"

    # Récupérer la dernière version LTS (Java 17) via Temurin
    LATEST_VERSION=$(curl -s https://api.adoptium.net/v3/info/available_releases | grep -oP '(?<="most_recent_feature_release":)[0-9]+')
    
    if version_greater_equal "$CURRENT_VERSION" "$LATEST_VERSION"; then
        echo "Java est déjà à jour (>= $LATEST_VERSION)"
    else
        read -p "Une version plus récente de Java est disponible ($LATEST_VERSION). Veux-tu la mettre à jour ? [y/N] " RESP
        if [[ "$RESP" =~ ^[Yy]$ ]]; then
            echo "Mise à jour de Java..."
            sudo apt update
            sudo apt install -y wget gnupg software-properties-common
            wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo gpg --dearmor -o /usr/share/keyrings/adoptium.gpg
            echo "deb [signed-by=/usr/share/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
            sudo apt update
            if [[ "$ARCH" == "arm64" ]]; then
                sudo apt install -y temurin-17-jdk:arm64
            else
                sudo apt install -y temurin-17-jdk:armhf
            fi
            echo "Java mis à jour !"
        fi
    fi
else
    echo "Java non trouvé. Installation de la dernière version stable..."
    sudo apt update
    sudo apt install -y wget gnupg software-properties-common
    wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo gpg --dearmor -o /usr/share/keyrings/adoptium.gpg
    echo "deb [signed-by=/usr/share/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
    sudo apt update
    if [[ "$ARCH" == "arm64" ]]; then
        sudo apt install -y temurin-17-jdk:arm64
    else
        sudo apt install -y temurin-17-jdk:armhf
    fi
    echo "Java installé !"
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
