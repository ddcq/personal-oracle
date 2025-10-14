import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/screens/games/qix/main.dart';

class QixPreliminaryScreen extends StatelessWidget {
  const QixPreliminaryScreen({super.key});

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
          Image.asset('assets/images/preliminary/qix.webp', width: 120),
          const SizedBox(height: 16),
          Text(
            'Guidez Odin et dessinez des formes pour conquérir les territoires des 9 mondes, mais attention à Fenrir qui rôde, prêt à frapper !',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    final Widget startButton = ChibiButton(
      text: 'Commencer',
      color: const Color(0xFFFF6B35), // Color from menu
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const QixGameScreen()));
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
