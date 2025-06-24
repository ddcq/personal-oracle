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
        detailedStory:
            'La guerre entre les Ases et les Vanes, deux clans divins, avait laissé de profondes cicatrices dans les mondes. Bien qu\'une paix ait finalement été conclue, elle n’effaça pas les destructions causées par les combats, notamment la perte de la muraille qui protégeait Asgard. Les dieux comprirent que, pour préserver leur royaume des incursions futures, une défense solide et inviolable était nécessaire. Ainsi, les Ases se réunirent au Thing, l’assemblée sacrée, et discutèrent longuement de la manière de rebâtir leur cité. Tous étaient d’accord : la nouvelle forteresse devrait surpasser l’ancienne, être digne du royaume des dieux et capable de tenir tête aux géants eux-mêmes.',
      ),
      MythCard(
        id: '2',
        title: 'Le géant bâtisseur propose son aide',
        description:
            'Un inconnu se présente et propose de bâtir la muraille en échange d’un prix exorbitant.',
        imagePath: 'assets/images/wall_2.jpg',
        detailedStory:
            'Alors que les Ases débattaient de la meilleure façon de reconstruire leur forteresse, un géant mystérieux, connu sous le nom de Hrimthurs, se présenta devant eux. Il proposa de bâtir une muraille inébranlable en échange d’un prix exorbitant : la main de Freyja, la déesse de l’amour et de la beauté, ainsi que le soleil et la lune. Les dieux, bien que réticents, virent dans cette offre une opportunité unique. Hrimthurs affirma qu\'il pouvait terminer la construction en seulement six mois, mais il devait travailler sans interruption, jour et nuit. Les Ases acceptèrent à contrecœur, mais avec un plan secret pour empêcher le géant de réussir.',
      ),
      MythCard(
        id: '3',
        title: 'Le géant commence la construction',
        description:
            'Le géant commence à travailler, mais les dieux réalisent qu’il pourrait réussir.',
        imagePath: 'assets/images/wall_3.jpg',
        detailedStory:
            'Hrimthurs se mit immédiatement au travail, utilisant sa force colossale pour soulever d’énormes blocs de pierre et les placer avec une précision incroyable. Les Ases observaient, inquiets, alors que le géant avançait à un rythme alarmant. En quelques semaines, une grande partie de la muraille était déjà érigée. Les dieux commencèrent à craindre que Hrimthurs ne termine son ouvrage avant la fin du délai imparti. Ils savaient qu\'ils devaient agir rapidement pour empêcher cela, mais comment ?',
      ),
      MythCard(
        id: '4',
        title: 'L’intervention de Loki',
        description:
            'Loki, le dieu de la malice, propose un plan pour retarder le géant.',
        imagePath: 'assets/images/wall_4.jpg',
        detailedStory:
            'Loki, toujours prêt à semer le trouble, eut une idée. Il se transforma en jument et se présenta devant le cheval du géant, Svadilfari. Le cheval, attiré par la jument, se mit à la poursuivre, laissant Hrimthurs sans son aide pour transporter les lourds blocs de pierre. Pendant ce temps, Loki, sous sa forme équine, mena le cheval loin du chantier, le retardant considérablement. Le géant, frustré par l’absence de son cheval, tenta de continuer seul, mais il était évident qu’il ne pourrait pas terminer la muraille à temps sans son fidèle compagnon.',
      ),
      MythCard(
        id: '5',
        title: 'La colère du géant',
        description:
            'Le géant, furieux de ne pas pouvoir terminer à temps, se rend compte qu’il a été trompé.',
        imagePath: 'assets/images/wall_5.jpg',
        detailedStory:
            'Lorsque Hrimthurs réalisa qu’il ne pourrait pas terminer la muraille à temps, sa colère fut immense. Il comprit qu’il avait été dupé par les Ases et par Loki. Furieux, il se mit à détruire ce qu’il avait construit, jurant de se venger. Les dieux, voyant le géant en colère, se préparèrent à se défendre. Ils savaient que Hrimthurs ne les laisserait pas s’en tirer si facilement. Mais Loki, toujours rusé, avait un plan pour mettre fin à cette menace.',
      ),
      MythCard(
        id: '6',
        title: 'La bataille finale',
        description:
            'Les dieux affrontent le géant dans une bataille épique pour protéger Asgard.',
        imagePath: 'assets/images/wall_6.jpg',
        detailedStory:
            'La colère du géant Hrimthurs se transforma en rage lorsqu’il comprit qu’il avait été trompé. Il se mit à détruire la muraille qu’il avait construite, mais les dieux ne le laissèrent pas faire. Odin, Thor et les autres Ases se préparèrent à combattre le géant. Une bataille épique s’ensuit, avec des éclairs de magie et des coups de marteau résonnant dans tout Asgard. Hrimthurs, bien que puissant, fut finalement vaincu par la ruse de Loki et la force des dieux. Alors qu’il tombait, il jura de se venger un jour, mais pour l’instant, Asgard était sauvé.',
      ),
      MythCard(
        id: '7',
        title: 'La reconstruction d’Asgard',
        description:
            'Après la victoire, les dieux reconstruisent Asgard et célèbrent leur triomphe.',
        imagePath: 'assets/images/wall_7.jpg',
        detailedStory:
            'Après la victoire sur Hrimthurs, les dieux se mirent à reconstruire Asgard. Ils utilisèrent les pierres de la muraille détruite pour ériger une nouvelle forteresse, encore plus solide que la précédente. Les Ases célébrèrent leur triomphe avec de grandes fêtes, honorant Loki pour son rôle crucial dans la défaite du géant. Ils comprirent que, même si la ruse et la tromperie n’étaient pas toujours les meilleures solutions, elles pouvaient parfois être nécessaires pour protéger leur royaume. La nouvelle muraille d’Asgard devint un symbole de leur force et de leur unité, et les dieux jurèrent de toujours veiller sur leur royaume, prêts à affronter toute menace qui pourrait surgir à l’avenir.',
      ),
    ],
  );
}
