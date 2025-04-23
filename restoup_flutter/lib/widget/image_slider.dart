import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';

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
    final List<String> imagePaths = [
      "assets/images/carousel1.png",
      "assets/images/carousel2.png",
    ];

    final PageController controller = PageController(viewportFraction: 0.9);

    return Column(
      children: [
        SizedBox(
          height: 220,
          width: double.infinity,
          child: PageView.builder(
            controller: controller,
            scrollDirection: Axis.horizontal,
            onPageChanged: onChange,
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5), // <-- ESPACE ENTRE LES IMAGES
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagePaths[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              imagePaths.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: currentSlide == index ? 15 : 8,
                height: 8,
                margin: const EdgeInsets.only(right: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: currentSlide == index ? AppColors.primaryRed : Colors.transparent,
                  border: Border.all(
                    color: AppColors.primaryRed,
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
