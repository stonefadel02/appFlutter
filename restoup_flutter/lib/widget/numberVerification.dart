import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/widget/changePassword.dart';

class NumberVerification extends StatefulWidget {
  const NumberVerification({super.key});

  @override
  State<NumberVerification> createState() => _NumberVerificationState();
}

class _NumberVerificationState extends State<NumberVerification> {
  final List<TextEditingController> _codeControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Ajouter des listeners pour passer au champ suivant automatiquement
    for (int i = 0; i < _codeControllers.length; i++) {
      _codeControllers[i].addListener(() {
        if (_codeControllers[i].text.length == 1 &&
            i < _codeControllers.length - 1) {
          _focusNodes[i].unfocus();
          FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/images/logoResto 1.png'),
                const SizedBox(height: 40),

                // Texte principal
                Text(
                  'Vérifier le numéro de téléphone',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nous venons d\'envoyer un code au',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grayColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '+229 697 584 85',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grayColor,
                  ),
                ),
                const SizedBox(height: 40),

                // Champs pour le code de vérification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 50,
                      height: 50,
                      child: TextField(
                        controller: _codeControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 1, // Un seul chiffre par champ
                        decoration: InputDecoration(
                          counterText: '', // Masquer le compteur de caractères
                          filled: true,
                          fillColor: AppColors.grayColor.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.grayColor.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.grayColor.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isEmpty && index > 0) {
                            _focusNodes[index].unfocus();
                            FocusScope.of(
                              context,
                            ).requestFocus(_focusNodes[index - 1]);
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // Bouton "Soumettre"
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePassword(),
                      ),
                      (route) => false,
                    );
                    String code =
                        _codeControllers
                            .map((controller) => controller.text)
                            .join();
                    print('Code entré : $code');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 6,
                    shadowColor: AppColors.primaryRed.withOpacity(0.3),
                  ),
                  child: const Text(
                    'Soumettre',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Texte "Renvoyer dans 04:258"
                Container(
                  width: double.infinity, // Pleine largeur comme le bouton
                  height: 50, // Même hauteur que le bouton
                  decoration: BoxDecoration(
                    color: AppColors.grayColor.withOpacity(0.1), // Fond gris
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Même borderRadius que le bouton
                    border: Border.all(
                      color: AppColors.grayColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Renvoyer dans 04:258',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
