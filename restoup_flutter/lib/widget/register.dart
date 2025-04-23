import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/widget/register2.dart';
import 'package:restoup_flutter/widget/resetPassword.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Valider le formulaire
  void _validateAndProceed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    // Passez à l'écran suivant avec email et mot de passe
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Register2(
          email: email,
          password: password,
        ),
      ),
    );
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
                Image.asset('assets/images/logoResto 1.png'),
                const SizedBox(height: 40),
                Text(
                  'Hello! Créer un compte',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Vous avez déjà un compte ? ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grayColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.05),
                    labelText: 'Adresse e-mail',
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
                    suffixIcon: _emailController.text.isNotEmpty
                        ? Icon(
                            Icons.check_circle,
                            color: AppColors.grayColor,
                          )
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
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
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.05),
                    labelText: 'Confirmer mot de passe',
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _validateAndProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 6,
                    shadowColor: AppColors.primaryRed.withOpacity(0.3),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Suivant',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResetPassword(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.grayColor.withOpacity(0.3),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OU',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grayColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.grayColor.withOpacity(0.3),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/Facebook.png',
                        width: 24,
                        height: 24,
                      ),
                      label: const Text(
                        'Facebook',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: AppColors.blueColor.withOpacity(0.1),
                        minimumSize: const Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/Google.png',
                        width: 24,
                        height: 24,
                      ),
                      label: const Text(
                        'Google',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: AppColors.grayColor.withOpacity(0.1),
                        minimumSize: const Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}