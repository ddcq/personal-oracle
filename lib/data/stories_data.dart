import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';

List<MythStory> getMythStories() {
  return [
    MythStory(
      title: 'Loading Story',
      correctOrder: [
        MythCard(
          id: 'dummy_1',
          title: 'Loading...',
          description: 'Please wait while the game loads.',
          imagePath: 'loading.webp', // A placeholder image
          detailedStory: 'Loading...',
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
              'Avant toute création, seul existait Ginnungagap, l’abîme infini où se faisaient face les flammes de Muspellheim et les glaces de Niflheim, opposées dans une attente silencieuse.',
          imagePath: 'creation_1.webp',
          detailedStory:
              'Au commencement des temps, avant que n’existe aucun monde, aucune mer, aucun ciel, aucun terre, il n’y avait que le Ginnungagap - le vide béant, l’abîme primordial qui s’étendait dans une solitude infinie.\n\nCe n’était ni lumière ni ténèbres, ni chaud ni froid, mais un néant absolu où rien ne pouvait naître ni mourir, car rien n’existait encore. Ce vide colossal séparait deux royaumes aux natures opposées, comme deux forces antagonistes attendant leur confrontation cosmique.\n\nAu nord du Ginnungagap s’étendait Niflheim, le monde de glace et de brouillard éternel, d’où coulaient les onze rivières Élivágar, charriant des eaux si froides qu’elles gelaient instantanément dans le vide. Au sud brûlait Muspellheim, le royaume du feu éternel et inextinguible, gardé par le géant Surtr brandissant son épée flamboyante, dans l’attente du jour où il incendierait tous les mondes.\n\nAinsi les forces primordiales se faisaient face dans l’immensité du vide, préparant la création dans leur opposition même.',
        ),
        MythCard(
          id: '2',
          title: 'Feu et glace',
          description:
              'Lorsque les étincelles ardentes de Muspellheim rencontrèrent les brumes glacées de Niflheim, la glace fondit en torrents d’eau primordiale, donnant naissance à l’essence de la vie.',
          imagePath: 'creation_2.webp',
          detailedStory:
              'Pendant des éons innombrables, le feu et la glace demeurèrent séparés par l’immensité du Ginnungagap. Mais lentement, inexorablement, les étincelles ardentes de Muspellheim commencèrent à dériver vers le nord, portées par des vents cosmiques imperceptibles.\n\nLorsque ces étincelles de chaleur pure rencontrèrent les brumes glacées de Niflheim dans le cœur du vide, un phénomène extraordinaire se produisit. La glace se mit à fondre pour la première fois depuis le début des temps, libérant des torrents d’eau primordiale.\n\nCes gouttes d’eau, nées de la rencontre miraculeuse entre les extrêmes, tombèrent dans l’abîme du Ginnungagap. Là, animées par la force vitale née de cette union impossible entre le feu et la glace, elles commencèrent à grouiller d’une énergie créatrice.\n\nC’était le premier miracle de l’existence : de l’opposition entre les forces contraires naissait la possibilité même de la vie. L’eau primordiale portait en elle le germe de tout ce qui allait exister.',
        ),
        MythCard(
          id: '3',
          title: 'Naissance d’Ymir',
          description:
              'De ces eaux naquit Ymir, premier géant, colossal et chaotique, accompagné d’Audhumla, la vache nourricière. Ensemble, ils ouvrirent la voie aux dieux et aux lignées à venir.',
          imagePath: 'creation_3.webp',
          detailedStory:
              'De l’eau primordiale, un être colossal émergea : Ymir, le premier géant, aussi connu sous le nom d’Aurgelmir. Sa chair était faite de glace fondue, ses os de roches anciennes, et ses yeux brillaient d’une lueur froide comme les étoiles naissantes.\n\nÀ côté de lui, une vache immense nommée Audhumla apparut, nourrie par les gouttes d’eau sucrée qui s’étaient formées dans le Ginnungagap. Audhumla était la source de vie pour Ymir, lui fournissant le lait nécessaire à sa survie. En léchant la glace des montagnes, elle découvrit bientôt Buri, le premier dieu, dont la descendance allait donner naissance aux Ases.\n\nAinsi naquit la première génération de géants et de dieux, marquant le début de l’histoire du monde. Ymir devint le père des géants, tandis qu’Audhumla nourrissait les êtres qui allaient façonner l’univers.',
        ),
        MythCard(
          id: '4',
          title: 'La mort d’Ymir',
          description:
              'Odin et ses frères affrontèrent Ymir, incarnation du chaos. Sa mort libéra des flots de sang qui engloutirent presque tous les géants, bouleversant à jamais l’équilibre du cosmos.',
          imagePath: 'creation_4.webp',
          detailedStory:
              'Les dieux, conscients que Ymir représentait une menace pour l’équilibre du cosmos, décidèrent de mettre fin à son règne chaotique. Odin, Vili et Vé, les trois frères divins, s’unirent pour affronter le géant primordial.\n\nDans une bataille épique, ils parvinrent à tuer Ymir. Son corps colossal s’effondra dans le Ginnungagap, et son sang se mit à couler en torrents. Ce sang inonda presque tous les autres géants, les noyant dans un océan de chaos.\n\nMais les dieux ne se contentèrent pas de tuer Ymir. Ils utilisèrent son corps pour façonner le monde : sa chair devint la terre, ses os les montagnes, son sang les mers et les rivières, et son crâne le ciel. Ainsi, de la mort du géant naquit l’univers tel que nous le connaissons.',
        ),
        MythCard(
          id: '5',
          title: 'Création du monde',
          description:
              'Du corps d’Ymir, les dieux forgèrent l’univers : la terre de sa chair, les montagnes de ses os, les mers de son sang, et le ciel de son crâne, donnant forme au monde des hommes, Midgard.',
          imagePath: 'creation_5.webp',
          detailedStory:
              'Les dieux, après avoir vaincu Ymir, se mirent à l’œuvre pour façonner le monde à partir de son corps colossal. Ils commencèrent par diviser son corps en deux moitiés égales, créant ainsi la terre et le ciel.\n\nLa chair d’Ymir devint la terre fertile, couverte de forêts luxuriantes et de plaines verdoyantes. Ses os furent brisés et érigés en montagnes majestueuses, formant les chaînes montagneuses qui traversent le monde. Son sang, qui avait inondé les géants, fut canalisé pour former les mers profondes et les rivières sinueuses.\n\nLe crâne d’Ymir fut soulevé pour créer le ciel, soutenu par quatre nains représentant les points cardinaux : Nord, Sud, Est et Ouest. Les étoiles furent placées dans le ciel comme des lanternes scintillantes, tandis que la lune et le soleil furent créés pour réguler le temps.\n\nAinsi naquit Midgard, le monde des hommes, au centre de l’univers, entouré par les neuf mondes interconnectés. Les dieux avaient façonné un cosmos harmonieux à partir du chaos primordial.',
        ),
      ],
    ),
    MythStory(
      title: 'La Guerre des Ases et des Vanes',
      correctOrder: [
        MythCard(
          id: '1',
          title: 'L’ombre de la discorde',
          description: 'La magie des Vanes émerveille mais inquiète les Ases, et la méfiance s’installe.',
          imagePath: 'ases_vanes_1.webp',
          detailedStory:
              'Dans la grande salle des dieux du ciel, les flammes des torches projetaient sur les murs des ombres vacillantes qui semblaient écouter les murmures des immortels. Les Vanes, maîtres des champs et des récoltes, avaient introduit une magie nouvelle, née de la terre et des saisons, qui fascinait autant qu’elle effrayait. Les Ases, guerriers d’Asgard, regardaient cette puissance d’un œil méfiant : ce savoir étranger remettait en cause leur autorité. Parmi eux, certains y voyaient une chance, d’autres une menace. Les mots échangés se transformèrent en accusations, et les accusations en colères à peine contenues. Le silence entre deux discours n’était plus celui du respect, mais celui d’un orage prêt à éclater. L’avidité se mêlait à la crainte, et l’orgueil à la jalousie. Le vent qui soufflait contre les portes de la salle semblait lui-même annoncer une rupture. Quand le regard des uns devint trop lourd, quand les mains se crispèrent sur les accoudoirs, chacun comprit que le fil qui unissait ces deux clans était sur le point de se rompre. L’équilibre fragile du monde s’inclinait déjà vers le chaos.',
        ),
        MythCard(
          id: '2',
          title: 'L’étincelle de la guerre',
          description: 'Un conflit éclate après que les Ases aient tenté de détruire une magicienne vane.',
          imagePath: 'ases_vanes_2.webp',
          detailedStory:
              'La tension trouva son incarnation dans une femme venue des Vanes, messagère et maîtresse des arcanes de la fertilité. Sa beauté éclatante et son savoir mystérieux troublaient l’ordre établi. Les Ases, incapables de supporter une telle indépendance, tentèrent de la réduire au silence par le feu. Mais trois fois les flammes dévorèrent son corps, et trois fois elle renaquit, plus forte, plus rayonnante, comme si la terre elle-même refusait de la céder aux flammes. Cet affrontement révéla au grand jour l’abîme qui séparait les deux peuples. Les Vanes, outrés de ce sacrilège, se levèrent en armes, appelant les vents et les moissons à leur aide. Les Ases, blessés dans leur fierté, saisirent leurs lances et se préparèrent au combat. La guerre n’éclata pas dans un cri, mais dans un silence funeste, lorsque chacun sut qu’aucun retour en arrière n’était possible. Le premier sang coula bientôt, et avec lui se brisa l’illusion d’une paix durable. Désormais, l’air était chargé de cendres et de malédictions.',
        ),
        MythCard(
          id: '3',
          title: 'La guerre des dieux',
          description: 'Ases et Vanes s’affrontent sans répit, ravageant terres et cieux.',
          imagePath: 'ases_vanes_3.webp',
          detailedStory:
              'Alors s’ouvrit une guerre que nul mortel n’aurait pu concevoir. Les Ases frappaient avec la violence du tonnerre, leurs armes forgées dans le feu des forges éternelles. Les Vanes ripostaient en invoquant la fécondité des terres, transformant les champs en pièges vivants, faisant jaillir des torrents et des forêts là où il n’y avait que désolation. Chaque bataille déchirait le monde, chaque victoire semblait aussitôt se transformer en défaite. Les murs d’Asgard tremblaient, et les plaines des Vanes se couvraient de cendres. Aucun camp ne reculait, et pourtant aucun n’avançait. La guerre, interminable, devenait une blessure qui ne se refermait pas. Les chants des scaldes ne racontaient plus des triomphes, mais des ravages sans fin. Les vents portaient la fumée des incendies jusque dans les royaumes des mortels, et même Yggdrasil, l’arbre cosmique, semblait gémir sous le poids de cette discorde. Dans les regards des dieux, on ne lisait plus la fierté, mais la lassitude d’un affrontement stérile. Pourtant, nul ne voulait céder le premier.',
        ),
        MythCard(
          id: '4',
          title: 'Les otages du destin',
          description: 'Épuisés, les dieux échangent des otages pour sceller une trêve fragile.',
          imagePath: 'ases_vanes_4.webp',
          detailedStory:
              'Quand le sang eut trop coulé, quand les armes devinrent aussi lourdes que les cœurs, une idée germa des ruines de la bataille. Les deux clans, incapables de vaincre, décidèrent de tenter un acte de confiance : l’échange d’otages. Les Vanes envoyèrent deux de leurs plus sages, un frère et une sœur dont la beauté et la puissance surpassaient celles des champs et des rivières. Les Ases, de leur côté, offrirent un maître des runes, gardien des secrets anciens, et un autre dieu à la langue acérée. Cet échange fut scellé non dans la joie, mais dans la méfiance, chaque pas franchi étant alourdi par le soupçon. Les otages traversèrent les plaines et les forteresses ennemies, portant avec eux les espoirs fragiles d’une paix encore incertaine. L’air était tendu comme une corde d’arc, et chaque regard jeté sur eux pouvait à tout instant devenir une menace. Pourtant, à travers cet acte de prudence, un frêle équilibre commença à renaître. Pour la première fois depuis longtemps, les dieux ne brandissaient pas leurs armes, mais leurs serments.',
        ),
        MythCard(
          id: '5',
          title: 'La réconciliation des dieux',
          description: 'Les otages tiennent parole, et les dieux apprennent à unir leurs forces.',
          imagePath: 'ases_vanes_5.webp',
          detailedStory:
              'Le temps fit son œuvre, et peu à peu, les otages devinrent plus que des garants : ils devinrent des ponts. Les Vanes, accueillis parmi les Ases, enseignèrent l’art de la magie de la terre, dévoilant les secrets des récoltes et des saisons. Les Ases, en retour, partagèrent la rigueur de leurs runes, le courage de leurs batailles et la discipline de leurs lois. Les rancunes ne disparurent pas en un souffle, mais à travers des années de patience et d’épreuves partagées, les liens se tissèrent. Les enfants de ces unions divines portaient en eux deux héritages, celui du tonnerre et celui de la fertilité. Les festins remplacèrent les guerres, et les chants célébrèrent à nouveau la puissance de l’union plutôt que la désolation des combats. Mais au fond de chaque regard, une ombre subsistait : le souvenir de la guerre n’était jamais loin, comme une cicatrice que le temps ne pouvait effacer. Pourtant, pour un temps, la paix régnait, fragile mais réelle.',
        ),
        MythCard(
          id: '6',
          title: 'L’alliance scellée',
          description: 'Ases et Vanes unissent définitivement leurs forces, préparant l’avenir.',
          imagePath: 'ases_vanes_6.webp',
          detailedStory:
              'La fin de la guerre ne fut pas une victoire, mais une reconnaissance mutuelle. Les Ases comprirent qu’ils ne pouvaient régner seuls sur le ciel et la guerre, et les Vanes acceptèrent que la terre et la fécondité devaient s’unir à la force et à la loi. Une nouvelle ère s’ouvrit, où les deux clans si longtemps ennemis siégeaient côte à côte dans les halls d’Asgard. Les serments prononcés résonnaient comme des pierres posées dans le lit d’un fleuve : solides, mais soumis aux flots du destin. Les dieux savaient que les épreuves ne manqueraient pas, que le chaos n’avait pas disparu, mais ils comprirent que seule leur union pouvait donner une chance de survie lors du crépuscule annoncé. Ainsi, de la cendre de la discorde naquit l’alliance. Les scaldes chantèrent alors non pas la gloire d’une victoire, mais la sagesse d’un compromis, et ces chants résonnèrent jusque dans les royaumes des mortels. Les Vanes et les Ases devinrent un seul peuple divin, liés non par le sang versé, mais par le sang partagé.',
        ),
      ],
    ),
    MythStory(
      title: 'La Muraille d’Asgard',
      correctOrder: [
        MythCard(
          id: '1',
          title: 'Les Dieux cherchent à protéger Asgard',
          description:
              'Après la guerre contre les Vanes, Asgard est vulnérable. Les Ases se rassemblent et décident qu’il leur faut une nouvelle muraille, plus solide et plus haute que jamais, pour protéger leur royaume.',
          imagePath: 'wall_1.webp',
          detailedStory:
              'La guerre entre les Ases et les Vanes, deux clans divins aux puissances redoutables, avait bouleversé l’équilibre des neuf mondes. Même si une paix fragile fut conclue, les cicatrices de ce conflit restaient visibles, et les dieux savaient qu’elles ne s’effaceraient jamais totalement. La muraille qui protégeait autrefois Asgard avait été réduite en ruines, laissant leur cité divine exposée aux attaques des géants et aux menaces extérieures. Odin, Thor et les autres Ases convoquèrent alors une grande assemblée, le Thing sacré, pour débattre de la manière de rebâtir leurs défenses. Chacun apporta son avis, mais une évidence s’imposait : il fallait une forteresse nouvelle, si solide et si majestueuse qu’aucun ennemi, pas même les puissants Jötunns, ne pourrait jamais l’abattre. Cette décision, marquée par la gravité des souvenirs de guerre, allait ouvrir la voie à une série d’événements que nul ne pouvait encore imaginer.',
        ),
        MythCard(
          id: '2',
          title: 'Le géant bâtisseur propose son aide',
          description:
              'Un mystérieux géant, Hrimthurs, se présente aux dieux et propose de bâtir une muraille invincible en six mois. En échange, il exige Freyja, le soleil et la lune, un prix que les Ases jugent exorbitant.',
          imagePath: 'wall_2.webp',
          detailedStory:
              'Alors que les Ases débattaient encore de leur dilemme, un étranger imposant franchit les portes d’Asgard. Il se présenta comme un maître bâtisseur, un géant du nom de Hrimthurs. Son offre était stupéfiante : il promettait de rebâtir une muraille si solide qu’aucune force ne pourrait jamais la renverser, et ce, en l’espace de six mois seulement. Mais son prix était terrifiant : il réclamait la main de Freyja, la déesse de la beauté et de l’amour, ainsi que le soleil et la lune, sources de lumière et de vie. Les Ases, choqués par cette demande, hésitèrent. Perdre Freyja serait une blessure à l’honneur d’Asgard, et céder le soleil et la lune plongerait les mondes dans les ténèbres éternelles. Pourtant, attirés par l’idée d’une muraille imprenable, ils décidèrent d’accepter, mais avec une ruse en tête : ils imposèrent que le géant n’aurait aucune aide, hormis son cheval, et qu’il devait terminer avant le premier jour de l’été. Les dés étaient jetés.',
        ),
        MythCard(
          id: '3',
          title: 'Le géant commence la construction',
          description:
              'Hrimthurs et son cheval Svadilfari commencent l’ouvrage. Les pierres s’élèvent si vite que les dieux s’inquiètent : il semble réellement capable de finir avant la date fixée.',
          imagePath: 'wall_3.webp',
          detailedStory:
              'Dès le lendemain, Hrimthurs se mit à l’ouvrage avec une vigueur impressionnante. Son fidèle cheval, Svadilfari, l’aidait à transporter d’énormes blocs de pierre que nul autre être n’aurait pu soulever. Ensemble, ils travaillaient nuit et jour, sans répit. Les Ases, d’abord confiants dans leur ruse, commencèrent à douter en voyant la vitesse à laquelle la muraille prenait forme. Chaque jour, les pierres s’élevaient plus haut, chaque nuit, la forteresse semblait avancer d’un pas de géant vers son achèvement. En quelques semaines, une grande partie de l’enceinte entourant Asgard était déjà debout, solide et massive. Odin et les autres dieux, habituellement sereins, se consultaient désormais avec inquiétude. Si le géant parvenait à achever son œuvre à temps, ils devraient tenir parole et céder Freyja, le soleil et la lune. Leur plan risquait de se retourner contre eux, et le désespoir commença à poindre.',
        ),
        MythCard(
          id: '4',
          title: 'L’intervention de Loki',
          description:
              'Voyant le danger, Loki propose une ruse : il se métamorphose en jument et attire Svadilfari, privant Hrimthurs de son plus précieux allié dans la construction de la muraille.',
          imagePath: 'wall_4.webp',
          detailedStory:
              'Alors que la date limite approchait et que l’angoisse des Ases montait, Loki, le dieu de la ruse, offrit son aide. Bien que souvent cause de leurs malheurs, il savait se rendre utile dans les situations désespérées. Son plan était audacieux : il se métamorphosa en une magnifique jument, luisante et vive, et se présenta devant Svadilfari. Le cheval, séduit, se lança à sa poursuite, abandonnant son maître. Hrimthurs, désemparé, dut continuer seul, mais même sa force colossale ne suffisait pas pour déplacer les blocs sans son destrier. Pendant plusieurs nuits, Loki, sous sa forme équine, attira Svadilfari toujours plus loin, retardant la construction de manière décisive. Les dieux observaient avec un mélange de soulagement et de stupeur, conscients que la ruse de Loki venait de sauver leur royaume, mais aussi que de telles tromperies pourraient avoir des conséquences inattendues.',
        ),
        MythCard(
          id: '5',
          title: 'La colère du géant',
          description:
              'Privé de son cheval, Hrimthurs comprend qu’il ne pourra pas finir la muraille. Trompé, il entre dans une rage furieuse et menace de détruire Asgard et d’écraser les dieux eux-mêmes.',
          imagePath: 'wall_5.webp',
          detailedStory:
              'Quand Hrimthurs réalisa qu’il avait été dupé, sa rage éclata comme une tempête. Le géant frappa la terre de ses poings et poussa un cri si terrible que les montagnes elles-mêmes semblèrent trembler. Sans Svadilfari, il était incapable d’achever l’œuvre, et il comprit que les Ases n’avaient jamais eu l’intention de tenir leur promesse. Fou de colère, il tenta de renverser les blocs déjà posés, jurant de réduire Asgard en cendres et d’écraser les dieux sous sa force. Les Ases, qui avaient redouté ce moment, se préparèrent à le combattre. Thor, la main crispée sur Mjöllnir, attendait l’instant où il pourrait frapper. Odin, quant à lui, observait avec gravité : ce duel n’était plus une affaire de ruse, mais un affrontement direct entre la puissance brute d’un géant et la volonté indomptable des dieux d’Asgard.',
        ),
        MythCard(
          id: '6',
          title: 'La bataille finale',
          description:
              'Odin, Thor et les Ases affrontent Hrimthurs dans un combat titanesque. Le ciel se déchire de tonnerre et de magie, jusqu’à ce que le géant soit terrassé et Asgard finalement sauvé.',
          imagePath: 'wall_6.webp',
          detailedStory:
              'La rage de Hrimthurs atteignit son paroxysme lorsqu’il se lança contre les murailles inachevées. Thor bondit en avant, brandissant Mjöllnir, et abattit des coups si puissants que le ciel se couvrit d’éclairs. Odin invoqua des enchantements pour protéger ses frères, tandis que les autres Ases combattaient aux côtés du dieu du tonnerre. La bataille résonna dans tout Asgard : chaque coup de poing du géant faisait trembler la terre, chaque coup de marteau faisait exploser des blocs de pierre. Malgré sa force titanesque, Hrimthurs ne put résister longtemps face à la fureur combinée des dieux. Thor, dans un rugissement de colère, asséna le coup final qui pulvérisa le crâne du géant. Hrimthurs s’effondra, écrasant le sol dans un fracas assourdissant. Son corps inerte rappela à tous que même la ruse pouvait mener à des affrontements sanglants. Asgard était sauvé, mais la victoire avait un prix.',
        ),
        MythCard(
          id: '7',
          title: 'La reconstruction d’Asgard',
          description:
              'Après leur victoire, les Ases reconstruisent la muraille d’Asgard en utilisant les pierres déjà posées. Ils célèbrent leur triomphe et jurent de protéger leur royaume contre toute menace future.',
          imagePath: 'wall_7.webp',
          detailedStory:
              'Une fois Hrimthurs vaincu, les Ases se tournèrent vers les ruines de son ouvrage. Les blocs de pierre qu’il avait posés étaient d’une solidité remarquable, et plutôt que de les détruire, les dieux décidèrent de les utiliser pour bâtir leur propre muraille. Ainsi, pierre après pierre, ils achevèrent la forteresse d’Asgard, cette fois en maîtres de leur destinée. La nouvelle enceinte se dressait, imposante et invincible, symbole de leur unité retrouvée après la guerre contre les Vanes et la menace du géant. Des fêtes grandioses furent organisées, et bien que Loki eût provoqué tout ce chaos par ses tromperies, il fut honoré pour sa ruse qui avait permis leur victoire. Les Ases jurèrent de défendre Asgard, quoi qu’il en coûte, et de veiller sur leur royaume jusqu’au Ragnarök. La muraille devint le rempart éternel de leur puissance et le signe que, même face aux menaces les plus grandes, les dieux sauraient triompher.',
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
              'Par pur amusement, Loki coupe les cheveux dorés de Sif, épouse de Thor, connus pour leur éclat semblable à l’or. Ce geste cruel provoque la honte de Sif et la colère grondante de Thor.',
          imagePath: 'forge_1.webp',
          detailedStory:
              'Dans les temps anciens, Loki, dieu de la malice et des tours perfides, s’ennuyait cruellement. Pour assouvir son besoin de chaos, il décida de s’en prendre à Sif, l’épouse de Thor, réputée pour sa beauté rayonnante et surtout pour ses cheveux d’or qui semblaient capturer la lumière du soleil. Alors qu’elle dormait paisiblement, Loki s’approcha silencieusement et, avec un sourire narquois, coupa chaque mèche précieuse. Lorsque Sif s’éveilla et découvrit sa chevelure mutilée, son désespoir résonna dans tout Asgard. Thor, découvrant l’affront infligé à son épouse, entra dans une fureur si terrible que la terre trembla sous ses pas. Il jura de faire payer à Loki cet outrage. Les dieux eux-mêmes redoutaient la tempête de colère qui menaçait de s’abattre sur le coupable.',
        ),
        MythCard(
          id: '2',
          title: 'Menace de Thor',
          description:
              'Découvrant l’humiliation de Sif, Thor saisit Loki et le menace de le briser en mille morceaux s’il ne trouve pas une solution. Terrifié, Loki promet d’offrir à Sif une chevelure encore plus belle.',
          imagePath: 'forge_2.webp',
          detailedStory:
              'Thor, ivre de rage, attrapa Loki par la gorge et le souleva comme une plume. Ses yeux flamboyaient comme la foudre, et sa voix, grondante, résonnait dans les halls d’Asgard : « Misérable filou ! Tu as osé porter atteinte à l’honneur de mon épouse ! Je vais t’écraser comme la vermine que tu es si tu n’effaces pas ton crime ! » Pris de panique, Loki réalisa qu’il avait été trop loin. Il tenta de se débattre, mais la poigne du dieu du tonnerre l’écrasait. Alors, avec une ruse feinte, il supplia Thor de lui laisser une chance de réparer son forfait. « J’apporterai à Sif une chevelure encore plus splendide que la précédente, je le jure sur mon sang ! » promit-il. Thor, bien qu’encore furieux, accepta, mais lui fit comprendre que la moindre déception lui coûterait tous ses os. Le compte à rebours de Loki venait de commencer.',
        ),
        MythCard(
          id: '3',
          title: 'Les nains forgerons',
          description:
              'Pour tenir sa promesse, Loki descend dans Svartalfheim, le royaume des nains forgerons. Il supplie Brokkr et Sindri de créer des trésors divins capables de calmer la colère de Thor et des dieux.',
          imagePath: 'forge_3.webp',
          detailedStory:
              'Conscient qu’il ne pouvait s’en sortir seul, Loki descendit dans les profondeurs sombres de Svartalfheim, le royaume des nains. Là régnaient Brokkr et Sindri, deux frères forgerons dont l’habileté dépassait celle de tous les artisans des neuf mondes. Dans leurs forges embrasées, ils façonnaient les merveilles les plus précieuses, du métal le plus pur, nourri par le feu éternel. Loki, rusé, leur exposa son dilemme : il devait offrir à Sif une chevelure d’or vivante et à Thor un présent digne de sa grandeur. Intrigués et flattés, les nains acceptèrent le défi. Ils promirent de forger non seulement une nouvelle chevelure pour Sif, mais aussi des trésors destinés aux dieux eux-mêmes. Leurs marteaux résonnèrent dans la pénombre, et des étincelles jaillirent comme des étoiles naissantes. Loki, impatient, observait en silence, déjà prêt à semer ses ruses pour tirer plus qu’il n’avait demandé.',
        ),
        MythCard(
          id: '4',
          title: 'Création de Mjöllnir',
          description:
              'Sous le marteau des nains naissent des trésors : Draupnir, Gungnir et enfin Mjöllnir, le marteau de Thor. Loki tente de saboter l’œuvre, mais le marteau, bien que court, est redoutable.',
          imagePath: 'forge_4.webp',
          detailedStory:
              'Brokkr et Sindri se mirent à l’ouvrage, le visage noirci par la chaleur de la forge, le cœur gonflé de fierté. Ils commencèrent par créer Draupnir, l’anneau d’or magique qui produisait huit nouveaux anneaux tous les neuf jours, puis Gungnir, la lance d’Odin qui ne manquait jamais sa cible. Mais leur plus grand chef-d’œuvre fut Mjöllnir, le marteau destiné à Thor. Loki, craignant qu’un tel trésor ne rende les dieux trop puissants, tenta de saboter leur travail. Il se transforma en mouche et piqua Brokkr à plusieurs reprises pour briser sa concentration. Le forgeron, bien qu’endurci, sursauta légèrement, et le manche du marteau se retrouva plus court qu’il ne devait l’être. Malgré cela, Mjöllnir naquit, un marteau si puissant qu’il pouvait convoquer la foudre, pulvériser les montagnes et toujours revenir à la main de son maître. Même imparfait, il surpassait tout autre arme jamais forgée.',
        ),
        MythCard(
          id: '5',
          title: 'Offrande à Thor',
          description:
              'Les trésors sont présentés aux dieux. Thor reçoit Mjöllnir, merveille de puissance. Malgré son manche court, il devient l’arme sacrée qui fera trembler géants et ennemis d’Asgard.',
          imagePath: 'forge_5.webp',
          detailedStory:
              'Lorsque les trésors furent présentés aux dieux, tous furent émerveillés. Odin contempla Draupnir et Gungnir, comprenant qu’ils renforceraient son pouvoir et sa gloire. Mais le moment le plus attendu fut celui où Thor s’empara de Mjöllnir. Le marteau vibra dans sa main, dégageant une puissance brute qui fit frémir l’air autour de lui. Thor sentit aussitôt que cette arme deviendrait l’instrument de sa grandeur et la terreur de ses ennemis. Certes, le manche était trop court, mais sa force surpassait tout ce que l’on pouvait imaginer. Les dieux décidèrent que Loki avait accompli sa promesse, bien qu’à contrecœur et avec ses habituelles manigances. Thor pardonna à demi au filou, préférant célébrer l’acquisition d’une arme qui assurerait la protection d’Asgard contre les géants. Mjöllnir devint dès ce jour le symbole du pouvoir de Thor et l’un des trésors les plus sacrés du panthéon nordique.',
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
              'Fenrir, le loup monstrueux fils de Loki, est accueilli à Asgard pour être surveillé de près. Bien qu’encore jeune, il inspire déjà la terreur par sa taille et son appétit grandissant.',
          imagePath: 'fenrir_1.webp',
          detailedStory:
              'Fenrir était le fils de Loki et de la géante Angrboda, une créature née des unions interdites entre les dieux et les forces du chaos. Dès sa naissance, le loup gigantesque manifestait une nature sauvage et une force qui dépassait l’entendement.\n\nConscients du danger qu’il représentait selon les sinistres prophéties des Nornes, les dieux prirent une décision audacieuse : plutôt que de le bannir ou de le tuer, ils décidèrent de l’élever à Asgard pour mieux le surveiller et peut-être l’apprivoiser.\n\nMais Fenrir grandissait de jour en jour, et sa taille comme sa férocité croissaient à un rythme effrayant. Ses yeux jaunes brillaient d’une intelligence inquiétante, et ses crocs acérés pouvaient broyer les os les plus solides. Seul Tyr, le courageux dieu de la guerre, osait s’approcher de la bête pour la nourrir, gagnant ainsi sa confiance fragile.',
        ),
        MythCard(
          id: '2',
          title: 'Les chaînes échouent',
          description:
              'Les dieux inventent un jeu pour tester la force de Fenrir, mais ni Leyding ni Dromi, les chaînes forgées par les nains, ne résistent : il les brise d’un simple élan de ses muscles.',
          imagePath: 'fenrir_2.webp',
          detailedStory:
              'Quand Fenrir devint si grand qu’il dominait même les plus imposants des dieux, la peur s’installa à Asgard. Les prophéties annonçaient qu’il dévorerait Odin lors du Ragnarök, et sa puissance grandissante rendait cette menace de plus en plus réelle.\n\nLes dieux décidèrent alors de l’enchaîner. Ils présentèrent cela comme un jeu, un défi pour tester sa force légendaire. Fenrir, encore naïf malgré sa taille, accepta de se laisser lier par Leyding, la plus solide des chaînes forgées par les nains.\n\nMais d’un simple mouvement d’épaules, le loup brisa Leyding comme un vulgaire fil. Les maillons de fer volèrent dans toutes les directions. Les dieux, feignant l’admiration, tentèrent alors avec Dromi, une chaîne encore plus massive et résistante.\n\nFenrir la réduisit en miettes d’un seul élan, révélant une force si surnaturelle que les dieux comprirent qu’aucune chaîne ordinaire ne pourrait jamais retenir cette créature du chaos.',
        ),
        MythCard(
          id: '3',
          title: 'Gleipnir',
          description:
              'Les dieux commandent aux nains de forger Gleipnir, un lien magique tissé d’éléments impossibles. Il ressemble à un ruban de soie mais enferme une puissance surnaturelle.',
          imagePath: 'fenrir_3.webp',
          detailedStory:
              'Comprenant qu’aucune force brute ne pourrait venir à bout de Fenrir, Odin envoya secrètement un messager chez les nains de Svartalfheim. Ces maîtres forgerons, capables de créer des merveilles impossibles, reçurent une commande extraordinaire.\n\nIls devaient créer Gleipnir, un lien magique tissé à partir de six éléments impossibles à trouver : le bruit des pas d’un chat, la barbe d’une femme, les racines d’une montagne, les tendons d’un ours, le souffle d’un poisson et la salive d’un oiseau.\n\nCes ingrédients mystiques, invisibles et intangibles, furent assemblés par les nains dans leurs forges enchantées. Le résultat était paradoxal : Gleipnir ressemblait à un simple ruban de soie, fin et lisse au toucher, mais il contenait une puissance magique capable de lier les forces les plus destructrices de l’univers.\n\nQuand les dieux reçurent cette chaîne miraculeuse, ils surent qu’ils tenaient enfin l’arme capable d’entraver le loup du destin.',
        ),
        MythCard(
          id: '4',
          title: 'Le défi',
          description:
              'Fenrir, méfiant face à cette chaîne étrange, accepte de se laisser lier uniquement si un dieu place sa main dans sa gueule en gage de sincérité et de bonne foi.',
          imagePath: 'fenrir_4.webp',
          detailedStory:
              'Quand les dieux présentèrent Gleipnir à Fenrir, le loup, désormais méfiant après les tentatives précédentes, examina attentivement ce lien étrange. Malgré son apparence fragile, quelque chose dans cette chaîne éveillait ses instincts les plus profonds.\n\n"Cette chaîne me semble suspecte, dit Fenrir en reniflant Gleipnir. Elle paraît faible, mais je sens en elle une magie puissante. Si c’est encore un de vos jeux, pourquoi ne pas utiliser des chaînes ordinaires ?\n\nLes dieux tentèrent de le rassurer, prétendant que c’était justement parce qu’il avait brisé les chaînes précédentes qu’ils voulaient tester cette nouvelle création des nains.\n\nMais Fenrir posa ses conditions d’une voix grave qui fit trembler les fondations d’Asgard : "J’accepte de me laisser enchaîner avec ce lien, mais seulement si l’un d’entre vous place sa main dans ma gueule en gage de bonne foi. Ainsi, si vous me trompez, au moins l’un de vous paiera le prix de cette trahison."',
        ),
        MythCard(
          id: '5',
          title: 'Le sacrifice de Tyr',
          description:
              'Tyr, le seul à avoir gagné la confiance du loup, place sa main dans sa gueule. Lorsque Fenrir réalise la ruse, il mord et arrache la main du dieu du courage.',
          imagePath: 'fenrir_5.webp',
          detailedStory:
              'Un lourd silence tomba sur l’assemblée des dieux. Tous savaient qu’ils s’apprêtaient à trahir Fenrir, et que celui qui placerait sa main dans la gueule du loup la perdrait à coup sûr. Personne n’osait se porter volontaire.\n\nSeul Tyr, le dieu du courage et de l’honneur, s’avança. Il était le seul à avoir nourri Fenrir, le seul en qui le loup avait encore confiance. Sans hésitation, fidèle à sa réputation de bravoure, il tendit sa main droite et la plaça entre les mâchoires redoutables de la bête.\n\nGleipnir fut alors attaché autour des pattes de Fenrir. Le loup tenta de le briser comme les chaînes précédentes, bandant tous ses muscles, tirant de toutes ses forces. Mais plus il luttait, plus le lien magique se resserrait.\n\nRéalisant qu’il avait été dupé et qu’il resterait prisonnier pour l’éternité, Fenrir leva ses yeux jaunes vers Tyr. Un regard de tristesse et de rage mêlées passa entre le dieu et la bête. Puis, d’un coup sec, Fenrir referma sa mâchoire, arrachant la main de Tyr dans un craquement sinistre.\n\nFenrir fut ensuite traîné vers une île déserte et attaché à un rocher au plus profond de la terre, où il demeure enchaîné jusqu’au Ragnarök, le jour où il brisera enfin ses liens pour dévorer Odin.\n\nAinsi Tyr perdit-il sa main, mais gagna l’éternelle reconnaissance des dieux pour son sacrifice héroïque qui sauva les neuf mondes... du moins temporairement.',
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
              'Un matin, Thor découvre que son marteau Mjöllnir a été volé. Privé de sa plus grande arme, Asgard entier devient vulnérable face aux forces du chaos qui menacent les neuf mondes.',
          imagePath: 'thor_1.webp',
          detailedStory:
              'Un matin, Thor se réveilla dans une rage terrible qui fit trembler tout Asgard. Son marteau Mjöllnir, sa plus précieuse possession, avait disparu ! Cette arme légendaire, forgée par les nains dans les profondeurs de Svartalfheim, était capable de contrôler la foudre et de pulvériser les montagnes.\n\nSans Mjöllnir, Thor n’était plus qu’un dieu ordinaire. Pire encore, sans cette arme divine, tous les dieux d’Asgard étaient vulnérables face aux forces du chaos qui menaçaient constamment les neuf mondes.\n\nLes recherches commencèrent immédiatement. Heimdall scruta les horizons avec sa vue perçante, Odin envoya ses corbeaux Hugin et Munin aux quatre coins du cosmos, mais le marteau demeurait introuvable. C’est alors que les soupçons se portèrent vers les géants, éternels ennemis des dieux.',
        ),
        MythCard(
          id: '2',
          title: 'Le chantage de Thrym',
          description:
              'Le géant Thrym avoue avoir volé Mjöllnir et exige la main de Freyja en mariage pour le rendre. Sa demande outrageante indigne les dieux et provoque la fureur de la déesse elle-même.',
          imagePath: 'thor_2.webp',
          detailedStory:
              'Les investigations menèrent rapidement au géant Thrym, roi des géants de givre dans les terres glacées de Jötunheim. Loin de nier son forfait, il avoua sans honte avoir dérobé le marteau et l’avoir caché dans les profondeurs de la terre, là où aucun dieu ne pourrait le trouver.\n\nMais Thrym posa ses conditions avec un sourire narquois : il ne rendrait Mjöllnir que si les dieux lui donnaient la main de la belle Freyja en mariage. La déesse de l’amour et de la beauté devrait devenir son épouse et régner à ses côtés sur le royaume des géants.\n\nCette demande outrageante indigna tous les dieux d’Asgard. Comment oser réclamer la plus belle des déesses en échange d’un objet volé ? Freyja elle-même entra dans une colère si terrible que son collier magique Brísingamen se brisa sous la force de sa fureur. Les murs du Valhalla tremblèrent sous sa rage.',
        ),
        MythCard(
          id: '3',
          title: 'Déguisement',
          description:
              'Pour duper Thrym, Loki suggère que Thor se déguise en Freyja. À contrecœur, le dieu du tonnerre accepte et enfile une robe de mariée et un voile pour tromper les géants.',
          imagePath: 'thor_3.webp',
          detailedStory:
              'C’est alors que Loki eut une idée aussi audacieuse que ridicule : Thor devrait se déguiser en Freyja pour tromper Thrym ! L’idée de voir le plus viril des dieux revêtir des habits de femme amusa beaucoup le rusé Loki.\n\nThor protesta violemment : "Jamais ! Les dieux se moqueront de moi pour l’éternité ! Ma réputation de guerrier sera ruinée !\n\nMais Heimdall le sage intervint: "Préfères-tu que les géants envahissent Asgard sans que nous puissions nous défendre ? Sans Mjöllnir, nous sommes perdus."\n\nÀ contrecœur, Thor accepta. Avec l’aide de Loki, il revêtit une magnifique robe de mariée, se couvrit d’un voile orné de bijoux précieux, et plaça sur sa poitrine le collier réparé de Freyja. Ses mains puissantes furent dissimulées sous de longs gants de soie. Ainsi déguisé, le dieu du tonnerre ressemblait à une épouse timide et voilée.',
        ),
        MythCard(
          id: '4',
          title: 'Le festin',
          description:
              'Lors du banquet, Thor dévore un bœuf, huit saumons et trois tonneaux d’hydromel. Les géants doutent, mais Loki justifie son appétit par une longue période de jeûne amoureux.',
          imagePath: 'thor_4.webp',
          detailedStory:
              'Le stratagème sembla d’abord fonctionner parfaitement. Thrym accueillit sa "fiancée" avec une joie débordante et organisa immédiatement un grand banquet nuptial. Tous les géants de Jötunheim furent conviés pour célébrer cette union extraordinaire.\n\nMais au cours du festin, Thor ne put contenir son appétit légendaire. Oubliant son rôle, il dévora un bœuf entier, huit saumons, et engloutit tous les mets destinés aux femmes. Il vida ensuite trois tonneaux entiers d’hydromel d’un trait, éveillant les soupçons des géants.\n\n"Par ma barbe !" s’exclama Thrym, les yeux écarquillés. "Je n’ai jamais vu une femme manger et boire avec un tel appétit ! Pourquoi la belle Freyja se montre-t-elle si vorace ?\n\nLoki, toujours prompt à mentir, répondit avec aplomb : "Noble Thrym, Freyja était si excitée par ce mariage qu’elle n’a pas touché à la nourriture depuis huit jours et huit nuits ! C’est la faim qui la rend si affamée."',
        ),
        MythCard(
          id: '5',
          title: 'Récupération',
          description:
              'Lorsque Mjöllnir est placé sur ses genoux pour bénir le mariage, Thor le saisit aussitôt, déchire son voile et massacre Thrym et les géants dans un orage de foudre.',
          imagePath: 'thor_5.webp',
          detailedStory:
              'Thrym, rassuré par l’explication de Loki, décida de procéder à la cérémonie. Selon la tradition, il ordonna qu’on apporte le marteau de Thor pour bénir l’union et le placer sur les genoux de la mariée, symbole de fertilité et de protection.\n\nDès que Mjöllnir fut posé sur ses genoux, Thor sentit sa force divine revenir en lui comme un torrent. Ses yeux s’enflammèrent de joie et de rage contenues. D’un geste puissant, il arracha son voile et déchira sa robe de mariée.\n\n"Je suis Thor, fils d’Odin !" rugit-it en brandissant son marteau. "Et voici ma réponse à votre chantage !\n\nLa foudre jaillit de Mjöllnir tandis que Thor massacrait Thrym et tous les géants présents dans un déchaînement de violence divine. Les éclairs illuminèrent la salle du festin transformée en champ de bataille, et le tonnerre résonna dans tout Jötunheim.\n\nAinsi Thor récupéra-t-il son marteau, et jamais plus les géants n’osèrent défier ouvertement le dieu du tonnerre.',
        ),
      ],
    ),
    MythStory(
      title: 'La Pêche du Serpent',
      correctOrder: [
        MythCard(
          id: '1',
          title: 'La quête du chaudron',
          description:
              'Thor se rend chez le géant Hymir afin de demander son aide pour obtenir un chaudron immense, capable de contenir l’hydromel des dieux. Leur rencontre marque le début d’une alliance fragile.',
          imagePath: 'peche_1.webp',
          detailedStory:
              'À l’aube d’un matin gris et glacial, Thor, le dieu guerrier, franchit les portes d’une caverne gelée où vivait Hymir, le géant à la peau dure comme le givre et aux yeux semblables à des abîmes insondables. Le souffle du dieu formait des nuages blancs dans l’air figé, et chacun de ses pas résonnait dans le silence de la demeure du colosse. Il ne venait pas en conquérant, mais en implorant l’aide d’Hymir pour retrouver un chaudron d’une taille colossale, capable de contenir l’hydromel des dieux. Le géant laissa échapper un rire grave, qui fit vibrer les parois de pierre et ébranla les stalactites au-dessus de leur tête. Puis son amusement se mua en méfiance : que voulait cet être des cieux dans son royaume glacé ? Après un long moment où le silence pesa plus que les mots, une alliance fragile se forma. Hymir accepta, mais avec arrière-pensée et défi : l’océan les attendait, indompté et impitoyable. Le destin, déjà, semblait suspendu aux vagues, et nul ne savait que cette alliance allait les confronter à une créature capable de défier l’imagination et le courage des dieux.',
        ),
        MythCard(
          id: '2',
          title: 'Le sacrifice du taureau',
          description:
              'Pour attirer une créature digne de leur défi, Hymir exige un appât hors du commun. Thor arrache la tête d’un taureau puissant, dont le sang chaud appelle les forces abyssales de l’océan.',
          imagePath: 'peche_2.webp',
          detailedStory:
              'Sous un ciel chargé de nuages noirs et bas, Hymir posa son exigence avec un grondement qui fit trembler la caverne : pour attirer la créature des abysses, il fallait un appât digne de sa puissance. Thor, sans un souffle d’hésitation, se dirigea vers le troupeau du géant et choisit le plus robuste des taureaux. L’animal mugissait, ses yeux reflétant une conscience de sa fin prochaine, ses sabots frappant la neige gelée. Thor agrippa les cornes et, d’un effort surhumain, renversa la bête, son sang chaud s’écoulant en une rivière écarlate qui contrastait avec la blancheur immaculée de la glace. Hymir observa en silence, partagé entre admiration et colère, tandis que Thor soulevait la tête du taureau, la brandissant comme un trophée offert aux flots. L’air vibrait de l’odeur du fer et de la mort. Les mouettes tournaient au-dessus, comme attirées par ce sacrifice brutal. Chaque goutte de sang sur la neige semblait appeler les profondeurs, et le vent se mit à hurler, comme si l’océan lui-même savait qu’un affrontement extraordinaire allait commencer.',
        ),
        MythCard(
          id: '3',
          title: 'L’océan sans fin',
          description:
              'Thor et Hymir s’embarquent sur une barque minuscule, affrontant des vagues furieuses et un ciel orageux. La mer rugit, comme si elle pressentait l’affrontement qui allait bouleverser les mondes.',
          imagePath: 'peche_3.webp',
          detailedStory:
              'Ils prirent place dans une barque frêle, si petite que l’on aurait cru que leur puissance suffirait à briser son bois à chaque vague. Hymir, immense, saisit les rames et fendit les flots avec des gestes lents et puissants, faisant éclater l’eau dans des gerbes argentées. À ses côtés, Thor fixait l’horizon, ses yeux brillant d’une flamme que ni le vent ni le froid ne pouvaient éteindre. La mer se déchaînait, ses vagues immenses frappant la frêle embarcation, tandis que les nuages s’amoncelaient, lourds et noirs, menaçant d’engloutir le ciel dans un chaos de tonnerre. Thor lia la tête sanglante du taureau à un hameçon d’acier sombre, ses mains rapides malgré le roulis incessant. Chaque clapotis semblait battre le rythme d’un tambour funèbre, chaque rafale rappelant qu’ils naviguaient aux confins du monde connu. Le silence entre eux était lourd, chargé de crainte et de défi, car tous deux pressentaient que ce qu’ils convoquaient des profondeurs n’était pas une créature ordinaire, mais un monstre capable de bouleverser les océans et le destin des dieux.',
        ),
        MythCard(
          id: '4',
          title: 'La morsure des profondeurs',
          description:
              'Le serpent de Midgard surgit des flots, immense et terrifiant, ses anneaux soulevant des tempêtes. Thor lutte à mains nues pour le retenir, défiant l’océan et la créature qui étreint le monde.',
          imagePath: 'peche_4.webp',
          detailedStory:
              'Le silence de l’océan éclata soudain en un fracas monstrueux : la ligne tendue vibra comme un éclair de métal et Thor tira de toutes ses forces. L’eau explosa, et une horreur antique apparut, écailles sombres comme la nuit, yeux d’un jaune incandescent, anneaux enserrant l’air comme pour englober le monde. Le serpent des profondeurs surgit, vomissant torrents d’écume et de fureur. La barque menaçait de se briser sous le poids de la bête. Thor, pieds ancrés dans le bois trempé, tenait la corde comme s’il voulait retenir l’océan lui-même. Hymir, glacé par la terreur, recula, ses yeux écarquillés fixant la gueule béante capable d’engloutir montagnes et citadelles. Le serpent, enragé, se tordait et ses anneaux fracassaient les vagues en tempêtes. Chaque seconde semblait suspendre le temps, oscillant entre la victoire et la catastrophe, tandis que le tonnerre et les éclairs illuminaient cette lutte titanesque.',
        ),
        MythCard(
          id: '5',
          title: 'Le combat inachevé',
          description:
              'Alors que Thor s’apprête à abattre sa puissance sur le serpent, Hymir, terrorisé, coupe la ligne. La créature disparaît dans les profondeurs, laissant une menace suspendue et un duel inachevé.',
          imagePath: 'peche_5.webp',
          detailedStory:
              'Thor, le regard incandescent, était prêt à abattre sa puissance sur le serpent, chaque muscle tendu, chaque fibre de son être vibrant d’une énergie divine. Mais avant qu’il ne puisse frapper, un cri de terreur s’éleva derrière lui. Hymir, dans un élan de panique, avait saisi la corde et, d’un geste désespéré, la rompit. Le serpent, libéré de son lien, disparut dans les profondeurs avec un rugissement qui fit trembler l’océan tout entier.\n\nLa barque chavira sous le choc, projetant Thor et Hymir dans les eaux glacées. Le dieu du tonnerre émergea, haletant, ses cheveux collés à son visage par l’eau salée. Hymir, tremblant de froid et de peur, se cramponna à une planche flottante. Le silence retomba sur l’océan, seulement troublé par le clapotis des vagues et le souffle rauque des deux survivants.\n\nThor regarda l’horizon, le cœur lourd. Il n’avait pas vaincu le serpent des profondeurs, mais il avait survécu à une épreuve qui aurait brisé n’importe quel autre être. Le destin des dieux restait incertain, mais une chose était claire : la lutte contre les forces du chaos ne faisait que commencer.',
        ),
      ],
    ),
    MythStory(
      title: 'La mort de Baldr',
      correctOrder: [
        MythCard(
          id: '1',
          title: 'Cauchemars de Baldr',
          description:
              'Baldr, dieu aimé de tous, est hanté par des songes prophétiques annonçant sa mort. Sa lumière vacille, et les dieux, inquiets, sentent qu’un destin sombre et inéluctable approche.',
          imagePath: 'baldr_1.webp',
          detailedStory:
              'Il fut un temps, lointain et sacré, où les dieux arpentaient les cieux d’Asgard et régnaient sur les neuf mondes. Parmi eux, nul n’était plus aimé que Baldr, le fils rayonnant d’Odin et de Frigg. Il était la lumière incarnée, la beauté sans faille, un dieu si pur que même les plus sombres créatures le respectaient. Partout où il marchait, la paix s’installait, les rires naissaient, et les cœurs se réchauffaient.\n\nMais un jour, cette clarté vacilla. Baldr fut envahi, nuit après nuit, par des songes noirs, des visions terrifiantes et claires comme des prophéties. Il se voyait périr, transpercé par une arme inconnue, et les échos de sa mort retentissaient jusque dans les racines d’Yggdrasil. Ces cauchemars ne le quittaient plus, et il les rapportait aux siens, le visage pâle, l’âme ébranlée.\n\nLes dieux, eux, ne rirent pas. Car les rêves de Baldr n’étaient point de simples illusions. Ils portaient en eux la vérité crue de l’avenir. Un frisson parcourut les couloirs dorés du palais des Ases. Car si Baldr devait périr… alors, c’était le monde lui-même qui s’apprêtait à sombrer.',
        ),
        MythCard(
          id: '2',
          title: 'Le serment de Frigg',
          description:
              'Pour sauver son fils, Frigg obtient des serments de toutes les choses du monde afin qu’aucune ne blesse Baldr. Mais elle néglige le gui, frêle et discret, croyant ce végétal trop insignifiant.',
          imagePath: 'baldr_2.webp',
          detailedStory:
              'Frigg, la reine des cieux, ne pouvait tolérer cette menace. Son amour pour Baldr était infini, et l’idée même de le voir disparaître lui était plus insupportable que mille morts. Elle se mit donc en route, portée par la détresse et la détermination.\n\nÀ travers les vents glacés de Niflheim, les terres brûlantes de Muspellheim, les forêts profondes d’Alfheim jusqu’aux abysses de Helheim, elle fit prêter serment à toutes choses existantes. Aux pierres, de ne point heurter son fils. À l’eau, de ne point le noyer. Au feu, de ne pas le brûler. Aux animaux, de ne jamais l’attaquer. À chaque plante, à chaque métal, à chaque élément, elle extorqua une promesse sacrée de ne jamais nuire à Baldr.\n\nLorsque son œuvre fut achevée, Asgard respira de nouveau. Plus rien ne semblait pouvoir blesser le dieu bien-aimé. Mais, dans sa précipitation, Frigg jugea sans importance une plante modeste et discrète, un végétal insignifiant suspendu aux branches des vieux chênes : le gui. Trop jeune, trop frêle, pensa-t-elle. Il ne saurait blesser qui que ce soit.\n\nEt ainsi, elle passa son chemin.',
        ),
        MythCard(
          id: '3',
          title: 'Le gui',
          description:
              'Loki découvre la faille : le gui n’a pas prêté serment. Déguisé en vieille femme, il arrache la vérité à Frigg et cueille cette plante fragile, en la transformant en arme d’un destin cruel.',
          imagePath: 'baldr_3.webp',
          detailedStory:
              'Là où les dieux voient l’oubli, Loki voit une ouverture. Le dieu du chaos, de la ruse et de la discorde, toujours à l’affût d’un secret ou d’une faille, sentit dans l’air la possibilité d’un bouleversement.\n\nPrenant l’apparence d’une vieille femme, il s’introduisit auprès de Frigg, lui tenant compagnie comme une âme curieuse et bienveillante. Il sut poser les bonnes questions, au bon moment, avec cette douceur trompeuse qui lui était coutumière.\n\n« Toutes les choses du monde ont-elles promis de protéger Baldr ? demanda-t-il d’une voix chevrotante.\n\n— Toutes, répondit Frigg avec un sourire fatigué. Toutes… sauf peut-être une. Une simple pousse de gui, qui pend aux arbres à l’ouest du Valhalla. Elle est si tendre, si jeune, si inoffensive... »\n\nCe fut tout ce que Loki avait besoin d’entendre. Il remercia, s’inclina, puis s’évanouit dans les ombres. Ses pas le menèrent aussitôt aux chênes sacrés, là où le gui verdissait doucement au vent d’automne. D’un geste calculé, il le cueillit, sentant en lui la clef d’un destin qu’il allait briser. Car même le plus fragile des êtres, entre les mains du mal, peut devenir une arme fatale.',
        ),
        MythCard(
          id: '4',
          title: 'La flèche',
          description:
              'Loki façonne le gui en flèche et la remet à Höd, le frère aveugle de Baldr. Sous prétexte d’un jeu innocent, il guide sa main, faisant de lui l’instrument involontaire d’un fratricide tragique.',
          imagePath: 'baldr_4.webp',
          detailedStory:
              'De retour dans son antre, Loki se mit à l’ouvrage. Il façonna le gui avec soin, lui donnant la forme d’une flèche fine et souple. Elle n’avait rien d’impressionnant, et pourtant, elle vibrait d’un pouvoir sinistre. C’était la seule chose au monde qui pouvait toucher Baldr, et Loki le savait.\n\nBientôt, arriva le jour des jeux en Asgard. Dans la grande plaine du palais, les dieux s’étaient rassemblés pour s’amuser d’un étrange divertissement : ils lançaient des armes, des pierres, des lances, contre Baldr, qui restait debout sans la moindre égratignure. Car rien, pensaient-ils, ne pouvait plus lui faire de mal.\n\nC’est alors que Loki s’approcha de Höd, le frère aveugle de Baldr, silencieux et solitaire à l’écart de la fête.\n\n« Pourquoi ne participez-vous pas, noble Höd ? murmura-t-il avec douceur. Votre frère mérite aussi un hommage de votre part. Voici une flèche... laissez-moi guider votre bras. »\n\nHöd, privé de la vue mais non du cœur, accepta sans malice. Il n’avait aucun soupçon, aucune raison de douter. Il tendit son arc, sentit la main de Loki poser la flèche entre ses doigts.\n\nEt tira.',
        ),
        MythCard(
          id: '5',
          title: 'La mort de Baldr',
          description:
              'La flèche en gui frappe Baldr en plein cœur. Le dieu lumineux s’effondre, mortellement atteint. Asgard plonge dans le silence et le désespoir, tandis que Loki s’éclipse, porteur du chaos.',
          imagePath: 'baldr_5.webp',
          detailedStory:
              'Le silence s’abattit avant même que la flèche n’atteigne sa cible. Elle fendit l’air, presque invisible, presque irréelle. Puis elle se planta dans la poitrine de Baldr avec une précision terrible.\n\nIl poussa un cri, un seul. Un son bref, déchirant, qui glaça le sang des immortels. Puis il s’effondra, comme frappé par la foudre.\n\nUn silence de mort enveloppa Asgard. Les rires cessèrent, les sourires s’éteignirent. L’incompréhension précéda l’horreur, qui bientôt se mua en désespoir. Frigg accourut, tomba à genoux, enlaça le corps inerte de son fils, hurlant un chagrin que même les étoiles entendirent.\n\nHöd, découvrant ce qu’il avait fait, laissa tomber son arc et sanglota, inconsolable. Il n’avait été que l’instrument, le jouet d’un esprit malin. Mais cela n’ôta rien à la tragédie.\n\nEt Loki, maître de la discorde, s’éclipsa dans les ombres, le sourire aux lèvres.\n\nBaldr était mort. Et avec lui, une part irremplaçable de la lumière du monde. Ce jour-là, les dieux comprirent que le crépuscule approchait. Le fil du destin avait été tranché. Ragnarök, le crépuscule des dieux, s’était mis en marche.',
        ),
      ],
    ),
    MythStory(
      title: 'Le Châtiment de Loki',
      correctOrder: [
        MythCard(
          id: '1',
          title: 'La fuite du fauteur de troubles',
          description:
              'Après la mort de Baldr, trahi par la ruse de Loki, le fauteur de troubles s’enfuit, changeant sans cesse de forme et se cachant dans une cabane aux quatre horizons, redoutant la vengeance des dieux.',
          imagePath: 'chatiment_1.webp',
          detailedStory:
              'Lorsque Baldr, le dieu aimé de tous, fut frappé par la flèche guidée par la ruse de Loki, un silence funèbre s’abattit sur Asgard. Les éclats de rire habituels de Loki furent remplacés par un cœur battant la peur et l’orgueil. Pressentant la colère des Ases, il changea de forme : serpent glissant entre les pierres des rivières, oiseau solitaire battant des ailes au-dessus des falaises escarpées, vieillard au regard fuyant. Chaque transformation n’était qu’une feinte contre le destin, et pourtant, même dans ses pires déguisements, son crime brillait comme une lumière sombre que nul ne pouvait éteindre. Il s’installa dans une vallée reculée, bâtissant une cabane étrange aux quatre portes ouvertes sur l’horizon, pour guetter chaque menace. Les nuits étaient longues et glaciales, et assis devant son feu, Loki rumina ses pensées : ruse contre loyauté, liberté contre fatalité. Le vent portait le murmure des pas d’Odin et des Ases, et chaque craquement dans la forêt résonnait comme l’écho d’une vengeance imminente. La fuite n’était qu’un sursis fragile, et le filet du destin se resserrait inexorablement autour du dieu changeant, comme une ombre prête à l’engloutir.',
        ),
        MythCard(
          id: '2',
          title: 'La traque des dieux',
          description:
              'Sous la direction d’Odin, les Ases et leurs alliés jurent que nul recoin du cosmos ne servira de refuge à Loki. La nature elle-même devient leur alliée dans une chasse inéluctable et implacable.',
          imagePath: 'chatiment_2.webp',
          detailedStory:
              'Dans la grande salle d’assemblée d’Asgard, les visages des Ases étaient marqués non par la colère mais par une détermination glaciale. Odin, le Père de Tout, leva son unique œil vers le ciel, et jura que Loki ne trouverait aucun refuge sous la voûte du monde. La traque commença : les faucons d’Odin planèrent au-dessus des forêts, les loups de Fenrir flairèrent chaque piste dans la neige, et les guerriers d’Asgard sillonnèrent vallées et montagnes. Même les Vanes, alliés depuis longtemps des Ases, prêtèrent leurs dons pour retrouver le traître. La nature elle-même semblait conspirer contre Loki : chaque pierre roulait sous ses pas, chaque souffle de vent portait son odeur, chaque rivière reflétait sa fuite éperdue. Les jours et les nuits se succédaient, mais la certitude grandissait : nul ne peut échapper éternellement à ceux qu’il a trahis. La traque ne ressemblait plus à une chasse ordinaire, mais à un châtiment cosmique, où chaque recoin du monde participait à la justice divine. La vengeance était inscrite dans l’ordre même des choses, et les pas des chasseurs divins faisaient vibrer la terre, comme si les neuf royaumes tout entiers retenaient leur souffle.',
        ),
        MythCard(
          id: '3',
          title: 'La capture au filet',
          description:
              'Sous la forme d’un saumon argenté, Loki tente d’échapper à ses poursuivants, mais le filet tissé par les dieux se resserre. Thor, d’une poigne infaillible, l’arrache aux flots et le livre à la justice divine.',
          imagePath: 'chatiment_3.webp',
          detailedStory:
              'Poussé à bout, Loki se glissa dans une rivière glaciale et prit la forme d’un saumon aux écailles étincelantes, réfléchissant la lueur froide de la lune. Bondissant de rocher en rocher, il espérait semer ses poursuivants, mais les Ases, armés de la sagesse d’Odin, avaient déjà préparé un filet colossal, tissé de cordes enchantées et si vaste qu’il semblait englober toute la vallée. Les dieux descendirent le courant, resserrant leur piège avec la patience des chasseurs qui savent que la proie ne peut échapper à l’inévitable. Le saumon bondit hors de l’eau, muscles tendus et flancs étincelants, tentant un dernier effort désespéré pour s’échapper. Mais Thor, d’une poigne divine, l’attrapa par la queue et le projeta sur la berge. Le filet se referma sur lui comme une toile de destin inéluctable. Reprenant sa forme humaine, Loki se retrouva entouré de visages sévères, les yeux d’Odin brûlant de jugement, ceux de Thor emplis de force et de colère, et ceux des autres Ases fixant son destin. La défiance brillait encore dans ses yeux, mais derrière cette flamme, l’ombre de la peur s’insinuait insidieusement. Son pouvoir de transformation avait été vaincu, et il comprit que la justice des dieux ne faillirait jamais.',
        ),
        MythCard(
          id: '4',
          title: 'Le jugement sans pitié',
          description:
              'Les dieux rappellent ses crimes et décident d’un châtiment éternel. Loki verra sa descendance brisée, et de ses propres fils naîtront les chaînes qui l’attacheront, scellant un sort cruel et sans retour.',
          imagePath: 'chatiment_4.webp',
          detailedStory:
              'Enchaîné devant les Ases, Loki entendit les accusations tomber comme des marteaux frappant un enclume : la mort de Baldr, les humiliations infligées aux dieux, et toutes les ruses accumulées depuis l’aube des temps. Certains réclamaient sa mort immédiate, mais Odin leva la main, déclarant que la fin serait trop douce. Le châtiment devait refléter la durée même du monde. Alors fut décidé que Loki serait attaché dans une caverne profonde et sombre, forcé de supporter le venin d’un serpent suspendu au-dessus de son visage. Mais avant même ce supplice, une cruauté plus terrible fut infligée : ses fils, Nárfi et Váli, furent transformés l’un contre l’autre, et de leurs entrailles les dieux forgèrent les chaînes qui retenaient leur père. La descendance de Loki était détruite, son avenir effacé, et chaque lien tissé était un rappel cruel de sa trahison. Le jugement des Ases ne se contentait pas de punir, il érigeait la souffrance en monument éternel, gravé dans la pierre et le sang, destiné à rappeler à tous que la ruse contre le divin se paie au prix fort.',
        ),
        MythCard(
          id: '5',
          title: 'L’enchaînement sous la pierre',
          description:
              'Dans une caverne glaciale, Loki est cloué à la roche par les entrailles de ses enfants. Ses paroles de défi résonnent dans le vide, promesse d’une vengeance future, mais impuissante face aux chaînes divines.',
          imagePath: 'chatiment_5.webp',
          detailedStory:
              'Dans une caverne glaciale, les dieux accomplirent la sentence. Loki fut étendu sur une pierre polie par le froid, ses bras et ses jambes écartés par les chaînes façonnées à partir des entrailles de ses fils. Les Ases les plus puissants tirèrent sur ces liens organiques, les clouant à la roche avec une force divine qui ne laissait aucun espoir de mouvement. Des gouttes glacées perlaient du plafond, tombant en rythme cruel sur son visage brûlé de douleur et de désespoir. Autour de lui, les dieux observaient : certains satisfaits, d’autres troublés par la cruauté de leur justice. Loki, malgré les tortures, parvint à lancer des paroles de défi, jurant que cette injustice ne resterait pas impunie. Mais les échos de ses cris se perdirent dans la caverne, engloutis par le silence de pierre et la noirceur des lieux. Il devint une ombre dans la roche, un présage de tempête et de vengeance à venir. La terre elle-même semblait boire sa douleur, l’absorbant pour l’éternité.',
        ),
        MythCard(
          id: '6',
          title: 'Le venin et la fidélité',
          description:
              'Un serpent suspendu laisse tomber son venin brûlant sur Loki, dont les hurlements ébranlent la terre. Mais Sigyn, fidèle, recueille goutte après goutte, adoucissant un supplice éternel qui façonne le monde.',
          imagePath: 'chatiment_6.webp',
          detailedStory:
              'Au-dessus du visage de Loki, un serpent dont le venin corrosif tombait goutte à goutte, distillait une torture infinie. Chaque perle brûlait sa peau et le fit hurler dans un écho qui secouait les rochers et la caverne entière. Pourtant, il ne fut pas laissé seul. Sigyn, son épouse, resta à ses côtés, fidèle malgré tout, tenant un bol pour recueillir le poison et soulager ses souffrances. Mais lorsque la coupe était pleine, le venin tombait sur le visage de Loki, le frappant avec une intensité brûlante. Ses hurlements résonnaient jusqu’à Midgard, ébranlant la terre et les royaumes des hommes. Ainsi commença son supplice éternel : enchaîné par le sang de ses fils, tourmenté par le venin, sauvé par l’amour indéfectible de Sigyn. Ce châtiment cruel devint une cicatrice vivante du cosmos, un avertissement pour tous les dieux et les hommes, et une promesse que lors du Ragnarök, la fureur de Loki se libérerait, enveloppant les neuf mondes dans un chaos dévastateur.',
        ),
      ],
    ),
  ];
}
