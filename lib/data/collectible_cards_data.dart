import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/card_version.dart';

// Helper function to create all versions of a card
List<CollectibleCard> _createCardVersions({required String id, required String title, required String description, required List<String> tags}) {
  return [
    CollectibleCard(id: id, title: title, description: description, imagePath: 'cards/chibi/$id.webp', tags: tags, version: CardVersion.chibi),
    CollectibleCard(id: id, title: title, description: description, imagePath: 'cards/premium/$id.webp', tags: tags, version: CardVersion.premium),
    CollectibleCard(id: id, title: title, description: description, imagePath: 'cards/epic/$id.webp', tags: tags, version: CardVersion.epic),
  ];
}

final allCollectibleCards = [
  ..._createCardVersions(
    id: 'baldr',
    title: 'Baldr le Bon',
    description: 'Le dieu de la lumière, de la beauté et de la pureté, fils d'Odin et de Frigg. Adoré de tous, sa présence apportait joie et paix. Un rêve prémonitoire de sa propre mort poussa sa mère, Frigg, à faire jurer à toute chose dans la création de ne jamais lui nuire. Seul le gui, jugé trop jeune et inoffensif, fut oublié. Sa mort tragique, orchestrée par Loki, fut le premier et plus terrible présage de la venue du Ragnarök, la fin des temps.',
    tags: ['Baldr', 'Ragnarök'],
  ),
  ..._createCardVersions(
    id: 'frigg',
    title: 'Frigg la Mère',
    description: 'Déesse de l’amour, du mariage et de la maternité, épouse d’Odin et reine d’Asgard. Elle est la mère de Baldr, le dieu bien-aimé. Dotée du don de prophétie, elle connaît le destin de tous les êtres, y compris celui de son fils, mais ne peut le changer. Son amour maternel la poussa à protéger Baldr en faisant prêter serment à toute la création, une tentative désespérée qui fut déjouée par la ruse de Loki.',
    tags: ['Frigg', 'Odin', 'Baldr'],
  ),
  ..._createCardVersions(
    id: 'gui',
    title: 'Le Gui Mortel',
    description: 'La seule plante capable de blesser le dieu Baldr. Frigg, dans sa quête pour protéger son fils, avait fait jurer à chaque élément de la nature de ne jamais lui faire de mal. Elle omit cependant le gui, le considérant trop jeune et faible pour représenter une menace. Loki, le dieu de la malice, exploita cette faille. Il fabriqua une flèche de gui et la donna à Höd, le frère aveugle de Baldr, qui le tua involontairement.',
    tags: ['Gui', 'Baldr', 'Loki'],
  ),
  ..._createCardVersions(
    id: 'thor',
    title: 'Thor le Protecteur',
    description: 'Le dieu du tonnerre, fils d’Odin et de Jörd (la Terre). Protecteur dévoué d’Asgard et des humains (Midgard), il est connu pour sa force prodigieuse et son courage sans faille. Armé de son marteau Mjöllnir, qui revient toujours dans sa main, de sa ceinture Megingjord qui décuple sa force, et de ses gants de fer Járngreipr, il combat sans relâche les géants et les monstres qui menacent l'ordre cosmique.',
    tags: ['Thor', 'Mjöllnir'],
  ),
  ..._createCardVersions(
    id: 'mjollnir',
    title: 'Mjöllnir',
    description: 'Le marteau légendaire de Thor, forgé par les nains Brokkr et Sindri. Symbole de protection et de destruction, il est capable de contrôler la foudre et le tonnerre. Mjöllnir ne manque jamais sa cible et revient toujours à son porteur après avoir été lancé. C'est l'une des armes les plus puissantes des dieux, indispensable dans la lutte éternelle contre les forces du chaos, notamment les géants.',
    tags: ['Mjöllnir', 'Thor'],
  ),
  ..._createCardVersions(
    id: 'thrym',
    title: 'Thrym le Géant',
    description: 'Le redoutable roi des géants de glace (Jötun) qui commit l'audace de voler Mjöllnir, le marteau de Thor. En échange de sa restitution, il exigea la main de la déesse Freyja. Pour récupérer son arme, Thor se déguisa en Freyja, accompagné de Loki en servante. La ruse fonctionna, et une fois le marteau en sa possession, Thor massacra Thrym et toute sa cour, restaurant l'honneur des dieux.',
    tags: ['Thrym', 'Freyja', 'Mjöllnir'],
  ),
  ..._createCardVersions(
    id: 'fenrir',
    title: 'Fenrir le Loup',
    description: 'Le loup gigantesque, l'un des trois enfants monstrueux de Loki et de la géante Angrboda. Les dieux, effrayés par sa croissance rapide et les prophéties annonçant qu'il causerait leur perte, décidèrent de l'enchaîner. Après avoir brisé deux chaînes, il fut finalement lié par le lien magique Gleipnir. Lors du Ragnarök, il se libérera et accomplira son destin en dévorant Odin, avant d'être tué par Vidar, le fils d'Odin.',
    tags: ['Fenrir', 'Loki', 'Odin', 'Ragnarök'],
  ),
  ..._createCardVersions(
    id: 'tyr',
    title: 'Týr le Sacrifié',
    description: 'Le dieu de la guerre, du droit et de la justice. D'un courage exemplaire, il est le seul dieu qui osa approcher le loup Fenrir lorsque celui-ci devint trop grand et menaçant. Pour prouver aux loup qu'ils ne voulaient pas le piéger avec la chaîne magique Gleipnir, Týr plaça sa main droite dans la gueule de la bête. Quand Fenrir comprit qu'il était enchaîné, il lui arracha la main. Ce sacrifice permit de neutraliser le loup jusqu'au Ragnarök.',
    tags: ['Tyr', 'Fenrir'],
  ),
  ..._createCardVersions(
    id: 'gleipnir',
    title: 'Gleipnir',
    description: 'La chaîne magique forgée par les nains pour lier le loup Fenrir. Contrairement aux lourdes chaînes précédentes que Fenrir avait brisées, Gleipnir était aussi fin et souple qu'un ruban de soie. Il était fabriqué à partir de six ingrédients impossibles : le son des pas d'un chat, la barbe d'une femme, les racines d'une montagne, les tendons d'un ours, le souffle d'un poisson et la salive d'un oiseau. C'est le seul lien que Fenrir ne put jamais briser.',
    tags: ['Gleipnir', 'Fenrir'],
  ),
  ..._createCardVersions(
    id: 'ymir',
    title: 'Ymir le Géant Primordial',
    description: 'Le premier être vivant, un géant primordial né de la rencontre du feu de Muspelheim et de la glace de Niflheim dans le vide du Ginnungagap. De sa sueur naquirent les premiers géants. Il fut nourri par la vache cosmique Audhumla. Finalement, il fut tué par les dieux Odin et ses frères, Vili et Vé. De son corps, ils créèrent le monde : sa chair devint la terre, son sang les océans, ses os les montagnes et son crâne la voûte céleste.',
    tags: ['Ymir'],
  ),
  ..._createCardVersions(
    id: 'audhumla',
    title: 'Audhumla la Vache Cosmique',
    description: 'La vache primordiale, née de la fonte des glaces au commencement des temps, tout comme le géant Ymir. De ses pis coulaient quatre rivières de lait qui nourrirent Ymir et permirent sa survie. En léchant un bloc de glace salé, Audhumla mit à jour Buri, le premier des dieux et l'ancêtre d'Odin. Elle est donc à l'origine des deux lignées, celle des géants et celle des dieux, qui s'affronteront durant le Ragnarök.',
    tags: ['Audhumla', 'Ymir', 'Buri'],
  ),
  ..._createCardVersions(
    id: 'ginnungagap',
    title: 'Le Ginnungagap',
    description: 'Le vide béant et silencieux qui existait avant toute création. C'était un abîme sans fond, bordé au nord par le royaume glacial de Niflheim et au sud par le royaume ardent de Muspelheim. C'est de la rencontre entre le souffle glacé de Niflheim et les étincelles brûlantes de Muspelheim au centre du Ginnungagap que la vie a émergé, donnant naissance au géant primordial Ymir et à la vache cosmique Audhumla.',
    tags: ['Ginnungagap'],
  ),
  ..._createCardVersions(
    id: 'sif',
    title: 'Sif aux Cheveux d’Or',
    description: 'Déesse de la fertilité, de la terre et des moissons, épouse de Thor. Elle était célèbre pour sa magnifique chevelure d'or pur, qui symbolisait les champs de blé mûr. Un jour, par malice, Loki lui coupa les cheveux. Furieux, Thor força Loki à réparer son méfait. Loki dut alors commander aux nains de forger une nouvelle chevelure d'or, qui poussait comme de vrais cheveux, ainsi que d'autres trésors pour les dieux.',
    tags: ['Sif', 'Thor'],
  ),
  ..._createCardVersions(
    id: 'brokkr_sindri',
    title: 'Brokkr et Sindri',
    description: 'Deux frères nains, maîtres forgerons réputés pour leur habileté inégalée. Suite à une ruse de Loki, ils firent le pari avec le dieu qu'ils pourraient créer des objets plus merveilleux que ceux créés par les fils d'Ivaldi. Ils forgèrent ainsi trois trésors exceptionnels : le sanglier d'or Gullinbursti pour Freyr, l'anneau d'or Draupnir pour Odin, et le plus célèbre de tous, le marteau Mjöllnir pour Thor, malgré un défaut mineur (son manche court) dû à une intervention de Loki.',
    tags: ['Brokkr', 'Sindri', 'Mjöllnir'],
  ),
  ..._createCardVersions(
    id: 'draupnir',
    title: 'Draupnir l’Anneau',
    description: 'L’anneau magique en or pur possédé par Odin, l'un des plus grands trésors des dieux. Forgé par les nains Brokkr et Sindri, son nom signifie "le goutteur". Il possède la capacité extraordinaire de se multiplier : toutes les neuf nuits, il produit huit nouveaux anneaux d'or de poids et de qualité identiques. Draupnir fut placé par Odin sur le bûcher funéraire de son fils Baldr en signe de respect, mais lui fut retourné du royaume des morts.',
    tags: ['Draupnir', 'Odin'],
  ),
  ..._createCardVersions(
    id: 'gungnir',
    title: 'Gungnir la Lance',
    description: 'La lance infaillible d'Odin, qui ne manque jamais sa cible. Son nom signifie "la chancelante". Elle fut également forgée par des nains, les fils d'Ivaldi, et obtenue par Loki. Un serment gravé sur sa pointe garantit sa précision. Gungnir est un symbole du pouvoir et de l'autorité d'Odin en tant que dieu de la guerre. C'est en se sacrifiant, pendu à Yggdrasil et transpercé par sa propre lance, qu'Odin acquit la connaissance des runes.',
    tags: ['Gungnir', 'Odin'],
  ),
  ..._createCardVersions(
    id: 'hrimthurs',
    title: 'Hrimthurs le Bâtisseur',
    description: 'Un géant (Jötunn) qui se présenta aux dieux sous les traits d'un simple bâtisseur. Il leur proposa un marché audacieux : construire une forteresse imprenable autour d'Asgard en seulement trois saisons. En paiement, il réclamait la déesse Freyja, ainsi que le Soleil et la Lune. Les dieux acceptèrent, pensant la tâche impossible. Mais le géant, aidé de son cheval magique Svadilfari, avança si vite que les dieux prirent peur et demandèrent à Loki d'intervenir.',
    tags: ['Hrimthurs', 'Freyja', 'Asgard'],
  ),
  ..._createCardVersions(
    id: 'svadilfari',
    title: 'Svadilfari le Cheval',
    description: 'Le cheval magique et exceptionnellement fort du géant bâtisseur Hrimthurs. Son nom signifie "voyageur malchanceux". La rapidité et la puissance de Svadilfari étaient telles qu'il permettait à son maître de construire la muraille d'Asgard à une vitesse prodigieuse, menaçant de faire gagner le pari au géant. Pour saboter le travail, Loki se transforma en une magnifique jument et attira Svadilfari loin de son maître, empêchant ainsi l'achèvement du mur à temps.',
    tags: ['Svadilfari', 'Hrimthurs'],
  ),
  ..._createCardVersions(
    id: 'sleipnir',
    title: 'Sleipnir le Cheval à Huit Pattes',
    description: 'Le cheval d’Odin, né de l’union de Loki transformé en jument et de Svadilfari. Le plus rapide de tous les chevaux des neuf mondes, capable de galoper sur terre, sur mer et dans les airs. Sleipnir est le fidèle destrier d'Odin, le transportant à travers les mondes lors de ses voyages. Ses huit pattes symbolisent sa vitesse surnaturelle et sa capacité à se mouvoir entre les dimensions.',
    tags: ['Sleipnir', 'Odin', 'Loki', 'Svadilfari'],
  ),
  ..._createCardVersions(
    id: 'bifrost',
    title: 'Bifrost',
    description: 'Le pont arc-en-ciel vibrant et chatoyant qui relie Midgard, le monde des hommes, à Asgard, la forteresse des dieux. Il est décrit comme étant fait de feu, d'air et d'eau, et est plus solide que n'importe quelle autre structure. Il est gardé en permanence par le dieu Heimdall, qui en surveille l'accès depuis son poste de garde, Himinbjörg. Le Bifrost s'effondrera lors du Ragnarök sous le poids des géants de feu menés par Surt.',
    tags: ['Bifrost', 'Asgard', 'Heimdall'],
  ),
  ..._createCardVersions(
    id: 'bragi', 
    title: 'Bragi', 
    description: 'Le dieu de la poésie, de l'éloquence et de la musique. Il est l'époux d'Idunn, la gardienne des pommes de jouvence. Bragi est représenté comme un vieil homme sage à la longue barbe, dont les paroles sont si belles qu'elles charment tous ceux qui les entendent. Il est le scalde (poète) de la cour des dieux à Asgard, accueillant les guerriers valeureux arrivant au Valhalla avec ses chants épiques qui relatent leurs hauts faits et la gloire des dieux.', 
    tags: ['Bragi', 'Idunn']
  ),
  ..._createCardVersions(
    id: 'brisingamen',
    title: 'Brisingamen',
    description: 'Le magnifique et légendaire collier de la déesse Freyja. Son nom signifie "le bijou de feu". Il fut forgé par quatre nains experts. Pour l'obtenir, Freyja dut passer une nuit avec chacun d'eux. Ce collier est le symbole de sa beauté, de sa séduction et de son pouvoir sur l'amour et le désir. Il fut volé par Loki et récupéré par Heimdall après un combat acharné où tous deux prirent la forme de phoques.',
    tags: ['Brisingamen', 'Freyja'],
  ),
  ..._createCardVersions(
    id: 'freyja',
    title: 'Freyja',
    description: 'Déesse majeure de la mythologie nordique, associée à l’amour, la beauté, la fertilité, mais aussi à la guerre, la richesse et la magie (le seidr). Sœur jumelle de Freyr, elle est la plus belle des déesses. Elle règne sur son propre royaume, Fólkvangr, où elle accueille la moitié des guerriers morts héroïquement au combat, l'autre moitié allant au Valhalla d'Odin. Elle possède le collier Brisingamen et un char tiré par deux chats.',
    tags: ['Freyja', 'Folkvangr'],
  ),
  ..._createCardVersions(
    id: 'gjallarhorn',
    title: 'Gjallarhorn',
    description: 'La "Corne retentissante" du dieu Heimdall. Il l'utilise pour surveiller le pont Bifrost. Le son de cette corne est si puissant qu'il peut être entendu dans les neuf mondes. Heimdall ne sonnera du Gjallarhorn qu'une seule fois, mais ce sera pour un événement capital : il l'utilisera pour alerter tous les dieux du début du Ragnarök, lorsque les géants et les monstres lanceront leur assaut final contre Asgard.',
    tags: ['Gjallarhorn', 'Heimdall', 'Ragnarök'],
  ),
  ..._createCardVersions(
    id: 'heimdall',
    title: 'Heimdall',
    description: 'Le gardien vigilant d'Asgard, posté à l'entrée du pont Bifrost pour empêcher les géants d'envahir le royaume des dieux. Né de neuf mères, il possède des sens surhumains : sa vue perçante lui permet de voir à des centaines de lieues et son ouïe est si fine qu'il peut entendre l'herbe pousser. Il est le détenteur de la corne Gjallarhorn. Lors du Ragnarök, il sera le dernier à tomber, tuant son éternel ennemi Loki dans un combat où ils s'entretueront.',
    tags: ['Heimdall', 'Asgard', 'Bifrost'],
  ),
  ..._createCardVersions(
    id: 'hel', 
    title: 'Hel', 
    description: 'Fille de Loki et de la géante Angrboda, sœur du loup Fenrir et du serpent Jörmungandr. Bannie par Odin, elle devint la souveraine du royaume des morts, Helheim. Elle est souvent représentée avec un corps à moitié vivant et à moitié décomposé. Elle règne sur les âmes de ceux qui sont morts de maladie ou de vieillesse, par opposition aux guerriers morts au combat qui vont au Valhalla ou à Fólkvangr. Son pouvoir sur les morts est absolu.', 
    tags: ['Hel', 'Helheim', 'Loki']
  ),
  ..._createCardVersions(
    id: 'helheim',
    title: 'Helheim',
    description: 'Le royaume des morts, l'un des neuf mondes, gouverné par la déesse Hel. C'est un lieu sombre, froid et brumeux, situé dans les profondeurs de Niflheim. C'est là que vont les âmes de ceux qui ne sont pas morts de manière héroïque au combat. L'entrée de Helheim est gardée par le chien monstrueux Garm. Même les dieux ne peuvent en réchapper sans la permission de Hel, comme le montre la vaine tentative de ramener Baldr à la vie.',
    tags: ['Helheim', 'Hel'],
  ),
  ..._createCardVersions(
    id: 'hofund', 
    title: 'Hofund', 
    description: 'L’épée étincelante du dieu gardien Heimdall. Son nom signifie "tête d'homme", possiblement en référence à un pommeau sculpté. Comme son propriétaire, l'épée est un symbole de vigilance et de protection pour Asgard. Bien que moins célèbre que d'autres armes divines comme Mjöllnir ou Gungnir, Hofund est une arme puissante qui sera utilisée par Heimdall lors de son combat final et mutuellement destructeur contre Loki durant le Ragnarök.', 
    tags: ['Hofund', 'Heimdall']
  ),
  ..._createCardVersions(
    id: 'huginnmuninn',
    title: 'Huginn et Muninn',
    description: 'Les deux corbeaux perchés sur les épaules d'Odin. Leurs noms signifient "Pensée" (Huginn) et "Mémoire" (Muninn). Chaque matin, Odin les envoie parcourir les neuf mondes. À leur retour, ils lui murmurent à l'oreille tout ce qu'ils ont vu et entendu. Ils sont les sources d'information du Père de Tout, lui conférant une connaissance quasi omnisciente des événements passés, présents et à venir, et l'aidant dans sa quête insatiable de sagesse.',
    tags: ['Huginn', 'Muninn', 'Odin'],
  ),
  ..._createCardVersions(
    id: 'idunn',
    title: 'Idunn',
    description: 'Déesse de la jeunesse et de l'éternité, épouse du dieu poète Bragi. Elle est la gardienne des pommes d'or, des fruits magiques qui confèrent aux dieux leur jeunesse et leur immortalité. Sans ces pommes, les dieux vieilliraient et mourraient comme de simples mortels. Idunn fut un jour enlevée par le géant Thjazi avec la complicité de Loki, forçant les dieux à vieillir jusqu'à ce que Loki soit contraint de la ramener à Asgard.',
    tags: ['Idunn', 'Pommes d’or'],
  ),
  ..._createCardVersions(
    id: 'jormungandr',
    title: 'Jörmungandr',
    description: 'Le Serpent de Midgard, l'un des trois enfants de Loki et de la géante Angrboda. Jeté dans l'océan qui entoure Midgard par Odin, il grandit de manière si démesurée qu'il finit par encercler le monde des hommes et se mordre la queue, d'où son surnom de "Serpent-Monde". Il est l'ennemi juré de Thor. Lors du Ragnarök, les deux adversaires s'affronteront dans un combat titanesque. Thor tuera Jörmungandr mais succombera à son venin neuf pas plus loin.',
    tags: ['Jörmungandr', 'Loki', 'Midgard'],
  ),
  ..._createCardVersions(
    id: 'loki',
    title: 'Loki',
    description: 'Dieu de la ruse, de la discorde et de la métamorphose. Fils de géants mais admis parmi les dieux Ases, il est le frère de sang d'Odin. Intelligent et charmeur, il utilise ses talents pour aider les dieux à se sortir de situations difficiles, mais sa nature malicieuse et chaotique le pousse aussi à être à l'origine de la plupart de leurs problèmes. Père de monstres comme Fenrir, Jörmungandr et Hel, son rôle devient de plus en plus sombre, jusqu'à provoquer le Ragnarök.',
    tags: ['Loki'],
  ),
  ..._createCardVersions(
    id: 'njord',
    title: 'Njord',
    description: 'Dieu de la mer, du vent, de la pêche et de la richesse. Il appartient à la famille des dieux Vanes, mais vint vivre à Asgard avec ses enfants, Freyja et Freyr, comme otage après la guerre entre les Ases et les Vanes. Il est invoqué par les marins pour des voyages sûrs et de bonnes prises. Son mariage malheureux avec la géante Skadi, qui aimait les montagnes tandis qu'il aimait la mer, illustre l'opposition entre ces deux mondes.',
    tags: ['Njord', 'Freyja', 'Freyr'],
  ),
  ..._createCardVersions(
    id: 'odin',
    title: 'Odin',
    description: 'Le Père de Tout, le dieu principal du panthéon nordique. Dieu de la sagesse, de la guerre, de la mort, de la poésie et de la magie (runes). Il règne sur Asgard depuis son trône Hlidskjalf, d'où il peut observer les neuf mondes. Il a sacrifié un œil pour boire à la source de Mimir et acquérir la connaissance universelle. Accompagné de ses corbeaux Huginn et Muninn et de ses loups Geri et Freki, il prépare les dieux et les hommes pour le Ragnarök.',
    tags: ['Odin', 'Asgard'],
  ),
  ..._createCardVersions(
    id: 'skadi',
    title: 'Skadi',
    description: 'Déesse géante associée à la chasse à l'arc, à l'hiver, aux montagnes et au ski. Fille du géant Thjazi, elle se rendit à Asgard pour venger la mort de son père, tué par les dieux. En guise de compensation, les dieux lui offrirent d'épouser l'un d'entre eux, mais elle devait le choisir en ne voyant que leurs pieds. Elle choisit Njord en pensant qu'il s'agissait de Baldr. Leur union fut un échec, Skadi ne supportant pas de vivre loin de ses montagnes enneigées.',
    tags: ['Skadi', 'Njord'],
  ),
  ..._createCardVersions(
    id: 'yggdrasil',
    title: 'Yggdrasil',
    description: 'L’Arbre Monde, un frêne immense et éternel qui est au centre du cosmos nordique. Ses branches s'étendent sur les neuf mondes et son tronc les relie. Trois racines principales le soutiennent, chacune plongeant dans une source : la source d'Urd à Asgard, la source de Mimir au pays des géants, et Hvergelmir à Niflheim. Yggdrasil est constamment attaqué par diverses créatures, comme le dragon Nidhogg qui ronge ses racines, mais il survit toujours, symbolisant la résilience de la vie.',
    tags: ['Yggdrasil', 'Neuf Mondes'],
  ),
];

List<CollectibleCard> getCollectibleCards() {
  return allCollectibleCards;
}