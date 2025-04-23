import 'package:flutter/material.dart';

class OrderDetailsPopup extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const OrderDetailsPopup({super.key, required this.products});

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
                // Icône de fermeture avec fond gris
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Fond gris
                    shape: BoxShape.circle, // Forme circulaire
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Ferme le popup
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero, // Supprime le padding par défaut de l'IconButton
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Liste des produits
            for (var product in products) ...[
              Row(
                children: [
                  // Image réelle du produit
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Coins arrondis pour l'image
                    ),
                    child: Image.asset(
                      'assets/images/product.png', // Remplace par le chemin de ton image
                      fit: BoxFit.cover, // Ajuste l'image pour remplir le conteneur
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Nom, "Maggi", quantité, prix et poids
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              product['name'].split(' ')[0], // "Régime" (partie avant "de")
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            const SizedBox(width: 4),
                            Text(
                              product['name'].split(' ').sublist(1).join(' '), // "de banane" (partie après "de")
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                            const Text(
                              "Maggi", // "Maggi" comme élément séparé
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
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