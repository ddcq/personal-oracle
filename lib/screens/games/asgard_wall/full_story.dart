import '../model.dart';

MythStory getMythStory() {
  return MythStory(
    title: 'La Muraille d’Asgard',
    correctOrder: [
      MythCard(
        id: '1',
        title: 'Les Dieux cherchent à protéger Asgard',
        description:
            'Après la guerre contre les Vanes, les Ases décident de reconstruire la forteresse d’Asgard.',
        imagePath: 'assets/images/wall_1.jpg',
      ),
      MythCard(
        id: '2',
        title: 'Le géant bâtisseur propose son aide',
        description:
            'Un inconnu se présente et propose de bâtir la muraille en échange d’un prix exorbitant.',
        imagePath: 'assets/images/wall_2.jpg',
      ),
      MythCard(
        id: '3',
        title: 'Le géant commence la construction',
        description:
            'Le géant commence à travailler, mais les dieux réalisent qu’il pourrait réussir.',
        imagePath: 'assets/images/wall_3.jpg',
      ),
      MythCard(
        id: '4',
        title: 'L’intervention de Loki',
        description:
            'Loki, le dieu de la malice, propose un plan pour retarder le géant.',
        imagePath: 'assets/images/wall_4.jpg',
      ),
      MythCard(
        id: '5',
        title: 'La colère du géant',
        description:
            'Le géant, furieux de ne pas pouvoir terminer à temps, se rend compte qu’il a été trompé.',
        imagePath: 'assets/images/wall_5.jpg',
      ),
      MythCard(
        id: '6',
        title: 'La bataille finale',
        description:
            'Les dieux affrontent le géant dans une bataille épique pour protéger Asgard.',
        imagePath: 'assets/images/wall_6.jpg',
      ),
      MythCard(
        id: '7',
        title: 'La reconstruction d’Asgard',
        description:
            'Après la victoire, les dieux reconstruisent Asgard et célèbrent leur triomphe.',
        imagePath: 'assets/images/wall_7.jpg',
      )
    ],
  );
}
