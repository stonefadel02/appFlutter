import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/services/api_service.dart';
import 'package:restoup_flutter/widget/productDetail.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Produits populaires",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<Map<String, dynamic>>(
            future: () async {
              await apiService.ensureInitialized();
              return apiService.getProductVariants(page: 1, limit: 4);
            }(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                print('Erreur détaillée: ${snapshot.error}');
                return Center(
                  child: Text(
                    'Erreur lors du chargement des produits: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!['data'] == null) {
                return const Center(child: Text('Aucun produit trouvé.'));
              }

              print('Données reçues: ${snapshot.data}');

              if (snapshot.data!['data']['variants'] == null) {
                return const Center(
                  child: Text('Structure de données incorrecte.'),
                );
              }

              final variants = snapshot.data!['data']['variants'] as List<dynamic>;

              if (variants.isEmpty) {
                return const Center(child: Text('Aucun produit disponible.'));
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: variants.length,
                itemBuilder: (context, index) {
                  final variant = variants[index];
                  final productName = variant['productName']?.toString() ?? 'Nom inconnu';
                  final price = variant['price']?.toString() ?? '0.0';
                  final productUnit = variant['productUnit']?.toString() ?? 'unité';
                  final productVariantId = variant['id']?.toString() ?? '';

                  if (productVariantId.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return ProductCard(
                    name: productName,
                    price: '€$price/$productUnit',
                    details: variant['productDescription']?.toString() ?? '',
                    image: variant['imageUrl']?.toString() ?? 'assets/images/product.png',
                    productVariantId: productVariantId,
                  );
                },
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
  final String productVariantId;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.details,
    required this.image,
    required this.productVariantId,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    try {
      final favoritesResponse = await _apiService.getFavorites();
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
      _isLoading = true;
    });

    try {
      if (_isFavorite) {
        final response = await _apiService.removeFromFavorites(widget.productVariantId);
        setState(() {
          _isFavorite = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['data']['message'])),
        );
      } else {
        await _apiService.addToFavorites(widget.productVariantId);
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
        _isLoading = false;
      });
    }
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
                          image: widget.image.startsWith('http')
                              ? NetworkImage(widget.image)
                              : AssetImage(widget.image) as ImageProvider,
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
                  onTap: _isLoading ? null : _toggleFavorite,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.grey,
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
                  widget.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                if (widget.details.isNotEmpty)
                  Text(
                    widget.details,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                if (widget.details.isNotEmpty) const SizedBox(height: 0),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              productVariantId: widget.productVariantId,
                            ),
                          ),
                        );
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