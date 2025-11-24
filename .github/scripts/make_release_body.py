import os
from pathlib import Path
from deep_translator import GoogleTranslator
import re

# Read raw commits
p=Path("/tmp/commits_raw.txt")
if not p.exists():
    commits = []
else:
    commits = [l.strip() for l in p.read_text(encoding='utf-8').splitlines() if l.strip()]

if not commits:
    fr_text = "Mise à jour automatique."
else:
    filtered_commits = []
    for commit in commits:
        if commit.startswith("feat") or commit.startswith("fix"):
            # Replace prefix with a dash and a space
            formatted_commit = re.sub(r'^(feat|fix)(\(.+?\))?:\s*', '- ', commit)
            filtered_commits.append(formatted_commit)
    
    if not filtered_commits:
        fr_text = "Mise à jour de maintenance."
    else:
        fr_text = "\n".join(filtered_commits)

# translate to English and Spanish using GoogleTranslator (web)
try:
    en_text = GoogleTranslator(source='auto', target='en').translate(fr_text)
except Exception as e:
    en_text = fr_text  # fallback to FR
try:
    es_text = GoogleTranslator(source='auto', target='es').translate(fr_text)
except Exception as e:
    es_text = fr_text

# Build release body with required tags
body = "<fr-FR>\n" + fr_text + "\n</fr-FR>\n<en-US>\n" + en_text + "\n</en-US>\n<es-ES>\n" + es_text + "\n</es-ES>"

# Save to a file for later steps
outp="/tmp/release_body.txt"
Path(outp).write_text(body, encoding='utf-8')