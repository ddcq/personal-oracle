import os
from pathlib import Path
from deep_translator import GoogleTranslator

# Read formatted commits
p=Path("/tmp/commits_formatted.txt")
if not p.exists():
    commits = []
else:
    commits = [l.strip() for l in p.read_text(encoding='utf-8').splitlines() if l.strip()]

if not commits:
    fr_text = "Mise à jour automatique."
else:
    # Build a short summary from commit messages:
    # we will join them with space but try to stay below 300 chars later.
    fr_text = " ".join(commits)
# Ensure <= 300 characters (cut at word boundary)
def truncate(s, n=300):
    if len(s)<=n:
        return s
    truncated = s[:n]
    # cut back to last space to avoid mid-word
    last_space = truncated.rfind(" ")
    if last_space>0:
        truncated = truncated[:last_space]
    return truncated

fr_text = truncate(fr_text,300)

# translate to English and Spanish using GoogleTranslator (web)
try:
    en_text = GoogleTranslator(source='auto', target='en').translate(fr_text)
except Exception as e:
    en_text = fr_text  # fallback to FR
try:
    es_text = GoogleTranslator(source='auto', target='es').translate(fr_text)
except Exception as e:
    es_text = fr_text

en_text = truncate(en_text,300)
es_text = truncate(es_text,300)

# Build release body with required tags
body = "<fr-FR>\n" + fr_text + "\n</fr-FR>\n<en-US>\n" + en_text + "\n</en-US>\n<es-ES>\n" + es_text + "\n</es-ES>"

# Print to stdout (GitHub Actions will capture)
print(body)

# Save to a file for later steps
outp="/tmp/release_body.txt"
Path(outp).write_text(body, encoding='utf-8')
print("SAVED_RELEASE_BODY_PATH="+outp)
