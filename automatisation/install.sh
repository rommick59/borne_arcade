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

echo ""
echo "===== Vérification de la version Python ====="

# Pour Raspberry Pi 32-bit, Python 3.11 est la dernière version recommandée
# Python 3.12+ nécessite des ajustements pour l'architecture 32-bit
if [ "$ARCH" = "i386" ] || [ "$ARCH" = "armhf" ]; then
    echo "Architecture 32-bit détectée, limitation à Python 3.11.x"
    LATEST_PYTHON="3.11.11"  # Dernière version 3.11 stable
else
    # Pour 64-bit, on peut aller plus haut
    LATEST_PYTHON="3.13.1"
fi

echo "Version Python cible : $LATEST_PYTHON"

# Vérifie la version Python actuellement installée
if command -v python3 >/dev/null 2>&1; then
    CURRENT_PYTHON=$(python3 --version 2>&1 | awk '{print $2}')
    echo "Python3 actuellement installé : $CURRENT_PYTHON"

    # Compare les versions (simple comparaison)
    CURRENT_MAJOR=$(echo "$CURRENT_PYTHON" | cut -d. -f1)
    CURRENT_MINOR=$(echo "$CURRENT_PYTHON" | cut -d. -f2)
    TARGET_MAJOR=$(echo "$LATEST_PYTHON" | cut -d. -f1)
    TARGET_MINOR=$(echo "$LATEST_PYTHON" | cut -d. -f2)

    if [ "$CURRENT_MAJOR" -gt "$TARGET_MAJOR" ] || \
       ([ "$CURRENT_MAJOR" -eq "$TARGET_MAJOR" ] && [ "$CURRENT_MINOR" -ge "$TARGET_MINOR" ]); then
        echo "Python3 est suffisamment récent."
        COMPILE_PYTHON=false
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
    echo "⚠️  ATTENTION : Cette opération peut prendre 30-60 minutes sur Raspberry Pi"
    
    read -p "Continuer ? [y/N] " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        echo "Installation Python annulée."
        COMPILE_PYTHON=false
    fi
fi

if [ "${COMPILE_PYTHON:-false}" = true ]; then
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
        wget \
        tk-dev \
        libgdbm-compat-dev

    PYTHON_TAR="Python-${LATEST_PYTHON}.tgz"
    PYTHON_URL="https://www.python.org/ftp/python/${LATEST_PYTHON}/${PYTHON_TAR}"
    TEMP_DIR="/tmp/python_build"

    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"

    echo "Téléchargement de $PYTHON_URL ..."
    
    # Téléchargement avec timeout et retry
    if ! wget --timeout=30 --tries=3 --show-progress "$PYTHON_URL"; then
        echo "❌ Erreur lors du téléchargement de Python $LATEST_PYTHON"
        echo "URL tentée : $PYTHON_URL"
        echo ""
        echo "Vérifiez que cette version existe sur python.org/ftp/python/"
        cd /
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    echo "Extraction..."
    tar -xf "$PYTHON_TAR"
    cd "Python-${LATEST_PYTHON}"

    echo "Configuration... (peut prendre quelques minutes sur Raspberry Pi)"
    # Pour les Pi 32-bit, on évite --enable-optimizations qui est très lent
    if [ "$ARCH" = "i386" ] || [ "$ARCH" = "armhf" ]; then
        ./configure --prefix=/usr/local
    else
    ./configure --enable-optimizations --prefix=/usr/local
    fi

    echo "Compilation... (peut prendre 30-60 min sur Raspberry Pi)"
    echo "Utilisation de $(nproc) cœurs CPU"
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
# --------------------- LUA SECTION ------------------------
# ==========================================================

echo ""
echo "===== VÉRIFICATION LUA ====="

if command -v lua >/dev/null 2>&1; then
    CURRENT_LUA=$(lua -v 2>&1 | awk '{print $2}')
    echo "Lua déjà installé : version $CURRENT_LUA"
else
    echo "Lua non trouvé. Installation via apt..."
    sudo apt update
    sudo apt install -y lua5.4
    CURRENT_LUA=$(lua -v 2>&1 | awk '{print $2}')
    echo "Lua installé : version $CURRENT_LUA"
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
echo "Lua     : $(lua -v 2>&1 | awk '{print $2}')"
