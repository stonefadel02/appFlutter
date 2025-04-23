import 'package:flutter/material.dart';

class PriceRangeScreen extends StatefulWidget {
  const PriceRangeScreen({super.key});

  @override
  State<PriceRangeScreen> createState() => _PriceRangeScreenState();
}

class _PriceRangeScreenState extends State<PriceRangeScreen> {
  RangeValues _priceRange = const RangeValues(100, 1500);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  const Text(
                    "Fourchette de prix",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 100),

          // Slider avec bulle au-dessus
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              showValueIndicator: ShowValueIndicator.always,
              rangeValueIndicatorShape:
                  const PaddleRangeSliderValueIndicatorShape(),
              valueIndicatorColor: Colors.red,
              valueIndicatorTextStyle: const TextStyle(color: Colors.white),
            ),
            child: RangeSlider(
              values: _priceRange,
              min: 100,
              max: 1500,
              divisions: 14,
              labels: RangeLabels(
                "${_priceRange.start.round()}€",
                "${_priceRange.end.round()}€",
              ),
              activeColor: Colors.yellow,
              inactiveColor: Colors.grey[300],
              onChanged: (RangeValues values) {
                setState(() {
                  _priceRange = values;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          // Affichage des valeurs dans des boîtes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${_priceRange.start.round()}€/kg",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "-",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${_priceRange.end.round()}€/kg",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),

          const Spacer(), // Pousse tout vers le haut, et laisse le bouton en bas
          // Bouton "Appliquer"
          Center(
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    "${_priceRange.start.round()}€/kg - ${_priceRange.end.round()}€/kg",
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Appliquer",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
