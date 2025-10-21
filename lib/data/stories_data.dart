import 'package:easy_localization/easy_localization.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';

List<MythStory> getMythStories() {
  return [
    MythStory(
      title: 'story_loading_title'.tr(),
      correctOrder: [
        MythCard(
          id: 'dummy_1',
          title: 'story_loading_card_title'.tr(),
          description: 'story_loading_card_description'.tr(),
          imagePath: 'loading.webp', // A placeholder image
          detailedStory: 'story_loading_card_detailed_story'.tr(),
        ),
      ],
    ),
    MythStory(
      title: 'story_creation_of_the_world_title'.tr(),
      correctOrder: [
        MythCard(
          id: '1',
          title: 'story_creation_of_the_world_card_1_title'.tr(),
          description: 'story_creation_of_the_world_card_1_description'.tr(),
          imagePath: 'creation_1.webp',
          detailedStory: 'story_creation_of_the_world_card_1_detailed_story'.tr(),
        ),
        MythCard(
          id: '2',
          title: 'story_creation_of_the_world_card_2_title'.tr(),
          description: 'story_creation_of_the_world_card_2_description'.tr(),
          imagePath: 'creation_2.webp',
          detailedStory: 'story_creation_of_the_world_card_2_detailed_story'.tr(),
        ),
        MythCard(
          id: '3',
          title: 'story_creation_of_the_world_card_3_title'.tr(),
          description: 'story_creation_of_the_world_card_3_description'.tr(),
          imagePath: 'creation_3.webp',
          detailedStory: 'story_creation_of_the_world_card_3_detailed_story'.tr(),
        ),
        MythCard(
          id: '4',
          title: 'story_creation_of_the_world_card_4_title'.tr(),
          description: 'story_creation_of_the_world_card_4_description'.tr(),
          imagePath: 'creation_4.webp',
          detailedStory: 'story_creation_of_the_world_card_4_detailed_story'.tr(),
        ),
        MythCard(
          id: '5',
          title: 'story_creation_of_the_world_card_5_title'.tr(),
          description: 'story_creation_of_the_world_card_5_description'.tr(),
          imagePath: 'creation_5.webp',
          detailedStory: 'story_creation_of_the_world_card_5_detailed_story'.tr(),
        ),
      ],
    ),
    MythStory(
      title: 'story_war_of_aesir_and_vanir_title'.tr(),
      correctOrder: [
        MythCard(
          id: '1',
                    title: 'story_war_of_aesir_and_vanir_card_1_title'.tr(),
                    description: 'story_war_of_aesir_and_vanir_card_1_description'.tr(),
                    imagePath: 'ases_vanes_1.webp',
                    detailedStory: 'story_war_of_aesir_and_vanir_card_1_detailed_story'.tr(),
        ),
        MythCard(
          id: '2',
                    title: 'story_war_of_aesir_and_vanir_card_2_title'.tr(),
                    description: 'story_war_of_aesir_and_vanir_card_2_description'.tr(),
                    imagePath: 'ases_vanes_2.webp',
                    detailedStory: 'story_war_of_aesir_and_vanir_card_2_detailed_story'.tr(),
        ),
        MythCard(
          id: '3',
                    title: 'story_war_of_aesir_and_vanir_card_3_title'.tr(),
                    description: 'story_war_of_aesir_and_vanir_card_3_description'.tr(),
                    imagePath: 'ases_vanes_3.webp',
                    detailedStory: 'story_war_of_aesir_and_vanir_card_3_detailed_story'.tr(),
        ),
        MythCard(
          id: '4',
                    title: 'story_war_of_aesir_and_vanir_card_4_title'.tr(),
                    description: 'story_war_of_aesir_and_vanir_card_4_description'.tr(),
                    imagePath: 'ases_vanes_4.webp',
                    detailedStory: 'story_war_of_aesir_and_vanir_card_4_detailed_story'.tr(),
        ),
        MythCard(
          id: '5',
                    title: 'story_war_of_aesir_and_vanir_card_5_title'.tr(),
                    description: 'story_war_of_aesir_and_vanir_card_5_description'.tr(),
                    imagePath: 'ases_vanes_5.webp',
                    detailedStory: 'story_war_of_aesir_and_vanir_card_5_detailed_story'.tr(),
        ),
        MythCard(
          id: '6',
                    title: 'story_war_of_aesir_and_vanir_card_6_title'.tr(),
                    description: 'story_war_of_aesir_and_vanir_card_6_description'.tr(),
                    imagePath: 'ases_vanes_6.webp',
                    detailedStory: 'story_war_of_aesir_and_vanir_card_6_detailed_story'.tr(),
        ),
      ],
    ),
    MythStory(
      title: 'story_mead_of_poetry_title'.tr(),
      correctOrder: [
        MythCard(
          id: '1',
                    title: 'story_mead_of_poetry_card_1_title'.tr(),
                    description: 'story_mead_of_poetry_card_1_description'.tr(),
                    imagePath: 'mead_1.webp',
                    detailedStory: 'story_mead_of_poetry_card_1_detailed_story'.tr(),
        ),
        MythCard(
          id: '2',
                    title: 'story_mead_of_poetry_card_2_title'.tr(),
                    description: 'story_mead_of_poetry_card_2_description'.tr(),
                    imagePath: 'mead_2.webp',
                    detailedStory: 'story_mead_of_poetry_card_2_detailed_story'.tr(),
        ),
        MythCard(
          id: '3',
                    title: 'story_mead_of_poetry_card_3_title'.tr(),
                    description: 'story_mead_of_poetry_card_3_description'.tr(),
                    imagePath: 'mead_3.webp',
                    detailedStory: 'story_mead_of_poetry_card_3_detailed_story'.tr(),
        ),
        MythCard(
          id: '4',
                    title: 'story_mead_of_poetry_card_4_title'.tr(),
                    description: 'story_mead_of_poetry_card_4_description'.tr(),
                    imagePath: 'mead_4.webp',
                    detailedStory: 'story_mead_of_poetry_card_4_detailed_story'.tr(),
        ),
        MythCard(
          id: '5',
                    title: 'story_mead_of_poetry_card_5_title'.tr(),
                    description: 'story_mead_of_poetry_card_5_description'.tr(),
                    imagePath: 'mead_5.webp',
                    detailedStory: 'story_mead_of_poetry_card_5_detailed_story'.tr(),
        ),
        MythCard(
          id: '6',
                    title: 'story_mead_of_poetry_card_6_title'.tr(),
                    description: 'story_mead_of_poetry_card_6_description'.tr(),
                    imagePath: 'mead_6.webp',
                    detailedStory: 'story_mead_of_poetry_card_6_detailed_story'.tr(),
        ),
      ],
    ),
    MythStory(
      title: 'story_the_wall_of_asgard_title'.tr(),
      correctOrder: [
        MythCard(
          id: '1',
          title: 'story_the_wall_of_asgard_card_1_title'.tr(),
          description: 'story_the_wall_of_asgard_card_1_description'.tr(),
          imagePath: 'wall_1.webp',
          detailedStory: 'story_the_wall_of_asgard_card_1_detailed_story'.tr(),
        ),
        MythCard(
          id: '2',
          title: 'story_the_wall_of_asgard_card_2_title'.tr(),
          description: 'story_the_wall_of_asgard_card_2_description'.tr(),
          imagePath: 'wall_2.webp',
          detailedStory: 'story_the_wall_of_asgard_card_2_detailed_story'.tr(),
        ),
        MythCard(
          id: '3',
          title: 'story_the_wall_of_asgard_card_3_title'.tr(),
          description: 'story_the_wall_of_asgard_card_3_description'.tr(),
          imagePath: 'wall_3.webp',
          detailedStory: 'story_the_wall_of_asgard_card_3_detailed_story'.tr(),
        ),
        MythCard(
          id: '4',
          title: 'story_the_wall_of_asgard_card_4_title'.tr(),
          description: 'story_the_wall_of_asgard_card_4_description'.tr(),
          imagePath: 'wall_4.webp',
          detailedStory: 'story_the_wall_of_asgard_card_4_detailed_story'.tr(),
        ),
        MythCard(
          id: '5',
          title: 'story_the_wall_of_asgard_card_5_title'.tr(),
          description: 'story_the_wall_of_asgard_card_5_description'.tr(),
          imagePath: 'wall_5.webp',
          detailedStory: 'story_the_wall_of_asgard_card_5_detailed_story'.tr(),
        ),
        MythCard(
          id: '6',
          title: 'story_the_wall_of_asgard_card_6_title'.tr(),
          description: 'story_the_wall_of_asgard_card_6_description'.tr(),
          imagePath: 'wall_6.webp',
          detailedStory: 'story_the_wall_of_asgard_card_6_detailed_story'.tr(),
        ),
        MythCard(
          id: '7',
          title: 'story_the_wall_of_asgard_card_7_title'.tr(),
          description: 'story_the_wall_of_asgard_card_7_description'.tr(),
          imagePath: 'wall_7.webp',
          detailedStory: 'story_the_wall_of_asgard_card_7_detailed_story'.tr(),
        ),
      ],
    ),
    MythStory(
      title: 'story_the_forging_of_mjolnir_title'.tr(),
      correctOrder: [
        MythCard(
          id: '1',
          title: 'story_the_forging_of_mjolnir_card_1_title'.tr(),
          description: 'story_the_forging_of_mjolnir_card_1_description'.tr(),
          imagePath: 'forge_1.webp',
          detailedStory: 'story_the_forging_of_mjolnir_card_1_detailed_story'.tr(),
        ),
        MythCard(
          id: '2',
          title: 'story_the_forging_of_mjolnir_card_2_title'.tr(),
          description: 'story_the_forging_of_mjolnir_card_2_description'.tr(),
          imagePath: 'forge_2.webp',
          detailedStory: 'story_the_forging_of_mjolnir_card_2_detailed_story'.tr(),
        ),
        MythCard(
          id: '3',
          title: 'story_the_forging_of_mjolnir_card_3_title'.tr(),
          description: 'story_the_forging_of_mjolnir_card_3_description'.tr(),
          imagePath: 'forge_3.webp',
          detailedStory: 'story_the_forging_of_mjolnir_card_3_detailed_story'.tr(),
        ),
        MythCard(
          id: '4',
          title: 'story_the_forging_of_mjolnir_card_4_title'.tr(),
          description: 'story_the_forging_of_mjolnir_card_4_description'.tr(),
          imagePath: 'forge_4.webp',
          detailedStory: 'story_the_forging_of_mjolnir_card_4_detailed_story'.tr(),
        ),
        MythCard(
          id: '5',
          title: 'story_the_forging_of_mjolnir_card_5_title'.tr(),
          description: 'story_the_forging_of_mjolnir_card_5_description'.tr(),
          imagePath: 'forge_5.webp',
          detailedStory: 'story_the_forging_of_mjolnir_card_5_detailed_story'.tr(),
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
      title: 'story_the_serpent_fishing_title'.tr(),
      correctOrder: [
        MythCard(
          id: '1',
          title: 'story_the_serpent_fishing_card_1_title'.tr(),
          description: 'story_the_serpent_fishing_card_1_description'.tr(),
          imagePath: 'peche_1.webp',
          detailedStory: 'story_the_serpent_fishing_card_1_detailed_story'.tr(),
        ),
        MythCard(
          id: '2',
          title: 'story_the_serpent_fishing_card_2_title'.tr(),
          description: 'story_the_serpent_fishing_card_2_description'.tr(),
          imagePath: 'peche_2.webp',
          detailedStory: 'story_the_serpent_fishing_card_2_detailed_story'.tr(),
        ),
        MythCard(
          id: '3',
          title: 'story_the_serpent_fishing_card_3_title'.tr(),
          description: 'story_the_serpent_fishing_card_3_description'.tr(),
          imagePath: 'peche_3.webp',
          detailedStory: 'story_the_serpent_fishing_card_3_detailed_story'.tr(),
        ),
        MythCard(
          id: '4',
          title: 'story_the_serpent_fishing_card_4_title'.tr(),
          description: 'story_the_serpent_fishing_card_4_description'.tr(),
          imagePath: 'peche_4.webp',
          detailedStory: 'story_the_serpent_fishing_card_4_detailed_story'.tr(),
        ),
        MythCard(
          id: '5',
          title: 'story_the_serpent_fishing_card_5_title'.tr(),
          description: 'story_the_serpent_fishing_card_5_description'.tr(),
          imagePath: 'peche_5.webp',
          detailedStory: 'story_the_serpent_fishing_card_5_detailed_story'.tr(),
        ),
      ],
    ),
    MythStory(
      title: 'story_the_death_of_baldr_title'.tr(),
      correctOrder: [
        MythCard(
          id: '1',
          title: 'story_the_death_of_baldr_card_1_title'.tr(),
          description: 'story_the_death_of_baldr_card_1_description'.tr(),
          imagePath: 'baldr_1.webp',
          detailedStory: 'story_the_death_of_baldr_card_1_detailed_story'.tr(),
        ),
        MythCard(
          id: '2',
          title: 'story_the_death_of_baldr_card_2_title'.tr(),
          description: 'story_the_death_of_baldr_card_2_description'.tr(),
          imagePath: 'baldr_2.webp',
          detailedStory: 'story_the_death_of_baldr_card_2_detailed_story'.tr(),
        ),
        MythCard(
          id: '3',
          title: 'story_the_death_of_baldr_card_3_title'.tr(),
          description: 'story_the_death_of_baldr_card_3_description'.tr(),
          imagePath: 'baldr_3.webp',
          detailedStory: 'story_the_death_of_baldr_card_3_detailed_story'.tr(),
        ),
        MythCard(
          id: '4',
          title: 'story_the_death_of_baldr_card_4_title'.tr(),
          description: 'story_the_death_of_baldr_card_4_description'.tr(),
          imagePath: 'baldr_4.webp',
          detailedStory: 'story_the_death_of_baldr_card_4_detailed_story'.tr(),        ),
        MythCard(
          id: '5',
          title: 'story_the_death_of_baldr_card_5_title'.tr(),
          description: 'story_the_death_of_baldr_card_5_description'.tr(),
          imagePath: 'baldr_5.webp',
          detailedStory: 'story_the_death_of_baldr_card_5_detailed_story'.tr(),
        ),
      ],
    ),
    MythStory(
      title: 'story_the_punishment_of_loki_title'.tr(),
      correctOrder: [
        MythCard(
          id: '1',
          title: 'story_the_punishment_of_loki_card_1_title'.tr(),
          description: 'story_the_punishment_of_loki_card_1_description'.tr(),
          imagePath: 'chatiment_1.webp',
          detailedStory: 'story_the_punishment_of_loki_card_1_detailed_story'.tr(),
        ),
        MythCard(
          id: '2',
          title: 'story_the_punishment_of_loki_card_2_title'.tr(),
          description: 'story_the_punishment_of_loki_card_2_description'.tr(),
          imagePath: 'chatiment_2.webp',
          detailedStory: 'story_the_punishment_of_loki_card_2_detailed_story'.tr(),
        ),
        MythCard(
          id: '3',
          title: 'story_the_punishment_of_loki_card_3_title'.tr(),
          description: 'story_the_punishment_of_loki_card_3_description'.tr(),
          imagePath: 'chatiment_3.webp',
          detailedStory: 'story_the_punishment_of_loki_card_3_detailed_story'.tr(),
        ),
        MythCard(
          id: '4',
          title: 'story_the_punishment_of_loki_card_4_title'.tr(),
          description: 'story_the_punishment_of_loki_card_4_description'.tr(),
          imagePath: 'chatiment_4.webp',
          detailedStory: 'story_the_punishment_of_loki_card_4_detailed_story'.tr(),
        ),
        MythCard(
          id: '5',
          title: 'story_the_punishment_of_loki_card_5_title'.tr(),
          description: 'story_the_punishment_of_loki_card_5_description'.tr(),
          imagePath: 'chatiment_5.webp',
          detailedStory: 'story_the_punishment_of_loki_card_5_detailed_story'.tr(),
        ),
        MythCard(
          id: '6',
          title: 'story_the_punishment_of_loki_card_6_title'.tr(),
          description: 'story_the_punishment_of_loki_card_6_description'.tr(),
          imagePath: 'chatiment_6.webp',
          detailedStory: 'story_the_punishment_of_loki_card_6_detailed_story'.tr(),
        ),
      ],
    ),
  ];
}
