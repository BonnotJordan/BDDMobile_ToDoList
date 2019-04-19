BDDMobile_List
==============

Cette application permet de gérer des tâches, de leur attribuer une catégorie et un tag, on peut aussi rajouter une image.

# Structure de l'application

Notre application est structurée en :
- Controllers
- Models
- Utils
- Views

Notre dossier Controllers contient nos différents controllers, notre dossier Models contient le model coreData, notre dossier Utils contient différentes fonction utilisables de façon génériques pour simplifier certains procédés, notre dossier Views contient nos storyboards.

# Parties de l'application

L'application est divisée en trois parties : les items, les categories et les tags. Ces trois parties sont accessibles depuis une bottom bar navigation. La bottom bar navigation comporte donc trois lien vers les différents écran (chaque lien est composé d'un nom et d'une image). Tous nos écrans ont été crées avec un navigation controller.

## Items

Le premier écran disponible est la liste des items, cet écran est composé d'une navigation bar avec le titre de l'écran et d'un bouton "+" et de la liste de tous les items crées. Lors du clic sur le bouton "+", nous accédons à l'écran d'ajout d'un item. Nous devons donc renseigner le nom de l'item, sa description (obligatoire), nous pouvons également ajouter une catégorie et des tags (facultatif). Un ajout d'image est disponible. Chaque Item possède donc zéro ou une catégorie (créée à l'avance ou à la volée) et zéros ou plusieurs tags (créables à l'avance ou à la volée). La catégorie est une search bar avec une liste de suggestion qui s'affiche selon le texte entré, l'utilisateur peut donc écrire entièrement le nom de la catégorie ou la sélectionner lorsqu'elle apparaît dans la liste des suggestions. Si la catégorie n'existe pas, elle est crée et ajoutée dans CoreData. Pour les tags, nous affichons donc les tags sous forme de bulles avec un "+", lors du clic, le tag est ajouté à la liste des tags sélectionnés, un bouton "-" permet de le déselectionner. L'utilisateur peux également filtrer les tags avec une search bar. Comme pour la catégorie, si le texte entré ne correspond à aucun tag, il sera alors crée et ajouté à CoreData.
Sur l'écran de la liste, nous pouvons supprimer ou éditer un item en glissant la cellule vers la gauche, deux boutons apparaissent donc pour choisir l'action que nous voulons réaliser. L'édition amène l'utilisateur vers l'écran d'ajout d'un item avec les informations pré-remplies.

## Categories

Comme pour les items, l'utilisateur arrive sur une liste des catégories existantes. L'écran est également composé d'un navigation bar composée d'un titre et d'un bouton "+" permettant la création d'une catégorie et de la liste des catégories.
Lors du clic sur le bouton "+", une pop-up apparaît nous demandant de renseigner un nom pour la catégorie. Nous pouvons également supprimer une catégorie en glissant la cellule vers la gauche. L'édition se fait en cliquant sur le cellule, une pop-up apparaît donc avec le nom de la catégorie pré-rempli. Lors de la suppression d'une catégorie, si elle est associée à un item, cet item n'aura donc plus de catégorie. Il faudra donc la rajouter depuis l'édition d'un item si l'utilisateur le souhaite. 

## Tags

Comme pour les items, l'utilisateur arrive sur une liste des tags existants. L'écran est également composé d'une navigation bar composée d'un titre et d'un bouton "+" permettant la création d'un tag et de la liste des tag.
Lors du clic sur le bouton "+", l'écran de création apparaît, il est composé d'un champs texte pour le nom de ce tag.
Sur l'écran de la liste, nous pouvons supprimer ou éditer un tag en glissant la cellule vers la gauche, deux boutons apparaissent donc pour choisir l'action que nous voulons réaliser. L'édition amène l'utilisateur vers l'écran d'ajout d'un tag avec le nom pré-remplis. Lors de la suppression d'un tag, si il est associé à un item, ce tag sera supprimé des tags associés à ce même item. Il y aura donc deux cas possibles, si l'utilisateur n'avait associé que ce tag, l'item n'aura plus de tags, au contraire, si il avait plusieurs tag, le tags effacé sera enlevé de la liste des tags sélectionnés.

# Sauvegarde des données

Pour la sauvegarde des données, nous utilisons CoreData.

# Librairies utilisées

Nous utilisons deux librairies externes trouvées sur GitHub, la première est [SearchTextField][searchtextfield], elle permet la création d'une search bar avec liste filtrées suivant le texte entré. La seconde est [TaggerKit][taggerkit], elle permet la gestion (ajout, suppresion, recherche) d'un tag depuis l'écran d'ajout d'un item.

  [searchtextfield]: https://github.com/apasccon/SearchTextField
  [taggerkit]: https://github.com/nekonora/TaggerKit
  
  # Evolutions possibles
  
  Les évolutions possibles sont :
  
  * Filtrage par catégories
  * Filtrage par tags
  * Associer une couleur à un tag
  * Ajout de l'image
  

