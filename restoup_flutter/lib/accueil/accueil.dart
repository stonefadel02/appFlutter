import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryRed,
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Image.asset(
            'assets/images/logorestoB 1.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
