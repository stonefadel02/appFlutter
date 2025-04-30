import 'package:flutter/material.dart';
import 'package:restoup_flutter/accueil/notificationScreen.dart';
import 'package:restoup_flutter/services/api_service.dart';
import 'package:restoup_flutter/widget/cartScreen.dart';
import 'package:restoup_flutter/widget/cart_manager.dart';
import 'package:restoup_flutter/accueil/commandes.dart';
import 'package:restoup_flutter/accueil/homeScreen.dart';

class Favoris extends StatefulWidget {
  const Favoris({super.key});

  @override
  State<Favoris> createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {
  List<Map<String, dynamic>> favoriteProducts = [];
  bool _isLoading = true;
  String? _error;
  int _cartItemCount = 0; // To store the number of items in the cart
  final ApiService _apiService = ApiService();
  final CartManager _cartManager = CartManager();
  Map<String, bool> _inCartStatus = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadCartItemCount(); // Load the cart item count
  }

  Future<void> _loadFavorites() async {
    try {
      await _apiService.ensureInitialized();
      final response = await _apiService.getFavorites();
      final favorites = List<Map<String, dynamic>>.from(response['data'] ?? []);
      setState(() {
        favoriteProducts = favorites;
        _isLoading = false;
      });
      // Vérifier l'état du panier pour chaque produit favori
      _checkCartStatus();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCartItemCount() async {
    try {
      final count = await _cartManager.getCartItemCount(); // Assuming this method exists
      setState(() {
        _cartItemCount = count;
      });
    } catch (e) {
      print('Erreur lors du chargement du nombre d\'articles dans le panier: $e');
    }
  }

  Future<void> _checkCartStatus() async {
    final status = <String, bool>{};
    for (var product in favoriteProducts) {
      final productVariantId = product['id']?.toString() ?? '';
      final isInCart = await _cartManager.isInCart(productVariantId);
      status[productVariantId] = isInCart;
    }
    setState(() {
      _inCartStatus = status;
    });
  }

  Future<void> _removeFromFavorites(String productVariantId, int index) async {
    try {
      final response = await _apiService.removeFromFavorites(productVariantId);
      setState(() {
        favoriteProducts.removeAt(index);
        _inCartStatus.remove(productVariantId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['data']['message'])),
      );
      await _loadCartItemCount(); // Update cart item count after removing
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  Future<void> _addToCart(Map<String, dynamic> product) async {
    try {
      final productVariantId = product['id']?.toString() ?? '';
      await _cartManager.addToCart(
        name: product['productName']?.toString() ?? 'Nom inconnu',
        price: product['price'] != null
            ? '€${product['price']}/${product['productUnit'] ?? 'unité'}'
            : '€0.0/unité',
        image: product['imageUrl']?.toString() ?? 'assets/images/product.png',
        quantity: 1, // Quantité par défaut
        brand: product['brandName']?.toString() ?? 'Marque inconnue',
        productVariantId: productVariantId,
      );
      setState(() {
        _inCartStatus[productVariantId] = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit ajouté au panier')),
      );
      await _loadCartItemCount(); // Update cart item count after adding
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout au panier: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white, // White background for loading
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.white, // White background for error
        body: Center(child: Text('Erreur : $_error')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Mes Favoris",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 28,
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                  size: 28,
                ),
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text(
                    "Votre liste de produits favoris. Appuyez directement sur les produits en clic pour commander",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 24),
                favoriteProducts.isEmpty
                    ? const Center(child: Text('Aucun produit favori.'))
                    : Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: favoriteProducts.length,
                          itemBuilder: (context, index) {
                            final product = favoriteProducts[index];
                            final productVariantId = product['id']?.toString() ?? '';
                            final name = product['productName']?.toString() ?? 'Nom inconnu';
                            final price = product['price'] != null
                                ? '€${product['price']}/${product['productUnit'] ?? 'unité'}'
                                : '€0.0/unité';
                            final image = product['imageUrl']?.toString() ?? 'assets/images/product.png';
                            final isInCart = _inCartStatus[productVariantId] ?? false;

                            return GestureDetector(
                              onTap: isInCart
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const CartScreen(),
                                        ),
                                      );
                                    }
                                  : () => _addToCart(product),
                              child: Card(
                                color: Colors.grey[200],
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 24),
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                              image: DecorationImage(
                                                image: image.startsWith('http')
                                                    ? NetworkImage(image)
                                                    : AssetImage(image) as ImageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () => _removeFromFavorites(productVariantId, index),
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
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "En poids ${product['productUnit'] != null ? '1,32€/${product['productUnit']}' : '1,32€/kg'}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            price,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          if (isInCart)
                                            const Text(
                                              "Dans le panier",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 100,
              child: Visibility(
                visible: _inCartStatus.containsValue(true),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_cart,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Aller au panier",
                          style: TextStyle(
                            fontSize: 12,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Commandes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoris",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Commandes()),
            );
          }
        },
      ),
    );
  }
}