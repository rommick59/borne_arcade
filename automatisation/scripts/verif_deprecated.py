#!/usr/bin/env python3

from ollama_wrapper import OllamaWrapper
import os

client = OllamaWrapper()

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
log_path = os.path.join(BASE_DIR, "..", "..",
                        "borne_arcade", "logs", "compilation.log")
log_path = os.path.abspath(log_path)

# Vérification de l'existence du fichier de logs
if not os.path.exists(log_path):
    print(f"⚠️  Le fichier de logs n'existe pas : {log_path}")
    print("Aucune analyse à effectuer.")

    # Création du rapport indiquant l'absence de logs
    output_path = os.path.join(
        BASE_DIR, "..", "..", "borne_arcade", "logs", "deprecated.md")
    output_path = os.path.abspath(output_path)

    with open(output_path, "w", encoding="utf-8") as f:
        f.write("# Rapport d'analyse\n\n")
        f.write("**Statut** : Aucun fichier de logs disponible\n\n")
        f.write(
            f"Le fichier de logs attendu n'a pas été trouvé :\n`{log_path}`\n")

    print(f"Rapport généré dans : {output_path}")
else:
    prompt = "Donne moi quel compilation à un probleme et quel est le probleme suivant ce fichier de logs." + \
        client.contenu_text(log_path)
    sys_prompt = """
    Tu es un analyste de code expert.

    Tu DOIS répondre STRICTEMENT selon le format suivant :

    1 PROBLÈME :
    Une seule phrase claire résumant le ou les problèmes détectés.
    Le fichier de warnings_errors est structuré de facon [NomDuJeu] Fichier:Ligne: warning: [deprecation] Description


    2 COMPILATIONS CONCERNÉES :
    Liste structurée sous cette forme :
    - Nom du jeu : 
    - NomFichier.java :
    - Ligne XX : description courte
    - Ligne XX : description courte

    3 SOLUTION :
    Explication claire et concise de la correction à apporter.

    4 EXEMPLE DE CORRECTION :
    Bloc de code AVANT puis bloc de code APRÈS.

    Tu ne dois rien ajouter en dehors de ces 4 sections.
    Réponse claire, structurée, sans texte inutile.
    """

    print("===== Analyse des deprecated =====")

    r = client.generate_text(
        model="qwen3:8b",
        prompt=prompt, system=sys_prompt
    )

    # Chemin du fichier de sortie
    output_path = os.path.join(
        BASE_DIR, "..", "..", "borne_arcade", "logs", "deprecated.md")
    output_path = os.path.abspath(output_path)

    # Écriture (crée ou écrase le fichier)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(r.response)

    print(f"Rapport généré dans : {output_path}")
