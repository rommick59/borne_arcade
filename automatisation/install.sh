#!/bin/bash

set -e

echo "===== Vérification des dépendances système ====="

# Détecte l'architecture du Pi
ARCH=$(dpkg --print-architecture)
echo "Architecture détectée : $ARCH"

# ==========================================================
# -------------------- JAVA SECTION ------------------------
# ==========================================================

if command -v java >/dev/null 2>&1; then
    CURRENT_JAVA=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo "Java déjà installé : version $CURRENT_JAVA"
else
    echo "Java non trouvé. Installation via apt..."
    sudo apt update
    sudo apt install -y default-jdk
    INSTALLED_JAVA=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo "Java installé : version $INSTALLED_JAVA"
fi

# ==========================================================
# ------------------- PYTHON SECTION -----------------------
# ==========================================================

# Récupère la dernière version stable de Python depuis python.org
echo ""
echo "===== Vérification de la version Python ====="

LATEST_PYTHON=$(curl -s https://www.python.org/ftp/python/ \
    | grep -oP '(?<=href=")[0-9]+\.[0-9]+\.[0-9]+(?=/)' \
    | sort -V \
    | tail -1)

if [ -z "$LATEST_PYTHON" ]; then
    echo "Impossible de récupérer la dernière version Python. Abandon."
    exit 1
fi

echo "Dernière version Python disponible : $LATEST_PYTHON"

# Vérifie la version Python actuellement installée
if command -v python3 >/dev/null 2>&1; then
    CURRENT_PYTHON=$(python3 --version 2>&1 | awk '{print $2}')
    echo "Python3 actuellement installé : $CURRENT_PYTHON"

    if [ "$CURRENT_PYTHON" = "$LATEST_PYTHON" ]; then
        echo "Python3 est déjà à jour."
    else
        read -p "Mise à jour Python $CURRENT_PYTHON -> $LATEST_PYTHON ? [y/N] " RESP
        if [[ "$RESP" =~ ^[Yy]$ ]]; then
            COMPILE_PYTHON=true
        else
            echo "Mise à jour Python ignorée."
            COMPILE_PYTHON=false
        fi
    fi
else
    echo "Python3 non trouvé. Installation depuis les sources..."
    COMPILE_PYTHON=true
fi

if [ "${COMPILE_PYTHON:-false}" = true ]; then
    echo ""
    echo "===== Compilation de Python $LATEST_PYTHON depuis les sources ====="

    # Dépendances nécessaires à la compilation
    sudo apt update
    sudo apt install -y \
        build-essential \
        libssl-dev \
        libffi-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libncurses5-dev \
        libgdbm-dev \
        liblzma-dev \
        uuid-dev \
        wget

    PYTHON_TAR="Python-${LATEST_PYTHON}.tgz"
    PYTHON_URL="https://www.python.org/ftp/python/${LATEST_PYTHON}/${PYTHON_TAR}"
    TEMP_DIR="/tmp/python_build"

    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"

    echo "Téléchargement de $PYTHON_URL ..."
    wget -q --show-progress "$PYTHON_URL"

    echo "Extraction..."
    tar -xf "$PYTHON_TAR"
    cd "Python-${LATEST_PYTHON}"

    echo "Configuration... (peut prendre quelques minutes sur Raspberry Pi)"
    ./configure --enable-optimizations --prefix=/usr/local

    echo "Compilation... (peut prendre 10-20 min sur Raspberry Pi)"
    make -j$(nproc)

    echo "Installation..."
    sudo make altinstall

    # Crée un lien symbolique vers python3
    PYTHON_SHORT=$(echo "$LATEST_PYTHON" | cut -d. -f1,2)
    sudo ln -sf "/usr/local/bin/python${PYTHON_SHORT}" /usr/local/bin/python3
    sudo ln -sf "/usr/local/bin/pip${PYTHON_SHORT}" /usr/local/bin/pip3

    echo "Nettoyage..."
    cd /
    rm -rf "$TEMP_DIR"

    echo "Python $LATEST_PYTHON installé avec succès !"
    python3 --version
fi

# ==========================================================
# -------------------- MG2D SECTION ------------------------
# ==========================================================

echo ""
echo "===== INSTALLATION MG2D ====="

REPO_URL="https://github.com/synave/MG2D.git"
TEMP_DIR="/tmp/MG2D_install"
TARGET_DIR="$HOME/MG2D"

if [ -d "$TARGET_DIR" ]; then
    echo "MG2D est déjà présent dans $TARGET_DIR"
else
    if ! command -v git >/dev/null 2>&1; then
        echo "git non trouvé. Installation..."
        sudo apt install -y git
    fi

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

    echo "MG2D installé avec succès dans $TARGET_DIR"
fi

echo ""
echo "===== SCRIPT TERMINÉ ====="
echo "Java    : $(java -version 2>&1 | awk -F '"' '/version/ {print $2}')"
echo "Python3 : $(python3 --version)"