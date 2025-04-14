

class UnbordingContent {
  String image;
  String title;
  String description;

  UnbordingContent({required this.image, required this.title, required this.description});
}

List<UnbordingContent> contents = [
   
  UnbordingContent(
    title: "Simplifiez vos achats ",
    image: "assets/images/Group.png",
    description: "Plus besoin de perdre du temps au marché. Commandez vos produits vivriers en quelques clics et concentrez-vous sur ce que vous faites de mieux : cuisiner ! ",
  ),
  UnbordingContent(
    title: "Livrés dès le lendemain ",
    image: "assets/images/Layer_1.png",
    description: "Votre commande est préparée et livrée rapidement. Plus de stress, gagnez du temps et optimisez vos opérations. ",
  ),
  UnbordingContent(
    title: "Gérez mieux votre restaurant",
    image: "assets/images/Frame.png",
    description: "Planifiez vos commandes, suivez vos livraisons en temps réel et assurez un stock toujours bien rempli. Resto Up, votre allié au quotidien ! ",
  ),

];
