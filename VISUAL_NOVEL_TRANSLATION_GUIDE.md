# 🎮 Visual Novel - Guide de Traduction

**Créé le**: 2026-01-17  
**Status**: 📝 TODO  
**Priorité**: MOYENNE  
**Estimation**: 8-10 heures  

---

## 📊 Contexte

Le Visual Novel "Loki's Life" contient actuellement **tout son contenu narratif en français** codé en dur dans le fichier `lib/screens/games/visual_novel/data/story_data.dart`.

**Textes estimés à traduire**: ~70-80 éléments
- Titres de scènes
- Dialogues (narrateur + personnages)
- Choix du joueur
- Descriptions des choix

---

## ✅ État actuel

### Implémenté
- ✅ Warning "French only" sur la page préliminaire
- ✅ Bouton désactivé pour langues EN/ES
- ✅ Clés de traduction pour l'interface (preliminary screen)

### À faire
- ❌ Extraction de tous les textes FR
- ❌ Traduction EN de ~70 textes
- ❌ Traduction ES de ~70 textes
- ❌ Création des clés i18n (~70 clés)
- ❌ Modification du fichier `story_data.dart`
- ❌ Remplacement des textes en dur par `.tr()`

---

## 🎯 Approche recommandée

### Phase 1: Extraction (1h)
Créer un script qui :
1. Parse `story_data.dart` ligne par ligne
2. Extrait tous les textes français
3. Génère les clés i18n structurées
4. Crée un fichier JSON avec tous les textes

**Structure de clés proposée**:
```
vn_story_title                    # Métadonnées
vn_story_description
vn_act2_title
vn_act2_description
vn_speaker_narrateur              # Personnages
vn_speaker_brokkr
vn_scene_root_bored_loki_title    # Par scène
vn_scene_root_bored_loki_d1       # Dialogues (d1, d2, d3...)
vn_scene_root_bored_loki_d2
vn_choice_path_malice_cut_hair   # Choix
vn_choice_path_malice_cut_hair_desc
```

### Phase 2: Traduction (6-8h)
Options :
1. **Traduction manuelle** (meilleure qualité, 8-10h)
2. **Traduction assistée** (DeepL/ChatGPT + révision, 4-6h)
3. **Traduction automatique** (rapide mais qualité moyenne, 2h)

### Phase 3: Intégration (1-2h)
1. Ajouter toutes les clés dans les fichiers JSON (FR/EN/ES)
2. Modifier `story_data.dart` :
   ```dart
   // Avant
   title: "L'Ennui d'Asgard",
   
   // Après  
   title: "vn_scene_root_bored_loki_title".tr(),
   ```
3. Ajouter import `easy_localization` si nécessaire
4. Tester avec les 3 langues

---

## 📁 Fichiers à modifier

### Traductions
- `assets/resources/langs/en-US.json` (+ ~70 clés)
- `assets/resources/langs/es-ES.json` (+ ~70 clés)
- `assets/resources/langs/fr-FR.json` (+ ~70 clés)

### Code
- `lib/screens/games/visual_novel/data/story_data.dart`
  - Ajouter: `import 'package:easy_localization/easy_localization.dart';`
  - Remplacer tous les textes en dur par `.tr()`

### Suppression du warning
- `lib/screens/games/visual_novel/visual_novel_preliminary_screen.dart`
  - Supprimer la bannière d'avertissement
  - Réactiver le bouton pour toutes les langues

---

## 🚀 Script d'extraction (à créer)

```python
#!/usr/bin/env python3
"""
Extrait tous les textes du Visual Novel pour traduction
Usage: python3 extract_vn_texts.py
Output: vn_texts_to_translate.json
"""

import re
import json

# 1. Lire story_data.dart
# 2. Parser chaque Scene
# 3. Extraire title, content, dialogues, choices
# 4. Générer clés structurées
# 5. Sauvegarder en JSON

# Format de sortie:
# {
#   "vn_scene_root_bored_loki_title": {
#     "fr": "L'Ennui d'Asgard",
#     "en": "[TODO]",
#     "es": "[TODO]",
#     "type": "title",
#     "scene": "scene_root_bored_loki",
#     "line": 51
#   },
#   ...
# }
```

---

## 📝 Exemple de traduction

### Avant (texte en dur)
```dart
Scene(
  id: 'scene_root_bored_loki',
  title: "L'Ennui d'Asgard",
  dialogues: [
    DialogueLine(
      speaker: "Narrateur",
      text: "*Dans les palais dorés d'Asgard, l'éternité pèse sur l'esprit de Loki*"
    ),
  ]
)
```

### Après (i18n)
```dart
Scene(
  id: 'scene_root_bored_loki',
  title: "vn_scene_root_bored_loki_title".tr(),
  dialogues: [
    DialogueLine(
      speaker: "vn_speaker_narrateur".tr(),
      text: "vn_scene_root_bored_loki_d1".tr()
    ),
  ]
)
```

### Fichiers JSON
```json
{
  "vn_scene_root_bored_loki_title": "The Boredom of Asgard",
  "vn_speaker_narrateur": "Narrator",
  "vn_scene_root_bored_loki_d1": "*In the golden palaces of Asgard, eternity weighs on Loki's mind*"
}
```

---

## ⚠️ Points d'attention

### Noms propres nordiques
**Ne PAS traduire** :
- Loki, Thor, Odin, Sif, Baldur
- Asgard, Midgard, Valhalla
- Mjöllnir, Yggdrasil
- Brokkr, Eitri

### Contexte narratif
- Maintenir le ton (malicieux pour Loki, neutre pour narrateur)
- Respecter les nuances émotionnelles
- Adapter les expressions idiomatiques françaises

### Formatage
- Conserver les `*actions*` entre astérisques
- Respecter la ponctuation dramatique (…, !, ?)
- Garder les pourcentages [50% des destins]

---

## 📅 Roadmap

### Priorité HAUTE (bloquant pour EN/ES)
- [ ] Phase 1: Extraction des textes
- [ ] Phase 2: Traduction EN (70 textes)
- [ ] Phase 2: Traduction ES (70 textes)

### Priorité MOYENNE (intégration)
- [ ] Phase 3: Ajout dans JSON
- [ ] Phase 3: Modification story_data.dart
- [ ] Tests dans les 3 langues

### Priorité BASSE (polish)
- [ ] Révision qualité des traductions
- [ ] Ajustements contextuels
- [ ] Suppression du warning FR-only

---

## 🔗 Ressources

### Fichiers concernés
- Source: `lib/screens/games/visual_novel/data/story_data.dart` (652 lignes)
- i18n: `assets/resources/langs/*.json`
- Warning: `lib/screens/games/visual_novel/visual_novel_preliminary_screen.dart`

### Documentation
- EasyLocalization: `.tr()` pour traduire
- Structure des scenes dans `visual_novel_models.dart`
- Design narratif: voir `visualnovel.md` (si existe)

---

## 💡 Alternative: Fichiers JSON par langue

Au lieu de modifier `story_data.dart`, créer :
- `visual_novel_story_fr.json`
- `visual_novel_story_en.json`
- `visual_novel_story_es.json`

Et charger dynamiquement selon la langue. Plus maintenable mais refactoring plus important.

---

**Dernière mise à jour**: 2026-01-17 19:58  
**Status warning actuel**: ✅ Opérationnel (utilisateurs informés)
