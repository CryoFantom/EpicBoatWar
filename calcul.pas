unit calcul;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
interface 

uses commun, math;

////////////////

const DISTANCE_ZONE_MAX=60;
	
Type Cases=Record
	x : Integer; 
	y : Integer; //coordonnées cartésiennes de la case
	distance : Single;
	angle : Single; //coordonnées polaires de la case (origine : bateau, angle : en radians, conventions trigo)
	visible : Boolean;
	cause : Nature; //pourquoi la case n'est pas visible (montagne, récifs - si les deux -> montagne)
end;

Type ZoneG=Record
	nbCases : Integer; //nombre de cases de la zone
	grille : Array[1..NMAXPOS] of Cases;
	xc : Single;
	yc : Single; //position du centre du bateau et de la zone
	end;

//////////////////

procedure calculZone (game : PJeu; var boat : Bateau);
procedure gestionDeplacement (var game : PJeu; var saisie:PAction; var joueur1, joueur2 : PJoueur; var nbBateaux : Integer);
procedure resetQuota (game : PJeu ; var joueur1,joueur2 : PJoueur);
procedure majProchainTir (joueur1Joue, debutTour : Boolean ; var joueur1,joueur2 : PJoueur; var nbBateaux : Integer);
procedure tirCancelled (joueur1Joue : Boolean ; var joueur1,joueur2 : PJoueur);
procedure gestionTir (var game : PJeu; var saisie:PAction; var joueur1, joueur2 : PJoueur; var nbBateaux : Integer);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

implementation
///////////////

procedure tabToGrille(zone : Zone ; var tab : BArray);
//conversion d'un tableau de position en grille de booléens

var x,y,i:Integer;

begin

				for x:=1 to TAILLE_X do //initialisation du tableau
					for y:=1 to TAILLE_Y do tab[x,y]:=False;

				for i:=1 to zone.nbCases do
					begin
					x:=zone.tabZone[i].x;
					y:=zone.tabZone[i].y;
					tab[x,y]:=True;
					end;
end;

procedure obstacleDansZone (obst : Obstacle; var zone:ZoneG);

Type Obstacles=record
	nature : Nature;
	x:Integer;
	y:Integer;
	distance:Single;
	angleMin:Single;
	angleMax:Single; //angle min et max entre le centre du bateau et les coins de l'obstacle
	end;

var angle:Array[1..5] of Single; //pour la recherche de angleMin et angleMax
	x,y,distance:Single; //pour simplifier la notation des coordonnées de l'obstacle
	obstZone : Array [1..100] of Obstacles; //tableau des obstacles situés dans la zone
	i,j,k,nb:Integer;

begin
	//pour chaque obstacle dans la zone, on calcule angleMin et angleMax
	nb:=0;
	for i:=1 to obst.npos do
	begin
		x:=obst.tab[i].x;
		y:=obst.tab[i].y;
		distance:=sqrt(sqr(x-zone.xc)+sqr(y-zone.yc));
		//si l'obstacle est dans la zone
		if distance<=DISTANCE_ZONE_MAX then
		begin
			nb:=nb+1;
			obstZone[nb].x:=obst.tab[i].x;
			obstZone[nb].y:=obst.tab[i].y;
			obstZone[nb].distance:=distance;
			obstZone[nb].nature:=obst.tab[i].nature;
			//calcul des 4 angles possibles
			for j:=1 to 4 do
			begin
				x:=obst.tab[i].x;
				y:=obst.tab[i].y; //pour rétablir les valeurs de départ si elles ont changé
				//position des 4 coins de l'obstacle
				case j of
					1,4 : x:=x-0.5;
					2,3 : x:=x+0.5;
				end;
				
				case j of
					1,2 : y:=y-0.5;
					3,4 : y:=y+0.5;
				end;
			
				angle[j]:=arctan2(y-zone.yc,x-zone.xc);
			end;
			
			//tri du tableau des angles
			for k:=4 downto 2 do
				for j:=1 to k-1 do
					if angle[j]>angle[j+1] then
						begin
						angle[5]:=angle[j];
						angle[j]:=angle[j+1];
						angle[j+1]:=angle[5];
						end;
			
			//attribution de angleMin et angleMax
			obstZone[nb].angleMin:=angle[1];
			obstZone[nb].angleMax:=angle[4];
		end; //obsctacle dans la zone
	end; //tous les obstacles
	
	//pour chaque case de la zone, on regarde si elle est impactée par la présence d'un obstacle
	for i:=1 to zone.nbCases do //toutes les cases
		for j:=1 to nb do //tous les obstacles dans la zone
			if zone.grille[i].distance>=obstZone[j].distance then //si la case est plus loin que l'obstacle
				//si la case est dans la même direction que l'obstacle (délimité par angleMin et angleMax)		
				if (not(obstZone[j].angleMin=-obstZone[j].angleMax) and (obstZone[j].angleMin<=zone.grille[i].angle) and (obstZone[j].angleMax>=zone.grille[i].angle))
				or ((obstZone[j].angleMin=-obstZone[j].angleMax) {obstacle aligné à gauche} and (obstZone[j].angleMax>pi()/2) and (abs(zone.grille[i].angle)>=obstZone[j].angleMax))
				or ((obstZone[j].angleMin=-obstZone[j].angleMax) {obstacle aligné à gauche} and (obstZone[j].angleMax<pi()/2) and (abs(zone.grille[i].angle)<=obstZone[j].angleMax))
				//pour compenser l'erreur résultant du passage de la valeur de l'angle de pi à -pi
				then zone.grille[i].cause:=obstZone[j].nature; //à cause de ce type d'obstacle
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure calculZone (game : PJeu; var boat : Bateau);

var proue, poupe : Position; //position de l'avant et de l'arrière du bateau
	zone : ZoneG;
	xmin,xmax,ymin,ymax:Integer; //pour pré-détermination de la zone
	x,y : Integer; //pour parcours de toute les cases
	i,nb : Integer; //pour stockage dans le tableau de la zone
	distance:Single;
	
begin
	//calcul de la position du centre du bateau (et de la zone)
	proue:=boat.pos[1];
	poupe:=boat.pos[boat.taille];
	zone.xc:=(proue.x+poupe.x)/2;
	zone.yc:=(proue.y+poupe.y)/2;
	
	//pré-détermination de la zone (carré de côté 2*distanceMax)
	xmin:=trunc(zone.xc)-DISTANCE_ZONE_MAX-1;
	if xmin<=0 then xmin:=1;
	
	xmax:=trunc(zone.xc)+DISTANCE_ZONE_MAX+1;
	if xmax>TAILLE_X then xmax:=TAILLE_X;
	
	ymin:=trunc(zone.yc)-DISTANCE_ZONE_MAX-1;
	if ymin<=0 then ymin:=1;
	
	ymax:=trunc(zone.yc)+DISTANCE_ZONE_MAX+1;
	if ymax>TAILLE_Y then ymax:=TAILLE_Y;
	
	
	//calcul de la distance entre chaque case de la pré-zone et le centre du bateau
	i:=0;
	for y:=ymin to ymax do
		for x:=xmin to xmax do
			begin
			distance:=sqrt(sqr(x-zone.xc)+sqr(y-zone.yc));
			//si le point est dans la zone, on l'ajoute dans le tableau, on calcule l'angle, et on vérifie s'il est masqué par un obstacle
			if distance<=DISTANCE_ZONE_MAX then
				begin
				i:=i+1;
				zone.grille[i].x:=x;
				zone.grille[i].y:=y;
				zone.grille[i].distance:=distance;
				zone.grille[i].angle:=arctan2(y-zone.yc,x-zone.xc); //usage : arctan2(y/x) -> renvoi l'angle en radians compris entre -pi et pi
				zone.grille[i].cause:=libre;
				end;
			end;
	
	zone.nbCases:=i;
		
	obstacleDansZone (game^.recifs,zone); 	//quelles cases sont rendues inaccessibles par un récif
			
	obstacleDansZone (game^.montagne,zone); 	//quelles cases sont cachées par une montagne
				
	//génération de la zone de tir
	nb:=0;
	boat.tir.typeZone:=tir;
	for i:=1 to zone.nbCases do
			if zone.grille[i].distance<=boat.tir.distance then
				begin
				nb:=nb+1;
				case zone.grille[i].cause of
					montagne : boat.tir.tabZone[nb].visible:=False; //tir bloqué par montagne
					recifs : boat.tir.tabZone[nb].visible:=True; //tir non bloqué par récifs
					libre : boat.tir.tabZone[nb].visible:=True;
				end;
				boat.tir.tabZone[nb].x:=zone.grille[i].x;
				boat.tir.tabZone[nb].y:=zone.grille[i].y;
				boat.tir.tabZone[nb].nature:=bZone;
				end;
	boat.tir.nbCases:=nb;
	
	tabToGrille(boat.tir,boat.tabTir); //pour accès à la zone de tir par la position
	
	//génération de la zone de déplacement
	nb:=0;
	boat.deplacement.typeZone:=deplacement;
	for i:=1 to zone.nbCases do
			if zone.grille[i].distance<=boat.quota then
				begin
				nb:=nb+1;
				case zone.grille[i].cause of
					montagne : boat.deplacement.tabZone[nb].visible:=False; //déplacement bloqué par montagne
					recifs : boat.deplacement.tabZone[nb].visible:=False; //déplacement bloqué par récifs
					libre : boat.deplacement.tabZone[nb].visible:=True;
				end;
				boat.deplacement.tabZone[nb].x:=zone.grille[i].x;
				boat.deplacement.tabZone[nb].y:=zone.grille[i].y;
				boat.deplacement.tabZone[nb].nature:=bZone;
				end;
	boat.deplacement.nbCases:=nb;
	
	tabToGrille(boat.detection,boat.tabDetec); //pour accès à la zone de détection par la position
	
	//génération de la zone de détection
	nb:=0;
	boat.detection.typeZone:=detection;
	for i:=1 to zone.nbCases do
			if zone.grille[i].distance<=boat.detection.distance then
				begin
				nb:=nb+1;
				case zone.grille[i].cause of
					montagne : boat.detection.tabZone[nb].visible:=False; //visibilité bloquée par montagne
					recifs : boat.detection.tabZone[nb].visible:=True; //visibilité non bloquée par récifs
					libre : boat.detection.tabZone[nb].visible:=True;
				end;
				boat.detection.tabZone[nb].x:=zone.grille[i].x;
				boat.detection.tabZone[nb].y:=zone.grille[i].y;
				boat.detection.tabZone[nb].nature:=bZone;
				end;
	boat.detection.nbCases:=nb;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure calculRotation (var saisie:PAction);

var ncase :Integer; //centre de la rotation
	i:Integer;

begin
	//détermination de la case centrale du bateau
	ncase:=trunc((saisie^.boat.taille+1)/2);
	
	//détermination de la nouvelle position du bateau
	if saisie^.coord.x=1 then	//rotation vers la droite
		for i:=1 to saisie^.boat.taille do
			case saisie^.boat.sens of
				NO, N : saisie^.boat.pos[i].x:=saisie^.boat.pos[i].x+(ncase-i);
				NE, E : saisie^.boat.pos[i].y:=saisie^.boat.pos[i].y+(ncase-i);
				SE, S : saisie^.boat.pos[i].x:=saisie^.boat.pos[i].x-(ncase-i);
				SO, O : saisie^.boat.pos[i].y:=saisie^.boat.pos[i].y-(ncase-i);
			end
	else if saisie^.coord.x=-1 then //rotation vers la gauche
		for i:=1 to saisie^.boat.taille do
			case saisie^.boat.sens of
				NE, N : saisie^.boat.pos[i].x:=saisie^.boat.pos[i].x-(ncase-i);
				NO, O : saisie^.boat.pos[i].y:=saisie^.boat.pos[i].y+(ncase-i);
				SO, S : saisie^.boat.pos[i].x:=saisie^.boat.pos[i].x+(ncase-i);				
				SE, E : saisie^.boat.pos[i].y:=saisie^.boat.pos[i].y-(ncase-i);
			end;
			
	//mise à jour de l'orientation du bateau
	if saisie^.coord.x=1 then 
		if saisie^.boat.sens=O then saisie^.boat.sens:=NO
		else saisie^.boat.sens:=succ(saisie^.boat.sens)
	else if saisie^.coord.x=-1 then 
		if saisie^.boat.sens=NO then saisie^.boat.sens:=O
		else saisie^.boat.sens:=pred(saisie^.boat.sens);
		
	//mise à jour du quota de déplacement
	saisie^.boat.quota:=saisie^.boat.quota-1/4*(saisie^.boat.taille-1);
	end;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure detection (var joueur1,joueur2 : PJoueur);

var b,i,j:Integer;

begin
//on recache tout
	for i:=1 to NBOAT do
		begin
			if joueur1^.boat[i].coule then  joueur1^.boat[i].detecte:=True
				else joueur1^.boat[i].detecte:=False;
			if joueur2^.boat[i].coule then  joueur2^.boat[i].detecte:=True
				else joueur2^.boat[i].detecte:=False;
		end;

//bateaux du joueur2 détectés par le joueur1
	for b:=1 to NBOAT do
		if not(joueur1^.boat[i].coule) then //si le bateau du j1 n'est pas coulé (il ne peut plus détecter les autres bateaux)
			for i:=1 to NBOAT do
				if not(joueur2^.boat[i].coule) then //si le bateau n'est pas coulé, auquel cas il est visible
					for j:=1 to joueur2^.boat[i].taille do
						if joueur1^.boat[b].tabDetec[joueur2^.boat[i].pos[j].x,joueur2^.boat[i].pos[j].y] then joueur2^.boat[i].detecte:=True;
						
//bateaux du joueur1 détectés par le joueur2
	for b:=1 to NBOAT do
		if not(joueur2^.boat[i].coule) then //si le bateau du j1 n'est pas coulé (il ne peut plus détecter les autres bateaux)
			for i:=1 to NBOAT do
				if not(joueur1^.boat[i].coule) then //si le bateau n'est pas coulé, auquel cas il est visible
					for j:=1 to joueur1^.boat[i].taille do
						if joueur2^.boat[b].tabDetec[joueur1^.boat[i].pos[j].x,joueur1^.boat[i].pos[j].y] then joueur1^.boat[i].detecte:=True;
end;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure calculDeplacement (var saisie:PAction);

var i:Integer;

begin
	//détermination de la nouvelle position du bateau
		for i:=1 to saisie^.boat.taille do
		begin
			case saisie^.boat.sens of
				N,NO,NE : saisie^.boat.pos[i].y:=saisie^.boat.pos[i].y-1*saisie^.coord.x;
				S,SO,SE : saisie^.boat.pos[i].y:=saisie^.boat.pos[i].y+1*saisie^.coord.x;
				E : saisie^.boat.pos[i].x:=saisie^.boat.pos[i].x+1*saisie^.coord.x;
				O : saisie^.boat.pos[i].x:=saisie^.boat.pos[i].x-1*saisie^.coord.x;
			end;
			case saisie^.boat.sens of
				NE,SE : saisie^.boat.pos[i].x:=saisie^.boat.pos[i].x+1*saisie^.coord.x;
				NO,SO : saisie^.boat.pos[i].x:=saisie^.boat.pos[i].x-1*saisie^.coord.x;
			end;
		end;
		
	//mise à jour du quota de déplacement
		if saisie^.coord.x=1 then //le bateau avance
			case saisie^.boat.sens of
				N,S,E,O : saisie^.boat.quota:=saisie^.boat.quota-1;
				NO,NE,SE,SO : saisie^.boat.quota:=saisie^.boat.quota-sqrt(2); //déplacement en diagonale plus rapide
			end;
		if saisie^.coord.x=-1 then //le bateau recule
			case saisie^.boat.sens of
				N,S,E,O : saisie^.boat.quota:=saisie^.boat.quota-2;
				NO,NE,SE,SO : saisie^.boat.quota:=saisie^.boat.quota-2*sqrt(2); //déplacement en diagonale plus rapide
			end;
end;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure gestionCollision (joueur1joue : Boolean; var saisie:PAction; var joueur1, joueur2 : PJoueur; var nbBateaux : Integer);

var i,b,t : Word;

begin
	for i:=1 to saisie^.boat.taille do
	begin
	//bateaux du joueur 1
		for b:=1 to NBOAT do
			//on ne vérifie que si le bateau est différent du bateau joué et n'est pas un bateau coulé
			if (not(joueur1Joue and (saisie^.noBateau=b)) and not(joueur1^.boat[b].coule)) then //si le bateau joué est le b-ième bateau du j1
			for t:=1 to joueur1^.boat[b].taille do
				if (joueur1^.boat[b].pos[t].x=saisie^.boat.pos[i].x) and (joueur1^.boat[b].pos[t].y=saisie^.boat.pos[i].y) then
					begin //si il y a collision, on enlève 2 PV à chaque bateau
						joueur1^.boat[b].ptDeVie:=joueur1^.boat[b].ptDeVie-2;
						joueur1^.boat[b].touche:=True;
						if joueur1^.boat[b].ptDeVie<=0 then 
						begin
							joueur1^.boat[b].coule:=True;
							joueur1^.boat[b].detecte:=True;
							joueur1^.nbBateaux:=joueur1^.nbBateaux-1;
							if (joueur1Joue and (saisie^.noBateau<>b)) then nbBateaux:=nbBateaux-1;
						end;
						saisie^.boat.ptDeVie:=saisie^.boat.ptDeVie-2;	
						saisie^.boat.touche:=True;
					end;
	//bateaux du joueur 2
		for b:=1 to NBOAT do
			//on ne vérifie que si le bateau est différent du bateau joué et n'est pas un bateau coulé
			if (not(not(joueur1Joue) and (saisie^.noBateau=b)) and not(joueur2^.boat[b].coule)) then //si le bateau joué est le b-ième bateau du j2
			for t:=1 to joueur2^.boat[b].taille do
				if (joueur2^.boat[b].pos[t].x=saisie^.boat.pos[i].x) and (joueur2^.boat[b].pos[t].y=saisie^.boat.pos[i].y) then
					begin //si il y a collision, on enlève 2 PV à chaque bateau
						joueur2^.boat[b].ptDeVie:=joueur2^.boat[b].ptDeVie-2;
						joueur2^.boat[b].touche:=True;
						if joueur2^.boat[b].ptDeVie<=0 then 
						begin
							joueur2^.boat[b].coule:=True;
							joueur2^.boat[b].detecte:=True;
							joueur2^.nbBateaux:=joueur2^.nbBateaux;
							if (not(joueur1Joue) and (saisie^.noBateau<>b)) then nbBateaux:=nbBateaux-1;
						end;
						saisie^.boat.ptDeVie:=saisie^.boat.ptDeVie-2;
						saisie^.boat.touche:=True;	
					end;
		end;
	if saisie^.boat.ptDeVie<=0 then 
	begin
	saisie^.boat.coule:=True;
	saisie^.boat.detecte:=True;
	if joueur1Joue then joueur1^.nbBateaux:=joueur1^.nbBateaux-1
	else joueur2^.nbBateaux:=joueur2^.nbBateaux-1;
	end;
end;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure gestionDeplacement (var game : PJeu; var saisie:PAction; var joueur1, joueur2 : PJoueur; var nbBateaux : Integer);

var i:Word;
var joueur,adversaire : PJoueur;
var sboat : Bateau;
var statut : StatutAction;

begin
	if game^.joueur1joue then joueur:=joueur1 else joueur:=joueur2;
	if game^.joueur1joue then adversaire:=joueur2 else adversaire:=joueur1;

//si déplacement abandonné
	if (saisie^.nature=finDeplacement) then 
	begin 
		saisie^.boat.quota:=0;
		joueur^.boat[saisie^.noBateau].quota:=0;
		saisie^.statut:=cancelled;
	end
else
	begin
		//stockage de l'état du bateau avant calcul (pour pouvoir le remettre à l'état précédent)
			sboat:=saisie^.boat;

		//si rotation
			if (saisie^.nature=rotation) then calculRotation (saisie);
				
		//si déplacement
			if (saisie^.nature=deplacement) then calculDeplacement (saisie);
			
			saisie^.statut:=allowed; //le déplacement est autorisé par défaut, et on va vérifier que rien de l'empêche
			
		//le bateau est-il toujours dans la zone de jeu
			for i:=1 to saisie^.boat.taille do
				if (saisie^.boat.pos[i].x<=0) or (saisie^.boat.pos[i].x>TAILLE_X)
				or (saisie^.boat.pos[i].y<=0) or (saisie^.boat.pos[i].y>TAILLE_Y)
				then saisie^.statut:=outzone;
				
		//le bateau rencontre-t-il une montagne ou un récif
			if saisie^.statut=allowed then
			begin
				for i:=1 to saisie^.boat.taille do
				begin
					if game^.grille[saisie^.boat.pos[i].x,saisie^.boat.pos[i].y]=montagne then saisie^.statut:=mountain;
					if game^.grille[saisie^.boat.pos[i].x,saisie^.boat.pos[i].y]=recifs then saisie^.statut:=reef;
				end;
			end;

		//si le déplacement est bloqué par un obstacle ou la limite de la zone de jeu, le bateau est remis à l'état précédent
			statut:=saisie^.statut;
			if saisie^.statut<>allowed then saisie^.boat:=sboat;
			saisie^.statut:=statut;

		//le quota est-il suffisant
			if (saisie^.statut=allowed) and (saisie^.boat.quota<0) then
				begin
					saisie^.statut:=overquota;
					joueur^.boat[saisie^.noBateau].quota:=0;	
				end;
				
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
		//si tout est bon, on enregistre le bateau, on regarde s'il y a collision et on met à jour la visibilité de l'adversaire//
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			if saisie^.statut=allowed then 
			begin
				gestionCollision(game^.joueur1Joue,saisie,joueur1,joueur2,nbBateaux); //détection et gestion des éventuelles collisions
				calculZone (game, saisie^.boat); //mise à jour des zones
				joueur^.boat[saisie^.noBateau]:=saisie^.boat;
			end;
			
		//mise à jour de la grille
			if saisie^.statut=allowed then //si le bateau s'est déplacé
			begin
				//on enlève le bateau de l'ancienne position
				for i:=1 to saisie^.boat.taille do
					game^.grille[sboat.pos[i].x,sboat.pos[i].y]:=libre;
				//et on le met sur la nouvelle
				if game^.joueur1Joue then
					for i:=1 to saisie^.boat.taille do
					game^.grille[saisie^.boat.pos[i].x,saisie^.boat.pos[i].y]:=bateauJ1
				else
					for i:=1 to saisie^.boat.taille do
					game^.grille[saisie^.boat.pos[i].x,saisie^.boat.pos[i].y]:=bateauJ2;
			end;
	end;
	
	if game^.joueur1joue then joueur1:=joueur else joueur2:=joueur;
	if game^.joueur1joue then joueur2:=adversaire else joueur1:=adversaire;
	
	//mise à jour de la visibilité des bateaux
	detection(joueur1,joueur2);
	
	if saisie^.boat.quota=0 then saisie^.statut:=overquota;
end;

procedure resetQuota (game : PJeu; var joueur1,joueur2 : PJoueur);

var i : Word; 

begin
	for i:= 1 to NBOAT do
	begin
		joueur1^.boat[i].quota:=joueur1^.boat[i].deplacement.distance;
		joueur2^.boat[i].quota:=joueur2^.boat[i].deplacement.distance;
		//on recalcule les zones de déplacement car le quota a changé
		calculZone(game,joueur1^.boat[i]);
		calculZone(game,joueur2^.boat[i]);
	end;
end;

procedure majProchainTir (joueur1Joue, debutTour : Boolean ; var joueur1,joueur2 : PJoueur; var nbBateaux : Integer);

var i : Word;
	joueur:PJoueur;

begin
	if joueur1joue then joueur:=joueur1 else joueur:=joueur2;
	nbBateaux:=0; 
	for i:= 1 to NBOAT do
		begin
			joueur^.boat[i].peutTirer:=False;
			if debutTour then
			begin
				if joueur^.boat[i].prochainTir=0 then joueur^.boat[i].prochainTir:=joueur^.boat[i].tRechargement;
				joueur^.boat[i].prochainTir:=joueur^.boat[i].prochainTir-1;
			end;
			if ((joueur^.boat[i].prochainTir=0) and not(joueur^.boat[i].coule)) then 
				begin
					nbBateaux:=nbBateaux+1;
					joueur^.boat[i].peutTirer:=True;
				end;
		end;
		
	if joueur1joue then joueur1:=joueur else joueur2:=joueur;
end;

procedure tirCancelled (joueur1Joue : Boolean ; var joueur1,joueur2 : PJoueur);

var i : Word;
	joueur:PJoueur;

begin
	if joueur1joue then joueur:=joueur1 else joueur:=joueur2;
	for i:= 1 to NBOAT do
		joueur^.boat[i].prochainTir:=joueur^.boat[i].prochainTir+1;
	if joueur1joue then joueur1:=joueur else joueur2:=joueur;
end;

procedure gestionTir (var game : PJeu; var saisie:PAction; var joueur1, joueur2 : PJoueur; var nbBateaux : Integer);

var b,t : Word;

begin
//si le tir est abandonné
	if (saisie^.nature=finTir) then 
	begin 
		if game^.joueur1joue then  //le joueur pourra tirer au prochain tour
			joueur1^.boat[saisie^.noBateau].prochainTir:=joueur1^.boat[saisie^.noBateau].prochainTir+1
		else  joueur2^.boat[saisie^.noBateau].prochainTir:=joueur2^.boat[saisie^.noBateau].prochainTir+1;
		saisie^.statut:=cancelled;
	end
else
// on regarde pour chaque bateau s'il est touché
	begin
	//bateaux du joueur 1
		for b:=1 to NBOAT do
			//on ne vérifie que si le bateau est différent du bateau joué
			if not(game^.joueur1Joue and (saisie^.noBateau=b)) then //si le bateau joué est le b-ième bateau du j1
			begin
				saisie^.statut:=allowed;
				for t:=1 to joueur1^.boat[b].taille do
					if (joueur1^.boat[b].pos[t].x=saisie^.coord.x) and (joueur1^.boat[b].pos[t].y=saisie^.coord.y) then
						begin //si le bateau est touché, on lui enlève le nombre de dégâts du bateau qui a tiré
							joueur1^.boat[b].ptDeVie:=joueur1^.boat[b].ptDeVie-saisie^.boat.degats;
							joueur1^.score:=joueur1^.score-saisie^.boat.degats;
							joueur1^.boat[b].touche:=True;
							if joueur1^.boat[b].ptDeVie<=0 then 
								begin
									joueur1^.boat[b].coule:=True;
									joueur1^.boat[b].detecte:=True;
									joueur1^.boat[b].peutTirer:=False;
									joueur1^.nbBateaux:=joueur1^.nbBateaux-1;
									if game^.joueur1joue then nbBateaux:=nbBateaux-1;
								end;
							if game^.joueur1joue then 
								begin
									joueur1^.score:=joueur1^.score+saisie^.boat.degats;
									joueur1^.boat[saisie^.noBateau].prochainTir:=joueur1^.boat[saisie^.noBateau].tRechargement;
									joueur1^.boat[saisie^.noBateau].peutTirer:=False;
								end
							else 
								begin
									joueur2^.boat[saisie^.noBateau].prochainTir:=joueur2^.boat[saisie^.noBateau].tRechargement;
									joueur2^.score:=joueur2^.score+saisie^.boat.degats;
									joueur2^.boat[saisie^.noBateau].peutTirer:=False;
								end;
						end;
			end;
	//bateaux du joueur 2
		for b:=1 to NBOAT do
			//on ne vérifie que si le bateau est différent du bateau joué
			if not(not(game^.joueur1Joue) and (saisie^.noBateau=b)) then //si le bateau joué est le b-ième bateau du j2
			begin
				saisie^.statut:=allowed;
				for t:=1 to joueur2^.boat[b].taille do
					if (joueur2^.boat[b].pos[t].x=saisie^.coord.x) and (joueur2^.boat[b].pos[t].y=saisie^.coord.y) then
						begin //si le bateau est touché, on lui enlève le nombre de dégâts du bateau qui a tiré
							joueur2^.boat[b].ptDeVie:=joueur2^.boat[b].ptDeVie-saisie^.boat.degats;
							joueur2^.score:=joueur2^.score-saisie^.boat.degats;
							joueur2^.boat[b].touche:=True;
							if joueur2^.boat[b].ptDeVie<=0 then 
							begin
								joueur2^.boat[b].coule:=True;
								joueur2^.boat[b].detecte:=True;
								joueur2^.boat[b].peutTirer:=False;
								joueur2^.nbBateaux:=joueur1^.nbBateaux-1;
								if not(game^.joueur1joue) then nbBateaux:=nbBateaux-1;
							end;
							if game^.joueur1joue then 
								begin
									joueur1^.score:=joueur1^.score+saisie^.boat.degats;
									joueur1^.boat[saisie^.noBateau].prochainTir:=joueur1^.boat[saisie^.noBateau].tRechargement;
									joueur1^.boat[saisie^.noBateau].peutTirer:=False;
								end
							else 
								begin
									joueur2^.boat[saisie^.noBateau].prochainTir:=joueur2^.boat[saisie^.noBateau].tRechargement;
									joueur2^.score:=joueur2^.score+saisie^.boat.degats;
									joueur2^.boat[saisie^.noBateau].peutTirer:=False;
								end;
						end;
			end;
	end;
end;

begin
end.
