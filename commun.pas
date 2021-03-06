unit commun;

interface

const 	NBOAT=6; //nombre maximum de bateaux
		TMAX=5; //taille maximale d’un bateau
		TAILLE_X=142; //largeur en caractères de la surface de jeu (max 169)
		TAILLE_Y=45; //hauteur en caractères de la surface de jeu (max 51)
		NMAXPOS=8000; //nombre maximum de valeurs dans un tableau de position
		NMAXOBST=300; //nombre max de positions dans un tableau d'obstacle (pour ne pas allouer inutilement de la mémoire avec la taille précédente)
		NBMONTS=6; //nombre maximum de montagnes
		NBRECIF=5; //nombre maximum de récifs
		PROBA=0.9; 
		
Type Nature=(montagne, centreMontagne, recifs, centreRecifs, bateauJ1, bateauJ2, libre, bZone);

Type TypeAction=(deplacement, rotation, tir, detection, finDeplacement, finTir, finTour, nonValide);

Type TypeBateau=(destroyer, croiseurlg, croiseurlrd, cuirasse);
		
Type Plateau=Array[1..TAILLE_X,1..TAILLE_Y] of Nature;

Type Orientation=(NO, N, NE, E, SE, S, SO, O); //orientation de l'avant du bateau

Type StatutAction=(allowed, overquota, outzone, mountain, reef, boatJ1, boatJ2, cancelled); //l'action est-elle autorisée et si non pourquoi

Type BArray = Array[1..TAILLE_X,1..TAILLE_Y] of Boolean;

Type Capacite=(detectAll, doubleDeplacement, doubleTir, rechargementExpress, plusTard {choix abandonné});
		
Type Position=Record
	nature : Nature; //bateauJ1, bateauJ2, récif, montagne, centreMontagne, centreRecifs
	x : Integer;
	y : Integer;
	visible : Boolean;
end;

Type Obstacle=Record
	tab : Array[1..NMAXOBST] of Position; //index des positions des obstacles
	npos : Integer; //nombre de positions enregistrées dans le tableau
end;

Type Jeu=Record
	montagne : Obstacle; //position des montagnes (pour calcul visibilité ...)
	recifs : Obstacle; //position des récifs
	listeCentres : Obstacle; //pour le fonctionnement de l'IA
	grille : Plateau; //pour tester la présence d’un obstacle ou d’un bateau à une position donnée
	joueur1Joue : Boolean; //quel joueur est en train de jouer
	capacite : Array [1..2,1..3] of Boolean; //quelles capacités sont utilisées (joueur puis capacité (detectAll, doubleDeplacement, doubleTir));
end;

Type Zone=Record
	typeZone : TypeAction; //déplacement, tir ou détection
	distance : Integer; //distance max de l'action (déplacement, tir ou détection)
	nbCases : Integer; //nombre de cases dans la zone
	tabZone : Array[1.. NMAXPOS] of Position; //ensemble des cases de la zone
end;

Type Bateau=Record
	taille : Integer;
	pos : Array[1..TMAX] of Position;
	sens : Orientation;
	nom : String;
	classe : TypeBateau;
	ptDeVie : Integer; //diminue à chaque fois que le bateau est touché
	degats : Integer; //nombre de dégâts que le bateau peut infliger
	tir : Zone; //distance + zone de tir
	tabTir : BArray; //accès à la zone de tir par la position
	tRechargement : Integer; //délai (en tour) avant de pouvoir tirer à nouveau (constant)
	prochainTir : Integer; //nombre de tours restant pour pouvoir tirer
	peutTirer : Boolean; //le bateau peut-il tirer pendant ce tour, recalculé au début de chaque tour
	deplacement : Zone; //distance + zone déplacement
	quota : Single; //nombre de déplacements restants pour un tour
	detection : Zone; //distance détection + zone où l'adversaire est détecté
	tabDetec : BArray; //accès à la zone de détection par coordonnées
	detecte : Boolean; //quel bateau adverse détecte le bateau
	touche : Boolean; //le bateau est touché
	coule : Boolean; //le bateau est coulé (PV à 0)
end;

Type listeBateaux = Array[1..NBOAT] of Bateau;

Type Joueur=Record
	nom : String;
	nbBateaux : Integer; //nombre de bateaux restants
	score : Integer;
	boat : listeBateaux; //ensemble des bateaux du joueur
	tabCapacite : Array [0..4] of Boolean; //quelles capacités ont été utilisées (True->False), 0:False si toutes les capacités utilisées
end;

Type Action=Record
	nature : TypeAction; //deplacement, rotation, tir, detection, nonValide, finTour, finDeplacement, finTir
	boat : Bateau;
	coord : Position;
	noBateau : Word ; //numéro du bateau concerné par l'action
	statut : StatutAction; //l'action est-elle autorisée et si non pourquoi (overquota, mountain, reef)
end;

Type PJeu = ^Jeu;
Type PJoueur = ^Joueur;
Type PAction = ^Action;

implementation

begin
end.

