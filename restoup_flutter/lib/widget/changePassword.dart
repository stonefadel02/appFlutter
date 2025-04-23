import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _obscureText = true; // Pour gérer l'affichage/masquage du mot de passe
  bool _obscureText1 = true;
  bool _rememberMe = false;
  final TextEditingController _emailController =
      TextEditingController(); // Contrôleur pour l'email

  @override
  void initState() {
    super.initState();
    // Écoute les changements dans le champ email pour mettre à jour l'icône
    _emailController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose(); // Nettoie le contrôleur
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/images/logoResto 1.png'),
                const SizedBox(height: 40),

                // Texte principal
                Text(
                  'Réinitialisez votre mot de passe',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Au moins 8 caractères, dont des lettres ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'majuscules et minuscules',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 40),

                // Champ Mot de passe avec icône œil
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.05),
                    labelText: 'Mot de Passe',
                    labelStyle: TextStyle(color: AppColors.grayColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.grayColor.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.grayColor.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.grayColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                ),
                const SizedBox(height: 16),

                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.05),
                    labelText: 'Mot de Passe',
                    labelStyle: TextStyle(color: AppColors.grayColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.grayColor.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.grayColor.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText1 ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.grayColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText1 = !_obscureText1;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText1,
                ),
                const SizedBox(height: 24),

                // Bouton "Se connecter"
                ElevatedButton(
                  onPressed: () {
                    // Logique de connexion ici
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
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          shape: const CircleBorder(),
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: Colors.black,
                        ),
                        const Text(
                          'Me rappeler',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
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
