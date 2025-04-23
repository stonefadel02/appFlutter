import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/services/api_service.dart';
import 'package:restoup_flutter/widget/registerSuccess.dart';

class Register4 extends StatefulWidget {
  final String email;
  final String password;
  final String contactName;
  final String contactFirstName;
  final String siret;
  final String companyName;
  final String postalAddress;
  final String? identityDocumentUrl;

  const Register4({
    super.key,
    required this.email,
    required this.password,
    required this.contactName,
    required this.contactFirstName,
    required this.siret,
    required this.companyName,
    required this.postalAddress,
    this.identityDocumentUrl,
  });

  @override
  State<Register4> createState() => _Register4State();
}

class _Register4State extends State<Register4> {
  final TextEditingController _addressController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addressController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer une adresse de livraison')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.register(
        email: widget.email,
        password: widget.password,
        companyName: widget.companyName,
        contactName: widget.contactName,
        contactFirstName: widget.contactFirstName,
        siret: widget.siret,
        postalAddress: widget.postalAddress,
        identityDocumentUrl: widget.identityDocumentUrl,
        deliveryAddress: _addressController.text.trim(),
      );

      if (response['error'] == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegisterSuccess()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${response['error']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'inscription: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                  'Où allons-nous vous livrer ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Afin de vous livrer à la bonne adresse, veuillez',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grayColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'entrer votre localisation.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grayColor,
                  ),
                ),
                const SizedBox(height: 40),
                Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {});
                  },
                  child: TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.grayColor.withOpacity(0.1),
                      hintText: "Adresse",
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
                      suffixIcon: Icon(
                        Icons.location_on,
                        color: AppColors.grayColor,
                      ),
                    ),
                    keyboardType: TextInputType.streetAddress,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 6,
                    shadowColor: AppColors.primaryRed.withOpacity(0.3),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Continuer',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
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