import 'package:flutter/material.dart';

class CustomeAppBar extends StatelessWidget {
  const CustomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Espace vide à gauche pour centrer le texte
        const Spacer(),
          const Spacer(),


        // Texte "Accueil" centré
        const Text(
          "Accueil",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Espace vide à droite pour équilibrer et centrer le texte
        const Spacer(),

        // Icônes de notification et panier à droite
        Row(
          children: [
            // Icône de notification
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), // Radius du fond
                    boxShadow: [
                      
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                    ),
                    iconSize: 22,
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 8), // Espacement entre les icônes

            // Icône de panier
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), // Radius du fond
                boxShadow: [
                  
                ],
              ),
              child: IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                ),
                iconSize: 22,
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}