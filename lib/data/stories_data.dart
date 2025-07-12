import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';

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
          detailedStory:
              'Dans les temps anciens, quand les dieux régnaient encore sur les neuf mondes, Baldr était le plus aimé de tous les Ases. Fils d\'Odin et de Frigg, il rayonnait de beauté et de bonté, et sa présence apportait la joie partout où il allait.\n\nMais un jour, Baldr commença à faire des cauchemars terrifiants. Nuit après nuit, des visions de sa propre mort venaient hanter son sommeil. Ces rêves prophétiques troublèrent profondément les dieux, car ils savaient que les songes de Baldr ne mentaient jamais. Une angoisse terrible s\'empara d\'Asgard, car perdre Baldr signifierait perdre la lumière même du monde.',
        ),
        MythCard(
          id: '2',
          title: 'Le serment de Frigg',
          description:
              'Pour protéger son fils, Frigg, la mère de Baldr, fait jurer à tous les êtres et objets du monde de ne jamais lui faire de mal. Elle néglige toutefois une plante jugée insignifiante : le gui.',
          imagePath: 'assets/images/baldr_2.jpg',
          detailedStory:
              'Frigg, sa mère, ne pouvait supporter l\'idée de perdre son fils bien-aimé. Dans son amour maternel, elle parcourut les neuf mondes avec une détermination farouche, visitant chaque royaume, chaque forêt, chaque montagne.\n\nElle fit jurer à tous les êtres vivants, à tous les objets, à toutes les plantes de ne jamais faire de mal à Baldr. Le feu promit de ne pas le brûler, l\'eau de ne pas le noyer, les pierres de ne pas le blesser, les arbres de ne pas le frapper, les animaux de ne pas l\'attaquer. Tous jurèrent de protéger le dieu lumineux.\n\nCependant, dans sa hâte et son inquiétude, Frigg négligea une petite plante qu\'elle jugeait trop jeune et innocente pour représenter un danger : le gui, qui poussait modestement sur les branches des chênes sacrés.',
        ),
        MythCard(
          id: '3',
          title: 'Le gui',
          description:
              'Loki, curieux et malveillant, découvre que le gui n\'a pas été inclus dans le serment de Frigg. Il décide de se servir de cette faiblesse pour accomplir ses sombres desseins.',
          imagePath: 'assets/images/baldr_3.jpg',
          detailedStory:
              'Loki, toujours à l\'affût des faiblesses et des secrets, ne tarda pas à découvrir cette omission. Déguisé en vieille femme, il se rendit auprès de Frigg et, par des questions apparemment innocentes, lui fit avouer qu\'elle avait négligé le gui.\n\n"Cette petite plante ? dit Frigg en riant. Elle pousse à l\'ouest du Valhalla, elle est si jeune et si faible ! Comment pourrait-elle nuire à mon fils ?\n\nCurieux et malveillant, Loki comprit qu\'il tenait là le moyen d\'accomplir ses sombres desseins. Un sourire cruel se dessina sur ses lèvres tandis qu\'il se dirigeait vers les chênes sacrés. Il cueillit le gui avec précaution, sentant déjà le pouvoir destructeur que contenait cette plante apparemment inoffensive.',
        ),
        MythCard(
          id: '4',
          title: 'La flèche',
          description:
              'Loki fabrique une flèche ou un projectile à partir du gui et le remet à Höd, le frère aveugle de Baldr. Il le persuade de participer à un jeu innocent en lançant le projectile.',
          imagePath: 'assets/images/baldr_4.jpg',
          detailedStory:
              'Avec une habileté diabolique, Loki façonna le gui en une flèche mortelle, taillant sa pointe avec un soin méticuleux. L\'arme paraissait fragile, presque dérisoire, mais elle portait en elle le destin tragique de Baldr.\n\nLors d\'une assemblée des dieux, alors que tous s\'amusaient à lancer des objets sur Baldr - qui ne pouvait plus être blessé depuis les serments de Frigg - Loki s\'approcha sournoisement de Höd, le frère aveugle de Baldr.\n\n"Pourquoi ne participez-vous pas au jeu, noble Höd ?" demanda Loki avec une fausse bienveillance. "Voici une flèche, laissez-moi guider votre main vers votre frère. Il sera honoré de recevoir votre hommage."\n\nHöd, ne soupçonnant aucune malice, accepta avec joie de participer à cette célébration de l\'invulnérabilité de son frère bien-aimé.',
        ),
        MythCard(
          id: '5',
          title: 'La mort de Baldr',
          description:
              'Sous l\'influence de Loki, Höd tire la flèche en gui qui transperce Baldr. Le dieu bien-aimé meurt sur-le-champ, plongeant les dieux dans un immense chagrin.',
          imagePath: 'assets/images/baldr_5.jpg',
          detailedStory:
              'Guidé par la main perfide de Loki, Höd banda son arc et tira. La flèche de gui vola à travers les airs dans un silence mortel et transperça le cœur de Baldr. Le dieu lumineux poussa un cri de surprise et de douleur avant de s\'effondrer, mort sur le coup.\n\nUn silence de mort tomba sur l\'assemblée. Tous les dieux restèrent figés d\'horreur, incapables de comprendre ce qui venait de se passer. Puis éclatèrent les pleurs et les lamentations. Frigg se précipita vers son fils, mais il était trop tard.\n\nHöd, réalisant l\'ampleur de sa tragédie involontaire, pleura amèrement. Loki, lui, disparut discrètement dans l\'ombre, son œuvre de destruction accomplie.\n\nAinsi périt Baldr le Beau, et avec lui, une part de la lumière du monde s\'éteignit pour toujours, annonçant les temps sombres du Ragnarök qui devaient venir.',
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
          detailedStory:
              'Un matin, Thor se réveilla dans une rage terrible qui fit trembler tout Asgard. Son marteau Mjöllnir, sa plus précieuse possession, avait disparu ! Cette arme légendaire, forgée par les nains dans les profondeurs de Svartalfheim, était capable de contrôler la foudre et de pulvériser les montagnes.\n\nSans Mjöllnir, Thor n\'était plus qu\'un dieu ordinaire. Pire encore, sans cette arme divine, tous les dieux d\'Asgard étaient vulnérables face aux forces du chaos qui menaçaient constamment les neuf mondes.\n\nLes recherches commencèrent immédiatement. Heimdall scruta les horizons avec sa vue perçante, Odin envoya ses corbeaux Hugin et Munin aux quatre coins du cosmos, mais le marteau demeurait introuvable. C\'est alors que les soupçons se portèrent vers les géants, éternels ennemis des dieux.',
        ),
        MythCard(
          id: '2',
          title: 'Le chantage de Thrym',
          description:
              'Thrym ne rendra le marteau que si les dieux lui donnent la main de la belle Freyja en mariage. Les dieux sont consternés par cette demande absurde.',
          imagePath: 'assets/images/thor_2.jpg',
          detailedStory:
              'Les investigations menèrent rapidement au géant Thrym, roi des géants de givre dans les terres glacées de Jötunheim. Loin de nier son forfait, il avoua sans honte avoir dérobé le marteau et l\'avoir caché dans les profondeurs de la terre, là où aucun dieu ne pourrait le trouver.\n\nMais Thrym posa ses conditions avec un sourire narquois : il ne rendrait Mjöllnir que si les dieux lui donnaient la main de la belle Freyja en mariage. La déesse de l\'amour et de la beauté devrait devenir son épouse et régner à ses côtés sur le royaume des géants.\n\nCette demande outrageante indigna tous les dieux d\'Asgard. Comment oser réclamer la plus belle des déesses en échange d\'un objet volé ? Freyja elle-même entra dans une colère si terrible que son collier magique Brísingamen se brisa sous la force de sa fureur. Les murs du Valhalla tremblèrent sous sa rage.',
        ),
        MythCard(
          id: '3',
          title: 'Déguisement',
          description:
              'Thor, avec l\'aide de Loki, se déguise en Freyja pour duper Thrym. Il revêt une robe de mariée et un voile pour infiltrer le royaume des géants.',
          imagePath: 'assets/images/thor_3.jpg',
          detailedStory:
              'C\'est alors que Loki eut une idée aussi audacieuse que ridicule : Thor devrait se déguiser en Freyja pour tromper Thrym ! L\'idée de voir le plus viril des dieux revêtir des habits de femme amusa beaucoup le rusé Loki.\n\nThor protesta violemment : "Jamais ! Les dieux se moqueront de moi pour l\'éternité ! Ma réputation de guerrier sera ruinée !\n\nMais Heimdall le sage intervint : "Préfères-tu que les géants envahissent Asgard sans que nous puissions nous défendre ? Sans Mjöllnir, nous sommes perdus."\n\nÀ contrecœur, Thor accepta. Avec l\'aide de Loki, il revêtit une magnifique robe de mariée, se couvrit d\'un voile orné de bijoux précieux, et plaça sur sa poitrine le collier réparé de Freyja. Ses mains puissantes furent dissimulées sous de longs gants de soie. Ainsi déguisé, le dieu du tonnerre ressemblait à une épouse timide et voilée.',
        ),
        MythCard(
          id: '4',
          title: 'Le festin',
          description:
              'Lors du banquet de mariage, Thor mange et boit avec une voracité telle que les géants commencent à douter de son identité féminine.',
          imagePath: 'assets/images/thor_4.jpg',
          detailedStory:
              'Le stratagème sembla d\'abord fonctionner parfaitement. Thrym accueillit sa "fiancée" avec une joie débordante et organisa immédiatement un grand banquet nuptial. Tous les géants de Jötunheim furent conviés pour célébrer cette union extraordinaire.\n\nMais au cours du festin, Thor ne put contenir son appétit légendaire. Oubliant son rôle, il dévora un bœuf entier, huit saumons, et engloutit tous les mets destinés aux femmes. Il vida ensuite trois tonneaux entiers d\'hydromel d\'un trait, éveillant les soupçons des géants.\n\n"Par ma barbe !" s\'exclama Thrym, les yeux écarquillés. "Je n\'ai jamais vu une femme manger et boire avec un tel appétit ! Pourquoi la belle Freyja se montre-t-elle si vorace ?\n\nLoki, toujours prompt à mentir, répondit avec aplomb : "Noble Thrym, Freyja était si excitée par ce mariage qu\'elle n\'a pas touché à la nourriture depuis huit jours et huit nuits ! C\'est la faim qui la rend si affamée."',
        ),
        MythCard(
          id: '5',
          title: 'Récupération',
          description:
              'Dès que Mjöllnir lui est présenté comme cadeau nuptial, Thor le saisit et massacre les géants, mettant fin à la supercherie dans un bain de sang.',
          imagePath: 'assets/images/thor_5.jpg',
          detailedStory:
              'Thrym, rassuré par l\'explication de Loki, décida de procéder à la cérémonie. Selon la tradition, il ordonna qu\'on apporte le marteau de Thor pour bénir l\'union et le placer sur les genoux de la mariée, symbole de fertilité et de protection.\n\nDès que Mjöllnir fut posé sur ses genoux, Thor sentit sa force divine revenir en lui comme un torrent. Ses yeux s\'enflammèrent de joie et de rage contenues. D\'un geste puissant, il arracha son voile et déchira sa robe de mariée.\n\n"Je suis Thor, fils d\'Odin !" rugit-il en brandissant son marteau. "Et voici ma réponse à votre chantage !\n\nLa foudre jaillit de Mjöllnir tandis que Thor massacrait Thrym et tous les géants présents dans un déchaînement de violence divine. Les éclairs illuminèrent la salle du festin transformée en champ de bataille, et le tonnerre résonna dans tout Jötunheim.\n\nAinsi Thor récupéra-t-il son marteau, et jamais plus les géants n\'osèrent défier ouvertement le dieu du tonnerre.',
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
          detailedStory:
              'Fenrir était le fils de Loki et de la géante Angrboda, une créature née des unions interdites entre les dieux et les forces du chaos. Dès sa naissance, le loup gigantesque manifestait une nature sauvage et une force qui dépassait l\'entendement.\n\nConscients du danger qu\'il représentait selon les sinistres prophéties des Nornes, les dieux prirent une décision audacieuse : plutôt que de le bannir ou de le tuer, ils décidèrent de l\'élever à Asgard pour mieux le surveiller et peut-être l\'apprivoiser.\n\nMais Fenrir grandissait de jour en jour, et sa taille comme sa férocité croissaient à un rythme effrayant. Ses yeux jaunes brillaient d\'une intelligence inquiétante, et ses crocs acérés pouvaient broyer les os les plus solides. Seul Tyr, le courageux dieu de la guerre, osait s\'approcher de la bête pour la nourrir, gagnant ainsi sa confiance fragile.',
        ),
        MythCard(
          id: '2',
          title: 'Les chaînes échouent',
          description:
              'Les dieux tentent de le lier avec des chaînes solides, mais Fenrir brise chaque lien, révélant une force surnaturelle incontrôlable.',
          imagePath: 'assets/images/fenrir_2.jpg',
          detailedStory:
              'Quand Fenrir devint si grand qu\'il dominait même les plus imposants des dieux, la peur s\'installa à Asgard. Les prophéties annonçaient qu\'il dévorerait Odin lors du Ragnarök, et sa puissance grandissante rendait cette menace de plus en plus réelle.\n\nLes dieux décidèrent alors de l\'enchaîner. Ils présentèrent cela comme un jeu, un défi pour tester sa force légendaire. Fenrir, encore naïf malgré sa taille, accepta de se laisser lier par Leyding, la plus solide des chaînes forgées par les nains.\n\nMais d\'un simple mouvement d\'épaules, le loup brisa Leyding comme un vulgaire fil. Les maillons de fer volèrent dans toutes les directions. Les dieux, feignant l\'admiration, tentèrent alors avec Dromi, une chaîne encore plus massive et résistante.\n\nFenrir la réduisit en miettes d\'un seul élan, révélant une force si surnaturelle que les dieux comprirent qu\'aucune chaîne ordinaire ne pourrait jamais retenir cette créature du chaos.',
        ),
        MythCard(
          id: '3',
          title: 'Gleipnir',
          description:
              'Les dieux chargent les nains de forger Gleipnir, une chaîne magique faite de choses impossibles : le souffle d\'un poisson, le bruit des pas d\'un chat, etc.',
          imagePath: 'assets/images/fenrir_3.jpg',
          detailedStory:
              'Comprenant qu\'aucune force brute ne pourrait venir à bout de Fenrir, Odin envoya secrètement un messager chez les nains de Svartalfheim. Ces maîtres forgerons, capables de créer des merveilles impossibles, reçurent une commande extraordinaire.\n\nIls devaient créer Gleipnir, un lien magique tissé à partir de six éléments impossibles à trouver : le bruit des pas d\'un chat, la barbe d\'une femme, les racines d\'une montagne, les tendons d\'un ours, le souffle d\'un poisson et la salive d\'un oiseau.\n\nCes ingrédients mystiques, invisibles et intangibles, furent assemblés par les nains dans leurs forges enchantées. Le résultat était paradoxal : Gleipnir ressemblait à un simple ruban de soie, fin et lisse au toucher, mais il contenait une puissance magique capable de lier les forces les plus destructrices de l\'univers.\n\nQuand les dieux reçurent cette chaîne miraculeuse, ils surent qu\'ils tenaient enfin l\'arme capable d\'entraver le loup du destin.',
        ),
        MythCard(
          id: '4',
          title: 'Le défi',
          description:
              'Soupçonneux, Fenrir accepte d\'être enchaîné avec Gleipnir uniquement si un dieu place sa main dans sa gueule en gage de bonne foi.',
          imagePath: 'assets/images/fenrir_4.jpg',
          detailedStory:
              'Quand les dieux présentèrent Gleipnir à Fenrir, le loup, désormais méfiant après les tentatives précédentes, examina attentivement ce lien étrange. Malgré son apparence fragile, quelque chose dans cette chaîne éveillait ses instincts les plus profonds.\n\n"Cette chaîne me semble suspecte, dit Fenrir en reniflant Gleipnir. Elle paraît faible, mais je sens en elle une magie puissante. Si c\'est encore un de vos jeux, pourquoi ne pas utiliser des chaînes ordinaires ?\n\nLes dieux tentèrent de le rassurer, prétendant que c\'était justement parce qu\'il avait brisé les chaînes précédentes qu\'ils voulaient tester cette nouvelle création des nains.\n\nMais Fenrir posa ses conditions d\'une voix grave qui fit trembler les fondations d\'Asgard : "J\'accepte de me laisser enchaîner avec ce lien, mais seulement si l\'un d\'entre vous place sa main dans ma gueule en gage de bonne foi. Ainsi, si vous me trompez, au moins l\'un de vous paiera le prix de cette trahison."',
        ),
        MythCard(
          id: '5',
          title: 'Le sacrifice de Tyr',
          description:
              'Tyr, le dieu du courage, offre sa main, sachant qu\'il la perdra. Lorsque Fenrir se rend compte de la ruse, il referme sa mâchoire et Tyr perd sa main.',
          imagePath: 'assets/images/fenrir_5.jpg',
          detailedStory:
              'Un lourd silence tomba sur l\'assemblée des dieux. Tous savaient qu\'ils s\'apprêtaient à trahir Fenrir, et que celui qui placerait sa main dans la gueule du loup la perdrait à coup sûr. Personne n\'osait se porter volontaire.\n\nSeul Tyr, le dieu du courage et de l\'honneur, s\'avança. Il était le seul à avoir nourri Fenrir, le seul en qui le loup avait encore confiance. Sans hésitation, fidèle à sa réputation de bravoure, il tendit sa main droite et la plaça entre les mâchoires redoutables de la bête.\n\nGleipnir fut alors attaché autour des pattes de Fenrir. Le loup tenta de le briser comme les chaînes précédentes, bandant tous ses muscles, tirant de toutes ses forces. Mais plus il luttait, plus le lien magique se resserrait.\n\nRéalisant qu\'il avait été dupé et qu\'il resterait prisonnier pour l\'éternité, Fenrir leva ses yeux jaunes vers Tyr. Un regard de tristesse et de rage mêlées passa entre le dieu et la bête. Puis, d\'un coup sec, Fenrir referma sa mâchoire, arrachant la main de Tyr dans un craquement sinistre.\n\nFenrir fut ensuite traîné vers une île déserte et attaché à un rocher au plus profond de la terre, où il demeure enchaîné jusqu\'au Ragnarök, le jour où il brisera enfin ses liens pour dévorer Odin.\n\nAinsi Tyr perdit-il sa main, mais gagna l\'éternelle reconnaissance des dieux pour son sacrifice héroïque qui sauva les neuf mondes... du moins temporairement.',
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
          detailedStory:
              'Au commencement des temps, avant que n\'existe aucun monde, aucune mer, aucun ciel, aucune terre, il n\'y avait que le Ginnungagap - le vide béant, l\'abîme primordial qui s\'étendait dans une solitude infinie.\n\nCe n\'était ni lumière ni ténèbres, ni chaud ni froid, mais un néant absolu où rien ne pouvait naître ni mourir, car rien n\'existait encore. Ce vide colossal séparait deux royaumes aux natures opposées, comme deux forces antagonistes attendant leur confrontation cosmique.\n\nAu nord du Ginnungagap s\'étendait Niflheim, le monde de glace et de brouillard éternel, d\'où coulaient les onze rivières Élivágar, charriant des eaux si froides qu\'elles gelaient instantanément dans le vide. Au sud brûlait Muspellheim, le royaume du feu éternel et inextinguible, gardé par le géant Surtr brandissant son épée flamboyante, dans l\'attente du jour où il incendierait tous les mondes.\n\nAinsi les forces primordiales se faisaient face dans l\'immensité du vide, préparant la création dans leur opposition même.',
        ),
        MythCard(
          id: '2',
          title: 'Feu et glace',
          description:
              'Les étincelles de chaleur rencontrent les brumes glacées, provoquant la naissance de l\'eau et le début de la vie dans le vide cosmique.',
          imagePath: 'assets/images/creation_2.jpg',
          detailedStory:
              'Pendant des éons innombrables, le feu et la glace demeurèrent séparés par l\'immensité du Ginnungagap. Mais lentement, inexorablement, les étincelles ardentes de Muspellheim commencèrent à dériver vers le nord, portées par des vents cosmiques imperceptibles.\n\nLorsque ces étincelles de chaleur pure rencontrèrent les brumes glacées de Niflheim dans le cœur du vide, un phénomène extraordinaire se produisit. La glace se mit à fondre pour la première fois depuis le début des temps, libérant des torrents d\'eau primordiale.\n\nCes gouttes d\'eau, nées de la rencontre miraculeuse entre les extrêmes, tombèrent dans l\'abîme du Ginnungagap. Là, animées par la force vitale née de cette union impossible entre le feu et la glace, elles commencèrent à grouiller d\'une énergie créatrice.\n\nC\'était le premier miracle de l\'existence : de l\'opposition entre les forces contraires naissait la possibilité même de la vie. L\'eau primordiale portait en elle le germe de tout ce qui allait exister.',
        ),
        MythCard(
          id: '3',
          title: 'Naissance d\'Ymir',
          description:
              'De cette union primordiale naît Ymir, le premier géant, ainsi que la vache Audhumla, nourricière du géant. La vie se propage.',
          imagePath: 'assets/images/creation_3.jpg',
          detailedStory:
              'De l\'eau primordiale, un être colossal émergea : Ymir, le premier géant, aussi connu sous le nom d\'Aurgelmir. Sa chair était faite de glace fondue, ses os de roches anciennes, et ses yeux brillaient d\'une lueur froide comme les étoiles naissantes.\n\nÀ côté de lui, une vache immense nommée Audhumla apparut, nourrie par les gouttes d\'eau sucrée qui s\'étaient formées dans le Ginnungagap. Audhumla était la source de vie pour Ymir, lui fournissant le lait nécessaire à sa survie. En léchant la glace des montagnes, elle découvrit bientôt Buri, le premier dieu, dont la descendance allait donner naissance aux Ases.\n\nAinsi naquit la première génération de géants et de dieux, marquant le début de l\'histoire du monde. Ymir devint le père des géants, tandis qu\'Audhumla nourrissait les êtres qui allaient façonner l\'univers.',
        ),
        MythCard(
          id: '4',
          title: 'La mort d\'Ymir',
          description:
              'Les premiers dieux, Odin et ses frères, tuent Ymir pour mettre fin au chaos. Son sang noie presque tous les autres géants.',
          imagePath: 'assets/images/creation_4.jpg',
          detailedStory:
              'Les dieux, conscients que Ymir représentait une menace pour l\'équilibre du cosmos, décidèrent de mettre fin à son règne chaotique. Odin, Vili et Vé, les trois frères divins, s\'unirent pour affronter le géant primordial.\n\nDans une bataille épique, ils parvinrent à tuer Ymir. Son corps colossal s\'effondra dans le Ginnungagap, et son sang se mit à couler en torrents. Ce sang inonda presque tous les autres géants, les noyant dans un océan de chaos.\n\nMais les dieux ne se contentèrent pas de tuer Ymir. Ils utilisèrent son corps pour façonner le monde : sa chair devint la terre, ses os les montagnes, son sang les mers et les rivières, et son crâne le ciel. Ainsi, de la mort du géant naquit l\'univers tel que nous le connaissons.',
        ),
        MythCard(
          id: '5',
          title: 'Création du monde',
          description:
              'Avec le corps d’Ymir, les dieux forment le monde : la terre avec sa chair, les montagnes avec ses os, la mer avec son sang, et le ciel avec son crâne.',
          imagePath: 'assets/images/creation_5.jpg',
          detailedStory:
              'Les dieux, après avoir vaincu Ymir, se mirent à l\'œuvre pour façonner le monde à partir de son corps colossal. Ils commencèrent par diviser son corps en deux moitiés égales, créant ainsi la terre et le ciel.\n\nLa chair d\'Ymir devint la terre fertile, couverte de forêts luxuriantes et de plaines verdoyantes. Ses os furent brisés et érigés en montagnes majestueuses, formant les chaînes montagneuses qui traversent le monde. Son sang, qui avait inondé les géants, fut canalisé pour former les mers profondes et les rivières sinueuses.\n\nLe crâne d\'Ymir fut soulevé pour créer le ciel, soutenu par quatre nains représentant les points cardinaux : Nord, Sud, Est et Ouest. Les étoiles furent placées dans le ciel comme des lanternes scintillantes, tandis que la lune et le soleil furent créés pour réguler le temps.\n\nAinsi naquit Midgard, le monde des hommes, au centre de l\'univers, entouré par les neuf mondes interconnectés. Les dieux avaient façonné un cosmos harmonieux à partir du chaos primordial.',
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
          detailedStory:
              'Dans les temps anciens, Loki, le dieu de la malice et de la ruse, s\'ennuyait profondément. Pour se divertir, il décida de jouer un tour à Thor, le dieu du tonnerre. Profitant d\'un moment d\'inattention, il coupa les magnifiques cheveux dorés de Sif, l\'épouse de Thor.\n\nSif était connue pour sa beauté éclatante et ses cheveux resplendissants qui brillaient comme l\'or au soleil. Lorsque Thor découvrit ce qu\'avait fait Loki, sa colère fut telle qu\'elle fit trembler les fondations d\'Asgard. Il jura de se venger et de faire payer à Loki son affront.',
        ),
        MythCard(
          id: '2',
          title: 'Menace de Thor',
          description:
              'Furieux, Thor menace de briser tous les os de Loki s’il ne répare pas son affront. Loki, paniqué, promet d’offrir une chevelure encore plus belle.',
          imagePath: 'assets/images/forge_2.jpg',
          detailedStory:
              'Thor, dans un accès de rage incontrôlable, attrapa Loki par le col et le secoua violemment. "Tu vas payer pour cela, Loki ! Je vais briser tous tes os si tu ne répares pas cet affront à Sif !" hurla-t-il, sa voix résonnant comme le tonnerre dans les halls d\'Asgard.\n\nLoki, réalisant l\'ampleur de sa bêtise, paniqua. Il savait que Thor ne plaisantait pas et qu\'il devait agir rapidement pour éviter une terrible vengeance. Avec un sourire forcé, il promit de réparer son erreur en offrant à Sif une chevelure encore plus belle que celle qu\'il avait coupée.',
        ),
        MythCard(
          id: '3',
          title: 'Les nains forgerons',
          description:
              'Loki se rend auprès des nains Brokkr et Sindri pour leur demander de forger des trésors magiques, capables d’apaiser la colère des dieux.',
          imagePath: 'assets/images/forge_3.jpg',
          detailedStory:
              'Pour tenir sa promesse, Loki se rendit dans les profondeurs de Svartalfheim, le royaume des nains, où il trouva les célèbres forgerons Brokkr et Sindri. Ces maîtres artisans étaient réputés pour leur habileté à créer des objets magiques d\'une puissance inégalée.\n\nLoki leur expliqua la situation et leur demanda de forger des trésors capables d\'apaiser la colère des dieux. Les nains, toujours prêts à relever un défi, acceptèrent avec enthousiasme. Ils commencèrent à travailler jour et nuit, utilisant leurs marteaux enchantés et leurs enclumes magiques pour créer des merveilles qui dépasseraient l\'imagination.',
        ),
        MythCard(
          id: '4',
          title: 'Création de Mjöllnir',
          description:
              'Malgré les ruses de Loki, les nains forgent plusieurs merveilles, dont Mjöllnir, un marteau redoutable capable de contrôler la foudre.',
          imagePath: 'assets/images/forge_4.jpg',
          detailedStory:
              'Brokkr et Sindri, avec leur talent inégalé, commencèrent à forger les trésors. Le premier fut Draupnir, un anneau magique capable de produire huit autres anneaux d\'or chaque neuf nuits. Ensuite, ils créèrent Gungnir, la lance d\'Odin qui ne manquait jamais sa cible.\n\nMais le chef-d\'œuvre fut Mjöllnir, le marteau de Thor. Malgré les tentatives de Loki pour saboter le processus en transformant Brokkr en une mouche pour le distraire, les nains restèrent concentrés. Mjöllnir fut forgé avec une telle puissance qu\'il pouvait contrôler la foudre et revenir dans la main de Thor après avoir été lancé.',
        ),
        MythCard(
          id: '5',
          title: 'Offrande à Thor',
          description:
              'Les trésors sont offerts aux dieux. Thor, émerveillé par Mjöllnir, accepte le pardon de Loki, bien que le manche soit un peu court.',
          imagePath: 'assets/images/forge_5.jpg',
          detailedStory:
              'Lorsque les nains présentèrent leurs créations aux dieux, Thor fut immédiatement attiré par Mjöllnir. Il le prit en main, ressentant la puissance du marteau qui pulsait à travers lui. "C\'est un trésor digne de mon épouse Sif !" s\'exclama-t-il, oubliant presque sa colère contre Loki.\n\nBien que le manche du marteau fût un peu court, ce qui le rendait difficile à manier pour un dieu de sa stature, Thor accepta le cadeau avec gratitude. Il savait que Mjöllnir serait un atout précieux dans ses combats contre les géants et les forces du chaos.\n\nLoki, soulagé, put enfin respirer. Il avait réussi à réparer son erreur et à apaiser la colère de Thor, au prix de quelques frayeurs supplémentaires. Les dieux célébrèrent la création de ces trésors magiques, renforçant ainsi leur lien avec les nains et leur pouvoir sur les neuf mondes.',
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
    ),
  ];
}