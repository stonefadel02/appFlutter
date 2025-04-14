import 'package:flutter/material.dart';

class CancelReasonPopup extends StatefulWidget {
  final Function(String) onSubmit; // Callback pour gérer l'annulation avec la raison

  const CancelReasonPopup({super.key, required this.onSubmit});

  @override
  State<CancelReasonPopup> createState() => _CancelReasonPopupState();
}

class _CancelReasonPopupState extends State<CancelReasonPopup> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // S'adapte à la taille du contenu
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre et icône de fermeture
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Motif d'annulation",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Background gris pour l'icône
                    shape: BoxShape.circle, // Forme circulaire
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Ferme le popup
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            const Text(
              "Veuillez saisir la raison de l'annulation",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Champ de texte pour la raison
            TextField(
              controller: _reasonController,
              maxLines: 4, // Multiligne
              decoration: InputDecoration(
                hintText: "Entrez un message",
                filled: true, // Active le fond
                fillColor: Colors.grey[200], // Background gris pour le champ de texte
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bouton "Envoyer"
            Center(
              child: SizedBox(
                width: 200, // Largeur réduite pour le bouton
                child: ElevatedButton(
                  onPressed: () {
                    final reason = _reasonController.text;
                    if (reason.isNotEmpty) {
                      widget.onSubmit(reason); // Appelle le callback avec la raison
                      Navigator.pop(context); // Ferme le popup
                    } else {
                      // Affiche un message d'erreur si le champ est vide
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Veuillez entrer une raison"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
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
                    "Envoyer",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}