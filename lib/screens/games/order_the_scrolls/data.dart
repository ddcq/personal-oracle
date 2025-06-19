
import 'model.dart';

List<MythStory> getMythStories() {
  return [
    MythStory(
      title: 'La mort de Baldr',
      correctOrder: [
        MythCard(id: '1', title: 'Cauchemars de Baldr', description: 'Baldr fait des cauchemars prophétiques.'),
        MythCard(id: '2', title: 'Le serment de Frigg', description: 'Frigg fait jurer à tous les êtres de ne pas lui nuire.'),
        MythCard(id: '3', title: 'Le gui', description: 'Loki découvre que le gui n\'a pas juré.'),
        MythCard(id: '4', title: 'La flèche', description: 'Loki fabrique une flèche en gui et trompe Höd.'),
        MythCard(id: '5', title: 'La mort de Baldr', description: 'Höd tire la flèche et tue Baldr.'),
      ],
    ),
    MythStory(
      title: 'Le marteau de Thor',
      correctOrder: [
        MythCard(id: '1', title: 'Mjöllnir est volé', description: 'Thrym vole le marteau de Thor.'),
        MythCard(id: '2', title: 'Le chantage de Thrym', description: 'Il exige la main de Freyja pour le rendre.'),
        MythCard(id: '3', title: 'Déguisement', description: 'Thor se déguise en Freyja et part chez les géants.'),
        MythCard(id: '4', title: 'Le festin', description: 'Thor mange avec voracité, les géants doutent.'),
        MythCard(id: '5', title: 'Récupération', description: 'Thor récupère Mjöllnir et massacre les géants.'),
      ],
    ),
    MythStory(
      title: 'Fenrir enchaîné',
      correctOrder: [
        MythCard(id: '1', title: 'Fenrir élevé par les dieux', description: 'Le loup est élevé parmi les dieux.'),
        MythCard(id: '2', title: 'Les chaînes échouent', description: 'Il brise deux chaînes puissantes.'),
        MythCard(id: '3', title: 'Gleipnir', description: 'Les nains forgent une chaîne magique.'),
        MythCard(id: '4', title: 'Le défi', description: 'Fenrir demande qu\'un dieu mette sa main en gage.'),
        MythCard(id: '5', title: 'Le sacrifice de Tyr', description: 'Tyr perd sa main, Fenrir est piégé.'),
      ],
    ),
    MythStory(
      title: 'La naissance du monde',
      correctOrder: [
        MythCard(id: '1', title: 'Ginnungagap', description: 'Le grand vide originel précède la création.'),
        MythCard(id: '2', title: 'Feu et glace', description: 'Muspellheim et Niflheim se rencontrent.'),
        MythCard(id: '3', title: 'Naissance d\'Ymir', description: 'Le géant primordial naît de la fusion.'),
        MythCard(id: '4', title: 'La mort d\'Ymir', description: 'Les dieux tuent Ymir.'),
        MythCard(id: '5', title: 'Création du monde', description: 'Le monde est formé à partir de son corps.'),
      ],
    ),
    MythStory(
      title: 'La forge de Mjöllnir',
      correctOrder: [
        MythCard(id: '1', title: 'Cheveux de Sif', description: 'Loki coupe les cheveux de Sif.'),
        MythCard(id: '2', title: 'Menace de Thor', description: 'Thor menace Loki de mort.'),
        MythCard(id: '3', title: 'Les nains forgerons', description: 'Loki commande des trésors aux nains.'),
        MythCard(id: '4', title: 'Création de Mjöllnir', description: 'Brokkr et Sindri forgent le marteau.'),
        MythCard(id: '5', title: 'Offrande à Thor', description: 'Thor reçoit Mjöllnir et pardonne Loki.'),
      ],
    ),
  ];
}
