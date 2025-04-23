import 'package:flutter/material.dart';
import 'package:restoup_flutter/widget/navBar.dart'; // Importer NavBar pour la navigation

class CompletionPopup extends StatelessWidget {
  const CompletionPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // S'adapte à la taille du contenu
          children: [
            // Icône de fermeture
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context); // Ferme le popup
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ],
            ),

            // Image de célébration (remplace l'icône)
            Image.asset(
              'assets/images/confetti.png', // Remplace par le chemin de ton image
              height: 50, // Ajuste la hauteur pour correspondre à l'icône précédente
              width: 50,
              fit: BoxFit.cover, // Ajuste l'image pour remplir l'espace
            ),
            const SizedBox(height: 16),

            // Titre "Félicitation" en rouge
            const Text(
              "Félicitation",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),

            // Description avec "Vous serez livrés" en gras
            const Text(
              "Votre commande a été livrée avec succès.\n",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const Text(
              "Vous serez livrés dès le lendemain !",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold, // "Vous serez livrés" en gras
              ),
            ),
            const SizedBox(height: 24),

            // Bouton "Accueil"
            SizedBox(
              width: 200, // Largeur réduite pour correspondre à la maquette
              child: ElevatedButton(
                onPressed: () {
                  // Naviguer vers la page d'accueil via NavBar
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavBar(), // Index 0 pour "Accueil"
                    ),
                    (route) => false, // Supprime toutes les pages précédentes
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
                  "Accueil",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}