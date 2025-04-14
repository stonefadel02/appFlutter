import 'package:flutter/material.dart';

class Favoris extends StatelessWidget {
  const Favoris({super.key});

  // Liste fictive des produits favoris
  final List<Map<String, dynamic>> favoriteProducts = const [
    {
      'name': 'Poulet',
      'price': '€31,32/kg',
      'image': 'assets/images/poulet.png',
      'inCart': false,
    },
    {
      'name': 'Huile de tournesol',
      'price': '€0,82/l',
      'image': 'assets/images/huile.png',
      'inCart': false,
    },
    {
      'name': 'Laitue',
      'price': '€31,32',
      'image': 'assets/images/laitue.png',
      'inCart': true, // Ce produit est dans le panier
    },
    {
      'name': 'Aubergine',
      'price': '€0,825/kg',
      'image': 'assets/images/aubergine.png',
      'inCart': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // En-tête
      appBar: AppBar(
        title: const Text(
          "Mes Favoris",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
        ],
      ),

      // Corps de la page
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            const Text(
              "Votre liste de produits favoris. Appuyez directement sur les produits en clic pour commander",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Grille des produits favoris
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 colonnes
                  crossAxisSpacing: 16, // Espacement horizontal entre les éléments
                  mainAxisSpacing: 16, // Espacement vertical entre les éléments
                  childAspectRatio: 0.75, // Ratio pour ajuster la hauteur des cartes
                ),
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = favoriteProducts[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image du produit
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
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
                              // Icône de cœur (favori)
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
                        ),
                        // Nom et prix du produit
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
                              Text(
                                product['price'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Bouton "Aller au panier" (visible si le produit est dans le panier)
                              if (product['inCart'])
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Action pour aller au panier (non implémentée pour l'instant)
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "Aller au panier",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
      ),
    );
  }
}