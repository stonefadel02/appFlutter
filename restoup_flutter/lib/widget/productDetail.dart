import 'package:flutter/material.dart';
import 'package:restoup_flutter/widget/cartScreen.dart';
import 'package:restoup_flutter/widget/cart_manager.dart';
import 'package:restoup_flutter/services/api_service.dart';
import 'package:restoup_flutter/widget/login.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productVariantId;

  const ProductDetailsScreen({
    super.key,
    required this.productVariantId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? _selectedBrand;
  int _quantity = 1;
  double _unitPrice = 0.0;
  Map<String, dynamic>? _variantData;
  bool _isLoading = true;
  bool _isFavoriteLoading = false;
  bool _isFavorite = false;
  String? _error;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthentication();
    });
  }

  Future<void> _checkAuthentication() async {
    if (!mounted) return;
    await apiService.ensureInitialized();
    if (!apiService.isAuthenticated()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return;
    }
    await _loadVariantDetails();
    await _checkIfFavorite();
  }

  Future<void> _loadVariantDetails() async {
    try {
      final response = await apiService.getProductVariantById(widget.productVariantId);
      if (!mounted) return;

      print('Détails de la variante reçus: $response');

      setState(() {
        _variantData = response['data'];
        if (_variantData != null && _variantData!['price'] != null) {
          _unitPrice = _variantData!['price'].toDouble();
        } else {
          _unitPrice = 0.0;
        }
        _selectedBrand = _variantData?['brand']?['name']?.toString();
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur dans _loadVariantDetails: $e');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _checkIfFavorite() async {
    try {
      final favoritesResponse = await apiService.getFavorites();
      final favorites = favoritesResponse['data'] as List<dynamic>;
      setState(() {
        _isFavorite = favorites.any((fav) => fav['id'] == widget.productVariantId);
      });
    } catch (e) {
      print('Erreur lors de la vérification des favoris: $e');
    }
  }

    Future<void> _toggleFavorite() async {
    setState(() {
      _isFavoriteLoading = true;
    });

    try {
      if (_isFavorite) {
        final response = await apiService.removeFromFavorites(widget.productVariantId);
        setState(() {
          _isFavorite = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['data']['message'])),
        );
      } else {
        await apiService.addToFavorites(widget.productVariantId);
        setState(() {
          _isFavorite = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit ajouté aux favoris')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    } finally {
      setState(() {
        _isFavoriteLoading = false;
      });
    }
  }

  double _extractUnitPrice(String priceString) {
    final pricePart = priceString.split('/')[0].replaceAll('€', '');
    return double.tryParse(pricePart) ?? 0.0;
  }

  String _calculateTotalPrice() {
    final totalPrice = _unitPrice * _quantity;
    final unit = _variantData?['product']?['unit']?.toString() ?? 'unité';
    return '€${totalPrice.toStringAsFixed(2)}/$unit';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text('Erreur : $_error')),
      );
    }

    final name = _variantData?['product']?['name']?.toString() ?? 'Nom inconnu';
    final price = _variantData != null && _variantData!['price'] != null
        ? '€${_variantData!['price']}/${_variantData!['product']?['unit'] ?? 'unité'}'
        : '€0.0/unité';
    final details = _variantData?['product']?['description']?.toString() ?? '';
    final image = _variantData?['imageUrl']?.toString() ?? 'assets/images/product.png';
    final brands = _variantData?['brand']?['name'] != null ? [_variantData!['brand']['name']] : ['Marque inconnue'];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFF5E1),
                          image: DecorationImage(
                            image: image.startsWith('http')
                                ? NetworkImage(image)
                                : AssetImage(image) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -10,
                        right: -10,
                        child: IconButton(
                          onPressed: _isFavoriteLoading ? null : _toggleFavorite,
                          icon: _isFavoriteLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(
                                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: _isFavorite ? Colors.red : Colors.grey,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _calculateTotalPrice(),
                      style: const TextStyle(
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
                Text(
                  "Description : ${details.isNotEmpty ? details : 'Aucune description disponible.'}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Marques",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: brands.map((brand) => _buildBrandChip(brand)).toList(),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (!mounted) return;
                        await CartManager().addToCart(
                          name: name,
                          price: _calculateTotalPrice(),
                          image: image,
                          quantity: _quantity,
                          brand: _selectedBrand ?? brands[0],
                          productVariantId: widget.productVariantId,
                        );
                        if (!mounted) return;
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
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
            if (!mounted) return;
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