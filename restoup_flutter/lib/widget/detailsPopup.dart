import 'package:flutter/material.dart';

class OrderDetailsPopup extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const OrderDetailsPopup({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // S'adapte à la taille du contenu
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre et icône de fermeture
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Détails Produit",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            const SizedBox(height: 16),

            // Liste des produits
            for (var product in products) ...[
              Row(
                children: [
                  // Image du produit (simulée avec un cercle jaune pour les bananes)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow, // Simulation d'une image de bananes
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Nom, quantité, prix et poids
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'], // Nom avec la marque (par exemple, "Régime de banane Maggi")
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            // Badge orange pour la quantité
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange, // Fond orange
                                borderRadius: BorderRadius.circular(10), // Coins arrondis
                              ),
                              child: Text(
                                product['quantity'], // Quantité (par exemple, "2")
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white, // Texte blanc
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Prix et poids
                            Text(
                              "${product['price']} ${product['weight']}", // Par exemple, "€16 30g"
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), // Espacement entre les produits
            ],
          ],
        ),
      ),
    );
  }
}