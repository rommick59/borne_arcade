# Babble Shot

Jeu **Bubble Shooter** en Python + Pygame, avec style visuel néon (dégradés, glow, particules, HUD moderne).

## Installation

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Lancer le jeu

```bash
python3 main.py
```

## Contrôles

- `←/→` : viser
- `'` : tirer
- `(` : démarrer
- `é` : rejouer
- `"` : quitter

### Saisie HighScore

- `←/→` : changer de case lettre
- `↑/↓` : changer la lettre sélectionnée
- `'` : confirmer le nom

## Gameplay

- Aligne 3 bulles (ou plus) de même couleur pour les faire exploser.
- Les bulles flottantes non connectées au haut tombent aussi.
- Toutes les `6` bulles tirées sans explosion majeure, une nouvelle ligne apparaît.
- Tu gagnes quand tout est vidé, et tu perds si les bulles atteignent la ligne rouge.
