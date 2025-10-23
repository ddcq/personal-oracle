#!/bin/zsh

# Script pour vérifier les clés de traduction manquantes
# Auteur: Assistant Claude
# Usage: ./check_translations.zsh

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Chemins des fichiers de traduction
FR_FILE="assets/resources/langs/fr-FR.json"
EN_FILE="assets/resources/langs/en-US.json"

# Fichiers temporaires
TEMP_DIR=$(mktemp -d)
FR_KEYS="$TEMP_DIR/fr_keys.txt"
EN_KEYS="$TEMP_DIR/en_keys.txt"
MISSING_FR="$TEMP_DIR/missing_fr.txt"
MISSING_EN="$TEMP_DIR/missing_en.txt"

# Fonction de nettoyage
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Vérification que les fichiers existent
check_files() {
    if [[ ! -f "$FR_FILE" ]]; then
        echo "${RED}Erreur: Fichier $FR_FILE introuvable${NC}"
        exit 1
    fi

    if [[ ! -f "$EN_FILE" ]]; then
        echo "${RED}Erreur: Fichier $EN_FILE introuvable${NC}"
        exit 1
    fi

    # Vérifier que jq est installé
    if ! command -v jq &> /dev/null; then
        echo "${RED}Erreur: jq n'est pas installé. Installez-le avec: brew install jq${NC}"
        exit 1
    fi
}

# Extraction et tri des clés
extract_keys() {
    echo "${BLUE}📝 Extraction des clés de traduction...${NC}"

    # Extraire les clés du fichier français et les trier
    jq -r 'keys[]' "$FR_FILE" | sort > "$FR_KEYS"
    FR_COUNT=$(wc -l < "$FR_KEYS" | tr -d ' ')

    # Extraire les clés du fichier anglais et les trier
    jq -r 'keys[]' "$EN_FILE" | sort > "$EN_KEYS"
    EN_COUNT=$(wc -l < "$EN_KEYS" | tr -d ' ')

    echo "${GREEN}✓ Clés françaises: $FR_COUNT${NC}"
    echo "${GREEN}✓ Clés anglaises: $EN_COUNT${NC}"
}

# Comparaison des clés
compare_keys() {
    echo "\n${BLUE}🔍 Comparaison des clés...${NC}"

    # Trouver les clés manquantes dans le fichier français
    comm -23 "$EN_KEYS" "$FR_KEYS" > "$MISSING_FR"
    MISSING_FR_COUNT=$(wc -l < "$MISSING_FR" | tr -d ' ')

    # Trouver les clés manquantes dans le fichier anglais
    comm -23 "$FR_KEYS" "$EN_KEYS" > "$MISSING_EN"
    MISSING_EN_COUNT=$(wc -l < "$MISSING_EN" | tr -d ' ')

    # Afficher les résultats
    display_results
}

# Affichage des résultats
display_results() {
    echo "\n${BLUE}📊 RAPPORT DE COMPARAISON${NC}"
    echo "=================================="

    if [[ $MISSING_FR_COUNT -eq 0 && $MISSING_EN_COUNT -eq 0 ]]; then
        echo "${GREEN}✅ Parfait! Toutes les clés sont présentes dans les deux fichiers.${NC}"
        return
    fi

    # Clés manquantes dans le fichier français
    if [[ $MISSING_FR_COUNT -gt 0 ]]; then
        echo "\n${RED}❌ Clés manquantes dans $FR_FILE ($MISSING_FR_COUNT):${NC}"
        echo "${RED}────────────────────────────────────────────────${NC}"
        while IFS= read -r key; do
            echo "  • $key"
        done < "$MISSING_FR"
    fi

    # Clés manquantes dans le fichier anglais
    if [[ $MISSING_EN_COUNT -gt 0 ]]; then
        echo "\n${RED}❌ Clés manquantes dans $EN_FILE ($MISSING_EN_COUNT):${NC}"
        echo "${RED}────────────────────────────────────────────────${NC}"
        while IFS= read -r key; do
            echo "  • $key"
        done < "$MISSING_EN"
    fi

    # Résumé
    echo "\n${YELLOW}📋 RÉSUMÉ:${NC}"
    echo "  • Total clés FR: $FR_COUNT"
    echo "  • Total clés EN: $EN_COUNT"
    echo "  • Manquantes FR: $MISSING_FR_COUNT"
    echo "  • Manquantes EN: $MISSING_EN_COUNT"

    if [[ $MISSING_FR_COUNT -gt 0 || $MISSING_EN_COUNT -gt 0 ]]; then
        echo "\n${YELLOW}💡 Actions recommandées:${NC}"
        if [[ $MISSING_FR_COUNT -gt 0 ]]; then
            echo "  1. Ajoutez les clés manquantes au fichier français"
        fi
        if [[ $MISSING_EN_COUNT -gt 0 ]]; then
            echo "  2. Ajoutez les clés manquantes au fichier anglais"
        fi
        echo "  3. Relancez ce script pour vérifier"
    fi
}

# Fonction principale
main() {
    echo "${BLUE}🌍 VÉRIFICATEUR DE TRADUCTIONS Oracle d'Asgard${NC}"
    echo "================================================="

    check_files
    extract_keys
    compare_keys

    echo "\n${GREEN}✓ Analyse terminée!${NC}"

    # Code de sortie selon les résultats
    if [[ $MISSING_FR_COUNT -gt 0 || $MISSING_EN_COUNT -gt 0 ]]; then
        exit 1
    else
        exit 0
    fi
}

# Exécution du script principal
main "$@"