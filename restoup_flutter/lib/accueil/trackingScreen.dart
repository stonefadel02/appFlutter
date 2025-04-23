import 'package:flutter/material.dart';
import 'package:restoup_flutter/widget/completionPopup.dart';
import 'package:restoup_flutter/widget/navBar.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:restoup_flutter/color/color.dart'; // Importer les couleurs

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key, required trackingSteps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
              backgroundColor: Colors.white,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.grey,
            size: 20,
          ),
        ),
        title: const Text(
          "Suivi de commande",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Suivez l'état de votre commande en direct.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Timeline des étapes de suivi
            _buildTimelineStep(
              context,
              title: "Prise en charge de la commande",
              time: "24/04/2025 à 09:46",
              isFirst: true,
            ),
            _buildTimelineStep(
              context,
              title: "Préparation de la commande",
              time: "24/04/2025 à 09:50",
            ),
            _buildTimelineStep(
              context,
              title: "Livraison de la commande",
              time: "24/04/2025 à 10:00",
              isLast: true,
            ),
            const Spacer(), // Pousse le bouton vers le bas

            // Bouton "Terminer la commande"
            Center(
              child: SizedBox(
                width: double.infinity, // Bouton pleine largeur
                child: ElevatedButton(
                  onPressed: () {
                    // Ouvre le popup de félicitations
                    showDialog(
                      context: context,
                      builder: (context) => const CompletionPopup(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Terminer la commande",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Ajouter la même barre de navigation que celle définie dans NavBar
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: Colors.white, // Fond blanc pour la barre de navigation
        waterDropColor: AppColors.primaryRed, // Couleur de l'effet goutte d'eau
        inactiveIconColor: AppColors.grayColor, // Couleur des icônes inactives
        onItemSelected: (index) {
          // Naviguer vers la page correspondante en utilisant NavBar
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavBar(),
            ),
          );
        },
        selectedIndex: 1, // "Commandes" est sélectionné
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

  // Widget pour chaque étape de la timeline
  Widget _buildTimelineStep(
    BuildContext context, {
    required String title,
    required String time,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Côté gauche : Cercle et ligne verticale
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red, // Cercle rouge
              ),
            ),
            if (!isLast) // Ne pas afficher de ligne après la dernière étape
              Container(
                width: 2,
                height: 60, // Hauteur de la ligne entre les étapes
                color: Colors.grey, // Ligne grise
              ),
          ],
        ),
        const SizedBox(width: 16),

        // Côté droit : Titre et heure
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              if (!isLast) const SizedBox(height: 24), // Espacement entre les étapes
            ],
          ),
        ),
      ],
    );
  }
}