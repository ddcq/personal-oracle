import 'package:flutter/material.dart';

class FindThePathGame extends StatefulWidget {
  const FindThePathGame({super.key});

  @override
  State<FindThePathGame> createState() => _FindThePathGameState();
}

class _FindThePathGameState extends State<FindThePathGame> {
  Offset _leafPosition = Offset(50, 400);
  final Offset _targetPosition = Offset(300, 100);
  bool _gameOver = false;

  final Size _leafSize = Size(50, 50);
  final Rect _safeZone = Rect.fromLTWH(30, 80, 300, 500);

  void _showHelp() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("🌿 Règles"),
        content: Text("Glisse la feuille jusqu’à la lumière sans sortir du chemin."),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
      ),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_gameOver) return;
    final newOffset = _leafPosition + details.delta;
    final leafRect = Rect.fromLTWH(newOffset.dx, newOffset.dy, _leafSize.width, _leafSize.height);

    if (_safeZone.contains(leafRect.topLeft) && _safeZone.contains(leafRect.bottomRight)) {
      setState(() {
        _leafPosition = newOffset;
        if ((newOffset - _targetPosition).distance < 40) {
          _gameOver = true;
          _showResult("🌞 Bien joué ! Tu as suivi le chemin.");
        }
      });
    } else {
      _gameOver = true;
      _showResult("🌪️ Tu es sorti du chemin !");
    }
  }

  void _showResult(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Résultat"),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _leafPosition = Offset(50, 400);
                  _gameOver = false;
                });
              },
              child: Text("Rejouer"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🌿 Find the Path"),
        actions: [IconButton(icon: Icon(Icons.help_outline), onPressed: _showHelp)],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.green.shade100,
              child: CustomPaint(
                painter: PathZonePainter(_safeZone),
              ),
            ),
          ),
          Positioned(
            left: _targetPosition.dx,
            top: _targetPosition.dy,
            child: Icon(Icons.wb_sunny, size: 40, color: Colors.yellow),
          ),
          Positioned(
            left: _leafPosition.dx,
            top: _leafPosition.dy,
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              child: Icon(Icons.eco, size: 50, color: Colors.green),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Text("🎯 But : Glisse la feuille jusqu'à la lumière sans sortir du chemin."),
          ),
        ],
      ),
    );
  }
}

class PathZonePainter extends CustomPainter {
  final Rect zone;
  PathZonePainter(this.zone);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.green.withOpacity(0.2);
    canvas.drawRect(zone, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
