import 'package:flutter/material.dart';

class DefeatScreen extends StatelessWidget {
  const DefeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Défaite...'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.gpp_bad, // Icône d'échec
                color: Colors.red,
                size: 100,
              ),
              SizedBox(height: 24),
              Text(
                'Défaite !',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red[800],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[600]!, width: 2),
                ),
                child: Text(
                  '💥 Un trou dans la muraille !\nLes Ases ne paieront pas le géant.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/game');
                },
                icon: Icon(Icons.refresh, color: Colors.black),
                label: Text(
                  'Réessayer',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                  elevation: 8,
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/')); // Retourne à l'écran d'accueil
                },
                child: Text(
                  'Retour à l\'accueil',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
