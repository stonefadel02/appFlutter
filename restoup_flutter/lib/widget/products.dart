import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre "Produits populaires"
          const Text(
            "Produits populaires",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 10),

          // Grille de produits
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final products = [
                {
                  'name': 'Poulet',
                  'price': '€1.32/2kg',
                  'details': 'En poids 1,32€/kg',
                  'image': 'assets/images/product.png',
                  'isFavorite': false,
                },
                {
                  'name': 'Huile de tournesol',
                  'price': '€0.82/L',
                  'details': '',
                  'image': 'assets/images/product.png',
                  'isFavorite': true,
                },
                {
                  'name': 'Salade',
                  'price': '€0.50/unité',
                  'details': '',
                  'image': 'assets/images/product.png',
                  'isFavorite': true,
                },
                {
                  'name': 'Aubergine',
                  'price': '€1.20/kg',
                  'details': '',
                  'image': 'assets/images/product.png',
                  'isFavorite': true,
                },
              ];

              return ProductCard(
                name: products[index]['name'] as String,
                price: products[index]['price'] as String,
                details: products[index]['details'] as String,
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

class ProductCard extends StatefulWidget {
  final String name;
  final String price;
  final String details;
  final String image;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.details,
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
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
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
          // Image et icône favori
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
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
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Titre, détail, prix, panier
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre (nom)
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Détail (gris) s’il y en a un
                if (widget.details.isNotEmpty)
                  Text(
                    widget.details,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                if (widget.details.isNotEmpty) const SizedBox(height: 0),

                // Prix + bouton panier
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        print("${widget.name} ajouté au panier");
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.red,
                          size: 18,
                        ),
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
