import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre "Produits populaires"
          const Text(
            "Produits populaires",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Couleur bleue comme dans la maquette
            ),
          ),
          const SizedBox(height: 10),

          // Grille de produits scrollable verticalement (2 colonnes)
          GridView.builder(
            shrinkWrap: true, // Permet à la grille de s'adapter à son contenu
            physics: const NeverScrollableScrollPhysics(), // Le défilement est géré par le parent
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 colonnes
              crossAxisSpacing: 10, // Espacement horizontal entre les cartes
              mainAxisSpacing: 10, // Espacement vertical entre les cartes
              childAspectRatio: 0.75, // Ratio hauteur/largeur pour les cartes
            ),
            itemCount: 4, // Nombre de produits (peut être dynamique)
            itemBuilder: (context, index) {
              // Liste de produits (données statiques pour l'exemple)
              final products = [
                {
                  'name': 'Poulet',
                  'price': '€1.32/2kg',
                  'image': 'assets/images/product.png', // Remplace par le chemin de ton image
                  'isFavorite': false,
                },
                {
                  'name': 'Huile de tournesol',
                  'price': '€0.82/L',
                  'image': 'assets/images/product.png', // Remplace par le chemin de ton image
                  'isFavorite': true,
                },
                {
                  'name': 'Salade',
                  'price': '€0.50/unité',
                  'image': 'assets/images/product.png', // Remplace par le chemin de ton image
                  'isFavorite': true,
                },
                {
                  'name': 'Aubergine',
                  'price': '€1.20/kg',
                  'image': 'assets/images/product.png', // Remplace par le chemin de ton image
                  'isFavorite': true,
                },
              ];

              return ProductCard(
                name: products[index]['name'] as String,
                price: products[index]['price'] as String,
                image: products[index]['image'] as String,
                isFavorite: products[index]['isFavorite'] as bool,
              );
            },
          ),
        ],
      ),
    );
  }
}

// Widget pour une carte de produit
class ProductCard extends StatefulWidget {
  final String name;
  final String price;
  final String image;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.isFavorite,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite; // Initialiser l'état du favori
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Fond gris clair pour chaque produit
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image circulaire et icône de cœur
          Stack(
            alignment: Alignment.center,
            children: [
              // Image circulaire du produit
              Padding(
                padding: const EdgeInsets.only(top: 10), // Espacement en haut pour centrer l'image
                child: Center(
                  child: ClipOval(
                    child: Container(
                      width: 100, // Taille du cercle
                      height: 100, // Taille du cercle
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Icône de cœur
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isFavorite = !_isFavorite; // Basculer l'état du favori
                    });
                  },
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.grey,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          // Contenu (nom, prix, icône de panier)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom du produit
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // Gérer les noms trop longs
                ),
                const SizedBox(height: 5),

                // Prix et icône de panier
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.price,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Logique pour ajouter au panier
                        print("${widget.name} ajouté au panier");
                      },
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}