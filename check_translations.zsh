#!/bin/zsh

# Couleurs pour la sortie
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
NC=$(tput sgr0) # Pas de couleur

# --- Configuration ---
# Dossier contenant les fichiers de langue
LANGS_DIR="assets/resources/langs"
# Fichiers de langue
EN_FILE="$LANGS_DIR/en-US.json"
FR_FILE="$LANGS_DIR/fr-FR.json"
# Dossier contenant le code source Dart
DART_DIR="lib"

# --- Vérifications initiales ---
if ! command -v jq &> /dev/null; then
    echo "${RED}ERREUR: 'jq' n'est pas installé. Veuillez l'installer (ex: brew install jq).${NC}"
    exit 1
fi

if [[ ! -f "$EN_FILE" || ! -f "$FR_FILE" ]]; then
    echo "${RED}ERREUR: Un ou plusieurs fichiers de traduction n'ont pas été trouvés.${NC}"
    echo "Vérifié: $EN_FILE"
    echo "Vérifié: $FR_FILE"
    exit 1
fi

# --- Création des fichiers temporaires ---
# Crée des fichiers temporaires pour stocker les listes de clés
DART_KEYS_FILE=$(mktemp)
EN_KEYS_FILE=$(mktemp)
FR_KEYS_FILE=$(mktemp)

# Assure que les fichiers temporaires sont supprimés à la fin du script
trap 'rm -f "$DART_KEYS_FILE" "$EN_KEYS_FILE" "$FR_KEYS_FILE"' EXIT

# --- Extraction des clés ---
echo "${BLUE}🔍 Extraction des clés...${NC}"

# 1. Extrait les clés du code Dart
# Cherche les chaînes de caractères suivies de ".tr" et nettoie le résultat
echo "   - Depuis les fichiers Dart (.tr)"
grep -rhEo "['\"][a-zA-Z0-9_.-]+['\"]\s*\.tr" "$DART_DIR" | sed -E "s/['\"]//g" | sed -E 's/\.tr$//' | sort -u > "$DART_KEYS_FILE"

# 2. Extrait les clés des fichiers JSON
# Utilise jq pour extraire récursivement tous les chemins vers des valeurs scalaires
echo "   - Depuis $EN_FILE"
jq -r 'paths(scalars) | join(".")' "$EN_FILE" | sort -u > "$EN_KEYS_FILE"
echo "   - Depuis $FR_FILE"
jq -r 'paths(scalars) | join(".")' "$FR_FILE" | sort -u > "$FR_KEYS_FILE"

DART_KEY_COUNT=$(wc -l < "$DART_KEYS_FILE")
EN_KEY_COUNT=$(wc -l < "$EN_KEYS_FILE")
FR_KEY_COUNT=$(wc -l < "$FR_KEYS_FILE")

echo "${GREEN}✅ Terminé!${NC} ($DART_KEY_COUNT clés dans le code, $EN_KEY_COUNT en anglais, $FR_KEY_COUNT en français)"

# --- Analyse et rapport ---
ANY_MISSING=false

# 1. Clés utilisées dans le code mais manquantes dans fr-FR.json
echo "\n${YELLOW}--- Clés manquantes dans fr-FR.json ---${NC}"
MISSING_FR=$(comm -23 "$DART_KEYS_FILE" "$FR_KEYS_FILE")
if [[ -n "$MISSING_FR" ]]; then
    ANY_MISSING=true
    echo "$MISSING_FR" | while read -r key; do echo "${RED}- $key${NC}"; done
else
    echo "${GREEN}Aucune clé manquante.${NC}"
fi

# 2. Clés utilisées dans le code mais manquantes dans en-US.json
echo "\n${YELLOW}--- Clés manquantes dans en-US.json ---${NC}"
MISSING_EN=$(comm -23 "$DART_KEYS_FILE" "$EN_KEYS_FILE")
if [[ -n "$MISSING_EN" ]]; then
    ANY_MISSING=true
    echo "$MISSING_EN" | while read -r key; do echo "${RED}- $key${NC}"; done
else
    echo "${GREEN}Aucune clé manquante.${NC}"
fi

# 3. Incohérences entre les fichiers de langue
echo "\n${YELLOW}--- Incohérences entre en-US.json et fr-FR.json ---${NC}"
INCONSISTENCY=false
# Clés dans EN mais pas dans FR
EN_NOT_FR=$(comm -23 "$EN_KEYS_FILE" "$FR_KEYS_FILE")
if [[ -n "$EN_NOT_FR" ]]; then
    INCONSISTENCY=true
    ANY_MISSING=true
    echo "${YELLOW}Clés présentes dans en-US.json mais absentes dans fr-FR.json:${NC}"
    echo "$EN_NOT_FR" | while read -r key; do echo "${RED}- $key${NC}"; done
fi

# Clés dans FR mais pas dans EN
FR_NOT_EN=$(comm -13 "$EN_KEYS_FILE" "$FR_KEYS_FILE")
if [[ -n "$FR_NOT_EN" ]]; then
    INCONSISTENCY=true
    ANY_MISSING=true
    echo "${YELLOW}Clés présentes dans fr-FR.json mais absentes dans en-US.json:${NC}"
    echo "$FR_NOT_EN" | while read -r key; do echo "${RED}- $key${NC}"; done
fi

if ! $INCONSISTENCY; then
    echo "${GREEN}Les deux fichiers de langue sont synchronisés.${NC}"
fi

# --- Résumé ---
echo "\n${BLUE}--- Résumé ---${NC}"
if $ANY_MISSING; then
    echo "${RED}Des problèmes de traduction ont été trouvés. Veuillez vérifier les listes ci-dessus.${NC}"
    exit 1
else
    echo "${GREEN}🎉 Parfait! Toutes les clés de traduction sont présentes et synchronisées.${NC}"
fi
