#!/bin/bash
set -e

# ==============================
# UTILITAIRES
# ==============================

print_section() {
    echo ""
    echo "=================================================="
    echo " $1"
    echo "=================================================="
}

detect_arch() {
    ARCH=$(dpkg --print-architecture)
    echo "Architecture détectée : $ARCH"
}

# ==============================
# JAVA
# ==============================

install_java() {
    print_section "VÉRIFICATION JAVA"

    if command -v java >/dev/null 2>&1; then
        CURRENT_JAVA=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
        echo "Java déjà installé : version $CURRENT_JAVA"
    else
        echo "Java non trouvé. Installation..."
        sudo apt update
        sudo apt install -y default-jdk
        echo "Java installé : $(java -version 2>&1 | awk -F '"' '/version/ {print $2}')"
    fi
}

# ==============================
# PYTHON
# ==============================

get_target_python_version() {
    if [ "$ARCH" = "i386" ] || [ "$ARCH" = "armhf" ]; then
        LATEST_PYTHON="3.11.11"
    else
        LATEST_PYTHON="3.13.1"
    fi
}

check_python() {
    print_section "VÉRIFICATION PYTHON"

    get_target_python_version
    echo "Version cible : $LATEST_PYTHON"

    if command -v python3 >/dev/null 2>&1; then
        CURRENT_PYTHON=$(python3 --version | awk '{print $2}')
        echo "Python actuel : $CURRENT_PYTHON"
    else
        COMPILE_PYTHON=true
    fi
}

compile_python() {
    if [ "${COMPILE_PYTHON:-false}" != true ]; then
        return
    fi

    print_section "COMPILATION PYTHON"

    echo "⚠️  ATTENTION : Cette opération peut prendre 30-60 minutes sur Raspberry Pi"
    
    read -p "Continuer ? [y/N] " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        echo "Installation Python annulée."
        COMPILE_PYTHON=false
    fi

}

# ==============================
# LUA
# ==============================

install_lua() {
    print_section "VÉRIFICATION LUA"

    if command -v lua >/dev/null 2>&1; then
        echo "Lua installé : $(lua -v 2>&1 | awk '{print $2}')"
    else
        sudo apt update
        sudo apt install -y lua5.4
        echo "Lua installé : $(lua -v 2>&1 | awk '{print $2}')"
    fi
}

# ==============================
# MG2D
# ==============================

install_mg2d() {
    print_section "INSTALLATION MG2D"

    REPO_URL="https://github.com/synave/MG2D.git"
    TARGET_DIR="$HOME/MG2D"
    TEMP_DIR="/tmp/MG2D_install"

    if [ -d "$TARGET_DIR" ]; then
        echo "MG2D déjà présent."
        return
    fi

    if ! command -v git >/dev/null 2>&1; then
        sudo apt install -y git
    fi

    git clone "$REPO_URL" "$TEMP_DIR"
    mv "$TEMP_DIR/MG2D" "$TARGET_DIR"
    rm -rf "$TEMP_DIR"

    echo "MG2D installé."
}


# ==============================
# MAIN
# ==============================

main() {
    print_section "VÉRIFICATION DES DÉPENDANCES"

    detect_arch
    install_java
    check_python
    compile_python
    install_lua
    install_mg2d

    print_summary

    #!/bin/bash

    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

    chmod +x ./hooks/setup-hooks.sh
    ./hooks/setup-hooks.sh

    # === 1. Lancer la borne ===
    cd "$SCRIPT_DIR/../borne_arcade" || exit 1
    bash lancerBorne.sh

    # === 2. Revenir dans borne ===
    cd "$SCRIPT_DIR/.." || exit 1

    # === 3. Lancer la vérification Python ===
    python3 "$SCRIPT_DIR/scripts/manager.py"


}

print_summary() {
    print_section "SCRIPT TERMINÉ"
    echo "Java    : $(java -version 2>&1 | awk -F '"' '/version/ {print $2}')"
    echo "Python3 : $(python3 --version)"
    echo "Lua     : $(lua -v 2>&1 | awk '{print $2}')"
}

main
