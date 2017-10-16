unit calcul;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
interface 

uses commun, math;

////////////////

const distanceZoneMax=30; //(2830 cases environ) 	(max 75)
	
Type Cases=Record
	x : Integer; 
	y : Integer; //coordonnées cartésiennes de la case
	distance : Float;
	angle : Float; //coordonnées polaires de la case (origine : bateau, angle : en radians, conventions trigo)
	visible : Boolean;
	cause : Nature; //pourquoi la case n'est pas visible (montagne, récifs - si les deux -> montagne)
end;

Type ZoneG=Record
	nbCases : Integer; //nombre de cases de la zone
	grille : Array[1..NMAXPOS] of Cases;
	xc : Float;
	yc : Float; //position du centre du bateau et de la zone
	end;


//////////////////

procedure calculZone (game : Jeu; var boat : Bateau); //maintenu ici pour le fonctionnement des tests et démos
procedure gestionDeplacement (saisie:Action; game : Jeu; joueur, adversaire : Joueur);


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

implementation
///////////////

procedure obstacleDansZone (obst : Obstacle; var zone:ZoneG);

Type Obstacles=record
	nature : Nature;
	x:Integer;
	y:Integer;
	distance:Float;
	angleMin:Float;
	angleMax:Float; //angle min et max entre le centre du bateau et les coins de l'obstacle
	end;

var angle:Array[1..5] of Float; //pour la recherche de angleMin et angleMax
	x,y,distance:Float; //pour simplifier la notation des coordonnées de l'obstacle
	obstZone : Array [1..100] of Obstacles; //tableau des obstacles situés dans la zone
	i,j,k,nb:Integer;

begin
	//pour chaque obstacle dans la zone, on calcule angleMin et angleMax
	nb:=0;
	for i:=1 to obst.npos do
	begin
		x:=obst.tab[i].x;
		y:=obst.tab[i].y;
		distance:=sqrt((x-zone.xc)**2+(y-zone.yc)**2);
		//si l'obstacle est dans la zone
		if distance<=distanceZoneMax then
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

procedure calculZone (game : Jeu; var boat : Bateau);

var proue, poupe : Position; //position de l'avant et de l'arrière du bateau
	zone : ZoneG;
	xmin,xmax,ymin,ymax:Integer; //pour pré-détermination de la zone
	x,y : Integer; //pour parcours de toute les cases
	i,nb : Integer; //pour stockage dans le tableau de la zone
	distance:Float;
	
begin
	//calcul de la position du centre du bateau (et de la zone)
	proue:=boat.pos[1];
	poupe:=boat.pos[boat.taille];
	zone.xc:=(proue.x+poupe.x)/2;
	zone.yc:=(proue.y+poupe.y)/2;
	
	//pré-détermination de la zone (carré de côté 2*distanceMax)
	xmin:=trunc(zone.xc)-distanceZoneMax-1;
	if xmin<=0 then xmin:=1;
	
	xmax:=trunc(zone.xc)+distanceZoneMax+1;
	if xmax>TAILLE_X then xmax:=TAILLE_X;
	
	ymin:=trunc(zone.yc)-distanceZoneMax-1;
	if ymin<=0 then ymin:=1;
	
	ymax:=trunc(zone.yc)+distanceZoneMax+1;
	if ymax>TAILLE_Y then ymax:=TAILLE_Y;
	
	
	//calcul de la distance entre chaque case de la pré-zone et le centre du bateau
	i:=0;
	for y:=ymin to ymax do
		for x:=xmin to xmax do
			begin
			distance:=sqrt((x-zone.xc)**2+(y-zone.yc)**2);
			//si le point est dans la zone, on l'ajoute dans le tableau, on calcule l'angle, et on vérifie s'il est masqué par un obstacle
			if distance<=distanceZoneMax then
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
		
	obstacleDansZone (game.recifs,zone); 	//quelles cases sont rendues inaccessibles par un récif
			
	obstacleDansZone (game.montagne,zone); 	//quelles cases sont cachées par une montagne
				
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
				end;
	boat.tir.nbCases:=nb;
	
	//génération de la zone de déplacement
	nb:=0;
	boat.tir.typeZone:=deplacement;
	for i:=1 to zone.nbCases do
			if zone.grille[i].distance<=boat.deplacement.distance then
				begin
				nb:=nb+1;
				case zone.grille[i].cause of
					montagne : boat.deplacement.tabZone[nb].visible:=False; //déplacement bloqué par montagne
					recifs : boat.deplacement.tabZone[nb].visible:=False; //déplacement bloqué par récifs
					libre : boat.deplacement.tabZone[nb].visible:=True;
				end;
				boat.deplacement.tabZone[nb].x:=zone.grille[i].x;
				boat.deplacement.tabZone[nb].y:=zone.grille[i].y;
				end;
	boat.deplacement.nbCases:=nb;
	
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
				end;
	boat.detection.nbCases:=nb;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure calculRotation (var saisie:Action; var game : Jeu);

var ncase :Integer; //centre de la rotation
	i:Integer;

begin
	//détermination de la case centrale du bateau
	ncase:=trunc((saisie.boat.taille+1)/2);
	
	//détermination de la nouvelle position du bateau
	if saisie.coord.x=1 then	//rotation vers la droite
		for i:=1 to saisie.boat.taille do
			case saisie.boat.sens of
				NO, N : saisie.boat.pos[i].x:=saisie.boat.pos[i].x+(ncase-i);
				NE, E : saisie.boat.pos[i].y:=saisie.boat.pos[i].y+(ncase-i);
				SE, S : saisie.boat.pos[i].x:=saisie.boat.pos[i].x-(ncase-i);
				SO, O : saisie.boat.pos[i].y:=saisie.boat.pos[i].y-(ncase-i);
			end
	else if saisie.coord.x=-1 then //rotation vers la gauche
		for i:=1 to saisie.boat.taille do
			case saisie.boat.sens of
				NE, N : saisie.boat.pos[i].x:=saisie.boat.pos[i].x-(ncase-i);
				NO, O : saisie.boat.pos[i].y:=saisie.boat.pos[i].y+(ncase-i);
				SO, S : saisie.boat.pos[i].x:=saisie.boat.pos[i].x+(ncase-i);				
				SE, E : saisie.boat.pos[i].y:=saisie.boat.pos[i].y-(ncase-i);
			end;
			
	//mise à jour de l'orientation du bateau
	if saisie.coord.x=1 then 
		if saisie.boat.sens=O then saisie.boat.sens:=NO
		else saisie.boat.sens:=succ(saisie.boat.sens)
	else if saisie.coord.x=-1 then 
		if saisie.boat.sens=NO then saisie.boat.sens:=O
		else saisie.boat.sens:=pred(saisie.boat.sens);
		
	//mise à jour du quota de déplacement
	saisie.boat.quota:=saisie.boat.quota-1/4*(saisie.boat.taille-1);
	end;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure gestionDeplacement (saisie:Action; game : Jeu; joueur, adversaire : Joueur);

begin
//si rotation
	if (saisie.nature=rotation) and (saisie.boat.quota-1/4*(saisie.boat.taille-1)>=0) then
		calculRotation (saisie,game);
		
//si déplacement
	if (saisie.nature=deplacement) then
	begin
	
		////en cours d'écriture////////
	
		//mise à jour du quota de déplacement
		case saisie.boat.sens of
			N,S,E,O : saisie.boat.quota:=saisie.boat.quota+saisie.coord.x;
			NO,NE,SE,SO : saisie.boat.quota:=saisie.boat.quota+sqrt(2)*saisie.coord.x; //déplacement en diagonale plus rapide
		end;
	end;
	
//mise à jour des zones
	calculZone (game, saisie.boat);
	

		
end;


end.
