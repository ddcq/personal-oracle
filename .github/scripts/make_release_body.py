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
    # Commits are originally in English
    en_text = "Automatic update."
else:
    filtered_commits = []
    for commit in commits:
        if commit.startswith("feat") or commit.startswith("fix"):
            # Replace prefix with a dash and a space
            formatted_commit = re.sub(r'^(feat|fix)(\(.+?\))?:\s*', '- ', commit)
            filtered_commits.append(formatted_commit)
    
    if not filtered_commits:
        en_text = "Maintenance update."
    else:
        en_text = "\n".join(filtered_commits)

# translate to French and Spanish using GoogleTranslator (web)
try:
    fr_text = GoogleTranslator(source='en', target='fr').translate(en_text)
except Exception as e:
    fr_text = en_text  # fallback to EN
try:
    es_text = GoogleTranslator(source='en', target='es').translate(en_text)
except Exception as e:
    es_text = en_text # fallback to EN

# Build release body with required tags
body = "<fr-FR>\n" + fr_text + "\n</fr-FR>\n<en-US>\n" + en_text + "\n</en-US>\n<es-ES>\n" + es_text + "\n</es-ES>"

# Save to a file for later steps
outp="/tmp/release_body.txt"
Path(outp).write_text(body, encoding='utf-8')