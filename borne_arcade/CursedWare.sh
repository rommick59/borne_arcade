#!/bin/bash

# Trouve la racine du projet (répertoire contenant ce script) pour rester robuste
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
GAME_DIR="$ROOT_DIR/projet/CursedWare"
LOCAL_LOVE="$ROOT_DIR/love-11.5/src/love"

cd "$GAME_DIR" || exit 1

# Priorite a Love2D systeme (meilleur support multi-architecture sur borne).
if command -v love >/dev/null 2>&1; then
	love .
	exit $?
fi

# Fallback sur le runtime local si present.
if [[ -x "$LOCAL_LOVE" ]]; then
	"$LOCAL_LOVE" .
	exit $?
fi

echo "Erreur: Love2D introuvable pour lancer CursedWare." >&2
echo "Installez le paquet 'love' (ex: sudo apt install -y love)." >&2
exit 1
