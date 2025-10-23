# Vérificateur de Traductions Oracle d'Asgard

## Description

Ce script zsh vérifie la cohérence entre les fichiers de traduction français (`fr-FR.json`) et anglais (`en-US.json`) en comparant leurs clés.

## Prérequis

- zsh (installé par défaut sur macOS)
- `jq` pour parser le JSON : `brew install jq`

## Installation

```bash
# Rendre le script exécutable
chmod +x check_translations.zsh
```

## Utilisation

```bash
# Exécuter la vérification
./check_translations.zsh
```

## Fonctionnalités

- ✅ **Extraction automatique** des clés de traduction des deux fichiers
- 📊 **Comptage** du nombre total de clés dans chaque fichier
- 🔍 **Comparaison** et détection des clés manquantes
- 🎨 **Affichage coloré** pour une lecture facile
- 🚨 **Code de sortie** approprié pour l'intégration CI/CD

## Sortie du script

### Cas parfait (toutes les clés présentes)
```
🌍 VÉRIFICATEUR DE TRADUCTIONS Oracle d'Asgard
=================================================
📝 Extraction des clés de traduction...
✓ Clés françaises: 504
✓ Clés anglaises: 504

🔍 Comparaison des clés...

📊 RAPPORT DE COMPARAISON
==================================
✅ Parfait! Toutes les clés sont présentes dans les deux fichiers.

✓ Analyse terminée!
```

### Cas avec clés manquantes
```
❌ Clés manquantes dans fr-FR.json (2):
────────────────────────────────────────────────
  • missing_key_1
  • missing_key_2

❌ Clés manquantes dans en-US.json (1):
────────────────────────────────────────────────
  • another_missing_key

📋 RÉSUMÉ:
  • Total clés FR: 502
  • Total clés EN: 503
  • Manquantes FR: 2
  • Manquantes EN: 1

💡 Actions recommandées:
  1. Ajoutez les clés manquantes au fichier français
  2. Ajoutez les clés manquantes au fichier anglais
  3. Relancez ce script pour vérifier
```

## Codes de sortie

- `0` : Tous les fichiers sont synchronisés
- `1` : Des clés manquantes ont été détectées

## Intégration CI/CD

Vous pouvez intégrer ce script dans votre pipeline pour vérifier automatiquement la cohérence des traductions :

```yaml
# Exemple GitHub Actions
- name: Check translations
  run: ./check_translations.zsh
```

## Structure des fichiers

Le script s'attend à trouver les fichiers de traduction aux emplacements suivants :
- `assets/resources/langs/fr-FR.json`
- `assets/resources/langs/en-US.json`

## Maintenance

Pour maintenir la cohérence des traductions :

1. **Avant chaque commit** : Exécutez le script pour vérifier
2. **Ajout de nouvelles clés** : Ajoutez-les dans les deux fichiers
3. **Suppression de clés** : Supprimez-les des deux fichiers
4. **Renommage de clés** : Renommez dans les deux fichiers simultanément

## Dépannage

### Erreur "jq command not found"
```bash
brew install jq
```

### Erreur "Permission denied"
```bash
chmod +x check_translations.zsh
```

### Fichiers introuvables
Vérifiez que vous exécutez le script depuis la racine du projet Oracle d'Asgard.