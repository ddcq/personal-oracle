import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/game_screen.dart';

class AsgardWallGameScreen extends StatelessWidget {
  const AsgardWallGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final Widget gameInfoLayout = Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.black.withAlpha(128), borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/preliminary/asgard_wall.webp', width: 120),
          const SizedBox(height: 16),
          Text(
            'Aidez Hrumthur à construire la muraille d’Asgard en plaçant les blocs qui tombent. Atteignez la hauteur de la victoire sans laisser de trous inaccessibles !',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    final Widget startButton = ChibiButton(
      text: 'Commencer la construction',
      color: const Color(0xFFEF4444), // Color from menu
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const GameScreen()));
      },
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: isLandscape
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(child: gameInfoLayout),
                          const SizedBox(width: 20),
                          startButton,
                        ],
                      )
                    : Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[gameInfoLayout, const SizedBox(height: 32), startButton]),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
