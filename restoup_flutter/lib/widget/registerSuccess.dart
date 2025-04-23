import 'package:flutter/material.dart';
import 'package:restoup_flutter/accueil/homeScreen.dart';
import 'package:restoup_flutter/color/color.dart';

class RegisterSuccess extends StatefulWidget {
  const RegisterSuccess({super.key});

  @override
  State<RegisterSuccess> createState() => _RegisterSuccessState();
}

class _RegisterSuccessState extends State<RegisterSuccess> {
  @override
  void initState() {
    super.initState();
    // Afficher le popup immédiatement après le chargement de la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSuccessPopup();
    });
  }

  // Fonction pour afficher le popup
  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche de fermer le popup en cliquant à l'extérieur
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            
            padding: const EdgeInsets.all(24.0),
            child: Stack(
              children: [
                // Contenu principal du popup
                Column(
                  mainAxisSize: MainAxisSize.min, // Ajuste la taille au contenu
                  children: [
                    const SizedBox(height: 40),

                    // Image (confettis)
                    Image.asset('assets/images/success.png'),
                    const SizedBox(height: 25),

                    // Titre "Félicitation"
                    const Text(
                      'Félicitation',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Message
                    Text(
                      'Votre compte RestoUp a bien été créé.\nVous pouvez à présent commander tous les produits dont vous avez besoin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grayColor,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Bouton "Accueil" avec largeur réduite
                    ElevatedButton(
                      onPressed: () {
                        // Ferme le popup et redirige vers la page d'accueil
                        Navigator.of(context).pop(); // Ferme le popup
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(
                          150,
                          50,
                        ), // Largeur réduite à 150
                        elevation: 6,
                        shadowColor: AppColors.primaryRed.withOpacity(0.3),
                      ),
                      child: const Text(
                        'Accueil',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),

                // Icône de fermeture en haut à droite
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // Ferme le popup
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Fond gris pour l'icône
                        shape: BoxShape.circle, // Forme circulaire
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.grayColor,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const Center(
        child:
            CircularProgressIndicator(), // Affiche un indicateur de chargement pendant que le popup s'ouvre
      ),
    );
  }
}
