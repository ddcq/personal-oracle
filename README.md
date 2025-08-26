![GitHub stars](https://img.shields.io/github/stars/ddcq/personal-oracle?style=social) ![GitHub forks](https://img.shields.io/github/forks/ddcq/personal-oracle?style=social) ![GitHub issues](https://img.shields.io/github/issues/ddcq/personal-oracle) ![GitHub top language](https://img.shields.io/github/languages/top/ddcq/personal-oracle) ![GitHub license](https://img.shields.io/github/license/ddcq/personal-oracle) ![GitHub last commit](https://img.shields.io/github/last-commit/ddcq/personal-oracle)

# 🪄 Personal Oracle – Mythologie Nordique Interactive

**Personal Oracle** est une application **Flutter** multi-plateforme (mobile, tablette, PC) qui vous plonge au cœur de la mythologie nordique.  
Découvrez les dieux, légendes et créatures à travers :  
- Un **questionnaire interactif** pour savoir *quel dieu nordique* vous êtes  
- Une collection de **mini-jeux** (Tetris, Qix, puzzle…) pour débloquer récompenses et trophées  
- Des **histoires et anecdotes mythologiques** à explorer  

Le projet a été intégralement réalisé à l’aide d’**IA** (génération du code et des assets graphiques).  

---

## ✨ Fonctionnalités

- Design moderne et responsive  
- Compatible Android, iOS, Windows, macOS, Linux  
- Mini-jeux intégrés avec système de récompenses  
- Contenus et illustrations mythologiques générés par IA  
- Code clair et facile à personnaliser  
- Expérience utilisateur immersive avec interface animée  
- Système de progression et de collection des trophées  

---

## 🛠️ Stack technique

- **Flutter** (Dart)  
- **Assets IA** pour les illustrations, fonds, icônes  
- Architecture modulaire : séparation claire entre la logique, les vues, et les ressources  
- Plugins Flutter utilisés : `shared_preferences`, `audioplayers`, etc.  

---

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir :  
- [Flutter](https://flutter.dev/docs/get-started/install) installé (canal stable recommandé)  
- [Git](https://git-scm.com/)  
- Un IDE compatible (Visual Studio Code, Android Studio, etc.)  
- Un émulateur ou un appareil connecté pour le test  

---

## 🚀 Installation & Exécution

### 1. Cloner le dépôt
```bash
git clone https://github.com/ddcq/personal-oracle.git
cd personal-oracle
```

### 2. Installer les dépendances
```bash
flutter pub get
```

### 3. Lancer l’application en mode debug
```bash
flutter run
```

### 4. Construire pour la production

- Pour Android :
```bash
flutter build apk
```

- Pour iOS :
```bash
flutter build ios
```

- Pour desktop (Windows, Linux, macOS) :
```bash
flutter build windows
flutter build linux
flutter build macos
```

---

## 📖 Utilisation

Une fois lancée, l'application propose :  
- Un **quiz interactif** composé de questions mythologiques pour déterminer votre profil divin  
- Des **mini-jeux** inspirés des classiques (Tetris, Qix, puzzles logiques)  
- Un **système de progression** avec des trophées et des objets à collectionner  
- Une **bibliothèque d’histoires** illustrées issues des légendes nordiques, débloquées au fil du jeu  

---

## 🧠 Architecture du projet

Le projet suit une structure modulaire Flutter :
```
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── quiz_screen.dart
│   └── game_screen.dart
├── widgets/
├── models/
├── services/
├── assets/
│   ├── images/
│   └── data/
└── utils/
```

---

## 🤝 Contribuer

Les contributions sont les bienvenues !  
Voici comment faire :  
1. Forkez le projet  
2. Créez une branche (`git checkout -b feature/ma-super-fonctionnalite`)  
3. Commitez vos modifications (`git commit -m 'Ajout de ma fonctionnalité'`)  
4. Poussez vers GitHub (`git push origin feature/ma-super-fonctionnalite`)  
5. Ouvrez une Pull Request et échangeons !  

---

## 📄 Licence

Ce projet est sous licence **GNU GPL v3.0**.  
Vous pouvez le modifier, l'étendre ou le distribuer sous les mêmes conditions.

---

## 👨‍💻 Auteur

**ddcq**  
- GitHub : [@ddcq](https://github.com/ddcq)

---

## ⭐ Soutenir le projet

Si ce projet vous plaît, n’hésitez pas à lui donner une ⭐ sur GitHub.  
Votre soutien aide à faire vivre ce type d’initiatives créatives mêlant IA et mythologie.

📦 **[Voir le dépôt](https://github.com/ddcq/personal-oracle
**