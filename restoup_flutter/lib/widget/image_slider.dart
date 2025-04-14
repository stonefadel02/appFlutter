import 'package:flutter/material.dart';

class ImageSlider extends StatelessWidget {
  final Function(int) onChange;
  final int currentSlide;
  const ImageSlider({
    super.key,
    required this.currentSlide,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    // Liste des images pour le carrousel
    final List<Widget> slides = [
      Image.asset(
        "assets/images/carousel1.png",
        fit: BoxFit.contain, // Affiche l'image en entier
      ),
      Image.asset(
        "assets/images/carousel2.png",
        fit: BoxFit.contain, // Affiche l'image en entier
      ),
    ];

    return Column(
      children: [
        // Conteneur pour l'image
        SizedBox(
          height: 220,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: PageView(
              scrollDirection: Axis.horizontal,
              allowImplicitScrolling: true,
              onPageChanged: onChange,
              physics: const ClampingScrollPhysics(),
              children: slides,
            ),
          ),
        ),
        // Indicateurs en dessous de l'image
        Padding(
          padding: const EdgeInsets.only(top: 5), // Espacement entre l'image et les indicateurs
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              slides.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: currentSlide == index ? 15 : 8,
                height: 8,
                margin: const EdgeInsets.only(right: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: currentSlide == index ? Colors.black : Colors.transparent,
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}