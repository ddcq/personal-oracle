#!/usr/bin/env python3
"""
Final simple translation script - translates by key directly
"""
import json

# Charger
with open('assets/resources/langs/en-US.json', 'r') as f:
    en = json.load(f)
with open('assets/resources/langs/es-ES.json', 'r') as f:
    es = json.load(f)

# English translations by key
keys_to_translate_en = {
    'norse_quiz_q3': 'What is the name of the realm of the Aesir gods?',
    'norse_quiz_q6': "What are the names of Odin's two ravens?",
    'norse_quiz_q10': 'What is the name of the giant wolf destined to kill Odin?',
    'norse_quiz_q11': 'Who is the goddess of love and fertility?',
    'norse_quiz_q15': 'What is the name of the world serpent?',
    'norse_quiz_q16': "What is Odin's eight-legged horse?",
    'norse_quiz_q17': "Who is Odin's beloved son, god of light?",
    'norse_quiz_q19': 'What is the name of the Norse end of the world?',
    'norse_quiz_q21': "Who is Odin's wife?",
    'norse_quiz_q23': 'What is the name of the realm of fire?',
    'norse_quiz_q29': 'Who is the goddess associated with winter and mountains?',
    'norse_quiz_q31': 'Which giant is at the origin of the world?',
    'norse_quiz_q32': 'How many worlds are there in Norse cosmology?',
    'norse_quiz_q41': 'Which animal gnaws at the roots of Yggdrasil?',
    'norse_quiz_q43': "What is the name of Odin's well of wisdom?",
    'norse_quiz_q53': 'Which goddess weeps golden tears?',
    'norse_quiz_q58': 'Which god wields the magical sword Skidbladnir?',
    'norse_quiz_q26_a2': "Idunn's apples",
    'norse_quiz_q26_a3': "Mimir's water",
    'norse_quiz_q43_a2': "Mimir's Well",
    'norse_quiz_q48_a2': 'They kill each other',
}

# Spanish translations by key
keys_to_translate_es = {
    'norse_quiz_q3': '¿Cómo se llama el reino de los dioses Ases?',
    'norse_quiz_q6': '¿Cómo se llaman los dos cuervos de Odín?',
    'norse_quiz_q10': '¿Cómo se llama el lobo gigante destinado a matar a Odín?',
    'norse_quiz_q11': '¿Quién es la diosa del amor y la fertilidad?',
    'norse_quiz_q15': '¿Cómo se llama la serpiente del mundo?',
    'norse_quiz_q16': '¿Cuál es el caballo de ocho patas de Odín?',
    'norse_quiz_q17': '¿Quién es el amado hijo de Odín, dios de la luz?',
    'norse_quiz_q19': '¿Cómo se llama el fin del mundo nórdico?',
    'norse_quiz_q21': '¿Quién es la esposa de Odín?',
    'norse_quiz_q23': '¿Cómo se llama el reino del fuego?',
    'norse_quiz_q29': '¿Quién es la diosa asociada al invierno y las montañas?',
    'norse_quiz_q31': '¿Qué gigante está en el origen del mundo?',
    'norse_quiz_q32': '¿Cuántos mundos hay en la cosmología nórdica?',
    'norse_quiz_q41': '¿Qué animal roe las raíces de Yggdrasil?',
    'norse_quiz_q43': '¿Cuál es el nombre del pozo de sabiduría de Odín?',
    'norse_quiz_q53': '¿Qué diosa llora lágrimas de oro?',
    'norse_quiz_q58': '¿Qué dios maneja la espada mágica Skidbladnir?',
    'norse_quiz_q26_a2': 'Las manzanas de Idunn',
    'norse_quiz_q26_a3': 'El agua de Mimir',
    'norse_quiz_q43_a2': 'Pozo de Mimir',
    'norse_quiz_q48_a2': 'Se matan mutuamente',
}

# Apply translations
for key, translation in keys_to_translate_en.items():
    if key in en:
        en[key] = translation

for key, translation in keys_to_translate_es.items():
    if key in es:
        es[key] = translation

# Save
with open('assets/resources/langs/en-US.json', 'w') as f:
    json.dump(en, f, ensure_ascii=False, indent=2)

with open('assets/resources/langs/es-ES.json', 'w') as f:
    json.dump(es, f, ensure_ascii=False, indent=2)

print(f"✅ Translation complete!")
print(f"   EN: {len(keys_to_translate_en)} keys translated")
print(f"   ES: {len(keys_to_translate_es)} keys translated")

# Verify
remaining_fr = 0
for k, v in en.items():
    if k.startswith('norse_quiz_q') and any(v.startswith(p) for p in ['Qui ', 'Quel', 'Comment', 'Où ', 'Combien', 'Les ', "L'eau"]):
        remaining_fr += 1

if remaining_fr == 0:
    print(f"\n🎉 SUCCESS! All norse_quiz keys are now translated!")
else:
    print(f"\n⚠️  {remaining_fr} keys still in French")
