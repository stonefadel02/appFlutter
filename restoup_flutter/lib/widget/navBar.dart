import 'package:restoup_flutter/accueil/commandes.dart';
import 'package:restoup_flutter/accueil/favoris.dart';
import 'package:restoup_flutter/accueil/homeScreen.dart';
import 'package:restoup_flutter/accueil/profileScreen.dart';
import 'package:restoup_flutter/color/color.dart'; // Importer les couleurs
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBar> {
  int page = 0;

  List screens = [
    const HomeScreen(),
    const Commandes(),
    const Favoris(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Permet au contenu de s'étendre derrière la barre de navigation
      body: screens[page],
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: Colors.white, // Fond blanc pour la barre de navigation
        waterDropColor: AppColors.primaryRed, // Couleur de l'effet goutte d'eau
        inactiveIconColor: AppColors.grayColor, // Couleur des icônes inactives
        onItemSelected: (index) {
          setState(() {
            page = index; // Met à jour l'index de la page
          });
        },
        selectedIndex: page, // Index de l'élément actuellement sélectionné
        barItems: [
          BarItem(
            filledIcon: Icons.home_filled,
            outlinedIcon: Icons.home_outlined,
          ),
          BarItem(
            filledIcon: Icons.receipt,
            outlinedIcon: Icons.receipt_outlined,
          ),
          BarItem(
            filledIcon: Icons.favorite,
            outlinedIcon: Icons.favorite_border,
          ),
          BarItem(
            filledIcon: Icons.person,
            outlinedIcon: Icons.person_outline,
          ),
        ],
      ),
    );
  }
}