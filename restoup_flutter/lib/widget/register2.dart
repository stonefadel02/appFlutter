import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/widget/register3.dart';
class Register2 extends StatefulWidget {
  const Register2({super.key});

  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {

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

  // Fonction pour sélectionner un fichier
  // Future<void> _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'], // Extensions autorisées
  //   );

  //   if (result != null) {
  //     setState(() {
  //       _selectedFile = result;
  //       _emailController.text = result.files.single.name; // Afficher le nom du fichier
  //     });
  //   }
  // }

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
                  'Hello! Créer un compte',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Finaliser la création de votre compte',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue.withOpacity(0.5),
                  ),
                ),
                
                const SizedBox(height: 40),

                // Champ Nom d'utilisateur ou Email avec icône conditionnelle
                TextField(
                  controller: _emailController, // Ajoute le contrôleur
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "Nom",
                    labelStyle: TextStyle(color: AppColors.grayColor),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primaryRed),
                    ),
                    suffixIcon:
                        _emailController.text.isNotEmpty
                            ? Icon(
                              Icons.check_circle, // Icône de validation (coche)
                              color:
                                  AppColors
                                      .grayColor, // Même couleur que le label
                            )
                            : null, // Aucune icône si le champ est vide
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _emailController, // Ajoute le contrôleur
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "Prenom",
                    labelStyle: TextStyle(color: AppColors.grayColor),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primaryRed),
                    ),
                    suffixIcon:
                        _emailController.text.isNotEmpty
                            ? Icon(
                              Icons.check_circle, // Icône de validation (coche)
                              color:
                                  AppColors
                                      .grayColor, // Même couleur que le label
                            )
                            : null, // Aucune icône si le champ est vide
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _emailController, // Ajoute le contrôleur
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "SIRET",
                    labelStyle: TextStyle(color: AppColors.grayColor),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primaryRed),
                    ),
                    suffixIcon:
                        _emailController.text.isNotEmpty
                            ? Icon(
                              Icons.check_circle, // Icône de validation (coche)
                              color:
                                  AppColors
                                      .grayColor, // Même couleur que le label
                            )
                            : null, // Aucune icône si le champ est vide
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _emailController, // Ajoute le contrôleur
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "Raison Sociale",
                    labelStyle: TextStyle(color: AppColors.grayColor),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primaryRed),
                    ),
                    suffixIcon:
                        _emailController.text.isNotEmpty
                            ? Icon(
                              Icons.check_circle, // Icône de validation (coche)
                              color:
                                  AppColors
                                      .grayColor, // Même couleur que le label
                            )
                            : null, // Aucune icône si le champ est vide
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _emailController, // Ajoute le contrôleur
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "Addresse postale",
                    labelStyle: TextStyle(color: AppColors.grayColor),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primaryRed),
                    ),
                    suffixIcon:
                        _emailController.text.isNotEmpty
                            ? Icon(
                              Icons.check_circle, // Icône de validation (coche)
                              color:
                                  AppColors
                                      .grayColor, // Même couleur que le label
                            )
                            : null, // Aucune icône si le champ est vide
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Champ pour sélectionner un fichier
                // GestureDetector(
                //   onTap: _pickFile, // Déclencher la sélection de fichier
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: AppColors.grayColor.withOpacity(0.1),
                //       borderRadius: BorderRadius.circular(8),
                //       border: Border.all(
                //         color: _selectedFile != null
                //             ? AppColors.primaryRed
                //             : AppColors.grayColor.withOpacity(0.3),
                //         width: 1,
                //       ),
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //       child: Row(
                //         children: [
                //           Expanded(
                //             child: Text(
                //               _selectedFile != null
                //                   ? _emailController.text
                //                   : "Sélectionnez un fichier",
                //               style: TextStyle(
                //                 color: _selectedFile != null
                //                     ? Colors.black
                //                     : AppColors.grayColor,
                //                 fontSize: 16,
                //               ),
                //             ),
                //           ),
                //           _selectedFile != null
                //               ? Icon(
                //                   Icons.check_circle,
                //                   color: AppColors.grayColor,
                //                 )
                //               : const SizedBox.shrink(),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 16),
                

                

                  ElevatedButton(
                  onPressed: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register3()),
                    );
                   
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
                        'Valider',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),                    ],
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
