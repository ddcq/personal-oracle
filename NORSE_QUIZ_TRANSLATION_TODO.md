# 🔧 TODO: Norse Quiz Translations

## 📋 Problème Identifié

Les 228 clés du Norse Quiz dans les fichiers `en-US.json` et `es-ES.json` sont actuellement en **français** au lieu d'être dans leur langue respective.

## 📊 Statistiques

- **Nombre de clés**: 228
- **Nombre de questions**: ~63
- **Réponses par question**: 3-4
- **Langues à traduire**: Anglais (EN) + Espagnol (ES)

## 🔑 Format des Clés

```
norse_quiz_q1: "Question 1"
norse_quiz_q1_a1: "Réponse A"
norse_quiz_q1_a2: "Réponse B"
norse_quiz_q1_a3: "Réponse C"
norse_quiz_q1_a4: "Réponse D" (optionnel)
```

## ✅ Exemples de Traductions Nécessaires

### Question 1
- **FR**: "Qui est le dieu principal de la mythologie nordique ?"
- **EN**: "Who is the main god in Norse mythology?"
- **ES**: "¿Quién es el dios principal de la mitología nórdica?"

### Question 2  
- **FR**: "Quel dieu manie le marteau Mjöllnir ?"
- **EN**: "Which god wields the hammer Mjöllnir?"
- **ES**: "¿Qué dios maneja el martillo Mjöllnir?"

### Question 3
- **FR**: "Comment s'appelle le royaume des dieux Ases ?"
- **EN**: "What is the name of the realm of the Aesir gods?"
- **ES**: "¿Cómo se llama el reino de los dioses Ases?"

## 🛠️ Méthode de Résolution

### Option 1: Script Python Automatique
1. Extraire toutes les clés françaises
2. Utiliser un service de traduction (DeepL/Google Translate API)
3. Valider manuellement les traductions
4. Mettre à jour les fichiers JSON

### Option 2: Traduction Manuelle
1. Copier `/tmp/norse_quiz_fr_keys.json`
2. Traduire manuellement chaque clé
3. Valider avec un natif si possible
4. Appliquer aux fichiers

### Option 3: Traduction Semi-Automatique
1. Traduire par lots de 50 clés
2. Utiliser l'IA pour les questions (précision mythologique importante)
3. Noms propres restent identiques (Thor, Odin, Mjöllnir, etc.)
4. Valider la cohérence

## 📁 Fichiers Concernés

- `assets/resources/langs/en-US.json` (lignes ~250-478)
- `assets/resources/langs/es-ES.json` (lignes ~250-478)
- Source: `lib/data/norse_quiz_questions_data.dart`

## 🎯 Priorité

**Moyenne** - Le quiz fonctionne mais n'est pas en anglais/espagnol.  
Utilisateurs francophones non affectés.

## 📝 Notes

- Les noms propres nordiques sont identiques dans les 3 langues
- Certaines réponses sont des noms (Thor, Odin) → pas de traduction
- Vérifier l'exactitude mythologique dans chaque langue
- Tester in-app après traduction

## ✅ Action Recommandée

Créer un script Python qui:
1. Lit le JSON français actuel
2. Traduit intelligemment (noms propres non traduits)
3. Génère les fichiers EN et ES
4. Permet validation manuelle avant commit

---
**Créé le**: 2026-01-16 21:50
**Status**: TODO
**Estimation**: 2-3 heures de travail
