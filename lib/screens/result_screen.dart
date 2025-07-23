import 'package:flutter/material.dart';
import '../data/app_data.dart';
import 'main_screen.dart';
import '../widgets/deity_card.dart'; // 👈 Import it
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultScreen extends StatelessWidget {
  final String deity;

  const ResultScreen({super.key, required this.deity});

  @override
  Widget build(BuildContext context) {
    final deityData = AppData.deities[deity]!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/backgrounds/landscape.jpg'), fit: BoxFit.cover),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Félicitations !',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontFamily: 'AmaticSC',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 70.sp,
                      letterSpacing: 2.0.sp,
                      shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Votre Divinité Tutélaire est :',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  DeityCard(deity: deityData),

                  SizedBox(height: 32.h),
                  
                  // Description
                  Container(
                    width: 1.sw,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 0, 0, 0.4), // More transparent
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Votre Profil',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          deityData.description,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
                  // Boutons d'action
                  Column(
                    children: [
                      SizedBox(
                        width: 0.8.sw,
                        child: ChibiButton(
                          text: 'Partager mon résultat',
                          color: const Color(0xFF1E88E5), // Blue
                          onPressed: () {
                            // TODO: Implement sharing functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Fonctionnalité de partage à venir !'),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: 0.8.sw,
                        child: ChibiButton(
                          text: 'Retour à l’accueil',
                          color: Colors.amber,
                          onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ),
                            (route) => false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}