import 'package:flutter/material.dart';
import 'package:restoup_flutter/widget/appBar.dart';
import 'package:restoup_flutter/widget/image_slider.dart';
import 'package:restoup_flutter/widget/products.dart';
import 'package:restoup_flutter/widget/searchBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlide = 0; // Variable pour suivre la diapositive actuelle

  // Fonction appelée lorsque l'utilisateur change de diapositive
  void onChange(int index) {
    setState(() {
      currentSlide = index; // Met à jour l'index de la diapositive
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Utiliser l'AppBar de Scaffold pour rendre CustomeAppBar fixe
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70), // Ajuste la hauteur selon tes besoins
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.white, // Fond blanc pour l'AppBar
          child: SafeArea(
            child: CustomeAppBar(),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Couleur de fond
        ),
        child: SingleChildScrollView(
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
              Container(
                child: MySearchBAR(),
              ),

              // Section des produits
              Container(
                child: Products(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}