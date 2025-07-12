import '../model.dart';

List<MythStory> getMythStories() {
  return [
    MythStory(
      title: 'La mort de Baldr',
      correctOrder: [
        MythCard(
          id: '1',
          title: 'Cauchemars de Baldr',
          description:
              'Baldr, le dieu aimé de tous, commence à faire des cauchemars troublants et prophétiques annonçant sa propre mort. Ces visions tourmentent les dieux, car elles semblent inéluctables.',
          imagePath: 'assets/images/baldr_1.jpg',
        ),
        MythCard(
          id: '2',
          title: 'Le serment de Frigg',
          description:
              'Pour protéger son fils, Frigg, la mère de Baldr, fait jurer à tous les êtres et objets du monde de ne jamais lui faire de mal. Elle néglige toutefois une plante jugée insignifiante : le gui.',
          imagePath: 'assets/images/baldr_2.jpg',
        ),
        MythCard(
          id: '3',
          title: 'Le gui',
          description:
              'Loki, curieux et malveillant, découvre que le gui n\'a pas été inclus dans le serment de Frigg. Il décide de se servir de cette faiblesse pour accomplir ses sombres desseins.',
          imagePath: 'assets/images/baldr_3.jpg',
        ),
        MythCard(
          id: '4',
          title: 'La flèche',
          description:
              'Loki fabrique une flèche ou un projectile à partir du gui et le remet à Höd, le frère aveugle de Baldr. Il le persuade de participer à un jeu innocent en lançant le projectile.',
          imagePath: 'assets/images/baldr_4.jpg',
        ),
        MythCard(
          id: '5',
          title: 'La mort de Baldr',
          description:
              'Sous l\'influence de Loki, Höd tire la flèche en gui qui transperce Baldr. Le dieu bien-aimé meurt sur-le-champ, plongeant les dieux dans un immense chagrin.',
          imagePath: 'assets/images/baldr_5.jpg',
        ),
      ],
    ),
    MythStory(
      title: 'Le marteau de Thor',
      correctOrder: [
        MythCard(
          id: '1',
          title: 'Mjöllnir est volé',
          description:
              'Le géant Thrym dérobe le marteau magique Mjöllnir, privant ainsi les dieux de leur plus grande arme de défense contre le chaos.',
          imagePath: 'assets/images/thor_1.jpg',
        ),
        MythCard(
          id: '2',
          title: 'Le chantage de Thrym',
          description:
              'Thrym ne rendra le marteau que si les dieux lui donnent la main de la belle Freyja en mariage. Les dieux sont consternés par cette demande absurde.',
          imagePath: 'assets/images/thor_2.jpg',
        ),
        MythCard(
          id: '4',
          title: 'Le festin',
          description:
              'Lors du banquet de mariage, Thor mange et boit avec une voracité telle que les géants commencent à douter de son identité féminine.',
          imagePath: 'assets/images/thor_4.jpg',
        ),
        MythCard(
          id: '5',
          title: 'Récupération',
          description:
              'Dès que Mjöllnir lui est présenté comme cadeau nuptial, Thor le saisit et massacre les géants, mettant fin à la supercherie dans un bain de sang.',
          imagePath: 'assets/images/thor_5.jpg',
        ),
      ],
    ),
    MythStory(
      title: 'Fenrir enchaîné',
      correctOrder: [
        MythCard(
          id: '1',
          title: 'Fenrir élevé par les dieux',
          description:
              'Le loup Fenrir, fils de Loki, est accueilli chez les dieux pour être élevé. Bien qu\'il soit encore jeune, il est déjà terrifiant et grandit rapidement.',
          imagePath: 'assets/images/fenrir_1.jpg',
        ),
        MythCard(
          id: '2',
          title: 'Les chaînes échouent',
          description:
              'Les dieux tentent de le lier avec des chaînes solides, mais Fenrir brise chaque lien, révélant une force surnaturelle incontrôlable.',
          imagePath: 'assets/images/fenrir_2.jpg',
        ),
        MythCard(
          id: '3',
          title: 'Gleipnir',
          description:
              'Les dieux chargent les nains de forger Gleipnir, une chaîne magique faite de choses impossibles : le souffle d\'un poisson, le bruit des pas d\'un chat, etc.',
          imagePath: 'assets/images/fenrir_3.jpg',
        ),
        MythCard(
          id: '4',
          title: 'Le défi',
          description:
              'Soupçonneux, Fenrir accepte d\'être enchaîné avec Gleipnir uniquement si un dieu place sa main dans sa gueule en gage de bonne foi.',
          imagePath: 'assets/images/fenrir_4.jpg',
        ),
        MythCard(
          id: '5',
          title: 'Le sacrifice de Tyr',
          description:
              'Tyr, le dieu du courage, offre sa main, sachant qu\'il la perdra. Lorsque Fenrir se rend compte de la ruse, il referme sa mâchoire et Tyr perd sa main.',
          imagePath: 'assets/images/fenrir_5.jpg',
        ),
      ],
    ),
    MythStory(
      title: 'La naissance du monde',
      correctOrder: [
        MythCard(
          id: '1',
          title: 'Ginnungagap',
          description:
              'Avant toute création, il n\'y avait que le Ginnungagap, un vaste vide séparant le feu de Muspellheim et la glace de Niflheim.',
          imagePath: 'assets/images/creation_1.jpg',
        ),
        MythCard(
          id: '2',
          title: 'Feu et glace',
          description:
              'Les étincelles de chaleur rencontrent les brumes glacées, provoquant la naissance de l\'eau et le début de la vie dans le vide cosmique.',
          imagePath: 'assets/images/creation_2.jpg',
        ),
        MythCard(
          id: '3',
          title: 'Naissance d\'Ymir',
          description:
              'De cette union primordiale naît Ymir, le premier géant, ainsi que la vache Audhumla, nourricière du géant. La vie se propage.',
          imagePath: 'assets/images/creation_3.jpg',
        ),
        MythCard(
          id: '4',
          title: 'La mort d\'Ymir',
          description:
              'Les premiers dieux, Odin et ses frères, tuent Ymir pour mettre fin au chaos. Son sang noie presque tous les autres géants.',
          imagePath: 'assets/images/creation_4.jpg',
        ),
        MythCard(
          id: '5',
          title: 'Création du monde',
          description:
              'Avec le corps d’Ymir, les dieux forment le monde : la terre avec sa chair, les montagnes avec ses os, la mer avec son sang, et le ciel avec son crâne.',
          imagePath: 'assets/images/creation_5.jpg',
        ),
      ],
    ),
    MythStory(
      title: 'La forge de Mjöllnir',
      correctOrder: [
        MythCard(
          id: '1',
          title: 'Cheveux de Sif',
          description:
              'Loki coupe les magnifiques cheveux dorés de Sif, l’épouse de Thor, par pur amusement. Ce geste irrite profondément Thor.',
          imagePath: 'assets/images/forge_1.jpg',
        ),
        MythCard(
          id: '2',
          title: 'Menace de Thor',
          description:
              'Furieux, Thor menace de briser tous les os de Loki s’il ne répare pas son affront. Loki, paniqué, promet d’offrir une chevelure encore plus belle.',
          imagePath: 'assets/images/forge_2.jpg',
        ),
        MythCard(
          id: '3',
          title: 'Les nains forgerons',
          description:
              'Loki se rend auprès des nains Brokkr et Sindri pour leur demander de forger des trésors magiques, capables d’apaiser la colère des dieux.',
          imagePath: 'assets/images/forge_3.jpg',
        ),
        MythCard(
          id: '4',
          title: 'Création de Mjöllnir',
          description:
              'Malgré les ruses de Loki, les nains forgent plusieurs merveilles, dont Mjöllnir, un marteau redoutable capable de contrôler la foudre.',
          imagePath: 'assets/images/forge_4.jpg',
        ),
        MythCard(
          id: '5',
          title: 'Offrande à Thor',
          description:
              'Les trésors sont offerts aux dieux. Thor, émerveillé par Mjöllnir, accepte le pardon de Loki, bien que le manche soit un peu court.',
          imagePath: 'assets/images/forge_5.jpg',
        ),
      ],
    ),
  ];
}
