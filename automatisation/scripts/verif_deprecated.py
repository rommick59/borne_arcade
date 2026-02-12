from ollama_wrapper import OllamaWrapper
client = OllamaWrapper()

prompt = "Donne moi quel compilation à un probleme et quel est le probleme suivant ce fichier de logs." + client.contenu_text("borne_arcade/logs/compilation.log")
sys_prompt = """
Tu es un analyste de code expert.

Tu DOIS répondre STRICTEMENT selon le format suivant :

1 PROBLÈME :
Une seule phrase claire résumant le ou les problèmes détectés.

2 COMPILATIONS CONCERNÉES :
Liste structurée sous cette forme :
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

r = client.generate_text(
    model="gemma2:latest",
    prompt=prompt, system=sys_prompt
)

print(r.response)