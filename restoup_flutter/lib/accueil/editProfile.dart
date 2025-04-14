import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Contrôleurs pour les champs de texte
  final TextEditingController _nameController = TextEditingController(text: "Jos");
  final TextEditingController _emailController = TextEditingController(text: "jos.creative@gmail.com");
  final TextEditingController _phoneController = TextEditingController(text: "784 679 0087");
  final TextEditingController _addressController = TextEditingController(text: "Rue 239 Paris Westerlay");
  final TextEditingController _fileController = TextEditingController(text: "jos.creative.pdf");

  @override
  void dispose() {
    // Libérer les contrôleurs
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _fileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre personnalisé avec flèche de retour
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context); // Retour à la page précédente
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      "Votre Profil",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48), // Espace pour équilibrer la disposition
                  ],
                ),
                const SizedBox(height: 20),

                // Sous-titre
                const Text(
                  "Mettez à jour vos informations",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),

                // Champ pour le nom
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nom",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Champ pour l'e-mail
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "E-mail",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Champ pour le numéro de téléphone
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: "Numéro de téléphone",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                // Champ pour l'adresse
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: "Adresse",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Champ pour le fichier PDF
                TextField(
                  controller: _fileController,
                  readOnly: true, // Champ non éditable directement
                  decoration: InputDecoration(
                    labelText: "Fichier PDF",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // Logique pour sélectionner un fichier
                      },
                      icon: const Icon(
                        Icons.upload_file,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Bouton "Sauvegarder" aligné à gauche avec largeur réduite
                SizedBox(
                  width: 200, // Largeur réduite
                  child: ElevatedButton(
                    onPressed: () {
                      // Logique pour sauvegarder les informations
                      print("Nom: ${_nameController.text}");
                      print("E-mail: ${_emailController.text}");
                      print("Téléphone: ${_phoneController.text}");
                      print("Adresse: ${_addressController.text}");
                      print("Fichier: ${_fileController.text}");
                    },
                    child: const Text(
                      "Sauvegarder",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}