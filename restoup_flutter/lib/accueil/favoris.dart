import 'package:flutter/material.dart';

class Favoris extends StatelessWidget {
  const Favoris({super.key});

  // Liste fictive des produits favoris
  final List<Map<String, dynamic>> favoriteProducts = const [
    {
      'name': 'Poulet',
      'price': '€31,32/kg',
      'image': 'assets/images/product.png',
      'inCart': false,
    },
    {
      'name': 'Huile de tournesol',
      'price': '€0,82/l',
      'image': 'assets/images/product.png',
      'inCart': false,
    },
    {
      'name': 'Laitue',
      'price': '€31,32',
      'image': 'assets/images/product.png',
      'inCart': true, // Ce produit est dans le panier
    },
    {
      'name': 'Aubergine',
      'price': '€0,825/kg',
      'image': 'assets/images/product.png',
      'inCart': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // En-tête
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Mes Favoris",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Centre le titre
        actions: [
          IconButton(
            onPressed: () {
              // Action pour ouvrir le panier (non implémentée pour l'instant)
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black,
              size: 28,
            ),
          ),
          IconButton(
            onPressed: () {
              // Action pour ouvrir les notifications (non implémentée pour l'instant)
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
      ),

      // Corps de la page
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description légèrement centrée à gauche
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: const Text(
                    "Votre liste de produits favoris. Appuyez directement sur les produits en clic pour commander",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 24),

                // Grille des produits favoris (défilante)
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 colonnes
                      crossAxisSpacing: 16, // Espacement horizontal
                      mainAxisSpacing: 16, // Espacement vertical
                      childAspectRatio: 0.65, // Réduit la hauteur relative de l'image
                    ),
                    itemCount: favoriteProducts.length,
                    itemBuilder: (context, index) {
                      final product = favoriteProducts[index];
                      return Card(
                        color: Colors.grey[200], // Fond gris pour la carte
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image du produit avec icône de cœur superposée
                            Stack(
                              children: [
                                // Image décalée vers le bas
                                Padding(
                                  padding: const EdgeInsets.only(top: 24), // Décalage vers le bas
                                  child: Container(
                                    height: 100, // Hauteur fixe pour l'image
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage(product['image']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                // Icône de cœur en haut à droite
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Nom, poids et prix du produit
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "En poids 1,32€/kg",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product['price'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Bouton "Aller au panier" superposé en bas (réduit)
            Positioned(
              left: 16,
              right: 16,
              bottom: 100,
              child: Visibility(
                visible: favoriteProducts.any((product) => product['inCart']),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Action pour aller au panier (non implémentée pour l'instant)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Réduit le padding vertical
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3), // Réduit le padding de l'icône
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_cart,
                            color: Colors.red,
                            size: 16, // Réduit la taille de l'icône
                          ),
                        ),
                        const SizedBox(width: 6), // Réduit l'espacement
                        const Text(
                          "Aller au panier",
                          style: TextStyle(
                            fontSize: 12, // Réduit la taille du texte
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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