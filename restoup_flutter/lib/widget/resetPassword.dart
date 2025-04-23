import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:restoup_flutter/widget/numberVerification.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+229';
  bool _isFocused = false; // Pour gérer l'état de focus

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
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
                const SizedBox(height: 32),

                // Texte principal
                Text(
                  'Récupération de Mot de Passe',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Entrez votre Numéro de téléphone',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grayColor,
                  ),
                ),
                const SizedBox(height: 40),

                // Texte "Numéro Téléphone" aligné à gauche
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Numéro Téléphone',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grayColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Champ unifié avec sélecteur de code de pays et numéro de téléphone
                Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      _isFocused = hasFocus;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.grayColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isFocused ? AppColors.primaryRed : AppColors.grayColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Sélecteur de code de pays
                        CountryCodePicker(
                          onChanged: (countryCode) {
                            setState(() {
                              _selectedCountryCode = countryCode.dialCode ?? '+229';
                            });
                          },
                          initialSelection: 'BJ',
                          favorite: ['+229', 'BJ'],
                          showCountryOnly: false,
                          showFlag: true,
                          showFlagDialog: true,
                          textStyle: TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 16,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          backgroundColor: Colors.transparent, // Fond transparent pour s'intégrer
                        ),

                        // Séparateur visuel (optionnel)
                        Container(
                          width: 1,
                          height: 30,
                          color: AppColors.grayColor.withOpacity(0.3),
                        ),

                        // Champ pour le numéro de téléphone
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              hintText: "697 380 040",
                              hintStyle: TextStyle(color: AppColors.grayColor),
                              border: InputBorder.none, // Pas de bordure individuelle
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              suffixIcon: _phoneController.text.isNotEmpty
                                  ? Icon(
                                      Icons.check_circle,
                                      color: AppColors.grayColor,
                                    )
                                  : null,
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Bouton "Se connecter"
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => const NumberVerification()),
                                      (route) => false,
                    );
                    String fullPhoneNumber = '$_selectedCountryCode${_phoneController.text}';
                    print('Numéro complet : $fullPhoneNumber');
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Se connecter',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
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