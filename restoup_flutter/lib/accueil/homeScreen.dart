import 'package:flutter/material.dart';
import 'package:restoup_flutter/accueil/notificationScreen.dart';
import 'package:restoup_flutter/widget/image_slider.dart';
import 'package:restoup_flutter/widget/products.dart';
import 'package:restoup_flutter/widget/searchBar.dart';
import 'package:restoup_flutter/widget/cartScreen.dart';
import 'package:restoup_flutter/widget/cart_manager.dart'; // For cart product count
import 'package:restoup_flutter/accueil/commandes.dart';
import 'package:restoup_flutter/accueil/favoris.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlide = 0; // Variable pour suivre la diapositive actuelle
  int _cartItemCount = 0; // To store the number of items in the cart
  final CartManager _cartManager = CartManager(); // Cart manager instance

  @override
  void initState() {
    super.initState();
    _loadCartItemCount(); // Load the cart item count
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

  // Fonction appelée lorsque l'utilisateur change de diapositive
  void onChange(int index) {
    setState(() {
      currentSlide = index; // Met à jour l'index de la diapositive
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Accueil",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carrousel juste après l'AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2), // Marges horizontales
              child: ImageSlider(
                currentSlide: currentSlide,
                onChange: onChange,
              ),
            ),

            // Ton Searchbar personnalisé
            MySearchBAR(),

            // Section des produits
            Products(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Commandes()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Favoris()),
            );
          }
        },
      ),
    );
  }
}