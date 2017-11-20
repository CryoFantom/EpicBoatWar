unit generation;

interface

uses commun, crt, calcul;

procedure genGrille(var plat : Jeu; var joueur1, joueur2: Joueur);

implementation

procedure positionAleatoire(var xp, yp : Integer);						//procédure sortant aléatoirement deux coordonnées

var i : Integer;
var test : Boolean;
var rando : Double;

	begin
		
			
		rando := random;												//Ce random définira la position x de la case aléatoire
		test := true;
		i:=1;
	
		while(test) do
		begin
			if((rando < i/(TAILLE_X-14)) and (rando >= (i-1)/(TAILLE_X-14))) then //rando fait partie d'un ensemble continue, on va donc chercher à le caser dans un intervalle. La borne haute de l'intervalle nous donne la position x de la case
			begin
				xp := i+7;												// + 7 pour permettre une zone de départ des bateaux sans obstacles
				test := False;											// pour sortir de la boucle													
			end
			else 
				i:=i+1;													//On avance l'intervalle de 1
		end;
	
		rando := random;												// Même chose sans la restriction de zones d'appartition, nous ressort la deuxième coordonnée, permettant ainsi de localiser la case aléatoire
		test := true;
		i:=1;
	
		while(test) do
		begin
			if((rando < i/(TAILLE_Y)) and (rando >= (i-1)/(TAILLE_Y))) then
			begin
				yp := i;
				test := False;
			end
			else 
				i:=i+1;
	end;
end;

procedure genObstacles (var plat: Plateau; var listeMontagne : Obstacle; var listeRecif : Obstacle);


var prob, rando : Double;
var xp, yp, i, j, k, l, nm, nr: Integer;
var test : Boolean;

begin

	Randomize;

	for i:=1 to TAILLE_X do											//Remplissage de la grille par rien
		for j:=1 to TAILLE_Y do
		begin
			plat[i][j]:=libre;
		end;		
		
	rando := random;
	test := True;
	i:=1;
	
	while(test) do														//On tire un nombre aléatoire de montagnes selon la même technique qu'au-dessus
		if ((rando < i/NBMONTS) and (rando >= (i-1)/NBMONTS)) then
		begin
			nm := i;
			test := false;
		end
		else
			i:=i+1;
		
	rando := random;
	test := True;
	i:=1;
	
	while(test) do														//Exactement la même chose que précédemment, mais pour les récifs
		if ((rando < i/NBRECIF) and (rando >= (i-1)/NBRECIF)) then
		begin
			nr := i;
			test := false;
		end
		else
			i:=i+1;
	
	listeMontagne.npos:=0;												//On initialise la taille du tableau des montagne
	
	for i:=1 to nm do													//Création montagnes
		begin
			positionAleatoire(xp, yp);									//Choix d'une case considérée comme centre de la chaîne de montagne
			plat[xp][yp] := centreMontagne;								//On la rentre dans le plateau. centreMontagne n'est qu'un repère pour l'IA future
			listeMontagne.npos:=listeMontagne.npos+1;					//On incrémente la taille du tableau de Montagne
			listeMontagne.tab[listeMontagne.npos].nature := montagne;	//On enregistre la nature de la case dans ce même tableau
			listeMontagne.tab[listeMontagne.npos].x:=xp;				//Puis la coordonnée X
			listeMontagne.tab[listeMontagne.npos].y:=yp;				//Puis la coordonnée Y
			listeMontagne.tab[listeMontagne.npos].visible:=True;		//Enfin on initialise cette variable
			for k:=-2 to 2 do											//Autour de ce centre on va générer un massif
				for l:=-2 to 2 do										//dans une zone de 5 par 5
				begin
						prob := random;
						if ((prob < PROBA/sqrt(k*k+l*l+1)) and (0<xp+k) and (xp+k<TAILLE_X) and (0<yp+l) and (yp+l<TAILLE_Y)) then	//on donne une chance d'être une montagne puis on vérifie qu'on ne dépasse pas du plateau
							begin
								plat[xp+k][yp+l] := montagne;									//Si oui on la note dans le plateau
								listeMontagne.npos:= listeMontagne.npos+1;						//On incrémente la taille du tableau des montagnes
								listeMontagne.tab[listeMontagne.npos].nature := montagne;		//Puis on enregistre la nature dans le tableau des montagnes
								listeMontagne.tab[listeMontagne.npos].x:=xp+k;					//etc
								listeMontagne.tab[listeMontagne.npos].y:=yp+l;					//etc
								listeMontagne.tab[listeMontagne.npos].visible:=True;			//etc
							end;
				end;
		end;
	
		listeRecif.npos:=0;
	
	for i:=1 to nr do													//On fait exactement la même chose que pour les montagnes, mais pour les récifs
		begin
			positionAleatoire(xp, yp);									//Position particulière
			plat[xp][yp] := centreRecifs;								//On note
			listeRecif.npos:=listeRecif.npos+1;
			listeRecif.tab[listeRecif.npos].nature := recifs;
			listeRecif.tab[listeRecif.npos].x:=xp;
			listeRecif.tab[listeRecif.npos].y:=yp;
			listeRecif.tab[listeRecif.npos].visible:=True;
			for k:=-2 to 2 do											//On génère la zone autour
				for l:=-2 to 2 do
				begin
						prob := random;
						if ((prob < PROBA/(k*k+l*l+1)) and (0<xp+k) and (xp+k<TAILLE_X) and (0<yp+l) and (yp+l<TAILLE_Y)) then
							begin
								plat[xp+k][yp+l] := recifs;
								listeRecif.npos:=listeRecif.npos+1;
								listeRecif.tab[listeRecif.npos].nature := recifs;
								listeRecif.tab[listeRecif.npos].x:=xp+k;
								listeRecif.tab[listeRecif.npos].y:=yp+l;
								listeRecif.tab[listeRecif.npos].visible:=True;
							end;
				end;
			
		end;

	test:=true;

	repeat																//Cette boucle permet d'embellir le tableau, en disant qu'une case vide entourée de 4 montagnes est elle-même une montagne
	begin
		for i:=2 to TAILLE_X-1 do
			for j:=2 to TAILLE_Y-1 do
				begin
					if((plat[i-1][j] = montagne) and (plat[i+1][j] = montagne) and (plat[i][j-1] = montagne) and (plat[i][j+1] = montagne)) then  //On regarde si la case est bien entourée de 4 montagnes
						begin
							plat[i][j]:=montagne;										//Si oui on note dans le plateau
							test:=False;												//Ce booléen permet de regarder si une modification a été faite, si oui on relancera le processus (d'autres cas peuvent être apparus suite à ces modifications)
							listeMontagne.npos:=listeMontagne.npos+1;					//On incrémente la taille du tableau des montagnes
							listeMontagne.tab[listeMontagne.npos].nature := montagne;	//On enregistre la position dans le tableau des montagnes
							listeMontagne.tab[listeMontagne.npos].x:=i;
							listeMontagne.tab[listeMontagne.npos].y:=j;
							listeMontagne.tab[listeMontagne.npos].visible:=True;
						end
					else test:=True
				end;
	end;
	until test;
	
end;

procedure affectation(taille, pdv, degats, trchrg, distDepl, distDetec, distTir : Integer; nom : String; var navire : Bateau);	//Cette procédure est juste créer pour faciliter l'assignation des caractéristiques à un bateau

begin
	navire.taille := taille;
	navire.nom:= nom;
	navire.ptDeVie := pdv;
	navire.degats := degats;
	navire.tir.distance := distTir;
	navire.tRechargement := trchrg;
	navire.deplacement.distance := distDepl;
	navire.detection.distance := distDetec;
	navire.detecte:=False;
	navire.coule:=False;
end;

procedure initBateau(var listeBateau : listeBateaux);

var i : Integer;

begin
	for i:=1 to NBOAT do												//On crée les types de bateau selon cet ordre : 1 cuirassé, 1 croiseur lourd, 2 croiseurs léger et 2 destroyers
		listeBateau[i].classe := cuirasse;
	for i:=2 to NBOAT do
		listeBateau[i].classe := croiseurlrd;
	for i:=3 to NBOAT do
		listeBateau[i].classe := croiseurlg;
	for i:=5 to NBOAT do
		listeBateau[i].classe := destroyer;
	
	for  i:=1 to NBOAT do
		begin		//taille, pdv, degats, trchrg, distDepl, distDetec, distTir, nom, navire
			if (listeBateau[i].classe = destroyer) then	
				affectation(2, 4, 2, 1, 10, 5, 3, 'destroyer', listeBateau[i]);		//si le bateau est un destroyer on lui attribue ses caractéristiques
			if (listeBateau[i].classe = croiseurlg) then
				affectation(3, 6, 3, 2, 7, 7, 5, 'croiseur leger' ,listeBateau[i]);	//idem pour le croiseur léger
			if (listeBateau[i].classe = croiseurlrd) then	
				affectation(4, 7, 4, 3, 6, 8, 7, 'croiseur lourd', listeBateau[i]);	//idem pour le croiseur lourd
			if (listebateau[i].classe = cuirasse) then
				affectation(5, 9, 6, 4, 5, 15, 10, 'cuirasse', listeBateau[i]);		//idem pour le cuirassé
		end;
end;

procedure genBateau (plat : Jeu; var joueur1, joueur2 : Joueur);

var i, j, x, y : Integer;

begin	
	initBateau(joueur1.boat);											//On initialise les bateaux des deux joueurs
	initBateau(joueur2.boat);
	
	joueur1.nom := 'J1';												//On initialise les noms, pour éviter tout problème d'affectation
	joueur2.nom := 'J2';
	
	joueur1.nbBateaux := NBOAT;											//Chaque joueur commence la partie avec le même nombre de bateaux (ici NBOAT)
	joueur2.nbBateaux := NBOAT;
	
	joueur1.score:= 0;													//On initialise le score des deux joueurs
	joueur2.score:= 0;
	
	//remplir les positions des bateaux
	
	y:=trunc(TAILLE_Y/2-NBOAT);											//au milieu à gauche
	for i:= 1 to NBOAT do												//On remplit les coordonnées de chaque bateau du joueur 1
		begin
			x:=2+TMAX;
			for j := 1 to joueur1.boat[i].taille do
				begin
					joueur1.boat[i].pos[j].x := x;						
					joueur1.boat[i].pos[j].y := y;
					joueur1.boat[i].pos[j].nature := bateauJ1;
					x:=x-1;
				end;
			y:=y+2;
			joueur1.boat[i].sens:=E;
		end;

	y:=trunc(TAILLE_Y/2-NBOAT);											//au milieu à droite
	for i:= 1 to NBOAT do												//On remplit les coordonnées de chaque bateau du joueur 2
		begin
			x:=TAILLE_X-2-TMAX;
			for j := 1 to joueur1.boat[i].taille do
				begin
					joueur2.boat[i].pos[j].x := x;
					joueur2.boat[i].pos[j].y := y;
					joueur2.boat[i].pos[j].nature := bateauJ2;
					x:=x+1;
				end;
			y:=y+2;
			joueur2.boat[i].sens:=O;
		end;
		
		
	//initialisation du quota
	resetQuota (joueur1,joueur2);
	
{	//calcul des zones de chaque bateau
	for k:= 1 to NBOAT do
	begin
		calculZone(plat,joueur1.boat[k]);
		calculZone(plat,joueur2.boat[k]);
	end;}
	
end;	

procedure genGrille(var plat : Jeu; var joueur1, joueur2 : Joueur);

begin
	genObstacles(plat.grille, plat.montagne, plat.recifs);				//On génère les obstacles
	plat.joueur1Joue:=True;												//Le joueur 1 ouvre le bal
	genBateau(plat, joueur1, joueur2);									//On génère les bateaux des deux joueurs
end;

begin
end.
