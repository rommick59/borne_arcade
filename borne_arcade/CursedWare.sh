#!/bin/bash

# Trouve la racine du projet (répertoire contenant ce script) pour rester robuste
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$ROOT_DIR/projet/CursedWare" || exit 1
"$ROOT_DIR/love-11.5/src/love" .
