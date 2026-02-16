# Responsive Provider - Guide d'utilisation

## Problème résolu

Sur **web**, l'application est affichée dans un conteneur avec un ratio 9:16 centré dans la fenêtre du navigateur. Le problème était que `flutter_screenutil` utilisait la taille de la **fenêtre** pour calculer `.w`, `.h`, et `.sp`, pas la taille du **jeu**. Cela causait des dimensions incorrectes quand la fenêtre était redimensionnée.

## Solution

`ResponsiveProvider` est un `InheritedWidget` qui calcule les dimensions basées sur la taille **réelle du jeu** (le conteneur 9:16), pas sur la taille de la fenêtre.

## Utilisation

### 1. Avec la classe `Responsive` (Recommandé)

```dart
import 'package:oracle_d_asgard/providers/responsive_provider.dart';

Widget build(BuildContext context) {
  final responsive = Responsive(context);

  return Container(
    width: responsive.width(100),    // 100 unités de largeur
    height: responsive.height(200),  // 200 unités de hauteur
    child: Text(
      'Hello',
      style: TextStyle(fontSize: responsive.sp(16)), // 16sp
    ),
  );
}
```

### 2. Méthodes disponibles

```dart
final responsive = Responsive(context);

// Dimensions scalées
responsive.width(100)        // Largeur scalée selon le ratio
responsive.height(200)       // Hauteur scalée selon le ratio
responsive.sp(16)            // Taille de police (utilise le min des deux ratios)

// Pourcentages de l'écran de jeu
responsive.screenWidth(0.5)  // 50% de la largeur du jeu
responsive.screenHeight(0.8) // 80% de la hauteur du jeu

// Informations
responsive.gameSize          // Taille du jeu (Size)
responsive.scaleWidth        // Ratio de largeur
responsive.scaleHeight       // Ratio de hauteur
```

### 3. Avec Builder (pour éviter les conflits de context)

Si vous avez besoin d'accéder au ResponsiveProvider dans un widget qui n'a pas encore le bon context:

```dart
Builder(
  builder: (context) {
    final responsive = Responsive(context);
    return Container(
      width: responsive.width(100),
      height: responsive.height(200),
    );
  },
)
```

## Migration de flutter_screenutil

| Avant (flutter_screenutil) | Après (ResponsiveProvider) |
|----------------------------|---------------------------|
| `100.w`                    | `Responsive(context).width(100)` |
| `200.h`                    | `Responsive(context).height(200)` |
| `16.sp`                    | `Responsive(context).sp(16)` |
| `0.5.sw`                   | `Responsive(context).screenWidth(0.5)` |
| `0.8.sh`                   | `Responsive(context).screenHeight(0.8)` |
| `MediaQuery.of(context).size.width` | `Responsive(context).gameSize.width` |

## Exemple complet

```dart
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/providers/responsive_provider.dart';

class MyGameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Column(
      children: [
        // Bouton avec taille responsive
        ElevatedButton(
          child: Text(
            'Play',
            style: TextStyle(fontSize: responsive.sp(18)),
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(
              responsive.width(200),
              responsive.height(50),
            ),
          ),
        ),

        // Espacement responsive
        SizedBox(height: responsive.height(20)),

        // Container qui prend 80% de la largeur du jeu
        Container(
          width: responsive.screenWidth(0.8),
          height: responsive.height(100),
          color: Colors.blue,
        ),
      ],
    );
  }
}
```

## Notes importantes

1. **Le ResponsiveProvider est déjà configuré** dans `main.dart` pour web et mobile
2. **Design size**: `360 x 690` (taille de référence mobile standard)
3. **Sur web**: Les calculs sont basés sur le conteneur 9:16, pas la fenêtre
4. **Sur mobile**: Les calculs sont basés sur la taille de l'écran réel
5. **Compatibilité**: `flutter_screenutil` continue de fonctionner mais donnera des résultats incorrects sur web

## Pourquoi pas utiliser flutter_screenutil directement?

`flutter_screenutil` utilise `MediaQuery.of(context).size` qui sur web retourne la taille de la **fenêtre du navigateur**, pas la taille du jeu. Notre `ResponsiveProvider` résout ce problème en fournissant la taille **réelle du conteneur de jeu**.
