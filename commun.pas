unit commun;

interface

const 	NBOAT=6; //nombre maximum de bateaux
		TMAX=5; //taille maximale d’un bateau
		TAILLE_X=150; //largeur en caractères de la surface de jeu (max 169)
		TAILLE_Y=50; //hauteur en caractères de la surface de jeu (max 51)
		NMAXPOS=7500; //nombre maximum de valeurs dans un tableau de position (max 7500)
		NBMONTS=6; //nombre maximum de montagnes
		NBRECIF=5; //nombre maximum de récifs
		PROBA=0.9; 
		
Type Nature=(montagne, centreMontagne, recifs, centreRecifs, bateauJ1, bateauJ2, libre);

Type TypeAction=(deplacement, rotation, tir, detection, nonValide);

Type TypeBateau=(destroyer, croiseurlg, croiseurlrd, cuirasse);
		
Type Plateau=Array[1..TAILLE_X,1..TAILLE_Y] of Nature;

Type Orientation=(NO, N, NE, E, SE, S, SO, O); //orientation de l'avant du bateau

Type StatutAction=(allowed, overquota, outzone, mountain, reef, boatJ1, boatJ2); //l'action est-elle autorisée et si non pourquoi
		
Type Position=Record
	nature : Nature; //bateauJ1, bateauJ2, récif, montagne, centreMontagne, centreRecifs
	x : Integer;
	y : Integer;
	visible : Boolean;
end;

Type Obstacle=Record
	tab : Array[1..NMAXPOS] of Position; //index des positions des obstacles
	npos : Integer; //nombre de positions enregistrées dans le tableau
end;
		
Type Jeu=Record
	montagne : Obstacle; //position des montagnes (pour calcul visibilité ...)
	recifs : Obstacle; //position des récifs
	grille : Plateau; //pour tester la présence d’un obstacle ou d’un bateau à une position donnée
	joueur1Joue : Boolean; //quel joueur est en train de jouer
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
	tRechargement : Integer; //délai (en tour) avant de pouvoir tirer à nouveau
	deplacement : Zone; //distance + zone déplacement
	quota : Single; //nombre de déplacements restants pour un tour
	detection : Zone; //distance détection + zone où l'adversaire est détecté
	detecte : Boolean; //bateau visible par l’adversaire, recalculé à chaque tour
end;

Type listeBateaux = Array[1..NBOAT] of Bateau;

Type Joueur=Record
	nom : String;
	nbBateaux : Integer; //nombre de bateaux restants
	score : Integer;
	boat : listeBateaux; //ensemble des bateaux du joueur
end;

Type Action=Record
	nature : TypeAction; //deplacement, rotation, tir, detection
	boat : Bateau;
	coord : Position;
	noBateau : Word ; //numéro du bateau concerné par l'action
	statut : StatutAction; //l'action est-elle autorisée et si non pourquoi (overquota, mountain, reef)
end;


implementation

begin
end.

