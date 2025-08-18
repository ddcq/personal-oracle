import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'puzzle_screen.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

// =========================================
// PUZZLE GAME - Les Runes Dispersées
// =========================================
class PuzzleGameScreen extends StatefulWidget {
  const PuzzleGameScreen({super.key});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/landscape.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack( // Wrap with a Stack
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Reconstitue les Runes Sacrées',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontFamily: 'AmaticSC',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 60.sp,
                            letterSpacing: 2.0.sp,
                            shadows: [
                              const Shadow(
                                blurRadius: 15.0,
                                color: Colors.black87,
                                offset: Offset(4.0, 4.0),
                              )
                            ],
                          ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(128),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const PuzzleImageTile(size: 80),
                          const SizedBox(height: 16),
                          Text(
                            'Assemble les fragments des anciennes runes pour déverrouiller leur pouvoir mystique',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                      child: ChibiButton(
                        text: 'Commencer le Puzzle',
                        color: const Color(0xFF06B6D4),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PuzzleScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned( // Add the back button
                top: 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PuzzleImageTile extends StatefulWidget {
  final double size;
  const PuzzleImageTile({super.key, required this.size});

  @override
  State<PuzzleImageTile> createState() => _PuzzleImageTileState();
}

class _PuzzleImageTileState extends State<PuzzleImageTile> {
  ui.Image? _image;
  int? _tileIndex;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final ByteData data = await rootBundle.load('assets/images/puzzle_chibi.png');
    final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo fi = await codec.getNextFrame();
    if (mounted) {
      setState(() {
        _image = fi.image;
        _tileIndex = Random().nextInt(9);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null || _tileIndex == null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const CircularProgressIndicator(),
      );
    }
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: PuzzleTilePainter(image: _image!, tileIndex: _tileIndex!),
    );
  }
}

class PuzzleTilePainter extends CustomPainter {
  final ui.Image image;
  final int tileIndex;

  PuzzleTilePainter({required this.image, required this.tileIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final double sheetWidth = image.width.toDouble();
    final double sheetHeight = image.height.toDouble();
    const int tilesPerRow = 3;
    final double tileWidth = sheetWidth / tilesPerRow;
    final double tileHeight = sheetHeight / tilesPerRow;

    final int tileCol = tileIndex % tilesPerRow;
    final int tileRow = tileIndex ~/ tilesPerRow;

    final Rect sourceRect = Rect.fromLTWH(
      tileCol * tileWidth,
      tileRow * tileHeight,
      tileWidth,
      tileHeight,
    );

    final Rect destRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(image, sourceRect, destRect, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
