unit generation;

interface

uses commun, crt;

procedure genGrille(var plat : Jeu; var joueur1, joueur2: Joueur);

implementation

procedure positionAleatoire(var xp, yp : Integer);

var i : Integer;
var test : Boolean;
var rando : Double;

	begin
		
			
		rando := random;
		test := true;
		i:=1;
	
		while(test) do
		begin
			if((rando < i/(TAILLE_X-14)) and (rando >= (i-1)/(TAILLE_X-14))) then
			begin
				xp := i+7;
				test := False;
			end
			else 
				i:=i+1;
		end;
	
		rando := random;
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
	
	while(test) do														//Nombre de montagnes
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
	
	while(test) do														//Nombre de récifs
		if ((rando < i/NBRECIF) and (rando >= (i-1)/NBRECIF)) then
		begin
			nr := i;
			test := false;
		end
		else
			i:=i+1;
	
	listeMontagne.npos:=0;
	
	for i:=1 to nm do													//Création motagnes
		begin
			positionAleatoire(xp, yp);									//Position particulière
			plat[xp][yp] := centreMontagne;							//On note
			listeMontagne.npos:=listeMontagne.npos+1;
			listeMontagne.tab[listeMontagne.npos].nature := montagne;
			listeMontagne.tab[listeMontagne.npos].x:=xp;
			listeMontagne.tab[listeMontagne.npos].y:=yp;
			listeMontagne.tab[listeMontagne.npos].visible:=True;
			for k:=-2 to 2 do											//On génère la zone autour
				for l:=-2 to 2 do
				begin
						prob := random;
						if ((prob < PROBA/sqrt(k*k+l*l+1)) and (0<xp+k) and (xp+k<TAILLE_X) and (0<yp+l) and (yp+l<TAILLE_Y)) then
							begin
								plat[xp+k][yp+l] := montagne;
								listeMontagne.npos:= listeMontagne.npos+1;
								listeMontagne.tab[listeMontagne.npos].nature := montagne;
								listeMontagne.tab[listeMontagne.npos].x:=xp+k;
								listeMontagne.tab[listeMontagne.npos].y:=yp+l;
								listeMontagne.tab[listeMontagne.npos].visible:=True;
							end;
				end;
		end;
	
		listeRecif.npos:=0;
	
	for i:=1 to nr do													//Création récifs
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

	repeat
	begin
		for i:=2 to TAILLE_X-1 do
			for j:=2 to TAILLE_Y-1 do
				begin
					if((plat[i-1][j] = montagne) and (plat[i+1][j] = montagne) and (plat[i][j-1] = montagne) and (plat[i][j+1] = montagne)) then
						begin
							plat[i][j]:=montagne;
							test:=False;
							listeMontagne.npos:=listerecif.npos+1;
							listeMontagne.tab[listeRecif.npos].nature := montagne;
							listeMontagne.tab[listeRecif.npos].x:=i;
							listeMontagne.tab[listeRecif.npos].y:=j;
							listeMontagne.tab[listeRecif.npos].visible:=True;
						end
					else test:=True
				end;
	end;
	until test;
	
end;

procedure affectation(taille, pdv, degats, trchrg : Integer; nom : String; var navire : Bateau);

begin
	navire.taille := taille;
	navire.nom:= nom;
	navire.ptDeVie := pdv;
	navire.degats := degats;
	navire.tRechargement := trchrg;
	navire.detecte:=True;
end;

procedure initBateau(var listeBateau : listeBateaux);

var i : Integer;

begin
	for i:=1 to NBOAT do
		listeBateau[i].classe := cuirasse;
	for i:=2 to NBOAT do
		listeBateau[i].classe := croiseurlrd;
	for i:=3 to NBOAT do
		listeBateau[i].classe := croiseurlg;
	for i:=5 to Nboat do
		listeBateau[i].classe := destroyer;
	
	for  i:=1 to NBOAT do
		begin
			if (listeBateau[i].classe = destroyer) then	
				affectation(1, 4, 2, 1, 'destroyer', listeBateau[i]);
			if (listeBateau[i].classe = croiseurlg) then
				affectation(2, 6, 3, 2, 'croiseur leger' ,listeBateau[i]);
			if (listeBateau[i].classe = croiseurlrd) then
				affectation(3, 7, 4, 3, 'croiseur lourd', listeBateau[i]);
			if (listebateau[i].classe = cuirasse) then
				affectation(4, 9, 6, 4, 'cuirasse', listeBateau[i]);
		end;
end;

procedure genBateau (joueur1, joueur2 : Joueur);

var i, j, x, y : Integer;

begin	
	initBateau(joueur1.boat);
	initBateau(joueur2.boat);
	
	joueur1.nom := '';
	joueur2.nom := '';
	
	joueur1.nbBateaux := NBOAT;
	joueur2.nbBateaux := NBOAT;
	
	joueur1.nbDeplacement := NBOAT;
	joueur2.nbDeplacement := NBOAT;
	
	joueur1.score:= 0;
	joueur2.score:= 0;
	
	//remplir les positions des bateaux
	
	y:=2;
	
	for i:= 1 to NBOAT do
		begin
			x:=2;
			for j := 1 to joueur1.boat[i].taille do
				begin
					joueur1.boat[i].pos[j].x := x;
					joueur1.boat[i].pos[j].y := y;
					joueur1.boat[i].pos[j].nature := bateauJ1;
					joueur1.boat[i].pos[j].visible:=True;
					x:=x+1;
				end;
			y:=y+2;
		end;
	y:=2;
	
	for i:= 1 to NBOAT do
		begin
			x:=TAILLE_X-2;
			for j := 1 to joueur1.boat[i].taille do
				begin
					joueur2.boat[i].pos[j].x := x;
					joueur2.boat[i].pos[j].y := y;
					joueur2.boat[i].pos[j].nature := bateauJ2;
					joueur2.boat[i].pos[j].visible:=True;
					x:=x-1;
				end;
			y:=y+2;
		end;
	
end;	

procedure genGrille(var plat : Jeu; var joueur1, joueur2 : Joueur);

begin
	genObstacles(plat.grille, plat.montagne, plat.recifs);
	plat.joueur1Joue:=True;
	genBateau(joueur1, joueur2);
end;

begin
end.
