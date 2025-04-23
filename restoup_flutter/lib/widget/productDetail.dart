import 'package:flutter/material.dart';
import 'package:restoup_flutter/widget/cartScreen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? _selectedBrand;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.grey),
                    ),
                    const Text(
                      "Détails produit",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 20),

                // Image + favori
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFF5E1),
                          image: DecorationImage(
                            image: AssetImage("assets/images/bananas.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -10,
                        right: -10,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Nom produit
                const Text(
                  "Régime de Banane",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Prix + quantité
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "9.50€/kg",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_quantity > 1) _quantity--;
                            });
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          _quantity.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _quantity++;
                            });
                          },
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Description
                const Text(
                  "Description : dolor sit amet consectetur. Facilisi nunc orci tristique et mattis at lobortis. Consequat in penatibus varius aliquet lorem viverra tempor tincidunt molestie. Consectetur.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Marques
                const Text(
                  "Marques",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    _buildBrandChip("Maggi"),
                    _buildBrandChip("Knorr"),
                    _buildBrandChip("Oreo"),
                    _buildBrandChip("Doritos"),
                    _buildBrandChip("Hein"),
                    _buildBrandChip("Harcot"),
                  ],
                ),
                const SizedBox(height: 30),

                // Bouton Ajouter panier
                // Bouton Ajouter panier
                Center(
                  child: SizedBox(
                    width: 200, // 👈 Ajuste cette valeur si tu veux plus large
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    );
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(left: 0, right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                      label: const Text(
                        "Ajouter au panier",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandChip(String brand) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: brand,
          groupValue: _selectedBrand,
          onChanged: (String? value) {
            setState(() {
              _selectedBrand = value;
            });
          },
          activeColor: Colors.red,
        ),
        Text(brand, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
